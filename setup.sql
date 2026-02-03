-- Gies Coffee Shop Database Setup
-- Creates users, database, tables, and sample data

-- Create users
CREATE USER IF NOT EXISTS 'admin'@'%' IDENTIFIED BY 'GiesCoffee2026!';
GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%';

CREATE USER IF NOT EXISTS 'student'@'%' IDENTIFIED BY 'coffee123';
GRANT SELECT, INSERT ON *.* TO 'student'@'%';

FLUSH PRIVILEGES;

-- Create database
CREATE DATABASE IF NOT EXISTS gies_coffee_shop;
USE gies_coffee_shop;

-- Menu Items Table
CREATE TABLE IF NOT EXISTS menu_items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price DECIMAL(5,2) NOT NULL,
    available BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Daily Sales Table
CREATE TABLE IF NOT EXISTS daily_sales (
    transaction_id VARCHAR(20) PRIMARY KEY,
    sale_date DATE NOT NULL,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(5,2) NOT NULL,
    total_amount DECIMAL(8,2) NOT NULL,
    payment_method VARCHAR(20),
    customer_type VARCHAR(20) DEFAULT 'Walk-in'
);

-- Customer Orders Table
CREATE TABLE IF NOT EXISTS customer_orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100),
    product_name VARCHAR(100) NOT NULL,
    quantity INT DEFAULT 1,
    order_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Populate Menu
INSERT INTO menu_items (product_name, category, price) VALUES
('Espresso', 'Coffee', 3.50),
('Latte', 'Coffee', 4.75),
('Cappuccino', 'Coffee', 4.50),
('Americano', 'Coffee', 3.75),
('Mocha', 'Coffee', 5.25),
('Cold Brew', 'Coffee', 4.50),
('Green Tea', 'Tea', 3.25),
('Chai Latte', 'Tea', 4.50),
('Earl Grey', 'Tea', 3.00),
('Hot Chocolate', 'Other', 4.00),
('Lemonade', 'Other', 3.50),
('Croissant', 'Pastry', 3.50),
('Blueberry Muffin', 'Pastry', 3.75),
('Chocolate Chip Cookie', 'Pastry', 2.50),
('Bagel with Cream Cheese', 'Pastry', 4.25),
('Cinnamon Roll', 'Pastry', 4.50),
('Avocado Toast', 'Food', 7.50),
('Turkey Sandwich', 'Food', 8.50),
('Caesar Salad', 'Food', 9.00),
('Grilled Cheese', 'Food', 6.50);

-- Populate 3 Days of Sales Data
INSERT INTO daily_sales VALUES
('T001','2026-01-13','Latte','Coffee',2,4.75,9.50,'Credit Card','Regular'),
('T002','2026-01-13','Croissant','Pastry',2,3.50,7.00,'Credit Card','Regular'),
('T003','2026-01-13','Espresso','Coffee',1,3.50,3.50,'Cash','Walk-in'),
('T004','2026-01-13','Avocado Toast','Food',1,7.50,7.50,'Credit Card','Walk-in'),
('T005','2026-01-13','Cappuccino','Coffee',1,4.50,4.50,'Mobile Pay','Regular'),
('T006','2026-01-13','Blueberry Muffin','Pastry',3,3.75,11.25,'Cash','Walk-in'),
('T007','2026-01-13','Americano','Coffee',1,3.75,3.75,'Credit Card','Student'),
('T008','2026-01-13','Chai Latte','Tea',1,4.50,4.50,'Mobile Pay','Student'),
('T009','2026-01-13','Turkey Sandwich','Food',1,8.50,8.50,'Credit Card','Regular'),
('T010','2026-01-13','Mocha','Coffee',2,5.25,10.50,'Cash','Walk-in'),
('T011','2026-01-13','Green Tea','Tea',1,3.25,3.25,'Credit Card','Student'),
('T012','2026-01-13','Cinnamon Roll','Pastry',2,4.50,9.00,'Mobile Pay','Regular'),
('T013','2026-01-13','Cold Brew','Coffee',3,4.50,13.50,'Credit Card','Student'),
('T014','2026-01-13','Bagel with Cream Cheese','Pastry',1,4.25,4.25,'Cash','Walk-in'),
('T015','2026-01-13','Latte','Coffee',1,4.75,4.75,'Credit Card','Regular'),
('T016','2026-01-13','Caesar Salad','Food',1,9.00,9.00,'Credit Card','Walk-in'),
('T017','2026-01-13','Hot Chocolate','Other',2,4.00,8.00,'Cash','Student'),
('T018','2026-01-13','Espresso','Coffee',2,3.50,7.00,'Mobile Pay','Regular'),
('T019','2026-01-13','Grilled Cheese','Food',1,6.50,6.50,'Credit Card','Student'),
('T020','2026-01-13','Lemonade','Other',2,3.50,7.00,'Cash','Walk-in'),
('T021','2026-01-14','Cappuccino','Coffee',1,4.50,4.50,'Credit Card','Regular'),
('T022','2026-01-14','Croissant','Pastry',1,3.50,3.50,'Credit Card','Regular'),
('T023','2026-01-14','Latte','Coffee',3,4.75,14.25,'Mobile Pay','Student'),
('T024','2026-01-14','Avocado Toast','Food',2,7.50,15.00,'Credit Card','Walk-in'),
('T025','2026-01-14','Americano','Coffee',1,3.75,3.75,'Cash','Regular'),
('T026','2026-01-14','Chocolate Chip Cookie','Pastry',4,2.50,10.00,'Cash','Student'),
('T027','2026-01-14','Mocha','Coffee',1,5.25,5.25,'Credit Card','Walk-in'),
('T028','2026-01-14','Earl Grey','Tea',1,3.00,3.00,'Mobile Pay','Regular'),
('T029','2026-01-14','Turkey Sandwich','Food',2,8.50,17.00,'Credit Card','Regular'),
('T030','2026-01-14','Espresso','Coffee',1,3.50,3.50,'Cash','Student'),
('T031','2026-01-14','Chai Latte','Tea',2,4.50,9.00,'Credit Card','Walk-in'),
('T032','2026-01-14','Blueberry Muffin','Pastry',1,3.75,3.75,'Mobile Pay','Student'),
('T033','2026-01-14','Cold Brew','Coffee',2,4.50,9.00,'Credit Card','Regular'),
('T034','2026-01-14','Cinnamon Roll','Pastry',1,4.50,4.50,'Cash','Walk-in'),
('T035','2026-01-14','Latte','Coffee',1,4.75,4.75,'Credit Card','Student'),
('T036','2026-01-14','Grilled Cheese','Food',2,6.50,13.00,'Mobile Pay','Regular'),
('T037','2026-01-14','Green Tea','Tea',1,3.25,3.25,'Cash','Walk-in'),
('T038','2026-01-14','Hot Chocolate','Other',1,4.00,4.00,'Credit Card','Student'),
('T039','2026-01-14','Caesar Salad','Food',1,9.00,9.00,'Credit Card','Regular'),
('T040','2026-01-14','Lemonade','Other',1,3.50,3.50,'Cash','Walk-in'),
('T041','2026-01-15','Latte','Coffee',2,4.75,9.50,'Credit Card','Regular'),
('T042','2026-01-15','Espresso','Coffee',1,3.50,3.50,'Cash','Walk-in'),
('T043','2026-01-15','Avocado Toast','Food',3,7.50,22.50,'Credit Card','Student'),
('T044','2026-01-15','Cappuccino','Coffee',1,4.50,4.50,'Mobile Pay','Regular'),
('T045','2026-01-15','Croissant','Pastry',2,3.50,7.00,'Cash','Walk-in'),
('T046','2026-01-15','Mocha','Coffee',2,5.25,10.50,'Credit Card','Student'),
('T047','2026-01-15','Turkey Sandwich','Food',3,8.50,25.50,'Credit Card','Regular'),
('T048','2026-01-15','Americano','Coffee',1,3.75,3.75,'Mobile Pay','Walk-in'),
('T049','2026-01-15','Chai Latte','Tea',1,4.50,4.50,'Cash','Student'),
('T050','2026-01-15','Bagel with Cream Cheese','Pastry',2,4.25,8.50,'Credit Card','Regular'),
('T051','2026-01-15','Cold Brew','Coffee',4,4.50,18.00,'Mobile Pay','Student'),
('T052','2026-01-15','Chocolate Chip Cookie','Pastry',6,2.50,15.00,'Cash','Walk-in'),
('T053','2026-01-15','Caesar Salad','Food',2,9.00,18.00,'Credit Card','Regular'),
('T054','2026-01-15','Green Tea','Tea',1,3.25,3.25,'Credit Card','Student'),
('T055','2026-01-15','Grilled Cheese','Food',1,6.50,6.50,'Cash','Walk-in'),
('T056','2026-01-15','Latte','Coffee',1,4.75,4.75,'Mobile Pay','Regular'),
('T057','2026-01-15','Hot Chocolate','Other',3,4.00,12.00,'Credit Card','Student'),
('T058','2026-01-15','Cinnamon Roll','Pastry',2,4.50,9.00,'Cash','Regular'),
('T059','2026-01-15','Earl Grey','Tea',1,3.00,3.00,'Credit Card','Walk-in'),
('T060','2026-01-15','Lemonade','Other',3,3.50,10.50,'Mobile Pay','Student');
