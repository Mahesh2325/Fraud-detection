


use DBMS;
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL
);

CREATE TABLE transactions (
    txn_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,                          
    amount DECIMAL(10, 2),                  
    recipient VARCHAR(255),                 
    merchant VARCHAR(255),                  
    location VARCHAR(255),                 
    device_type VARCHAR(50),                
    txn_type VARCHAR(50),                 
    frequency INT,                          
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  
    is_fraud BOOLEAN,                       
    user_name VARCHAR(255),                 
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE fraud_history (
    history_id INT PRIMARY KEY AUTO_INCREMENT,
    txn_id INT,                           
    is_fraud BOOLEAN,                   
    detection_method VARCHAR(255),       
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  
    FOREIGN KEY (txn_id) REFERENCES transactions(txn_id)
);


INSERT INTO users (name) VALUES 
('Ravi Kumar'),
('Priya Sharma'),
('Aman Singh'),
('Neha Verma'),
('Vikas Joshi'),
('Sneha Patel'),
('Ankit Mehra'),
('Pooja Sinha'),
('Rahul Jain'),
('Divya Kapoor');


INSERT INTO transactions (user_id, amount, recipient, merchant, location, device_type, txn_type, frequency, is_fraud, user_name) VALUES 
(1, 1500.00, 'amit@upi', 'Flipkart', 'Delhi', 'Android', 'Online', 5, 0, 'Ravi Kumar'),
(2, 250.75, 'neha@upi', 'Zomato', 'Mumbai', 'iOS', 'Food', 2, 0, 'Priya Sharma'),
(3, 5000.00, 'pooja@upi', 'Amazon', 'Bangalore', 'Android', 'Shopping', 10, 1, 'Aman Singh'),
(4, 89.00, 'rahul@upi', 'Uber', 'Delhi', 'iOS', 'Transport', 3, 0, 'Neha Verma'),
(5, 20000.00, 'vikas@upi', 'Meesho', 'Hyderabad', 'Android', 'Online', 20, 1, 'Vikas Joshi'),
(6, 349.99, 'ravi@upi', 'Swiggy', 'Chennai', 'iOS', 'Food', 1, 0, 'Sneha Patel'),
(7, 7890.00, 'divya@upi', 'Ajio', 'Pune', 'Android', 'Shopping', 12, 1, 'Ankit Mehra'),
(8, 150.00, 'ankit@upi', 'IRCTC', 'Kolkata', 'Android', 'Travel', 4, 0, 'Pooja Sinha'),
(9, 1050.00, 'sneha@upi', 'Snapdeal', 'Ahmedabad', 'iOS', 'Online', 6, 1, 'Rahul Jain'),
(10, 499.00, 'priya@upi', 'Myntra', 'Noida', 'Android', 'Shopping', 3, 0, 'Divya Kapoor');


INSERT INTO fraud_history (txn_id, is_fraud, detection_method) VALUES 
(3, 1, 'ML_Model'),
(5, 1, 'ML_Model'),
(7, 1, 'ML_Model'),
(9, 1, 'ML_Model');

INSERT INTO transactions (user_id, amount, recipient, merchant, location, device_type, txn_type, frequency, user_name, is_fraud)
VALUES (1, 299.00, 'test@upi', 'TestStore', 'Delhi', 'Android', 'Online', 2, 'Ravi Kumar', NULL);
INSERT INTO transactions (user_id, amount, recipient, merchant, location, device_type, txn_type, frequency, user_name, is_fraud)
VALUES (1, 1000.00, 'test@upi', 'Amazon', 'Delhi', 'Android', 'Shopping', 3, 'Ravi Kumar', NULL),
       (2, 500.00, 'sample@upi', 'Flipkart', 'Mumbai', 'iOS', 'Shopping', 5, 'Priya Sharma', NULL);

SELECT * FROM transactions;
