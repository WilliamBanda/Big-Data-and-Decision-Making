# Design Document: Bank Transaction Database

By William Banda

Video Overview: <https://youtu.be/pEsjJ_kr0aU?si=5X2a8Pu6Zow6pHwt>

## Scope
The banking transaction database includes all entities necessary to track and manage customer bank transactions. This writeup gives an overview of the design process of the bank transaction database, covering its purpose, scope, entities, relationships, optimizations, and limitations.

## Purpose
This database aims to manage customer accounts, transactions (deposits, withdrawals, account transfers, service payments), and account balances within a bank. It provides a central repository to track financial activities, enabling efficient management and reporting of all customer transactions.

## In Scope
* Customer accounts with basic identifying information details like name, account number, mobile number, and date of birth.
* All transactions within the bank, including deposits, withdrawals, account transfers, and service payments.
* Transaction details such as type, amount, date, and description.
* Tracking account balances by calculating total debits, credits, and current balance.
Out of Scope
* External bank accounts or transactions occurring outside this bank.
* Detailed information about services offered.
* User authentication or authorization mechanisms (assumed to be handled elsewhere).

## Functional Requirements
Users can
* Create and manage customer accounts.
* View account details and transaction history.
* Deposit and withdraw funds from accounts.
* Transfer money between accounts within the bank.
* Pay for services using their bank accounts.
* Generate reports on account balances and transactions (potentially using the account_balances view).

Users cannot
*	Access or modify information about other customers without proper authorization.
* Perform transactions exceeding account balance limits.
* View details of external bank accounts or transactions.

## Representation

### Entities
Entities are captured in SQL tables with the following schema.

#### Customer Account
Represents a customer's bank account and includes the following attributes: 
*	'id' ('INTEGER' and 'Primary Key' constraint applied): Represents the unique identifier for the account.
*	'first_name' (TEXT, NOT NULL is a condition since this field can’t be empty): Customer's first name.
*	'last_name' (TEXT, NOT NULL): Customer's last name and the condition is as above.
*	'account_no' ('INTEGER', 'UNIQUE', 'NOT NULL'): Unique account number i.e this condition makes sure only each account number is specific to one customer and cannot be dublicated.
*	'account_balance' ('NUMERIC', 'NOT NULL', 'CHECK' (account_balance >= 0)): Current balance in the account (this condition specifies that the numeric account balance cannot be zero).
*	'mobile_no' ('INTEGER', 'NOT NULL'): Customer's mobile number. This condition ensures that the mobile number is always an integer.
*	'dob' ('DATE', 'NOT NULL'): Customer's date of birth. NOT NULL, meaning that the date of birth column cannot be left blank.
*	'date_created' ('NUMERIC', 'NOT NULL', 'DEFAULT CURRENT_TIMESTAMP'): Date and time the account was created.
*	'deleted_at' ('NUMERIC', 'NOT NULL'): Timestamp for account deletion (assumed for soft deletion).

#### Transaction (Base Table)
Represents a general transaction within the bank and includes the following attributes.
*	'id' ('INTEGER', 'Primary Key'): Unique identifier for the transaction.
*	'transaction_type' ('TEXT', 'NOT NULL'): Type of transaction (deposit, withdrawal, transfer, service payment).
*	'account_id' ('INTEGER', 'NOT NULL', 'FOREIGN KEY' references Customer Account(id)): Account associated with the transaction.
*	'amount' (NUMERIC, NOT NULL, CHECK(amount != 0)): Transaction amount (this numeric amount is enforced that it can never be zero).
*	'date_created' ('NUMERIC', 'NOT NULL', 'DEFAULT CURRENT_TIMESTAMP'): Date and time the transaction was created.
*	'description' ('TEXT'): Optional description of the transaction.

#### Account to Account Transaction
*	Represents a transfer of funds between two accounts within the bank and the table is separated for potential future enhancements with the following attributes: 
*	'id' ('INTEGER', 'Primary Key'): Unique identifier for the transfer transaction.
*	'sender_id' ('INTEGER', 'NOT NULL', 'FOREIGN KEY' references Customer Account(id)): Account sending the funds.
*	'receiver_id' ('INTEGER', 'NOT NULL', 'FOREIGN KEY' references Customer Account(id)): Account receiving the funds.
*	'transaction_id, ('INTEGER', 'NOT NULL', 'FOREIGN KEY' references Transaction(id)): Reference to the corresponding transaction record.
	

#### Withdrawn Transaction
*	Represents a withdrawal of funds from a customer account (separate table for clarity) with the following attributes: 
*	'id' ('INTEGER', 'Primary Key'): Unique identifier for the withdrawal transaction.
*	'account_id' ('INTEGER', 'NOT NULL', 'FOREIGN KEY' references Customer Account(id)): Account from which funds were withdrawn.
*	'transaction_id' ('INTEGER', 'NOT NULL', 'FOREIGN KEY' references Transaction(id)): Reference to the corresponding transaction record.
The provided code defines two entities within a bank transaction database:

#### Deposit Transactions
This entity represents a specific type of transaction - depositing money into a customer account with the following attributes:
*	'id' ('INTEGER', 'Primary Key'): This is a unique identifier (primary key) for each deposit transaction. It's an auto-incrementing integer field that ensures each deposit has a distinct ID.
* 'account_id' ('INTEGER', 'NOT NULL', 'FOREIGN KEY': This is a foreign key referencing the customer_account table. It identifies the specific customer account that received the deposit.
*	'transaction_id' ('INTEGER', 'NOT NULL', 'FOREIGN KEY': This is another foreign key, but this time referencing the base transaction table. It links the deposit transaction to its corresponding generic transaction record. This likely store information common to all transactions (amount, date, etc.).

#### Payment For Service Transaction
This entity represents a specific type of transaction - paying for a service using a bank account with the following attributes:
*	'id' ('INTEGER', 'Primary Key'): Similar to 'DEPOSIT_TRANSACTIONS', this is a unique identifier (primary key) for each service payment transaction.
*	'account_id' ('INTEGER', 'NOT NULL', 'FOREIGN KEY': This foreign key references the customer_account table, identifying the customer account used for the payment.
*	'service_type' (TEXT): This attribute captures the type of service paid for. It's a text field allowing flexibility in describing the service.
*	'transaction_id' ('INTEGER', 'NOT NULL', 'FOREIGN KEY': Like in 'DEPOSIT_TRANSACTIONS', this foreign key references the base transaction table, linking the service payment to its corresponding generic transaction record.

### Relationships

The below entity relationship diagram describes the relationships among the entities in the database.

<https://github.com/WilliamBanda/Big-Data-and-Decision-Making/blob/main/Entity%20Diagram-2024-04-22-221904.png>

As detailed by the diagram:

A Customer Account can own many Transactions (one-to-many relationship). This signifies that a single customer account can have multiple transactions associated with it. A Transaction can use zero-or-one Account-to-Account Transaction, Withdrawn Transaction, Deposit Transaction, or Payment for Service Transaction. This reflects that a transaction can be one of these specific types, or none of them. Each specific transaction type entity (Account-to-Account Transaction, Withdrawn Transaction, Deposit Transaction, or Payment for Service Transaction) has a foreign key referencing a single Transaction record, ensuring a clear link back to the base transaction table.

## Limitations
*	The current design does not capture details about external bank accounts or transactions occurring outside this bank.
*	The service_type attribute in Payment for Service Transaction has a limited set of predefined options. Adding new service types would require altering the database schema.
*	The database lacks user authentication or authorization mechanisms, which are assumed to be handled elsewhere.

## Optimizations
*	Consider adding indexes on frequently used columns like account_no and account_id for faster retrieval of customer accounts and transactions.
* Explore materialized views.



