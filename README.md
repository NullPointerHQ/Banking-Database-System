# Banking Database System
<div align="center">
<img src="https://media1.tenor.com/m/lewtfUgSCCYAAAAC/saving-money.gif" alt="Figure 0: Cover Image" width="300">
</div>

⚖  _GIF Credits: [Tenor Link](https://tenor.com/view/saving-money-finance-piggy-bank-investing-gif-10803059622258280486)_

👨🏼‍⚖️ _Legal Disclaimer: This project is made as an assignment for a course and to learn SQL using a theoretical version of Wells Fargo. I have no affiliation with the company itself._
## 👋Introduction
### Objectives
1. To simulate a basic banking database system for Wells Fargo, the system should be able to manage multiple user accounts such as Checkings and Savings as well as Loans. The system should also be able to update those accounts or close them as necessary, for instance, increasing the balance on a checking account when a direct deposit is made.
2. To allow me to learn the fundamentals of SQL with hands-on experience.

## Prerequisites

**Database:**
* MySQL Server

**Client App:**
* Python 3.x
* `mysql-connector-python` Driver

## 🎮 Guide & Features
### Database Overview
This project is meant to mimic a real-world banking database. It is designed to be utilized by bankers to manage day-to-day operations and customer needs. The database also tracks bank branches, customer profiles, checking and savings accounts, loans and transaction histories.

### Client App Overview
This is a simple CLI Python desktop application that exists primarily as a proof-of-concept to show that the database can be connected to from external programs and execute commands.

> Note: `sample-data.sql` is provided as a convenience to test the database. The database operates independently and needs neither the data nor the client app to function.

---

## ⚙️ Configuration

The project is mostly plug and play using your favorite SQL Server and, if using the app, IDE.

🔐 If you are using the client app please update the following two lines in `client_app.py` with your own password before attempting execution:

Line 1 & 248: `cnx = mysql.connector.connect(host="localhost", user="root", password="REPLACE ME WITH YOUR PASSWORD", database="wells_fargo_database") # - Connects to the database`
