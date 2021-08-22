

CREATE DATABASE UNIONBANK

USE UNIONBANK;

CREATE SCHEMA BORROWER;

CREATE SCHEMA LOAN;
GO

CREATE TABLE BORROWER (
BORROWER_ID INT NOT NULL PRIMARY KEY,
BORROWER_FIRSTNAME VARCHAR(255) NOT NULL, 
BORROWER_MIDDLENAME CHAR (1) NOT NULL,
BORROWER_LASTNAME VARCHAR (255) NOT NULL,
DOB DATETIME NOT NULL,
GENDER CHAR(1) NULL,
SSN CHAR (9) NOT NULL,
PHONE_NUMBER VARCHAR(10) NOT NULL,
EMAIL VARCHAR(255) NOT NULL,
CITIZENSHIP VARCHAR (255) NULL,
ISUSCITIZEN BIT NULL,
CREATEDATE DATETIME NOT NULL);

ALTER TABLE [dbo].[Borrower]
ADD CONSTRAINT CHK_EMAIL CHECK(EMAIL LIKE '@');

--SELECT * FROM BORROWER;

CREATE TABLE BORROWER_ADDRESS (
ADDRESS_ID INT NOT NULL,
BORROWER_ID INT NOT NULL, 
STREET_ADDRESS VARCHAR (255) NOT NULL,
ZIP VARCHAR (5) NOT NULL,
CREATE_DATE DATETIME NOT NULL);


ALTER TABLE BORROWER_ADDRESS
ADD CONSTRAINT [FK_BORROWER_ADDRESS_BORROWER_BORROWER_ID] FOREIGN KEY(BORROWER_ID)
REFERENCES BORROWER(BORROWER_ID) ON DELETE CASCADE;

ALTER TABLE BORROWER_ADDRESS
ADD CONSTRAINT [FK_BORROWER_ADDRESS_US_ZIPCODES_ZIP] FOREIGN KEY(ZIP)
REFERENCES US_ZIPCODES(ZIP) ON DELETE CASCADE;



--SELECT * FROM BORROWER_ADDRESS;


CREATE TABLE LOAN.LOAN_SETUP_INFORMATION (
ISSURROGATE_KEY INT NOT NULL,
LOAN_NUMBER VARCHAR (10) NOT NULL PRIMARY KEY,
PURCHASE_AMOUNT NUMERIC  NOT NULL,
PURCHASE_DATE DATETIME NOT NULL,
LOAN_TERM INT NOT NULL,
BORROWER_ID INT NOT NULL,
UNDERWRITER_ID INT NOT NULL,
PRODUCT_ID CHAR (2) NOT NULL,
INTEREST_RATE DECIMAL NOT NULL,
PAYMENT_FREQUENCY INT NOT NULL,
APPRAISAL_VALUE NUMERIC NOT NULL,
CREATE_DATE DATETIME NOT NULL,
LTV DECIMAL NOT NULL,
FIRST_INTEREST_PAYMENT_DATE DATETIME NULL,
MATURITY_DATE DATETIME NOT NULL);



---SELECT * FROM LOAN_SETUP_INFORMATION;


CREATE TABLE LOAN.LOAN_PERIODIC (
ISSURROGATE_KEY INT NOT NULL,
LOAN_NUMBER VARCHAR(10) NOT NULL PRIMARY KEY,
CYCLE_DATE DATETIME NOT NULL,
EXTRA_MONTHLY_PAYMENT NUMERIC NOT NULL,
UNPAID_PRINCIPAL_BALANCE NUMERIC NOT NULL,
BEGINNING_SCHEDULE_BALANCE  NUMERIC NOT NULL,
PAID_INSTALLMENT  NUMERIC NOT NULL,
INTEREST_PORTION  NUMERIC NOT NULL,
PRINCIPAL_PORTION NUMERIC NOT NULL,
END_SCHEDULE_BALANCE NUMERIC NOT NULL,
ACTUAL_END_SCHEDULE_BALANCE NUMERIC NOT NULL,
TOTAL_INTEREST_ACCRUED  NUMERIC NOT NULL,
TOTAL_PRINCIPAL_ACCRUED NUMERIC NOT NULL,
DEFAULT_PENALTY  NUMERIC NOT NULL,
DELINQUENCY_CODE INT NOT NULL,
CREATE_DATE DATETIME NOT NULL);


ALTER TABLE LOAN.LOAN_PERIODIC
ADD CONSTRAINT [FK_LOAN.LOAN_PERIODIC_LOAN.LOAN_SETUP_INFORMATION] FOREIGN KEY(LOAN_NUMBER)
REFERENCES LOAN.LOAN_SETUP_INFORMATION(LOAN_NUMBER) ON DELETE CASCADE;

ALTER TABLE LOAN.LOAN_PERIODIC
ADD CONSTRAINT [FK_LOAN.LOAN_PERIODIC_LOAN.LU_DELINQUENCY] FOREIGN KEY(DELINQUENCY_CODE)
REFERENCES LOAN.LU_DELINQUENCY(DELINQUENCY_CODE) ON DELETE CASCADE;

--SELECT * FROM LOAN.LOAN_PERIODIC

CREATE TABLE LOAN.LU_DELINQUENCY (
DELINQUENCY_CODE INT NOT NULL PRIMARY KEY,
DELINQUENCY VARCHAR (255) NOT NULL);


CREATE TABLE LOAN.LU_PAYMENY_FREQUENCY (
PAYMENT_FREQUENCY INT NOT NULL PRIMARY KEY,
PAYMENT_IS_MADE_EVERY INT NULL,
PAYMENT_FREQUENCY_DESCRIPTION VARCHAR(255) NOT NULL);


CREATE TABLE LOAN.UNDERWRITER (
UNDERWRITER_ID INT NOT NULL PRIMARY KEY,
UNDERWRITER_FIRSTNAME VARCHAR (255) NULL,
UNDERWRITER_MIDDLE_INITIAL CHAR (1) NULL,
UNDERWRITER_LASTNAME VARCHAR (255) NOT NULL,
PHONE_NUMBER VARCHAR (14) NULL,
EMAIL VARCHAR (255) NOT NULL,
CREATE_DATE DATETIME NOT NULL);

ALTER TABLE LOAN.UNDERWRITER
ADD CONSTRAINT UC_UNDERWRITER_EMAIL CHECK(EMAIL LIKE '@');
 

ALTER TABLE LOAN.LOAN_SETUP_INFORMATION
ADD CONSTRAINT [FK_LOAN.LOAN_SETUP_INFORMATION_LOAN.LOAN_UNDERWRITER] FOREIGN KEY(UNDERWRITER_ID)
REFERENCES LOAN.UNDERWRITER(UNDERWRITER_ID) ON DELETE CASCADE;


CREATE TABLE DBO.CALENDAR (
CALENDARDATE DATETIME NULL);


CREATE TABLE DBO.US_ZIPCODES (
IsSurrogateKey INT NOT NULL,
ZIP VARCHAR(5) NOT NULL PRIMARY KEY,
LATITUDE FLOAT NULL,
LONGITUDE FLOAT NULL,
CITY VARCHAR(255) NULL,
STATE_ID CHAR(2) NULL,
POPULATION INT NULL,
DENSITY DECIMAL NULL,
COUNTY_FIPS VARCHAR(10) NULL,
COUNTY_NAME VARCHAR(255) NULL,
COUNTY_NAMES_ALL VARCHAR(255) NULL,
COUNTY_FIPS_ALL VARCHAR(50) NULL,
TIMEZONE VARCHAR(255) NULL,
CREATEDATE DATETIME NOT NULL);


CREATE TABLE DBO.STATE (
STATE_ID CHAR(2) NOT NULL PRIMARY KEY,
STATE_NAME VARCHAR(255) NOT NULL,
CREATE_DATE DATETIME NOT NULL);

ALTER TABLE [dbo].[State]
ADD CONSTRAINT UC_STATE_NAME UNIQUE(STATE_NAME)
;


ALTER TABLE DBO.US_ZIPCODES
ADD CONSTRAINT [FK_DBO.US_ZIPCODES_LOAN.UNDERWRITER] FOREIGN KEY(STATE_ID)
REFERENCES LOAN.UNDERWRITER(UNDERWRITER_ID) ON DELETE CASCADE;



SELECT *FROM LOAN.LOAN_PERIODIC;

ALTER TABLE BORROWER
ADD CONSTRAINT CHK_BORROWER_DOB CHECK(DOB<= DATEADD(YEAR, -18, GETDATE()));

ALTER TABLE BORROWER
ADD CONSTRAINT DF_BORROWER_PHONE_NMBR CHECK (LEN(PHONE_NUMBER)=10);

ALTER TABLE BORROWER
ADD CONSTRAINT CHK_BORROWER_SSN CHECK (LEN(SSN)=9);

ALTER TABLE BORROWER
ADD CONSTRAINT DF_BORROWER_CREATEDATE DEFAULT(GETDATE()) FOR CREATEDATE;

ALTER TABLE BORROWER_ADDRESS
ADD CONSTRAINT DF_BORROWER_ADDRESS_CREATEDATE DEFAULT(GETDATE()) FOR CREATEDATE;



ALTER TABLE LOAN.LOAN_PERIODIC
ADD CONSTRAINT CHK_LOAN_PERIODIC_PAID_INSTALLMENT CHECK([Interest_portion]+[Principal_portion]=[Paid_installment]);



ALTER TABLE LOAN.LOAN_PERIODIC
ADD CONSTRAINT DF_LOAN_PERIODIC_CREATEDATE DEFAULT(GETDATE()) FOR CREATE_DATE;

ALTER TABLE LOAN.LOAN_PERIODIC
ADD CONSTRAINT DF_LOAN_PERIODIC DEFAULT(0) FOR [Extra_monthly_payment];



ALTER TABLE LOAN.LOAN_SETUP_INFORMATION
ADD CONSTRAINT CHK_LOAN_SETUP_INFO CHECK((LOAN_NUMBER)=35 OR (LOAN_NUMBER)=30 OR (LOAN_NUMBER)=15 OR (LOAN_NUMBER)=10);


ALTER TABLE LOAN.LOAN_SETUP_INFORMATION
ADD CONSTRAINT CHK_INTEREST_RATE CHECK((INTEREST_RATE) >= 0.01 AND (INTEREST_RATE) <=0.30);

ALTER TABLE LOAN.LOAN_SETUP_INFORMATION
ADD CONSTRAINT DF_LOAN_SETUP_INFORMATION_CREATEDATE DEFAULT(GETDATE()) FOR CREATE_DATE;


ALTER TABLE [dbo].[State]
ADD CONSTRAINT DF_STATE_CREATEDATE DEFAULT(GETDATE()) FOR CREATE_DATE;


ALTER TABLE LOAN.UNDERWRITER
ADD CONSTRAINT DF_UNDERWRITER_CREATEDATE DEFAULT(GETDATE()) FOR CREATE_DATE;


ALTER TABLE [dbo].[US_ZipCodes]
ADD CONSTRAINT DF_US_ZIPCODES_CREATEDATE DEFAULT(GETDATE()) FOR CREATEDATE;

