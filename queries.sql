-- This SQL file has the typical SQL queries that users will run on our bank transaction database

-- Add a New Account for a Customer
INSERT INTO customer_account (first_name, last_name, account_no, account_balance, mobile_no, dob, deleted_at)
VALUES ('William', 'Banda', 123457, 1000.00, 1234567890, DATE('2024-04-15'), DATE('2024-04-20'));  

-- Find all customer accounts
SELECT * FROM customer_account;

-- Find a customer account by account number
SELECT *
FROM customer_account
WHERE account_no = 123457;

-- Retrieve details of the first 01 customer accounts (You can input any number of your choice)
SELECT "first_name", "last_name", "account_no"
FROM "customer_account"
LIMIT 1;

-- Find customer accounts created within a specific date range 
SELECT "account_no", "date_created"  
FROM "customer_account"
WHERE "date_created" BETWEEN DATE('2024-04-15') 
AND DATE('2024-04-20');  

-- Find transactions with a possible misspelling in the description 
SELECT "description"
FROM "transaction"
WHERE "description" LIKE '%uncertain%';

-- Find transactions with specific service types 
SELECT "service_type", "amount"
FROM "payment_for_service_transaction"
WHERE "service_type" = 'Utility' OR "service_type" = 'Subscription' 
;

-- Find transactions with amounts less than £100 (amounts can be specified)
SELECT "amount"
FROM "transaction"
WHERE "amount" < 100;  

-- Find transactions with amounts exceeding £500, ordered by amount descending 
SELECT "amount", "date_created"  
FROM "transaction"
WHERE "amount" > 500  
ORDER BY "amount" DESC
LIMIT 10;

-- Count the number of distinct transaction types 
SELECT COUNT(DISTINCT "transaction_type")
FROM "transaction";

-- Count the number of distinct transaction types 
SELECT COUNT(DISTINCT "transaction_type")
FROM "transaction";

-- Find transactions from years 2019 to 2022 
SELECT "date_created", "amount"  -- You can select other columns
FROM "transaction"
WHERE YEAR("date_created") IN (2019, 2020, 2021, 2022);

-- Find All Transactions for a Specific Customer
SELECT *
FROM transaction t
INNER JOIN customer_account ca ON t.account_id = ca.id
WHERE ca.first_name = 'William' AND ca.last_name = 'Banda';

-- Find All Transactions for a Specific Account Number
SELECT *
FROM transaction
WHERE account_id = (
  SELECT id
  FROM customer_account
  WHERE account_no = 123457 
);

-- Find All Deposit Transactions of Between Dates
SELECT *
FROM transaction
WHERE transaction_type = 'deposit'  
  AND date_created BETWEEN DATE('2024-04-15') AND DATE('2024-04-20'); 

  -- Find All Withdraw Transactions of Between Dates
SELECT *
FROM transaction
WHERE transaction_type = 'withdraw'  
  AND date_created BETWEEN DATE('2024-04-15') AND DATE('2024-04-20'); 

-- Retrieve details of all payment for service transactions
SELECT pfs.*
FROM payment_for_service_transaction pfs
INNER JOIN transaction t ON pfs.transaction_id = t.id;  

-- Retrieve details of all account-to-account transactions
SELECT aat.*
FROM account_to_account_transactions aat
INNER JOIN transaction t ON aat.transaction_id = t.id;  




