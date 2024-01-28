DROP TABLE IF EXISTS jc_student_child;
DROP TABLE IF EXISTS jc_student_order;
DROP TABLE IF EXISTS jc_passport_office;
DROP TABLE IF EXISTS jc_register_office;
DROP TABLE IF EXISTS jc_country_struct;
DROP TABLE IF EXISTS jc_university;
DROP TABLE IF EXISTS jc_street;



CREATE TABLE jc_street
(
    street_code integer not null,
    street_name varchar(300),

    PRIMARY KEY(street_code)
);
CREATE TABLE jc_university
(
    university_id integer not null,
    unversity_name varchar(300),

    PRIMARY KEY(university_id)
);

CREATE TABLE jc_country_struct
(
    area_id char(12) unique not null,
    area_name varchar(200),
    PRIMARY KEY(area_name)
);

CREATE TABLE jc_passport_office
(
    p_office_id integer not null,
    p_office_area_id char(12) not null,
    p_office_name varchar(200),
    PRIMARY KEY(p_office_id),
    FOREIGN KEY (p_office_area_id) REFERENCES jc_country_struct(area_id) ON DELETE RESTRICT
);

CREATE TABLE jc_register_office
(
    r_office_id integer not null,
    r_office_area_id char(12) not null,
    r_office_name varchar(200),
    PRIMARY KEY(r_office_id),
    FOREIGN KEY (r_office_area_id) REFERENCES jc_country_struct(area_id) ON DELETE RESTRICT
);

CREATE TABLE jc_student_order
(
    student_order_id SERIAL,
    student_order_status int not null ,
    student_order_date timestamp not null ,
    h_sur_name varchar(100) not null ,
    h_given_name varchar(100) not null ,
    h_patronymic varchar(100) not null ,
    h_date_of_birth date not null ,
    h_passport_seria varchar(10),
    h_passport_number varchar(10) not null ,
    h_passport_date date not null ,
    h_passport_office_id integer not null ,
    h_post_index varchar(10),
    h_street_code integer not null ,
    h_building varchar(10) not null ,
    h_extension varchar(10),
    h_apartment varchar(10),
    h_university_id integer not null ,
    h_student_number varchar(30),
    w_sur_name varchar(100) not null ,
    w_given_name varchar(100) not null ,
    w_patronymic varchar(100) not null ,
    w_date_of_birth date not null ,
    w_passport_seria varchar(10),
    w_passport_number varchar(10) not null ,
    w_passport_date date not null ,
    w_passport_office_id integer not null ,
    w_post_index varchar(10),
    w_street_code integer not null ,
    w_building varchar(10) not null ,
    w_extension varchar(10),
    w_apartment varchar(10),
    w_university_id integer not null ,
    w_student_number varchar(30),
    certificate_id varchar(20) not null ,
    register_office_id integer not null ,
    marriage_date date not null ,
    PRIMARY KEY (student_order_id),
    FOREIGN KEY (h_street_code) REFERENCES jc_street(street_code)  ON DELETE RESTRICT,
    FOREIGN KEY (h_passport_office_id) REFERENCES jc_passport_office(p_office_id)  ON DELETE RESTRICT,
    FOREIGN KEY (h_university_id) REFERENCES jc_university(university_id)   ON DELETE RESTRICT,
    FOREIGN KEY (w_street_code) REFERENCES jc_street(street_code) ON DELETE RESTRICT,
    FOREIGN KEY (w_passport_office_id) REFERENCES jc_passport_office(p_office_id)  ON DELETE RESTRICT,
    FOREIGN KEY (w_university_id) REFERENCES jc_university(university_id)   ON DELETE RESTRICT,
    FOREIGN KEY (register_office_id) REFERENCES jc_register_office(r_office_id) ON DELETE RESTRICT
);

CREATE TABLE jc_student_child
(
    student_child_id SERIAL,
    student_order_id integer not null,
    c_sur_name varchar(100) not null,
    c_given_name varchar(100) not null,
    c_patronymic varchar(100) not null,
    c_date_of_birth date not null,
    c_certificate_number varchar(10) not null,
    c_certificate_date date not null,
    c_register_office_id integer not null,
    c_post_index varchar(10),
    c_street_code integer not null,
    c_building varchar(10) not null,
    c_extension varchar(10),
    c_apartment varchar(10),
    PRIMARY KEY (student_child_id),
    FOREIGN KEY (c_street_code) REFERENCES jc_street(street_code)  ON DELETE RESTRICT,
    FOREIGN KEY (c_register_office_id) REFERENCES jc_register_office(r_office_id) ON DELETE RESTRICT
);
/*
INSERT INTO jc_street (street_code, street_name) VALUES (2,'Street First'),
                                                        (3,'Street First'),
                                                        (4,'Street First');

UPDATE jc_street SET street_name = 'Super'
WHERE street_code = 2;

DELETE FROM jc_street WHERE street_code = 3;
*/
INSERT INTO jc_street (street_code, street_name)
VALUES (1, 'улица Садовая'),
       (2, 'Невский проспект'),
       (3, 'улица Стахановцев'),
       (4, 'улица Гороховая'),
       (5, 'проспект Ветеранов');

INSERT INTO jc_university (university_id,unversity_name) values
                                                             (1, 'Санкт-Петербургский Государственный Университет'),
                                                             (2, 'Санкт-Петербургский Политехнический Университет'),
                                                             (3, 'Санкт-Петербургский Морской Технический Университет');

INSERT INTO jc_country_struct (area_id, area_name)
VALUES ('010000000000', 'Город'),
       ('010010000000', 'Город Район 1'),
       ('010020000000', 'Город Район 2'),
       ('010030000000', 'Город Район 3'),
       ('010040000000', 'Город Район 4'),

       ('020000000000', 'Край'),
       ('020010000000', 'Край Область 1'),
       ('020010010000', 'Край Область 1 Район 1'),
       ('020010010001', 'Край Область 1 Район 1 Поселение 1'),
       ('020010010002', 'Край Область 1 Район 1 Поселение 2'),
       ('020010020000', 'Край Область 1 Район 2'),
       ('020010020001', 'Край Область 1 Район 2 Поселение 1'),
       ('020010020002', 'Край Область 1 Район 2 Поселение 2'),
       ('020010020003', 'Край Область 1 Район 2 Поселение 3'),
       ('020020000000', 'Край Область 2'),
       ('020020010000', 'Край Область 2 Район 1'),
       ('020020010001', 'Край Область 2 Район 1 Поселение 1'),
       ('020020010002', 'Край Область 2 Район 1 Поселение 2'),
       ('020020010003', 'Край Область 2 Район 1 Поселение 3'),
       ('020020020000', 'Край Область 2 Район 2'),
       ('020020020001', 'Край Область 2 Район 2 Поселение 1'),
       ('020020020002', 'Край Область 2 Район 2 Поселение 2');

INSERT INTO jc_passport_office (p_office_id, p_office_area_id, p_office_name)
VALUES (1, '010010000000', 'Паспортный стол района 1 города'),
       (2, '010020000000', 'Паспортный стол 1 района 2 города'),
       (3, '010020000000', 'Паспортный стол 2 района 2 города'),
       (4, '010010000000', 'Паспортный стол района 3 города'),
       (5, '020010010001', 'Паспортный стол Область 1 поселения 1'),
       (6, '020010020002', 'Паспортный стол Область 1 поселения 2'),
       (7, '020020010000', 'Паспортный стол Область 2 район 1'),
       (8, '020020020000', 'Паспортный стол Область 2 район 2');

INSERT INTO jc_register_office (r_office_id, r_office_area_id, r_office_name)
VALUES (1, '010010000000', 'ЗАГС 1 района 1 города'),
       (2, '010010000000', 'ЗАГС 2 района 1 города'),
       (3, '010020000000', 'ЗАГС района 2 города'),
       (4, '020010010001', 'ЗАГС Область 1 поселения 1'),
       (5, '020010020002', 'ЗАГС Область 1 поселения 2'),
       (6, '020020010000', 'ЗАГС Область 2 район 1'),
       (7, '020020020000', 'ЗАГС Область 2 район 2');

INSERT INTO public.jc_student_order(student_order_status, student_order_date, h_sur_name, h_given_name, h_patronymic, h_date_of_birth, h_passport_seria, h_passport_number, h_passport_date, h_passport_office_id, h_post_index, h_street_code, h_building, h_extension, h_apartment,h_university_id,h_student_number, w_sur_name, w_given_name, w_patronymic, w_date_of_birth, w_passport_seria, w_passport_number, w_passport_date, w_passport_office_id, w_post_index, w_street_code, w_building, w_extension, w_apartment,w_university_id,w_student_number, certificate_id, register_office_id, marriage_date)	VALUES (0, '2024-01-28 12:09:38.952505+04', 'Bob', 'Morley', 'Shumacher', '1997-08-24 +04', '1010', '100010', '2017-09-15 +04', 1, '195000', 1, '12', '', '142', 1, 'HH1324', 'Anna', 'Elisabet', 'Taylor', '1998-03-12 +04', '2010', '200010', '2018-04-05 +04', 1, '195000', 1, '12', '', '142', 1, 'JJ1345', '123456010', 1, '2016-07-04 +03')
RETURNING "student_order_id"