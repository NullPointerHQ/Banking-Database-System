import mysql.connector 
cnx = mysql.connector.connect(host="localhost", user="root", password="REPLACE ME WITH YOUR PASSWORD", database="wells_fargo_database") # - Connects to the database

cur = cnx.cursor()# - RETURNs a 'Tuple'

user_choice = 0 # - User choice for main menu, 4 to exit
user_choice_internal = 10 # - User choice for internal menus, exit depends on listed menu
    
while user_choice != 4: 
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n" 
          "Welcome [USER]! Please select an option from the list below:\n"
          "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n"
          "1) {Query selection and program}\n"
          "2) {Stored routine implementation}\n"
          "3) {Company task implementations}\n"
          "4) {Exit Program}\n"
          "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
    user_choice = int(input("USER:"))
    
# -{Query selection and program}
    if user_choice == 1:           
        while user_choice_internal != 17:
            print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n"
                  "\tQUERY SELECTION AND PROGRAM\n" 
                  "'Select SIX SQL queries from Question 5 in Report 2.'\n"
                  " Each query must include one or more host variables.'\n\n"
                  "Please select a query from the list below\n"
                  "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n"
                  "1) Query  11 - {More than one table in FROM}\n"
                  "2) Query  12 - {More than one table in FROM}\n"
                  "3) Query  13 - {Aggregate function and GROUP BY}\n"
                  "4) Query  14 - {Aggregate function and GROUP BY}\n"
                  "5) Query  15 - {Use SUBQUERY}\n"
                  "6) Query  16 - {Use SUBQUERY}\n"
                  "4) Option 17 - {RETURN}\n"
                  "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")

            user_choice_internal = int(input("USER:"))
        
            # - Query 1: Display the routing numbers for every account that has between X and Y dollars.
            if user_choice_internal == 11:
                print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n"
                      "\t\t\t\tEXECUTING QUERY 1\n"                                            
                      "\tAll account numbers, balances, branch IDs, and associated routing\n"
                      "\tnumbers of accounts with les than $'X' and more than $'Y'\n"
                      "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n")

                min_account_bal = float(input("Please enter the minimum account balance: $" )) # - Host variable 1: Minimum requirement of Account Balance
                max_account_bal = float(input("Please enter the maximum account balance: $" )) # - Host Variable 2: Upper limit of account balance

                query_11 = ("SELECT a.account_number, a.account_balance, a.branch_id, b.routing_number "
                            "FROM account a, branch b "
                            "WHERE a.branch_id = b.branch_id AND a.account_balance > %s AND a.account_balance < %s;") # - Stores the SQL query
                cur.execute(query_11, (min_account_bal, max_account_bal))

                print("Account Number | Account Balance | Branch ID | Routing Number")

                rows = cur.fetchall()
                for (account_number, account_balance, branch_id, routing_number) in rows:
                    print(f"\t{account_number}\t|\t{account_balance}\t|\t{branch_id}\t|{routing_number}")

            # - Query 2: Display the name, account numbers and loan IDs of any customers that have an account and a loan
            # - all over $5,000 and less than $1,000,000
            elif user_choice_internal == 12:
                print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n"
                      "\t\t\t\tEXECUTING QUERY 2\n"
                      "\tAll name(s), account number(s), and loan ID(s) of customers that have a checking\n"
                      " account, savings account and a loan, all with balances between $'X' and $'Y'\n"
                      "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n")
                min_bal = float(input("Please enter the minimum balance: $" )) # - Host variable 1: Minimum requirement of Account Balance
                max_bal = float(input("Please enter the maximum balance: $" )) # - Host Variable 2: Upper limit of account balance

                query_12 = ("SELECT c.name, a.account_number, l.loan_id "
                            "FROM customer c, account a, loan l "
                            "WHERE c.customer_id = a.customer_id AND c.customer_id = l.customer_id "
                            "AND a.account_balance > %s AND l.loan_balance > %s AND a.account_balance < %s AND l.loan_balance < %s;")
                cur.execute(query_12, (min_bal, min_bal, max_bal, max_bal))
                print("Name\t   | Account Number | Loan ID")

                rows = cur.fetchall()
                for (name, account_number, loan_id) in rows:
                    print(f"{name} |\t{account_number}\t    |\t{loan_id}")
            # - Query 3: Display all branches that manage more than 'X' accounts of 'Y' type and the amount of accounts managed
            elif user_choice_internal == 13:
                query_13 = ("SELECT branch_id, count(branch_id) "
                            "FROM account "
                            "WHERE account_type = %s " 
                            "GROUP BY branch_id "
                            "HAVING count(branch_id) > %s;")
                
                print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n"
                      "\t\t\t\tEXECUTING QUERY 3\n"
                      "\tAll branches that manage more than 'X' accounts of 'Y' type\n"
                      "\tand the amount of accounts managed\n"
                      "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n")

                account_type_allowed = 0 # - Default Value | Host variable 1: The accont type that the user wants to restrict the search to
                min_accounts_managed = int(input("Please set the minimum number of accounts managed (RECOMMENDED = 2): ")) # - Host Variable 2: The minimum amount of accounts that a branch has to manage

                print("\nPlease set the account type permitted.\nOptions:\n"
                      "1) Checking\n"
                      "2) Saving\n")

                # - Ensuring the user selects one of the two options
                while account_type_allowed != 1 and account_type_allowed != 2:
                    account_type_allowed = int(input("USER: "))

                # - Adjusting the users response for the database
                if   account_type_allowed == 1:
                    account_type_allowed = "Checking"
                elif account_type_allowed == 2:
                    account_type_allowed = "Saving"
                    
                cur.execute(query_13, (account_type_allowed, min_accounts_managed))
                print("Managing Branch | Accounts Managed")

                rows = cur.fetchall()
                for (r) in rows:
                    print(r)
                    
            # - Query 4: Display all branches whose average loan amount exceeds 'X' amount
            elif user_choice_internal == 14:
                print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n"
                      "\t\t\t\tEXECUTING QUERY 4\n"
                      "\tAll branches that whose average loan amount exceeds 'X' amount.\n"
                      "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n")
                min_amount = float(input("Please enter the minimum amount: ")) # - Host Variable 1: the minimum amount for the loans
                query_14 = ("SELECT branch_id, avg(loan_balance) "
                            "FROM loan "
                            "GROUP BY branch_id "
                            "HAVING avg(loan_balance) > %s")
                cur.execute(query_14, (min_amount,)) # - Citation: https://www.geeksforgeeks.org/python/tuple-with-one-item-in-python/
                print("Branch ID | Average Loan Amount\n")
                rows = cur.fetchall()
                for (r) in rows:
                    print(r)

            # - Query 5: Display the IDs and Account numbers of all customers that have a balance exceeding 'X' and an account of type 'Y'
            elif user_choice_internal == 15:
                print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n"
                      "\t\t\t\tEXECUTING QUERY 5\n"
                      "Display the IDs and Account numbers of all customers that have a balance\n"
                      "exceeding 'X' and an account of type 'Y'.\n"
                      "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n")

                query_15 = ("SELECT a.customer_id, a.account_number "
                            "FROM account a "
                            "WHERE account_type = %s AND customer_id IN "
                            "(SELECT customer_id "
                            "FROM loan l "
                            "WHERE l.loan_balance > %s AND l.customer_id = a.customer_id);")

                min_bal = float(input("Please enter the balance minimum: "))    # - Host Variable 1: The minimum balance 
                target_account = 0 # Default Value                              # - Host Variable 2: Holds the target account type

                print("\nPlease set the account type permitted.\nOptions:\n"
                      "1) Checking\n"
                      "2) Saving\n")

                # - Ensuring the user selects one of the two options
                while target_account != 1 and target_account != 2:
                    target_account= int(input("USER: "))

                # - Adjusting the users response for the database                 
                if   target_account == 1:
                    target_account = "Checking"
                    
                elif target_account == 2:
                    target_account = "Saving"
                    
                cur.execute(query_15, (target_account, min_bal))
                print("Customer | Account Number\n")
                rows = cur.fetchall()
                for (r) in rows:
                    print(r)

            # - Query 6: Display the IDs and Branch IDs of customers with a loan at 'X' branch and 'Y' account type at a seperate branch.
            elif user_choice_internal == 16:
                print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n"
                      "\t\t\t\tEXECUTING QUERY 6\n"
                      "Display the IDs and Branch IDs of customers with a loan at 'X' branch and\n"
                      "'Y' account type at a seperate branch.\n"
                      "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n")

                target_account = 0 # - Default Value | Host Variable 1: Holds the target account type
                target_branch  = 0 # - Default Value | Host Variable 2: Holds the target branch
                
                # - Prompting the user for the target account
                print("\nPlease set the account type permitted.\n"
                      "(Recommended for Testing: 1)\n"
                      "Options:\n"
                      "1) Checking\n"
                      "2) Saving\n")

                while target_account != 1 and target_account != 2:
                    target_account= int(input("USER: "))

                # - Adjusting the value of 'target_account' based on user input
                if   target_account == 1:
                    target_account = "Checking"
                    
                elif target_account == 2:
                    target_account = "Saving"

                target_branch = int(input("Please enter the target branch ID (Recommended for testing: 290): ")) 
                
                query_16 = ("SELECT a.customer_id, a.branch_id "
                            "FROM account a "
                            "WHERE account_type = %s AND branch_id = %s AND "
                            "customer_id IN (SELECT customer_id "
			    "FROM loan l "
			    "WHERE l.branch_id != a.branch_id AND l.customer_id = a.customer_id);")

                cur.execute(query_16, (target_account, target_branch))
                print("Customer ID| Branch ID\n")
                rows = cur.fetchall()
                for (r) in rows:
                    print(r)
                
 # - Stored Routine Implementation
    if user_choice == 2:
        # - Query Variables
        query_21 = ("CALL active_accounts") # - Procedure
        query_22 = ("SELECT determine_net_worth(%s, %s)") # - F(x)
        
        print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n"
              "\tSTORED ROUTINE IMPLEMENTATION\n"
              "Define a procedure that uses an aggregate function\n"
              "Define a function that returns a value."
              "Write a Python (or other) program that calls/uses both the procedure and the\nfunction.\n"
              "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n")
        # - Procedure    
        print("Finding all accounts with activity\n")
        cur.execute(query_21) # - Executing Procedure Query
        active_accounts = cur.fetchall()# - Result from active_accounts
        
        print("All accounts with activity are listed below:\n"
              "Customer ID | Customer Name | Account Number | # of Transactions\n")

        for (account) in active_accounts:
             print(account)

        # - Function
        # - Cycles mySQL connection to prevent NoneType error.
        cur.close();
        cnx.close()

        cnx = mysql.connector.connect(host="localhost", user="root", password="YOUR PASSWORD HERE", database="wells_fargo_database") # - Connecting to the database
        cur = cnx.cursor()
        
        not_used = 0 # This variable is required for the function but it is not actually used by it
        target_ID = int(input("Please enter a customer ID to calculate their net worth: "))
            
        cur.execute(query_22, (target_ID, not_used))

        net_worth = cur.fetchall()
        print(f"The net worth of Customer ID {target_ID} is ${net_worth}")


    # - Company task Implementation
    if user_choice == 3:
        while user_choice_internal != 35:
            # Variables used by the 'Facilitator' Procedure w/ placeholder values
            transaction_type   = "Deposit"
            loan_involved      = "NO"
            source_account_num = "null"
            dest_account_num   = -1
            amount             = 0
            # - Repeated Queries
            account_bal_query = "SELECT account_balance FROM account WHERE account_number = %s" # - Displays the balance of account number 'X'
            loan_bal_query = "SELECT loan_balance FROM loan WHERE loan_id = %s" # - Displays the balance of Loan ID 'X'
            
            facilitator = "CALL facilitator(%s, %s, %s, %s, %s)" # - Calls facilitator procedure to carry out the requested changes
            
            print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n"
                  "\tCOMPANY TASK IMPLEMENTATIONS\n"
                  "Assume THREE business tasks for your company and implement them\n"
                  "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n"
                  "31)  Make a Deposit\n"
                  "32)  Make a Withdrawal\n"
                  "33)  Transfer funds\n"
                  "34)  Make a Payment\n"
                  "35)  RETURN\n")

            user_choice_internal = int(input("USER:"))

            if user_choice_internal != 35:
                amount = float(input("Please enter an amount ending with two decimal places: $"))
                source_account_num = int(input("Please enter an account number: "))
                    
                if user_choice_internal == 31:  # - Deposits
                    transaction_type = "Deposit"

                    # - Displaying the account number, amount and current balance for user verification
                    cur.execute(account_bal_query, (source_account_num,))
                    bal = cur.fetchall()
                    print(f'Depositing: ${amount} into account number {source_account_num} which has a balance of ${bal}\n')

                    # - Executing the deposit operation
                    cur.execute(facilitator, (transaction_type, loan_involved, source_account_num, dest_account_num, amount))
                    bal = cur.fetchall()

                    # - Displaying the account number, amount and new balance for user verification
                    cur.execute(account_bal_query, (source_account_num,)) # - Gathers new balance
                    bal = cur.fetchall()
                    print(f'Deposit complete! New balance for account number ({source_account_num} is ${bal}\n')

                if user_choice_internal == 32:  # - Withdrawals
                    transaction_type = "Withdraw" 

                    # - Displaying the account number, amount and current balance for user verification
                    cur.execute(account_bal_query, (source_account_num,))
                    bal = cur.fetchall()
                    print(f"Withdrawing: ${amount} from account number {source_account_num} which has a balance of ${bal}\n")

                    # - Executing the deposit operation
                    cur.execute(facilitator, (transaction_type, loan_involved, source_account_num, dest_account_num, amount))# - See facilitator procedure for execution details
                    
                    # - Displaying the account number, amount and new balance for user verification
                    cur.execute(account_bal_query, (source_account_num,)) # - Gathers new balance to display to the user
                    bal = cur.fetchall()
                    print(f"Withdrawal complete! New balance for account number ({source_account_num} is {bal}\n")

                if user_choice_internal == 33:   # - Transfers
                    transaction_type = "Transfer"
                    dest_account_num = int(input("Please enter the destination account number: "))                        

                    # - Displaying the account numbers, and amount being transferred for user verification
                    print(f"Transferring: ${amount} from account number {source_account_num} to account number {dest_account_num}")

                    # - Executing the deposit operation
                    cur.execute(facilitator, (transaction_type, loan_involved, source_account_num, dest_account_num, amount))# - See facilitator procedure for execution details

                    # - Displaying the account number, amount and new balance for user verification
                    cur.execute(account_bal_query, (source_account_num,)) # - Gathers source account balance to display to the user
                    bal = cur.fetchall()
                    print(f"Transfer complete! New balance for account number ({source_account_num} is {bal}\n")
                    
                    cur.execute(account_bal_query, (dest_account_num,)) # - Gathers destination account balance to display to the user
                    bal = cur.fetchall()
                    print(f"New balance for account number ({dest_account_num} is {bal}\n")

                if user_choice_internal == 34:  # - Loan Repayment
                    transaction_type = "Payment"
                    loan_involved = "YES"

                    dest_account_num = int(input("Please enter the loan ID number: "))

                    # - Displaying the loan ID and balance on the loan to the user for verification
                    cur.execute(loan_bal_query, (dest_account_num,))
                    bal = cur.fetchall()
                    print(f"Loan number {dest_account_num} has a balance of {bal}\n")

                    # - Executing the deposit operation
                    cur.execute(facilitator, (transaction_type, loan_involved, source_account_num, dest_account_num, amount))# - See facilitator procedure for execution details

                    # - Displaying the account number, amount and new balance for user verification
                    cur.execute(loan_bal_query, (dest_account_num,)) # - Gathers the loan balance to display to the user
                    bal = cur.fetchall()
                    print(f"${amount} payment received! New balance on loan number ({dest_account_num} is {bal}\n")
                        

if user_choice == 4:
    print("Exiting program...")        
    cur.close(); 
    cnx.close() # - Closes connection with database
