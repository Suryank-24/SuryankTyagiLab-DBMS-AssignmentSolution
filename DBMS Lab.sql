CREATE DATABASE e_commerce;
USE e_commerce;

CREATE TABLE e_commerce.supplier
(
	supp_id INT PRIMARY KEY AUTO_INCREMENT,
    supp_name VARCHAR(30) NOT NULL,
    supp_city VARCHAR(40) NOT NULL,
    supp_phone VARCHAR(10) NOT NULL
);

CREATE TABLE e_commerce.customer
(
	cus_id INT PRIMARY KEY AUTO_INCREMENT,
    cus_name VARCHAR(30) NOT NULL,
    cus_phone VARCHAR(10) NOT NULL,
    cus_city VARCHAR(40) NOT NULL,
    cus_gender CHARACTER NOT NULL
);

CREATE TABLE e_commerce.category
(
	cat_id INT PRIMARY KEY,
    cat_name VARCHAR(30) NULL DEFAULT NULL
);

CREATE TABLE e_commerce.product
(
	pro_id INT PRIMARY KEY,
    pro_name VARCHAR(30) NULL DEFAULT NULL,
    pro_desc VARCHAR(60) NULL DEFAULT NULL,
    cat_id INT NOT NULL,
    FOREIGN KEY(cat_id) REFERENCES category(cat_id)
);

CREATE TABLE e_commerce.productdetails
(
		prod_id INT PRIMARY KEY,
        pro_id INT NOT NULL,
        supp_id INT NOT NULL,
        prod_price INT NOT NULL,
        FOREIGN KEY(pro_id) REFERENCES product(pro_id),
        FOREIGN KEY(supp_id) REFERENCES supplier(supp_id)
);

CREATE TABLE e_commerce.`order`
(
	ord_id INT PRIMARY KEY,
    ord_amount INT NOT NULL,
    ord_date DATE,
    cus_id	INT NOT NULL,
    prod_id INT NOT NULL,
	FOREIGN KEY(cus_id) REFERENCES customer(cus_id),
	FOREIGN KEY(prod_id) REFERENCES productdetails(prod_id)
);

CREATE TABLE e_commerce.ratings
(
	rat_id INT PRIMARY KEY,
    cus_id INT NOT NULL,
    supp_id INT NOT NULL,
    rat_ratstars INT NOT NULL,
    FOREIGN KEY(supp_id) REFERENCES supplier(supp_id),
	FOREIGN KEY(cus_id) REFERENCES customer(cus_id)
);

INSERT INTO e_commerce.supplier VALUES
(1,'Rajesh Retails','Delhi','1234567890'),
(2,'Appario Ltd.','Mumbai','2589631470'),
(3,'Knome products','Banglore','9785462315'),
(4,'Bansal Retails','Kochi','8975463285'),
(5,'Mittal Ltd.','Lucknow','7898456532');

INSERT INTO e_commerce.customer VALUES
(1,'AAKASH','9999999999','DELHI','M'), 
(2,'AMAN','9785463215', 'NOIDA','M'),
(3,'NEHA','9999999999','MUMBAI','F'),
(4,'MEGHA','9994562399','KOLKATA','F'),
(5,'PULKIT','7895999999', 'LUCKNOW','M');

INSERT INTO e_commerce.category VALUES
(1,'BOOKS'),
(2,'GAMES'),
(3,'GROCERIES'),
(4,'ELECTRONICS'),
(5,'CLOTHES');

INSERT INTO e_commerce.product VALUES
(1,'GTA V','DFJDJFDJFDJFDJFJF',2),
(2,'TSHIRT', 'DFDFJDFJDKFD', 5),
(3,'ROG LAPTOP', 'DFNTTNTNTERND', 4), 
(4,'OATS', 'REURENTBTOTH', 3), 
(5,'HARRY POTTER' ,'NBEMCTHTJTH', 1);

INSERT INTO e_commerce.productdetails VALUES
(1,1,2,1500),
(2,3,5,30000),
(3,5,1,3000),	
(4,2,3,2500),
(5,4,1,1000);

INSERT INTO e_commerce.`order` VALUES
(20,1500,'2021-10-12',3,5),
(25,30500,'2021-09-16',5,2),
(26,2000,'2021-10-05',1,1),
(30,3500,'2021-08-16',4,3),
(50,2000,'2021-10-06',2,1);

INSERT INTO e_commerce.ratings VALUES
(1,2,2,4), 
(2,3,4,3),
(3,5,1,5),
(4,1,3,2),
(5,4,5,4);

#Query 3:

SELECT customer.cus_gender, COUNT(cus_gender) AS COUNT FROM customer
INNER JOIN `order` ON customer.cus_id = `order`.cus_id
WHERE `order`.ord_amount >= 3000
GROUP BY customer.cus_gender;

#Query 4:

SELECT `order`.*, pro_name FROM `order`, productdetails,product
WHERE `order`.cus_id = 2
AND `order`.prod_id = productdetails.prod_id AND productdetails.prod_id = product.pro_id;

#Query 5:

SELECT supplier.* FROM supplier,productdetails WHERE supplier.supp_id 
IN (SELECT productdetails.supp_id FROM productdetails GROUP BY productdetails.supp_id
HAVING COUNT(productdetails.supp_id) > 1 ) GROUP BY supplier.supp_id;

#Query 6:

SELECT category.* FROM `order` INNER JOIN productdetails ON
`order`.prod_id = productdetails.prod_id INNER JOIN product ON
product.pro_id = productdetails.prod_id INNER JOIN category ON
category.cat_id = product.cat_id
HAVING MIN(`order`.ord_amount);


#Query 7:

SELECT product.pro_id,product.pro_name FROM `order` INNER JOIN productdetails ON
productdetails.prod_id = `order`.prod_id INNER JOIN product ON
product.pro_id = productdetails.pro_id
WHERE `order`.ord_date > '2021/10/05';

#Query 8:

SELECT customer.cus_name,customer.cus_gender FROM
customer WHERE customer.cus_name LIKE 'A%' OR customer.cus_name
LIKE '%A';

#Query 9:

SELECT supplier.supp_id,supplier.supp_name,ratings.rat_ratstars,
CASE
 WHEN ratings.rat_ratstars > 4 THEN 'genuine supplier'
 WHEN ratings.rat_ratstars > 2 THEN 'average supplier'
 ELSE 'supplier should not be considered'
END 
AS verdict FROM ratings INNER JOIN supplier ON supplier.supp_id = ratings.supp_id;



/*This query is used above in the workbench for lab assesment*/
delimiter $$
CREATE procedure proc1()
BEGIN
SELECT supplier.supp_id,supplier.supp_name,ratings.rat_ratstars,
CASE
 WHEN ratings.rat_ratstars > 4 THEN 'genuine supplier'
 WHEN ratings.rat_ratstars > 2 THEN 'average supplier'
 ELSE 'supplier should not be considered'
END 
AS verdict FROM ratings INNER JOIN supplier ON supplier.supp_id = ratings.supp_id;
END $$

call proc1;