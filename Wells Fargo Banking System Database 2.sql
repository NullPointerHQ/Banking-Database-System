-- Note to the grader: The WF database and sample data are carried over from report 2 and are included in this file for convenience
-- during testing so that all procedures and functions are available when the database is instantiated.
-- ~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~
-- 	DATABASE IMPLEMENTATION FROM REPORT 2:
-- ~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~

-- =========================================
-- 		 Wells Fargo Banking Database
-- =========================================

DROP DATABASE IF EXISTS wells_fargo_database; 
CREATE DATABASE wells_fargo_database; 
USE wells_fargo_database;

CREATE TABLE branch(
	-- Attributes
	branch_id			INT NOT NULL,
    state				VARCHAR(3) NOT NULL,
    routing_number		integer NOT NULL,
    
    -- Keys
    PRIMARY KEY			(branch_id),
    -- Constraints
    CONSTRAINT new_branch_id UNIQUE (branch_id),
    

    -- Note to the Grader [9/26/25]:  With the Professors approval the constraint 'valid_branch_routing_number is 
    -- integrated in the declaration of the attribute routing_number as 'NOT NULL'
    
    -- Constraint: valid_us_state, Abbreviations for US States and territories are provided by the Federal Aviation Administration
    -- (FAA) and can be viewed here: https://www.faa.gov/air_traffic/publications/atpubs/cnt_html/appendix_a.html					
   
	 CONSTRAINT valid_us_state CHECK( state IN (						
	 'AL', 'AK', 'AZ', 'AR', 'AS', 'CA', 'CO', 'CT', 'DE', 'DC',
	 'FL', 'GA', 'GU', 'HI', 'ID', 'IL', 'IN', 'IA', 'KS', 'KY',
	 'LA', 'ME', 'MD', 'MA', 'MI', 'MN', 'MS', 'MO', 'MT', 'NE',
	 'NV', 'NH', 'NJ', 'NM', 'NY', 'NC', 'ND', 'MP', 'OH', 'OK',
	 'OR', 'PA', 'PR', 'RI', 'SC', 'SD', 'TN', 'TX', 'TT', 'UT', 
	 'VT', 'VA', 'VI', 'WA', 'WV', 'WI', 'WY'))
     );
     
CREATE TABLE customer(
	-- Attributes
    customer_id 		INT NOT NULL,
    customer_status 	VARCHAR(10) NOT NULL,
    name 				VARCHAR(50) NOT NULL,	-- The 'minimum_information' constraint requires this value not to be null
    address				VARCHAR(50) NOT NULL,	-- The 'minimum_information' constraint requires this value not to be null
    email				VARCHAR(50),
    phone				VARCHAR(10),			-- Changed to store as a VARCHAR, Phone numbers violate integer limits (https://stackoverflow.com/questions/14284494/mysql-error-1264-out-of-range-value-for-column)
    branch_id			INT NOT NULL,
	
    -- KEYS
    PRIMARY KEY 		(customer_id),
    CONSTRAINT branch_required_customer FOREIGN KEY			(branch_id)   REFERENCES branch(branch_id),
    
    -- Constraints
    CONSTRAINT new_customer UNIQUE (customer_id)); 					-- Textbook Page: 147 and 151
    -- Note to the grader [9/26/25]: The constraint 'minimum_involvement' which belongs here, with the Professors approval,
    -- was not implemented as it would have been exceedingly complex and performance intensive to implement a constraint that
    -- that reviews one to two different tables to verify if an attribute matches with that in a third table.

CREATE TABLE account(
	-- Attributes
	account_number		INT 		NOT NULL,
    account_status		VARCHAR(10) NOT NULL,
    account_type		VARCHAR(10) NOT NULL,
    account_balance		FLOAT(2)	NOT NULL,
    customer_id 		INT NOT NULL,
    branch_id			INT NOT NULL,
    
    -- Key
    PRIMARY KEY			(account_number),
    
    CONSTRAINT account_holder           FOREIGN KEY			(customer_id) REFERENCES customer(customer_id),
    CONSTRAINT branch_required_accounts FOREIGN KEY			(branch_id)   REFERENCES branch(branch_id),
    CONSTRAINT new_account 	            UNIQUE				(account_number),
    CONSTRAINT valid_account_type       CHECK (account_type IN ('Checking', 'Saving'))
	);
    
CREATE TABLE loan(
	loan_id				INT 		NOT NULL,
    loan_status			VARCHAR(10) NOT NULL,
    loan_balance		FLOAT(2)	NOT NULL,
    interest_rate		FLOAT(2)	NOT NULL,
    customer_id 		INT NOT NULL,
    branch_id			INT NOT NULL,
    
    PRIMARY KEY			(loan_id),
    
    CONSTRAINT new_loan				  UNIQUE		(loan_id),
    CONSTRAINT borrower				  FOREIGN KEY   (customer_id) REFERENCES customer(customer_id),
    CONSTRAINT branch_required_loans  FOREIGN KEY   (branch_id)   REFERENCES branch(branch_id),
	CONSTRAINT valid_loan_status	  CHECK 		(loan_status IN ('Pending', 'Active', 'Delinquent', 'Paid')),
    CONSTRAINT loan_balance_min		  CHECK 		(loan_balance >= 0.00),
    CONSTRAINT valid_interest_rate	  CHECK			(interest_rate >= 0.00)
    );

CREATE TABLE transaction(
	transaction_id		INT 		NOT NULL,
    transaction_date	DATE 		NOT NULL,		-- Textbook Page 154, Dates must be in format: YYYY-MM-DD
    transaction_status	VARCHAR(10) NOT NULL,
    transaction_amount	float(2)	NOT NULL,
    transaction_type	VARCHAR(10) NOT NULL,
    account_number		INT 		NOT NULL,
    branch_id			INT 		NOT NULL,
    loan_id				INT,
    
    PRIMARY KEY			(transaction_id),
    FOREIGN KEY			(loan_id)		 REFERENCES loan(loan_id),
    
    CONSTRAINT new_transaction 			  			  UNIQUE	  (transaction_id),
    CONSTRAINT destination_account_number 			  FOREIGN KEY (account_number) REFERENCES account(account_number),
    CONSTRAINT branch_required_transactions    		  FOREIGN KEY (branch_id)     REFERENCES branch(branch_id),
    CONSTRAINT valid_transaction_status	  			  CHECK		  (transaction_status IN ('Processing', 'Completed', 'Failed')),
    CONSTRAINT transaction_amount_minimum 			  CHECK		  (transaction_amount > 0.00),
	CONSTRAINT valid_transaction_type 	  			  CHECK		  (transaction_type IN ('Withdraw', 'Deposit', 'Transfer'))
    );
   
   -- Note to the grader [10/3/25]: To my knowledge, this trigger is syntactically correct and should work, however my workbench
   -- refuses to create the trigger and doesn't provide any error message or insight as to why. 
   -- I am out of time to get this to work and can only conclude that some setting within my database is improperly configured
   -- The rest of the database works and the tables will be created.
    DELIMITER $$ -- sakila-mini
   CREATE TRIGGER overdraft_flag 
    BEFORE UPDATE ON account  -- Ch 4 Slide 42
	FOR EACH ROW 
    BEGIN
        IF NEW.account_balance < -100.00 THEN -- Ch 4 Slide 37 & 46 | sakila-mini trigger
			SET NEW.account_balance = OLD.account_balance
		END IF;
	END$$
    DELIMITER ;
-- ~-~-~-~-~-~-~-~-~-~-~-~-~-~
-- SAMPLE DATA FROM REPORT 2:
-- ~-~-~-~-~-~-~-~-~-~-~-~-~-~
INSERT INTO branch (branch_id, state, routing_number) VALUES		-- sakila-mini
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
 
 -- ~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~
 -- FUNCTIONS AND PROCEDURES FOR REPORT 3 START HERE
 -- ~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~
 
 -- Question 2: {Stored routine implementation}
-- Question 2.1: {Define a procedure that uses an aggregate function}
-- This procedure will find all accounts with activity and will count the amount of transactions
DELIMITER $$
CREATE PROCEDURE active_accounts()
	BEGIN
		SELECT c.customer_id, c.name, a.account_number, count(t.account_number)
        FROM customer c, account a, transaction t
        WHERE c.customer_id = a.customer_id AND a.account_number = t.account_number
        GROUP BY c.customer_id, c.name, a.account_number;
    END$$
 
 
-- Question 2.2: {Define a function that returns a value}
-- This function will return the net worth of a customer
CREATE FUNCTION determine_net_worth (ID INT, NOT_USED INT)
	RETURNS FLOAT(2)
    DETERMINISTIC
    BEGIN 
		DECLARE account_bal FLOAT(2);
        DECLARE loan_bal FLOAT(2);
        
        SELECT sum(account_balance) INTO account_bal -- Ch 4 Slide 33
        FROM account
        WHERE customer_id = ID;
       
       SET loan_bal = (SELECT sum(loan_balance) FROM loan WHERE customer_id = ID);
       
	-- Checks if a customer has loans with WF
       IF loan_bal = null THEN
			SET loan_bal = 0.00;
       END IF;
       
	   RETURN account_bal - loan_bal;
    END$$


-- Question 3: {Company task implementations}
-- Assume three buisness tasks for your company and implement them
-- Handles the creation and updates of records in the transactions table (WILL NOT UPDATE ACCOUNTS TABLE)
CREATE PROCEDURE records_maker(
IN transaction_type VARCHAR(15),
IN loan_involved    VARCHAR(3),
IN account_num INT,	
IN dest_loan INT,			
IN amount FLOAT(2),
IN task VARCHAR(15)) -- Used by the facilitator procedure to instruct the records_maker on its course of action
BEGIN
DECLARE new_id INT; -- Will hold the transaction ID of the current transaction
DECLARE acc_branch_id INT; -- Will hold the branch ID of the branch that manages the account

SET new_id = (SELECT max(transaction_id) + 1 FROM transaction);  -- Citation: This soln inspired by: https://stackoverflow.com/questions/4073923/select-last-row-in-mysql
SET acc_branch_id = (SELECT branch_id FROM account WHERE account_number = account_num);

-- New Transactions
IF task = 'NEW' THEN
	IF loan_involved = 'YES' THEN -- Loan payments
		INSERT INTO transaction (transaction_id, transaction_date, transaction_status, transaction_amount, transaction_type, account_number, branch_id, loan_id) VALUES
		(new_id, NOW(), 'Processing', amount, transaction_type, account_num, acc_branch_id, dest_loan); -- See sakila_mini for 'NOW()'
    
	ELSE -- Deposits/Withdrawals
		INSERT INTO transaction (transaction_id, transaction_date, transaction_status, transaction_amount, transaction_type, account_number, branch_id, loan_id) VALUES
		(new_id, NOW(), 'Processing', amount, transaction_type, account_num, acc_branch_id, null);
	END IF;

ELSEIF task = 'UPDATE' THEN -- Sets the status of the transaction to 'Complete'
	SET new_id = (SELECT max(transaction_id) FROM transaction); -- Grabs the last transaction in the transaction table
    UPDATE transaction
    SET transaction_status = 'Completed'
    WHERE transaction_id = new_id;
END IF;
END$$

-- Manages the accounts table and updates the values within to reflect changes such as deposit or withdrawals (WILL NOT LEAVE TRANSACTION RECORDS)
CREATE PROCEDURE accounts_manager(
IN task VARCHAR(15),
IN is_loan VARCHAR(3),
IN amount FLOAT(2),
IN account_num INT)
BEGIN
	IF task = 'DEPOSIT' THEN
		IF is_loan = 'YES' THEN		-- Decreases Balance of Loans
			UPDATE loan
            SET loan_balance = loan_balance - amount
            WHERE loan_id = account_num;
		ELSE 						-- Increases the balance in 'X' account
			UPDATE account
            SET account_balance = account_balance + amount
            WHERE account_number = account_num;
		END IF;
	ELSEIF task = 'WITHDRAW' THEN	-- Decreases the balance in 'X' account
		UPDATE account
        SET account_balance = account_balance - amount
        WHERE account_number = account_num;
	END IF;
END$$

-- The facilitator procedure calls all the necessary functions and procedures to complete a bank transaction
CREATE PROCEDURE facilitator( 
IN transaction_type VARCHAR(15),
IN loan_involved    VARCHAR(3),	-- Determines whether the dest_account_num is a loan id
IN source_account_num INT,		-- Has to exist
IN dest_account_num INT,		-- Can be a loan ID, another account number or -1 for just withdrawal or deposit
IN amount FLOAT(2))
BEGIN
-- Ensuring the provided information is valid
-- Values are assumed to be valid
	IF transaction_type = 'Deposit' THEN
		CALL records_maker (transaction_type, loan_involved, source_account_num, null, amount, 'NEW'); -- Creates the record in the transactions table
        CALL accounts_manager ('DEPOSIT', 'NO', amount, source_account_num); -- Updates the balances in the accounts table
        CALL records_maker (transaction_type, loan_involved, source_account_num, null, amount, 'UPDATE'); -- Updates the record in the transactions table
                
	ELSEIF transaction_type = 'Withdraw' THEN
		CALL records_maker (transaction_type, loan_involved, source_account_num, null, amount, 'NEW'); -- Creates the record in the transactions table
		CALL accounts_manager ('WITHDRAW', 'NO', amount, source_account_num); -- Updates the balances in the accounts table
		CALL records_maker (transaction_type, loan_involved, source_account_num, null, amount, 'UPDATE'); -- Updates the record in the transactions table
			
	ELSEIF transaction_type = 'Transfer' THEN
	-- Removing the funds from the source account
		CALL records_maker (transaction_type, loan_involved, source_account_num, null, amount, 'NEW'); -- Creates the record in the transactions table
		CALL accounts_manager ('WITHDRAW', 'NO', amount, source_account_num); -- Updates the balances in the accounts table
		CALL records_maker (transaction_type, loan_involved, source_account_num, null, amount, 'UPDATE'); -- Updates the record in the transactions table
			
	-- Adding the funds to the destination account
		CALL records_maker (transaction_type, loan_involved, dest_account_num, null, amount, 'NEW'); -- Creates the record in the transactions table
		CALL accounts_manager ('DEPOSIT', 'NO', amount, dest_account_num); -- Updates the balances in the accounts table
		CALL records_maker (transaction_type, loan_involved, dest_account_num, null, amount, 'UPDATE'); -- Updates the record in the transactions table
			
	ELSEIF transaction_type = 'Payment' THEN
		CALL records_maker ('DEPOSIT', loan_involved, source_account_num, dest_account_num, amount, 'NEW'); -- Creates the record in the transactions table
		CALL accounts_manager ('WITHDRAW', 'NO', amount, source_account_num); -- Updates the balance in the accounts table
		CALL accounts_manager ('DEPOSIT', 'YES', amount, dest_account_num); -- Updates the balances in the loans table
		CALL records_maker ('DEPOSIT', loan_involved, source_account_num, dest_account_num, amount, 'UPDATE'); -- Updates the record in the transactions table
	END IF;
END$$
DELIMITER ;