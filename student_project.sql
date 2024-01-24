DROP TABLE IF EXISTS jc_student_child;
DROP TABLE IF EXISTS jc_student_order;
DROP TABLE IF EXISTS jc_passport_office;
DROP TABLE IF EXISTS jc_register_office;
DROP TABLE IF EXISTS jc_country_struc;
DROP TABLE IF EXISTS jc_street;



CREATE TABLE jc_street
(
    street_code integer not null,
    street_name varchar(300),

    PRIMARY KEY(street_code)
);

CREATE TABLE jc_country_struc
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
    FOREIGN KEY (p_office_area_id) REFERENCES jc_country_struc(area_id) ON DELETE RESTRICT
);

CREATE TABLE jc_register_office
(
    r_office_id integer not null,
    r_office_area_id char(12) not null,
    r_office_name varchar(200),
    PRIMARY KEY(r_office_id),
    FOREIGN KEY (r_office_area_id) REFERENCES jc_country_struc(area_id) ON DELETE RESTRICT
);

CREATE TABLE jc_student_order
(
    student_order_id SERIAL,
    h_sur_name varchar(100) not null ,
    h_patronymic varchar(100) not null ,
    h_date_of_birth date not null ,
    h_passport_seria varchar(10),
    h_passport_number varchar(10) not null ,
    h_passport_date date not null ,
    h_passport_office integer not null ,
    h_post_index varchar(10),
    h_street_code integer not null ,
    h_building varchar(10) not null ,
    h_extension varchar(10),
    h_apartment varchar(10),
    w_sur_name varchar(100) not null ,
    w_patronymic varchar(100) not null ,
    w_date_of_birth date not null ,
    w_passport_seria varchar(10),
    w_passport_number varchar(10) not null ,
    w_passport_date date not null ,
    w_passport_office integer not null ,
    w_post_index varchar(10),
    w_street_code integer not null ,
    w_building varchar(10) not null ,
    w_extension varchar(10),
    w_apartment varchar(10),
    certificate_id varchar(20) not null ,
    register_office_id integer not null ,
    marriage_date date not null ,
    PRIMARY KEY (student_order_id),
    FOREIGN KEY (h_street_code) REFERENCES jc_street(street_code)  ON DELETE RESTRICT,
    FOREIGN KEY (w_street_code) REFERENCES jc_street(street_code) ON DELETE RESTRICT,
    FOREIGN KEY (register_office_id) REFERENCES jc_register_office(r_office_id) ON DELETE RESTRICT
);

CREATE TABLE jc_student_child
(
    student_child_id SERIAL,
    student_order_id integer not null ,
    c_sur_name varchar(100) not null ,
    c_patronymic varchar(100) not null ,
    c_date_of_birth date not null ,
    c_certificate_number varchar(10),
    c_certificate_date date not null ,
    c_register_office_id integer not null ,
    c_post_index varchar(10),
    c_street_code integer not null ,
    c_building varchar(10) not null ,
    c_extension varchar(10),
    PRIMARY KEY (student_child_id),
    FOREIGN KEY (c_street_code) REFERENCES jc_street(street_code)  ON DELETE RESTRICT,
    FOREIGN KEY (c_register_office_id) REFERENCES jc_register_office(r_office_id) ON DELETE RESTRICT
);

INSERT INTO jc_street (street_code, street_name) VALUES (2,'Street First'),
                                                        (3,'Street First'),
                                                        (4,'Street First');

UPDATE jc_street SET street_name = 'Super'
WHERE street_code = 2;

--DELETE FROM jc_street WHERE street_code = 3;
