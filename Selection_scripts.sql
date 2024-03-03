-- Скрипты для выборок определенных данных из таблиц
USE library;

-- 1. Общее количество книг в библиотеке 
SELECT count(*) AS 'количество книг в библиотеке'
FROM books b;


-- 2. Общее количество читателей
SELECT count(*) AS 'количество читателей'
FROM readers r;


-- 3. Количество книг, которые брал каждый читатель за все время
SELECT 
	r.lastname AS 'фамилия читателя',
	count(*) AS 'количество взятых за все время книг'
FROM book_issuance bi JOIN readers r ON bi.reader_id = r.id
GROUP BY bi.reader_id
ORDER BY count(*) DESC;


-- 4. Количество книг на руках у каждого читателя
SELECT 
	r.lastname AS 'фамилия читателя',
	count(*) AS 'количество книг на руках у читателя'
FROM book_issuance bi JOIN readers r ON bi.reader_id = r.id
WHERE bi.issuance_status = 'выдана'
GROUP BY bi.reader_id
ORDER BY count(*) DESC;


-- 5. Дата последнего посещения читателем библиотеки
SELECT
	r.lastname AS 'фамилия читателя',
	MAX(bi.date_of_issue) AS 'дата последнего посещения'
FROM book_issuance bi JOIN readers r ON bi.reader_id = r.id
GROUP BY 1
ORDER BY 2 DESC;


-- 6. Самый читаемый автор
WITH tab AS (SELECT  
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
LIMIT 1;


-- 7. Самые предпочитаемые жанры (по убыванию)
-- Пройти по всем книгам из таблицы book_issuance, на каждой счетчик по жанру (пересечение с books) и DESC
SELECT 
	b.genre AS 'жанр',
	count(*) AS 'количество раз взятия книг указанного жанра'
FROM book_issuance bi JOIN books b ON bi.book_id = b.id
GROUP BY 1 
ORDER BY count(*) DESC;


-- 8. Любимый жанр каждого читателя
-- Сортируем книги по читателям, затем у каждой книги определяем жанр и подсчитываем какие. Берем только тот, которых больше всего
with tab as (SELECT 
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
ORDER BY reader_id;


-- ДОПОЛНИТЕЛЬНЫЕ СКРИПТЫ

-- Какие книги есть в библиотеке
SELECT 
	b.title AS 'название книги',
	a.lastname AS 'автор',
	b.genre AS 'жанр'
FROM books b JOIN authors a ON b.author_id = a.id;


-- Кто и когда брал книгу
SELECT 
	b.title AS 'название книги',
	bi.issuance_status AS 'статус выдачи',
	bi.reader_id AS 'id читателя',
	bi.date_of_issue AS 'дата выдачи',
	bi.date_of_return AS 'дата возврата' 
FROM book_issuance bi JOIN books b ON bi.book_id = b.id 
WHERE bi.book_id = 1;


-- Где и у кого сейчас книга
SELECT 
	b.title AS 'название книги',
	bi.issuance_status AS 'статус выдачи',
	bi.reader_id AS 'id читателя',
	bi.date_of_issue AS 'дата выдачи',
	bi.date_of_return AS 'дата возврата'
FROM book_issuance bi JOIN books b ON bi.book_id = b.id 
WHERE bi.book_id = 1
ORDER BY bi.date_of_return DESC
LIMIT 1;


-- Выданные книги, которые не вернули вовремя
SELECT 
	bi.id AS 'id выдачи',
	b.title AS 'название книги',
	r.lastname AS 'фамилия читателя',
	bi.date_of_return AS 'дата возврата'
FROM book_issuance bi 
JOIN books b ON bi.book_id = b.id 
JOIN readers r ON bi.reader_id = r.id
WHERE bi.date_of_return < curdate()
AND bi.issuance_status = 'выдана';


