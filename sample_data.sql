-- ~-~-~-~-~-~-~-~-~-~-~-~-~-~
-- SAMPLE DATA:
-- ~-~-~-~-~-~-~-~-~-~-~-~-~-~
INSERT INTO branch (branch_id, state, routing_number) VALUES	
(103, 'FL', 1236547824),
(104, 'FL', 1236547824),

(289, 'NY', 1248652365),
(290, 'NY', 1248652365),

(312, 'CA', 1254673298),
(313, 'CA', 1254673298);

INSERT INTO customer (customer_id, customer_status, name, address, email, phone, branch_id) VALUES
(1, 'ACTIVE', 'John Doe', '1234 Mockingbird Lane', 'MrDoe25@gmail.com', null, 103),
(2, 'ACTIVE', 'Jane Doe', '1234 Mockingbird Lane', 'MsDoe25@gmail.com', 9544878654, 103),
(3, 'ACTIVE', 'Elenanor Smith', '5678 Palm Tree Lane', 'ESmith23@gmail.com', 5615485325, 104),
(4, 'ACTIVE', 'Owlsley the Owl', '777 Glades Road', null, null, 104),
(5, 'ACTIVE', 'Frank Jones', '8797 Orange Tree Road', 'FJones19@gmail.com', 5614148798, 104),

(6, 'ACTIVE', 'Anna Davis', '4561 Liberty Lane', 'ADavis99@gmail.com', 1234567891, 289),
(7, 'ACTIVE', 'Harry Smith', '9781 Monopoly Street', 'HSmith63@gmail.com', null, 290),
(8, 'ACTIVE', 'Daisy Smith', '4561 Liberty Lane', 'DSmith64@gmail.com', null, 289);

INSERT INTO account (account_number, account_status, account_type, account_balance, customer_id, branch_id) VALUES
(1, 'ACTIVE', 'Checking', 5678.90,  1, 103),
(2, 'ACTIVE', 'Saving',  50907.00, 1, 103),
(3, 'ACTIVE', 'Checking', 487.03,   2, 103),
(4, 'ACTIVE', 'Saving',  1.00,     2, 103),

(5, 'ACTIVE', 'Checking', 0.33,     3, 104),
(6, 'ACTIVE', 'Checking', 156.35,   4, 104),
(7, 'ACTIVE', 'Saving',  4500.56,  4, 104),
(8, 'ACTIVE', 'Checking', 123.45,   5, 104),
(9, 'ACTIVE', 'Saving',  6789.10,  5, 104),

(10, 'ACTIVE', 'Checking',  78975.00,  6, 290),
(11, 'ACTIVE', 'Saving',  1000000.00,  6, 290);

INSERT INTO loan (loan_id, loan_status, loan_balance, interest_rate, customer_id, branch_id) VALUES
(1, 'ACTIVE', 367548.65, 3.99, 6, 289),
(2, 'ACTIVE', 1500.00, 1.50, 7, 289),
(3, 'ACTIVE', 35000.00, 29.99, 8, 289),

(4, 'ACTIVE', 25.00, 29.99, 5, 104);

 INSERT INTO transaction (transaction_id, transaction_date, transaction_status, transaction_amount, transaction_type, account_number, branch_id, loan_id) VALUES
 (1, '2025-09-30', 'Completed', 100.00,  'Deposit', 1, 103, null),
 (2, '2025-09-30', 'Completed', 100.00,  'Deposit', 8, 104, 4),
 (3, '2025-10-03', 'Processing', 148.00, 'Withdraw', 1, 103, null),
 (4, '2025-10-03', 'Processing', 20.00,  'Withdraw', 6, 104, null),
 (5, '2025-10-03', 'Processing', 0.02,   'Withdraw', 5, 104, null);
 
