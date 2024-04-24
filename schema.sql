-- This SQL file, has the schema of our bank transaction database, including the CREATE TABLE, CREATE INDEX, CREATE VIEW, etc. statements that compose it

-- Represent customer account
CREATE TABLE "customer_account" (
  "id" INTEGER,
  "first_name" TEXT NOT NULL,
  "last_name" TEXT NOT NULL,
  "account_no" INTEGER UNIQUE NOT NULL,
  "account_balance" NUMERIC NOT NULL CHECK(account_balance >= 0),  -- Constraint here
  "mobile_no" INTEGER NOT NULL,
  "dob" DATE NOT NULL,
  "date_created" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "deleted_at" NUMERIC NOT NULL,
  PRIMARY KEY("id")
);

-- Represent account to account transactions
CREATE TABLE "account_to_account_transactions" (
  "id" INTEGER,
  "sender_id" INTEGER NOT NULL,
  "receiver_id" INTEGER NOT NULL,
  "transaction_id" INTEGER NOT NULL,  -- 
  FOREIGN KEY ("sender_id") REFERENCES "customer_account"("id"),
  FOREIGN KEY ("receiver_id") REFERENCES "customer_account"("id"),
  FOREIGN KEY ("transaction_id") REFERENCES "transaction"("id"),  
  PRIMARY KEY("id")
);

-- Represent withdrawn transactions
CREATE TABLE "withdrawn_transactions" (
  "id" INTEGER,
  "account_id" INTEGER NOT NULL,
  "transaction_id" INTEGER NOT NULL,  
  FOREIGN KEY ("account_id") REFERENCES "customer_account"("id"),
  FOREIGN KEY ("transaction_id") REFERENCES "transaction"("id"),  
  PRIMARY KEY("id")
);

-- Represent deposit transactions
CREATE TABLE "deposit_transactions" (
  "id" INTEGER,
  "account_id" INTEGER NOT NULL,
  "transaction_id" INTEGER NOT NULL,  
  FOREIGN KEY ("account_id") REFERENCES "customer_account"("id"),
  FOREIGN KEY ("transaction_id") REFERENCES "transaction"("id"),  
  PRIMARY KEY("id")
);

-- Represent payment for service transaction
CREATE TABLE "payment_for_service_transaction" (
  "id" INTEGER,
  "account_id" INTEGER NOT NULL,
  "service_type" TEXT NOT NULL CHECK("service_type" IN ('online_purchase', 'subscription', 'utility')),
  "transaction_id" INTEGER NOT NULL,  
  FOREIGN KEY ("account_id") REFERENCES "customer_account"("id"),
  FOREIGN KEY ("transaction_id") REFERENCES "transaction"("id"),  
  PRIMARY KEY("id")
);

-- Represent all transactions 
CREATE TABLE "transaction" (
    "id" INTEGER,
    "transaction_type" TEXT NOT NULL,
    "account_id" INTEGER NOT NULL,
    "amount" NUMERIC NOT NULL CHECK("amount" != 0),
    "date_created" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "description" TEXT,
    PRIMARY KEY("id"),
    FOREIGN KEY("account_id") REFERENCES "customer_account"("id")
);

-- Create indexes to speed common searches
CREATE INDEX "customer_name_search" ON "customer_account" ("first_name", "last_name");

CREATE INDEX "dob_search" ON "customer_account" ("dob");

CREATE INDEX "mobile_no_search" ON "customer_account" ("mobile_no");

CREATE INDEX "service_type_search" ON "payment_for_service_transaction" ("name");

CREATE INDEX "transaction_type_search" ON "transaction" ("transaction_type");

CREATE INDEX "account_id_search" ON "withdrawn_transactions" ("account_id");

CREATE INDEX "account_id_search" ON "deposit_transactions" ("account_id");

CREATE INDEX "transaction_amount_range" ON "transaction" ("amount");

CREATE INDEX "account_number_search" ON "customer_account" ("account_no");

-- Create a view named 'account_balances' to efficiently retrieve customer account details
CREATE VIEW account_balances AS
SELECT ca.id AS account_id, ca.first_name || ' ' || ca.last_name AS account_holder_name,
SUM(CASE WHEN dt.amount IS NOT NULL THEN -dt.amount ELSE 0 END) AS total_debits,
SUM(CASE WHEN wt.amount IS NOT NULL THEN wt.amount ELSE 0 END) AS total_credits,
(ca.account_balance - SUM(CASE WHEN dt.amount IS NOT NULL THEN dt.amount ELSE 0 END) + SUM(CASE WHEN wt.amount IS NOT NULL THEN wt.amount ELSE 0 END)) AS current_balance
FROM customer_account ca
LEFT JOIN withdrawn_transactions wt ON ca.id = wt.account_id
LEFT JOIN deposit_transactions dt ON ca.id = dt.account_id
GROUP BY ca.id, ca.first_name, ca.last_name;










