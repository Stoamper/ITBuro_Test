-- Создание таблиц базы данных АРМ "Помощник библиотекаря"
-- Подумать про: on update on delete для внешних ключей, default значения

DROP database IF EXISTS library;
CREATE DATABASE library;
USE library;

-- 1. Создание таблицы librarians (все работающие библиотекари) 
DROP TABLE IF EXISTS librarians;
CREATE TABLE librarians(
	id serial PRIMARY KEY, -- Код библиотекаря (BIGINT unsigned not null auto_increment unique)
	lastname VARCHAR(100),
	firstname VARCHAR(100),
	patronymic VARCHAR(100)
);


-- 2. Создание таблицы readers (все читатели, зарегистрированные в библиотеке) 
DROP TABLE IF EXISTS readers;
CREATE TABLE readers(
	id serial PRIMARY KEY, -- Код читателя (BIGINT unsigned not null auto_increment unique)
	lastname VARCHAR(100),
	firstname VARCHAR(100),
	patronymic VARCHAR(100),
	phone_number VARCHAR(20) UNIQUE,
	address VARCHAR(200) UNIQUE
);


-- 3. Создание таблицы authors (авторы книг) 
DROP TABLE IF EXISTS authors;
CREATE TABLE authors(
	id serial PRIMARY KEY, -- Код автора (BIGINT unsigned not null auto_increment unique)
	lastname VARCHAR(100),
	firstname VARCHAR(100),
	patronymic VARCHAR(100)
);


-- 4. Создание таблицы books (все книги, находящиеся в библиотеке) 
DROP TABLE IF EXISTS books;
CREATE TABLE books(
	id serial PRIMARY KEY, -- Код книги (BIGINT unsigned not null auto_increment unique)
	title VARCHAR(100),
	author_id BIGINT unsigned NOT NULL,
	genre ENUM('роман', 'триллер', 'биография', 'рассказ', 'фантастика', 'сказка'),
	isbn VARCHAR(20),
	publishing_year YEAR,
	FOREIGN KEY(author_id) REFERENCES authors(id) ON UPDATE CASCADE ON DELETE CASCADE
);


-- 5. Создание таблицы book_issuance (данные о выданных книгах) 
DROP TABLE IF EXISTS book_issuance;
CREATE TABLE book_issuance(
	id serial PRIMARY KEY, -- Код выдачи (BIGINT unsigned not null auto_increment unique)
	book_id BIGINT unsigned NOT NULL,
	issuance_status ENUM('выдана', 'в библиотеке'),
	reader_id BIGINT unsigned NOT NULL,
	date_of_issue DATE COMMENT 'ДАТА ВЫДАЧИ КНИГИ НА РУКИ',
	date_of_return DATE COMMENT 'ДАТА ВОЗВРАТА КНИГИ В БИБЛИОТЕКУ',
	librarian_id BIGINT unsigned NOT NULL,
	FOREIGN KEY(book_id) REFERENCES books(id) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY(reader_id) REFERENCES readers(id) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY(librarian_id) REFERENCES librarians(id) ON UPDATE CASCADE ON DELETE CASCADE
);
