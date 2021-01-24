

try:
    import pyrebase
    import pyodbc
except:
    import os
    os.system("pip install pyrebase")
    os.system("pip install pyodbc")
    import pyrebase
    import pyodbc


#------------ Firebase configuration info and variables
    
firebaseConfig = {
    "apiKey": "AIzaSyDqNnwTFcJRajoYDqpLpG723BlES4AWuZA",
    "authDomain": "projecto-bd2.firebaseapp.com",
    "databaseURL": "https://projecto-bd2-default-rtdb.firebaseio.com",
    "projectId": "projecto-bd2",
    "storageBucket": "projecto-bd2.appspot.com",
    "messagingSenderId": "685931296708",
    "appId": "1:685931296708:web:d8f2df56f1db2352de5691",
    "measurementId": "G-JEQ8WF6L2J"
};

firebase = pyrebase.initialize_app(firebaseConfig)
db = firebase.database()

rootRef = db.child('/salesgoal_col/');

#------------ Methods

def getFirebaseData():

    data = {}
    info = rootRef.get()

    for task in info.each():
        data[task.key()] = task.val()

    return data

#------------ Azure configuration info and variables

connection_string = 'Driver=ODBC Driver 17 for SQL Server;Server=tcp:rocket-bd2.database.windows.net,1433;Database=ROCKET-BD2;Uid=rocket-admin;Pwd=2020-bd2-2020;Encrypt=yes;TrustServerCertificate=no;Connection Timeout=30;'

sales_goals = getFirebaseData()

#------------ Methods

def try_upload_sales_goal( sales_goal_rows ):
    
    from decimal import Decimal
    
    def lookup_for_sales_dimension(sql_cursor, sales_person_code):
        sql_cursor.execute(f"SELECT dim_id FROM DIM_SALESPERSON WHERE sales_person_code = '{sales_person_code}'")
        result = sql_cursor.fetchone()
        return result[0] if result else -1
    
    if sales_goal_rows == {}:
        return
    
    try:        
        # stablish connection with azure sql database
        conn = pyodbc.connect(connection_string)
        
        # cursor to create sql commands
        cursor = conn.cursor()
        successful_uploads = 0
    
        print(sales_goal_rows.items())
        pass
    
        # for each row insert in db
        for _, sg in sales_goal_rows.items():
            
            try:
                # lookup for dimension index                    
                sales_person_id = lookup_for_sales_dimension(cursor, sg["salesperson"])
                
                if sales_person_id == -1:
                    break
                
                year = int(sg["year"])
                month_numeric = int(sg["month"])
                brand_code = sg["brand"]
                sales_goal = Decimal(sg["amount"])
                sales_goal_code = sg["code"]
                
                # upsert into sales goal fact table (crud app)
                command  = f"IF EXISTS (SELECT * from FACT_SALES_GOAL where sales_goal_code='{sales_goal_code}')\n"
                command += f"UPDATE FACT_SALES_GOAL\n"
                command += f"SET year={year}, month_numeric={month_numeric}, sales_person_id='{sales_person_id}', brand_code='{brand_code}', sales_goal={sales_goal}, sales_goal_code='{sales_goal_code}'\n"
                command += f"WHERE sales_goal_code='{sales_goal_code}';\n"
                command += f"ELSE \n"
                command += f"INSERT INTO FACT_SALES_GOAL(year, month_numeric, sales_person_id, brand_code, sales_goal, sales_goal_code) \n"
                command += f"VALUES({year}, {month_numeric}, '{sales_person_id}', '{brand_code}', {sales_goal}, '{sales_goal_code}');\n"
                
                cursor.execute(command)
                cursor.commit() # save changes
                successful_uploads += 1
                
            except Exception as e:
                print(f"Error with {sg}:\n{e}")
                    
        print (f"Synchronization {float(successful_uploads)/float(len(sales_goal_rows))*100.0} %\n")
        conn.close()
        
    except Exception as e:
        print(f"\nSomething went wrong with database connection: \n{e}")



try_upload_sales_goal(sales_goals)
