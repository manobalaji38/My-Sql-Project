-- drop database MART;
select database();
CREATE DATABASE MART;
USE MART;

-- 1. Users Table
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    address VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 2. Categories Table
CREATE TABLE Categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE
);

-- 3. Products Table
CREATE TABLE Products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    stock INT NOT NULL,
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id) ON DELETE SET NULL ON UPDATE CASCADE
);

-- 4. Orders Table
CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(50),
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 5. Order_Items Table
CREATE TABLE Order_Items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Products(product_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 6. Shopping_Cart Table
CREATE TABLE Shopping_Cart (
    cart_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 7. Cart_Items Table
CREATE TABLE Cart_Items (
    cart_item_id INT AUTO_INCREMENT PRIMARY KEY,
    cart_id INT,
    product_id INT,
    quantity INT NOT NULL,
    FOREIGN KEY (cart_id) REFERENCES Shopping_Cart(cart_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Products(product_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 8. Payment Table
CREATE TABLE Payment (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    amount DECIMAL(10, 2) NOT NULL,
    payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    payment_method VARCHAR(50),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 9. Delivery Table
CREATE TABLE Delivery (
    delivery_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    delivery_address VARCHAR(255),
    delivery_date DATETIME,
    status VARCHAR(50),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 10. Reviews Table
CREATE TABLE Reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    user_id INT,
    rating INT CHECK (rating >= 1 AND rating <= 10),
    comment TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES Products(product_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO Users (username, password, email, address)
VALUES ('Manoj', 'Manoj6', 'Manoj1@gmail.com', '1 Main St'),
('Mano', 'Mano38', 'Mano38@gmail.com', '2 Main St'),
('Dhoni', 'Dhoni7', 'Dhoni7@gmail.com', '3 Main St'),
('Mass', 'Mass6', 'Mass38@gmail.com', '4 Main St'),
('MS', 'Ms38', 'Ms38@gmail.com', '5 Main St');

SELECT * FROM Users;

INSERT INTO Categories (category_name)
VALUES ('Fruits');

SELECT * FROM Categories;

INSERT INTO Products (name, description, price, stock, category_id)
VALUES ('Apple', 'Fresh red apples', 100.10, 100, 1),
('Orange', 'Fresh Oranges', 500.50, 50, 1),
('Kiwi', 'Fresh Kiwis', 200.50, 90, 1),
('Banana', 'Fresh Bananas', 120.50, 200, 1),
('Cherry', 'Fresh Cherrys', 2500.50, 300, 1);

SELECT * FROM Products;

SELECT u.username, p.name
FROM Users u
CROSS JOIN Products p;

INSERT INTO Orders (user_id, status)
VALUES (1, 'Success'),
(1, 'Failure'),
(1, 'Pending'),
(1, 'Update'),
(1, 'Success');

SELECT * FROM Orders;

SELECT * FROM Orders WHERE user_id = 1;

SELECT o.order_id, u.username, o.order_date, o.status
FROM Orders o
INNER JOIN Users u ON o.user_id = u.user_id;

INSERT INTO Order_Items (order_id, product_id, quantity, price)
VALUES (1, 1, 5, 0.50),
(2, 2, 15, 170.50),
(3, 3, 25, 230.50),
(4, 4, 35, 220.50),
(5, 5, 54, 110.50);

SELECT * FROM Order_Items;

SELECT oi.*, p.name 
FROM Order_Items oi
JOIN Products p ON oi.product_id = p.product_id
WHERE oi.order_id = 1;

SELECT p.name, oi.quantity, oi.price
FROM Order_Items oi
RIGHT JOIN Products p ON oi.product_id = p.product_id;

INSERT INTO Shopping_Cart (user_id)
VALUES (1);

SELECT * FROM Shopping_Cart;

SELECT u.username, sc.cart_id, sc.created_at
FROM Users u
LEFT JOIN Shopping_Cart sc ON u.user_id = sc.user_id;

INSERT INTO Cart_Items (cart_id, product_id, quantity)
VALUES (1, 1, 3),
(1, 2, 4),
(1, 3, 5),
(1, 4, 6),
(1, 5, 7);

SELECT * FROM Cart_Items;

SELECT ci.*, p.name 
FROM Cart_Items ci
JOIN Shopping_Cart sc ON ci.cart_id = sc.cart_id
JOIN Products p ON ci.product_id = p.product_id
WHERE sc.user_id = 1;

INSERT INTO Payment (order_id, amount, payment_method)
VALUES (1, 2.50, 'Credit Card'),
(2, 220.50, 'Debit Card'),
(3, 120.50, 'Credit Card'),
(4, 225.50, 'Debit Card'),
(5, 150.50, 'Credit Card');

SELECT * FROM Payment;

SELECT * FROM Payment WHERE order_id = 1;

INSERT INTO Delivery (order_id, delivery_address, delivery_date, status)
VALUES (1, '123 Main St', '2024-10-10 10:00:00', 'Scheduled'),
(2, '2 Main St', '2024-10-10 10:00:00', 'Updated'),
(3, '3 Main St', '2024-10-10 10:00:00', 'Finished'),
(4, '4 Main St', '2024-10-10 10:00:00', 'Scheduled'),
(5, '5 Main St', '2024-10-10 10:00:00', 'Pending');

SELECT * FROM Delivery;

SELECT * FROM Delivery WHERE order_id = 1;

INSERT INTO Reviews (product_id, user_id, rating, comment)
VALUES (1, 1, 5, 'Great apples!'),
(2, 1, 4, 'Great Oranges!'),
(3, 1, 7, 'Great Kiwi!'),
(4, 1, 10, 'Great Bananas!'),
(5, 1, 7, 'Great Cherrys!');

SELECT * FROM Reviews;

SELECT r.*, u.username 
FROM Reviews r
JOIN Users u ON r.user_id = u.user_id
WHERE r.product_id = 1;

SELECT * FROM Products WHERE category_id = 1;

CALL GetUserProductCombinations();

CALL GetFullOrderDetails();

CALL GetOrderDetails(1);

CALL GetUserCartDetails(2);

CALL GetProductOrderDetails(3);
