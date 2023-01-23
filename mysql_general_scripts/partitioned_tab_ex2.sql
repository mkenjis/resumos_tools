CREATE TABLE store(
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	sname varchar(50));

insert into store(sname) values ('AAAAAA');
insert into store(sname) values ('BBBBBB');
insert into store(sname) values ('CCCCCC');
insert into store(sname) values ('DDDDDD');


CREATE TABLE employees  (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    fname VARCHAR(25) NOT NULL,
    lname VARCHAR(25) NOT NULL,
    store_id INT NOT NULL,
    department_id INT NOT NULL,
	FOREIGN KEY (store_id) REFERENCES store(id)
)
    PARTITION BY RANGE(id)  (
        PARTITION p0 VALUES LESS THAN (5),
        PARTITION p1 VALUES LESS THAN (10),
        PARTITION p2 VALUES LESS THAN (15),
        PARTITION p3 VALUES LESS THAN MAXVALUE
);

INSERT INTO employees(fname,lname,store_id,department_id) VALUES
    ('Bob', 'Taylor', 3, 2), ('Frank', 'Williams', 1, 2),
    ('Ellen', 'Johnson', 3, 4), ('Jim', 'Smith', 2, 4),
    ('Mary', 'Jones', 1, 1), ('Linda', 'Black', 2, 3),
    ('Ed', 'Jones', 2, 1), ('June', 'Wilson', 3, 1),
    ('Andy', 'Smith', 1, 3), ('Lou', 'Waters', 2, 4),
    ('Jill', 'Stone', 1, 4), ('Roger', 'White', 3, 2),
    ('Howard', 'Andrews', 1, 2), ('Fred', 'Goldberg', 3, 3),
    ('Barbara', 'Brown', 2, 3), ('Alice', 'Rogers', 2, 2),
    ('Mark', 'Morgan', 3, 3), ('Karen', 'Cole', 3, 2);
	
SELECT PARTITION_NAME, TABLE_ROWS FROM INFORMATION_SCHEMA.PARTITIONS WHERE TABLE_NAME = 'employees';

ALTER TABLE employees add FOREIGN KEY (store_id) REFERENCES store(id);
ERROR 1506 (HY000): Foreign keys are not yet supported in conjunction with partitioning


CREATE TABLE Orders (
    OrderID int NOT NULL,
    OrderNumber int NOT NULL,
    PersonID INT,
    PRIMARY KEY (OrderID),
    FOREIGN KEY (PersonID) REFERENCES employees(PersonID)
);
ERROR 1506 (HY000): Foreign keys are not yet supported in conjunction with partitioning
