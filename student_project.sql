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

--SELECT * FROM jc_student_order WHERE student_order_status = 1 ORDER BY student_order_date

SELECT so.*, ro.r_office_area_id, ro.r_office_name FROM jc_student_order so
JOIN jc_register_office ro ON so.register_office_id = ro.r_office_id
WHERE student_order_status = 0
ORDER BY student_order_date;

SELECT so.*, ro.r_office_area_id, ro.r_office_name,
po_h.p_office_id as h_p_office_area_id, po_h.p_office_name as h_p_office_name,
po_w.p_office_id as w_p_office_area_id, po_w.p_office_name as w_p_office_name
FROM jc_student_order so
JOIN jc_register_office ro ON so.register_office_id = ro.r_office_id
JOIN jc_passport_office po_h ON po_h.p_office_id = so.h_passport_office_id
JOIN jc_passport_office po_w ON po_w.p_office_id = so.h_passport_office_id
WHERE student_order_status = 0
ORDER BY student_order_date;

SELECT soc.*, ro.r_office_id,ro.r_office_name
FROM jc_student_child soc
JOIN jc_register_office ro ON ro.r_office_id = soc.c_register_office_id
WHERE student_order_id IN (7,2,3)

ORDER BY student_order_id;

SELECT so.*, ro.r_office_area_id, ro.r_office_name,
        po_h.p_office_id as h_p_office_area_id, po_h.p_office_name as h_p_office_name,
            po_w.p_office_id as w_p_office_area_id, po_w.p_office_name as w_p_office_name,
            soc.*, ro_c.r_office_id, ro_c.r_office_name
            FROM jc_student_order so
            JOIN jc_register_office ro ON so.register_office_id = ro.r_office_id
            JOIN jc_passport_office po_h ON po_h.p_office_id = so.h_passport_office_id
            JOIN jc_passport_office po_w ON po_w.p_office_id = so.h_passport_office_id
            JOIN jc_student_child soc ON soc.student_order_id = so.student_order_id
            JOIN jc_register_office ro_c ON ro_c.r_office_id = soc.c_register_office_id
            WHERE student_order_status = 0
            ORDER BY student_order_date;

CREATE INDEX idx_student_order_status ON jc_student_order (student_order_status);