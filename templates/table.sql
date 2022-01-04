drop table registered;
drop table section;
drop table courses;
drop table users;
drop table student;
drop table department;
drop table university;

create table university(
    univ_id CHAR(2) NOT NULL,
    univ_name CHAR(10) NOT NULL,
    PRIMARY KEY(univ_id)
); 

create table department(
    dept_name VARCHAR(20) NOT NULL,
    building VARCHAR(20) NOT NULL,
    univ_id CHAR(2) NOT NULL,
    dept_id CHAR(2) NOT NULL,
    PRIMARY KEY(dept_name),
    FOREIGN KEY(univ_id) references university(univ_id) on delete cascade
);

create table student(
    id CHAR(10) NOT NULL,
    name VARCHAR(10) NOT NULL,
    dept_name VARCHAR(20) NOT NULL,
    year NUMERIC(1,0) NOT NULL,
    min_credit_limit NUMERIC(1,0) NOT NULL,
    max_credit_limit NUMERIC(2,0) NOT NULL,
    tot_credit NUMERIC(2,0) check (tot_credit >=student.min_credit_limit and tot_credit <= student.max_credit_limit ),
    PRIMARY KEY(id),
    FOREIGN KEY(dept_name) references department(dept_name) on delete cascade
);

create table users(
    id CHAR(10) NOT NULL,
    pwd VARCHAR(20) NOT NULL,
    PRIMARY KEY(id),
    FOREIGN KEY(id) references student(id) on delete cascade
);


create table courses(
    course_id CHAR(8) NOT NULL,
    title VARCHAR(20) NOT NULL,
    dept_name VARCHAR(20) NOT NULL,
    credits NUMERIC(1,0) check(credits > 0),
    is_major BOOLEAN NOT NULL,
    is_required BOOLEAN NOT NULL,
    PRIMARY KEY(course_id),
    FOREIGN KEY(dept_name) references department(dept_name) on delete cascade
);

create table section(
    course_id CHAR(8) NOT NULL,
    sec_id CHAR(2) NOT NULL,
    semester varchar(6) check (semester in ('Spring', 'Summer', 'Fall', 'Winter')),
    year NUMERIC(4,0) check (year >2000 and year <2100),
    is_contact BOOLEAN NOT NULL,
    is_not_contact BOOLEAN NOT NULL,
    PRIMARY KEY(course_id, sec_id, semester, year),
    FOREIGN KEY(course_id) references courses(course_id) on delete cascade
);



create table registered(
    id CHAR(10) NOT NULL,
    course_id CHAR(8) NOT NULL,
    sec_id CHAR(2) NOT NULL,
    semester varchar(6) check (semester in ('Spring','Summer', 'Fall', 'Winter')),
    year NUMERIC(4,0) check (year > 2000 and year < 2100),
    PRIMARY KEY(id, course_id, sec_id, semester, year),
    FOREIGN KEY(course_id, sec_id, semester, year) references section(course_id, sec_id, semester, year) on delete cascade,
    FOREIGN KEY(id) references student(id) on delete cascade
);


--university--
INSERT INTO university VALUES('32','정보대학');
INSERT INTO university VALUES('17','공과대학');
INSERT INTO university VALUES('12','경영대학');
INSERT INTO university VALUES('25','보건과학대학');
INSERT INTO university VALUES('15','정경대학');


--department--
INSERT INTO department VALUES('컴퓨터학과', '우정정보관', '32', '00');
INSERT INTO department VALUES('경영학과', '현차관', '12', '00');
INSERT INTO department VALUES('경제학과', '정경관', '15', '00');
INSERT INTO department VALUES('보건환경융합과학부', '하나과학관', '25','00');
INSERT INTO department VALUES('전기전자공학부', '신공학관', '17', '03');
INSERT INTO department VALUES('산업경영공학부', '신공학관', '17', '01');
INSERT INTO department VALUES('신소재공학부', '공학관', '17', '02');
--courses--
INSERT INTO courses VALUES('COSE156', '모두를위한파이썬', '컴퓨터학과', 3, FALSE, FALSE);
INSERT INTO courses VALUES('COSE211', '이산수학', '컴퓨터학과', 3, TRUE, FALSE);
INSERT INTO courses VALUES('COSE214', '알고리즘', '컴퓨터학과', 3, TRUE, TRUE);

INSERT INTO courses VALUES('COSE215', '계산이론', '컴퓨터학과', 3, TRUE, FALSE);
INSERT INTO courses VALUES('COSE242', '데이터통신', '컴퓨터학과', 3, TRUE, FALSE);
INSERT INTO courses VALUES('COSE222', '컴퓨터구조', '컴퓨터학과', 3, TRUE, TRUE);
INSERT INTO courses VALUES('COSE281', '공학수학', '컴퓨터학과', 3, TRUE, FALSE);
INSERT INTO courses VALUES('COSE342', '컴퓨터네트워크', '컴퓨터학과', 3, TRUE, TRUE);
INSERT INTO courses VALUES('COSE371', '데이터베이스', '컴퓨터학과', 3, TRUE, TRUE);
INSERT INTO courses VALUES('COSE382', '확률및랜덤과정', '컴퓨터학과', 3, TRUE, FALSE);
INSERT INTO courses VALUES('BUSS205', '마케팅원론', '경영학과', 3, TRUE, TRUE);
INSERT INTO courses VALUES('BUSS238', '광고론', '경영학과', 3, TRUE, FALSE);
INSERT INTO courses VALUES('BUSS203', '경영수학', '경영학과', 3, TRUE, FALSE);

INSERT INTO courses VALUES('GEQR067', '하이퍼텍스트와계산가능성', '컴퓨터학과', 3, FALSE, TRUE);
INSERT INTO courses VALUES('KECE208', '데이터구조및알고리즘', '전기전자공학부', 3, TRUE, FALSE);
INSERT INTO courses VALUES('KECE232', '공학수학2', '전기전자공학부', 3, TRUE, TRUE);
INSERT INTO courses VALUES('AMSE220', '공학수학2', '신소재공학부', 3, TRUE, TRUE);
INSERT INTO courses VALUES('GECT001', '정보적사고', '컴퓨터학과', 1, FALSE, TRUE);


--student--
INSERT INTO student VALUES('2020111999', 'Kim', '컴퓨터학과', 2, 0, 22, 0);
INSERT INTO student VALUES('2019320898', 'Park', '컴퓨터학과', 3, 0, 22, 0);
INSERT INTO student VALUES('2021300870', 'Hong', '컴퓨터학과', 1, 0, 22, 0);
INSERT INTO student VALUES('2020320998', 'Cho', '컴퓨터학과', 2, 0, 22, 0);
INSERT INTO student VALUES('2020320051', 'Jin', '컴퓨터학과', 2, 0, 22, 0);
--users--


--section--
INSERT INTO section VALUES('COSE342', '00', 'Fall', 2021, FALSE, TRUE);
INSERT INTO section VALUES('COSE342', '01', 'Fall', 2021, FALSE, TRUE);
INSERT INTO section VALUES('COSE211', '01', 'Fall', 2021, FALSE, TRUE);
INSERT INTO section VALUES('COSE211', '02', 'Fall', 2021, FALSE, TRUE);
INSERT INTO section VALUES('COSE222', '01', 'Fall', 2021, FALSE, TRUE);
INSERT INTO section VALUES('COSE222', '02', 'Fall', 2021, FALSE, TRUE);
INSERT INTO section VALUES('COSE222', '03', 'Fall', 2021, FALSE, TRUE);
INSERT INTO section VALUES('GEQR067', '00', 'Fall', 2021, FALSE, TRUE);
INSERT INTO section VALUES('COSE371', '01', 'Fall', 2021, FALSE, TRUE);
INSERT INTO section VALUES('COSE371', '02', 'Fall', 2021, TRUE, TRUE);
INSERT INTO section VALUES('COSE371', '01', 'Spring', 2022, TRUE, FALSE);
INSERT INTO section VALUES('COSE281', '01', 'Fall', 2021, FALSE, TRUE);
INSERT INTO section VALUES('COSE281', '02', 'Fall', 2021, FALSE, TRUE);
INSERT INTO section VALUES('COSE382', '01','Fall', 2021, FALSE,TRUE);

INSERT INTO section VALUES('BUSS205', '01', 'Fall', 2021, FALSE, TRUE);
INSERT INTO section VALUES('BUSS205', '02', 'Fall', 2021, FALSE, TRUE);
INSERT INTO section VALUES('BUSS205', '03', 'Fall', 2021, FALSE, TRUE);
INSERT INTO section VALUES('BUSS203', '01', 'Fall', 2021, FALSE, TRUE);
INSERT INTO section VALUES('BUSS203', '02', 'Fall', 2021, FALSE, TRUE);

INSERT INTO section VALUES('COSE214', '01', 'Fall', 2021, FALSE, TRUE);
INSERT INTO section VALUES('COSE214', '02', 'Fall', 2021, TRUE, TRUE);
INSERT INTO section VALUES('COSE214', '03', 'Fall', 2021, FALSE, TRUE);
INSERT INTO section VALUES('COSE214', '01', 'Spring', 2021, FALSE, TRUE);
INSERT INTO section VALUES('COSE214', '02', 'Spring', 2021, TRUE, TRUE);
INSERT INTO section VALUES('COSE215', '00', 'Fall', 2021, FALSE, TRUE);
INSERT INTO section VALUES('COSE215', '00', 'Spring', 2021, FALSE, TRUE);
INSERT INTO section VALUES('COSE242', '01', 'Fall', 2021, FALSE, TRUE);
INSERT INTO section VALUES('COSE242', '02', 'Fall', 2021, FALSE, TRUE);

INSERT INTO section VALUES('KECE232', '01', 'Fall', 2021, FALSE, TRUE);
INSERT INTO section VALUES('KECE232', '02', 'Fall', 2021, TRUE, FALSE);
INSERT INTO section VALUES('KECE232', '03', 'Fall', 2021, FALSE, TRUE);
INSERT INTO section VALUES('KECE208', '01', 'Fall', 2021, FALSE, TRUE);
INSERT INTO section VALUES('KECE208', '02', 'Fall', 2021, FALSE, TRUE);
INSERT INTO section VALUES('KECE208', '03', 'Fall', 2021, TRUE, TRUE);
INSERT INTO section VALUES('KECE208', '04', 'Fall', 2021, FALSE, TRUE);

INSERT INTO section VALUES('AMSE220', '01', 'Fall', 2021, FALSE, TRUE);
INSERT INTO section VALUES('AMSE220', '02', 'Fall', 2021, FALSE, TRUE);
INSERT INTO section VALUES('AMSE220', '03', 'Fall', 2021, FALSE, TRUE);
INSERT INTO section VALUES('GECT001', '00', 'Fall', 2021, FALSE, TRUE);
INSERT INTO section VALUES('COSE156', '00', 'Fall', 2021, FALSE, TRUE);