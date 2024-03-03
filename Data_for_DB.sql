-- Заполнение таблиц данными


-- Добавление данных в таблицу librarians
INSERT IGNORE INTO librarians (lastname, firstname, patronymic)
VALUES
	('Голубева', 'Ирина', 'Владимировна'),
	('Богданова', 'Елена', 'Алексеевна'),
	('Зуева', 'Екатерина', 'Робертовна');


-- Добавление данных в таблицу readers
INSERT IGNORE INTO readers (lastname, firstname, patronymic, phone_number, address)
VALUES
	('Соколов', 'Иван', 'Александрович', '123-456-7890', 'Ленина 36'),
	('Стрелков', 'Алексей', 'Викторович', '456-789-0123', 'Смирнова 20'),
	('Назаров', 'Давид', 'Акопович', '789-012-3486', 'Парковая 11'),
	('Маслов', 'Александр', 'Иванович', '012-345-6789', 'Космонавтов 56'),
	('Лыткин', 'Дмитрий', 'Григорьевич', '345-678-9012', 'Яблочкова 28'),
	('Лобанов', 'Олег', 'Викторович', '678-901-2345', 'Лодыгина 11'),
	('Рожков', 'Виктор', 'Иванович', '901-234-5678', 'Веденеева 30'),
	('Корнилова', 'Ольга', 'Николаевна', '234-567-8901', 'Жукова 1'),
	('Муравьева', 'Инна', 'Игоревна', '567-890-1234', 'Одоевского 15'),
	('Золотухина', 'Евгения', 'Сергеевна', '890-123-4567', 'Луначарского 29'),
	('Усольцев', 'Юрий', 'Александрович', '123-456-7891', 'Революции 3А'),
	('Доронина', 'Светлана', 'Константиновна', '456-789-0124', 'Мира 14'),
	('Громов', 'Артем', 'Викторович', '789-012-3456', 'Декабристов 10'),
	('Силин', 'Николай', 'Иванович', '012-345-6780', 'Фонтанная 7'),
	('Юдин', 'Валентин', 'Александрович', '345-678-9011', 'Пушкарская 128'),
	('Якушев', 'Виталий', 'Семенович', '678-901-2346', 'Юрша 30'),
	('Смирнов', 'Антон', 'Витальевич', '901-234-5679', 'Садовая 22'),
	('Пестова', 'Наталья', 'Викторовна', '234-567-892', 'Тургенева 35'),
	('Мухин', 'Андрей', 'Юрьевич', '567-890-1238', 'Макаренко 15'),
	('Евсеева', 'София', 'Ивановна', '890-123-4561', 'Хрустальная 24');


-- Добавление данных в таблицу authors
INSERT IGNORE INTO authors (lastname, firstname, patronymic)
VALUES
	('Моррисон', 'Тони', 'Нобела'),
	('Селинджер', 'Дж. Д.', 'Джером Девид'),
	('Болдуин', 'Джеймс', 'Артур'),
	('Херстон', 'Зора Нил', 'Льюис'),
	('Воннегут', 'Курт', 'Дж.'),
	('Плат', 'Сильвия', 'Таунсенд'),
	('Твен', 'Марк', 'Сэмюэл Ленгхорн'),
	('Анджелоу', 'Мая', 'Сэнт Клер'),
	('Фицджеральд', 'Ф. Скотт', 'Францис'),
	('Хемингуэй', 'Эрнест', 'Миллер');


-- Добавление данных в таблицу books
INSERT IGNORE INTO books (title, author_id, genre, isbn, publishing_year)
VALUES
	('Песнь Соломона', 1, 'роман', '9780099768418', 2016),
	('Боже, храни мое дитя', 1, 'роман', '9780099555926', 2015),
	('Фрэнни и Зуи', 2, 'роман', '9783462037708', 2019),
	('Ловец на хлебном поле', 2, 'роман', '9783462032185', 2022),
	('Иди, вещай с горы', 3, 'роман', '9781841593715', 2016),
	('Я вам не негр', 3, 'триллер', '9780141986678', 2017),
	('Расовый вопрос в эссеистике', 4, 'биография', '9780008522964', 2022),
	('Нанесение прямого удара кривой палкой', 4, 'рассказ', '9780008434342', 2021),
	('Добро пожаловать в обезьянник', 5, 'фантастика', '9780099387817', 1994),
	('Бойня номер пять, или Крестовый поход детей', 5, 'роман', '9781784874858', 2019),
	('Письма Сильвии Плат', 6, 'рассказ', '9780571339211', 2019),
	('Под стеклянным колпаком', 6, 'роман', '9781784874858', 2013),
	('Приключения Гекльберри Финна', 7, 'роман', '9781447967507', 2015),
	('Приключения Тома Соера', 7, 'роман', '9781405878005', 2008),
	('Я знаю, почему птица в клетке поёт', 8, 'биография', '9781408274248', 2008),
	('Всем Божьим детям нужна дорожная обувь', 8, 'биография', '9781844085057', 2008),
	('Последний магнат', 9, 'фантастика', '9780141194080', 2010),
	('Великий Гэтсби', 9, 'роман', '9781840227956', 2019),
	('По ком звонит колокол', 10, 'роман', '9783498001957', 2023),
	('Прощай, оружие!', 10, 'роман', '9781857151497', 1993);

	
-- Добавление данных в таблицу book_issuance
INSERT IGNORE INTO book_issuance (book_id, issuance_status, reader_id, date_of_issue, date_of_return, librarian_id)
VALUES
	(1, 'в библиотеке', 1, '2020-10-10', '2020-10-22', 1),
	(1, 'в библиотеке', 3, '2021-11-10', '2021-11-22', 2),
	(1, 'выдана', 2, '2024-02-28', '2020-03-13', 1),
	(2, 'в библиотеке', 3, '2023-01-27', '2023-02-12', 2),
	(3, 'в библиотеке', 4, '2022-04-15', '2024-04-30', 2),
	(4, 'выдана', 4, '2024-02-27', '2020-03-11', 2),
	(5, 'в библиотеке', 5, '2021-01-07', '2021-01-21', 2),
	(6, 'в библиотеке', 5, '2021-11-27', '2021-11-12', 2),
	(7, 'выдана', 5, '2024-02-15', '2024-02-29', 2),
	(7, 'выдана', 5, '2024-02-15', '2024-02-29', 3),
	(8, 'в библиотеке', 6, '2022-05-10', '2022-05-24', 3),
	(8, 'выдана', 6, '2024-01-27', '2024-02-12', 2),
	(9, 'в библиотеке', 5, '2021-11-27', '2021-11-12', 3),
	(11, 'в библиотеке', 7, '2023-01-27', '2023-02-12', 2),
	(12, 'в библиотеке', 8, '2021-11-27', '2021-11-12', 2),
	(13, 'в библиотеке', 9, '2023-01-27', '2023-02-12', 3),
	(14, 'в библиотеке', 10, '2023-01-27', '2023-02-12', 2),
	(14, 'выдана', 1, '2023-01-27', '2020-02-12', 2),
	(15, 'в библиотеке', 5, '2021-11-27', '2021-11-12', 3),
	(16, 'в библиотеке', 5, '2023-01-27', '2023-02-12', 3),
	(17, 'в библиотеке', 7, '2023-01-27', '2023-02-12', 3),
	(19, 'в библиотеке', 8, '2021-11-27', '2021-11-12', 3),
	(20, 'в библиотеке', 9, '2023-01-27', '2023-02-12', 3),
	(20, 'выдана', 10, '2024-02-20', '2024-03-03', 2);
	