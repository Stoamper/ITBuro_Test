'''Консольное приложение АРМ "Помощник библиотекаря'''
'''Для работы с приложением необходимо в терминале ввести  py Prog_console.py и далее через пробел 
интересуемую команду из списка ниже'''

import mysql.connector
import sys

'''Подключение к базе данных library'''
'''ВНИМАНИЕ! Укажите ваши данные! Без них программа не сможет подключиться к базе данных'''
cnx = mysql.connector.connect(user='root', password='*******',
                              host='localhost',
                              database='library')

cursor = cnx.cursor()

try:
    command = sys.argv[1]
except IndexError:
    print('Для справки введите Help')
else:
    if command == 'Help':
        print('Для работе в АРМ "Помощник библиотекаря" доступны следующие команды: \n',
              'РАБОТА С БАЗОВОЙ ДАННЫХ\n',
              '"Insert_book" - добавить новую книгу в базу\n',
              '"Delete_book" - удалить книгу из базы\n',
              '"Update_book" - изменить информацию о книге\n',
              '"Insert_reader" - добавить нового читателя в базу\n',
              '"Delete_reader" - удалить читателя из базы\n',
              '"Update_reader" - изменить информацию о читателе\n',
              '"Insert_book_issuance" - добавить в базу новую выданную книгу\n',
              '"Update_book_issuance" - изменить информацию о выданной книге\n',
              'ПОЛУЧЕНИЕ СПРАВОЧНОЙ ИНФОРМАЦИИ\n',
              '"Authors" - показать всех авторов\n',
              '"Books" - показать общее количество книг в библиотеке\n',
              '"Readers" - показать всех читателей\n',
              '"Books_taken" - показать сколько книг брал каждый читатель за все время\n',
              '"Books_readers" - показать сколько книг находится на руках у каждого читателя в настоящее время\n',
              '"Last_visit" - показать дату последнего посещения библиотеки у каждого читателя\n',
              '"Most_read_author" - показать самого читаемого автора\n',
              '"Most_read_genre" - показать самые предпочитаемые читателями жанры по убыванию\n',
              '"Favorite_genre_readers" - показать любимый жанр каждого читателя\n',
              '"All_books" - показать все книги, имеющиеся в библиотеке\n',
              '"Book_issuance_info" - показать историю выдачи по конкретной книге\n',
              '"Current_book_status" - показать где и у кого находится книга в настоящее время\n',
              '"Not_returned_books" - вывести отчет в формате .txt о книгах, не вернутых вовремя\n')
    elif command == 'Authors':
        query = 'SELECT count(*) FROM authors'
        cursor.execute(query)
        result = cursor.fetchall()
        for row in result:
            print(f'Общее количество авторов книг в библиотеке: {row[0]}')
    elif command == 'Books':
        query = 'SELECT count(*) FROM books'
        cursor.execute(query)
        result = cursor.fetchall()
        for row in result:
            print(f'Общее количество книг в библиотеке: {row[0]}')
    elif command == 'Readers':
        query = 'SELECT count(*) FROM readers'
        cursor.execute(query)
        result = cursor.fetchall()
        for row in result:
            print(f'Общее количество читателей: {row[0]}')
    elif command == 'Books_taken':
        query = ('''SELECT r.lastname AS "фамилия читателя", 
                    count(*) AS "количество взятых за все время книг" 
                    FROM book_issuance bi JOIN readers r ON bi.reader_id = r.id 
                    GROUP BY bi.reader_id 
                    ORDER BY count(*) DESC''')
        cursor.execute(query)
        result = cursor.fetchall()
        for row in result:
            print(f'{row[0]} за все время взял {row[1]} книг(и)')
    elif command == 'Books_readers':
        query = ('''SELECT r.lastname AS 'фамилия читателя',
                    count(*) AS 'количество книг на руках у читателя'
                    FROM book_issuance bi JOIN readers r ON bi.reader_id = r.id
                    WHERE bi.issuance_status = 'выдана'
                    GROUP BY bi.reader_id
                    ORDER BY count(*) DESC''')
        cursor.execute(query)
        result = cursor.fetchall()
        for row in result:
            print(f'{row[0]} держит на руках {row[1]} книг(и)')
    elif command == 'Last_visit':
        query = ('''SELECT
                    r.lastname AS 'фамилия читателя',
                    MAX(bi.date_of_issue) AS 'дата последнего посещения'
                    FROM book_issuance bi JOIN readers r ON bi.reader_id = r.id
                    GROUP BY 1
                    ORDER BY 2 DESC''')
        cursor.execute(query)
        result = cursor.fetchall()
        for row in result:
            print(f'{row[0]} в последний раз посещал библиотеку {row[1]}')
    elif command == 'Most_read_author':
        query = ('''WITH tab AS (SELECT  
                    b.author_id AS author_id,
                    count(*) AS cnt
                    FROM books b
                    JOIN book_issuance bi ON b.id = bi.book_id 
                    GROUP BY b.author_id 
                    ORDER BY cnt DESC)
                    SELECT 
                    author_id AS 'id автора',
                    a.lastname AS 'фамилия автора',
                    t.cnt AS 'количество книг, которые были взяты читателями'
                    FROM tab t JOIN authors a ON t.author_id = a.id
                    GROUP BY 1
                    ORDER BY t.cnt DESC
                    LIMIT 1''')
        cursor.execute(query)
        result = cursor.fetchall()
        for row in result:
            print(f'Самый читаемый автор: {row[1]} (его книги брали {row[2]} раз(а))')
    elif command == 'Most_read_genre':
        query = ('''SELECT 
                    b.genre AS 'жанр',
                    count(*) AS 'количество раз взятия книг указанного жанра'
                    FROM book_issuance bi JOIN books b ON bi.book_id = b.id
                    GROUP BY 1 
                    ORDER BY count(*) DESC''')
        cursor.execute(query)
        result = cursor.fetchall()
        for row in result:
            print(f'Из жанра {row[0]} брали {row[1]} произведения(й)')
    elif command == 'Favorite_genre_readers':
        query = ('''with tab as (SELECT 
                    bi.reader_id AS reader_id,
                    b.genre AS genre,
                    count(*) AS n_books
                    FROM book_issuance bi JOIN books b ON bi.book_id = b.id
                    GROUP BY 1, 2
                    ORDER BY count(*) DESC)
                    SELECT reader_id AS 'id читателя',
                    r.lastname AS 'фамилия читателя',
                    any_value(genre) AS 'любимый жанр',
                    MAX(t.n_books) AS 'количество книг в любимом жанре'
                    FROM tab t JOIN readers r ON t.reader_id = r.id
                    GROUP BY 1
                    ORDER BY reader_id''')
        cursor.execute(query)
        result = cursor.fetchall()
        for row in result:
            print(f'Читатель: {row[1]}; любимый жанр: {row[2]}')
    elif command == 'All_books':
        query = ('''SELECT 
                    b.title,
                    a.lastname,
                    b.genre
                    FROM books b JOIN authors a ON b.author_id = a.id''')
        cursor.execute(query)
        result = cursor.fetchall()
        for row in result:
            print(f'"{row[0]}", автор {row[1]}, жанр {row[2]}')
    elif command == 'Book_issuance_info':
        book_id = input('Введите id книги, по которой надо получить информацию: ')
        query = (f'''SELECT 
                    b.title,
                    bi.issuance_status,
                    bi.reader_id,
                    bi.date_of_issue,
                    bi.date_of_return 
                    FROM book_issuance bi JOIN books b ON bi.book_id = b.id 
                    WHERE bi.book_id = {book_id}''')
        cursor.execute(query)
        result = cursor.fetchall()
        for row in result:
            print(f'Книга: {row[0]}, статус: {row[1]}, id читателя: {row[2]}, дата выдачи: {row[3]}, '
                  f'дата возврата: {row[4]}')
    elif command == 'Current_book_status':
        book_id = input('Введите id книги, по которой надо получить информацию: ')
        query = (f'''SELECT 
                    b.title,
                    bi.issuance_status,
                    bi.reader_id,
                    bi.date_of_issue,
                    bi.date_of_return 
                    FROM book_issuance bi JOIN books b ON bi.book_id = b.id 
                    WHERE bi.book_id = {book_id}
                    ORDER BY bi.date_of_return DESC
                    LIMIT 1''')
        cursor.execute(query)
        result = cursor.fetchall()
        for row in result:
            print(f'Книга: {row[0]}, статус: {row[1]}, id читателя: {row[2]}, дата выдачи: {row[3]}, '
                  f'дата возврата: {row[4]}')
    elif command == 'Not_returned_books':
        query = (f'''SELECT 
                    bi.id,
                    b.title,
                    r.lastname,
                    bi.date_of_return 
                    FROM book_issuance bi 
                    JOIN books b ON bi.book_id = b.id 
                    JOIN readers r ON bi.reader_id = r.id
                    WHERE bi.date_of_return < curdate()
                    AND bi.issuance_status = 'выдана';''')
        cursor.execute(query)
        result = cursor.fetchall()
        for row in result:
            with open('Not_returned_books_report.txt', 'a') as f:
                f.writelines(str(row) + '\n')
        print('Отчет сформирован. Перейдите в папку расположения программы')
    elif command == 'Insert_book':
        title = input('Введите название книги: ')
        author_id = input('Введите id автора: ')
        genre = input('Введите жанр: ')
        isbn = input('Введите ISBN: ')
        publishing_year = input('Введите год публикации: ')
        insert_query = f'''INSERT IGNORE INTO books (title, author_id, genre, isbn, publishing_year)  
                        VALUES('{title}', {author_id}, '{genre}', '{isbn}', {publishing_year})'''
        cursor.execute(insert_query)
        cnx.commit()
    elif command == 'Delete_book':
        book_id = input('Введите id книги, которую следует удалить из базы: ')
        delete_query = f'''DELETE FROM books WHERE id = {book_id}'''
        cursor.execute(delete_query)
        cnx.commit()
    elif command == 'Update_book':
        book_id = input('Введите id книги, которую следует изменить: ')
        title = input('Введите название книги: ')
        author_id = input('Введите id автора: ')
        genre = input('Введите жанр: ')
        isbn = input('Введите ISBN: ')
        publishing_year = input('Введите год публикации: ')
        update_query = f'''UPDATE books SET title = '{title}', author_id = {author_id}, 
                            genre = '{genre}', isbn = '{isbn}', publishing_year = {publishing_year}
                            WHERE id = {book_id}'''
        cursor.execute(update_query)
        cnx.commit()
    elif command == 'Insert_reader':
        lastname = input('Введите фамилию читателя: ')
        firstname = input('Введите имя читателя: ')
        patronymic = input('Введите отчество читателя: ')
        phone_number = input('Введите телефон читателя: ')
        address = input('Введите адресс читателя: ')
        insert_query = f'''INSERT IGNORE INTO readers (lastname, firstname, patronymic, phone_number, address)  
                        VALUES('{lastname}', '{firstname}', '{patronymic}', '{phone_number}', '{address}')'''
        cursor.execute(insert_query)
        cnx.commit()
    elif command == 'Delete_reader':
        reader_id = input('Введите id читателя, которого следует удалить: ')
        delete_query = f'''DELETE FROM readers WHERE id = {reader_id}'''
        cursor.execute(delete_query)
        cnx.commit()
    elif command == 'Update_reader':
        reader_id = input('Введите id пользователя, которого следует изменить: ')
        lastname = input('Введите фамилию читателя: ')
        firstname = input('Введите имя читателя: ')
        patronymic = input('Введите отчество читателя: ')
        phone_number = input('Введите телефон читателя: ')
        address = input('Введите адресс читателя: ')
        update_query = f'''UPDATE readers SET lastname = '{lastname}', firstname = '{firstname}', 
                            patronymic = '{patronymic}', phone_number = '{phone_number}', address = '{address}'
                            WHERE id = {reader_id}'''
        cursor.execute(update_query)
        cnx.commit()
    elif command == 'Insert_book_issuance':
        book_id = input('Введите id книги: ')
        issuance_status = input('Введите статус (в библиотеке/выдана): ')
        reader_id = input('Введите id читателя: ')
        date_of_issue = input('Введите дату выдачи книги читателю (YYYY-MM-DD): ')
        date_of_return = input('Введите ожидаемую дату вовзрата книги (YYYY-MM-DD): ')
        librarian_id = input('Введите id библиотекаря, выдавшего книгу: ')
        insert_query = f'''INSERT IGNORE INTO book_issuance (book_id, issuance_status, reader_id, date_of_issue,
                        date_of_return, librarian_id)  
                        VALUES({book_id}, '{issuance_status}', {reader_id}, '{date_of_issue}', '{date_of_return}',
                        {librarian_id})'''
        cursor.execute(insert_query)
        cnx.commit()
    elif command == 'Update_book_issuance':
        issuance_id = input('Введите id строки выдачи: ')
        issuance_status = input('Введите статус (в библиотеке/выдана): ')
        date_of_return = input('Введите ожидаемую дату вовзрата книги (YYYY-MM-DD): ')
        update_query = f'''UPDATE book_issuance SET issuance_status = '{issuance_status}', 
                            date_of_return = '{date_of_return}'
                            WHERE id = {issuance_id}'''
        cursor.execute(update_query)
        cnx.commit()
    else:
        print('Для справки введите Help')
cursor.close()
cnx.close()