import pyodbc
from decimal import Decimal

connection_string = 'Driver=ODBC Driver 17 for SQL Server;Server=tcp:rocket-bd2.database.windows.net,1433;Database=ROCKET-BD2;Uid=rocket-admin;Pwd=2020-bd2-2020;Encrypt=yes;TrustServerCertificate=no;Connection Timeout=30;'

def try_upload_sales_goal( sales_goal_rows ):
    
    if sales_goal_rows == []:
        return
    
    try:        
        # stablish connection with azure sql database
        conn = pyodbc.connect(connection_string)
        
        # cursor to create sql commands
        cursor = conn.cursor()
        successful_uploads = 0
    
        # for each row insert in db
        for sg in sales_goal_rows:
            
            for (k, sg) in sg.items():
            
                try: 
                    year = int(sg["year"])
                    month_numeric = int(sg["month"])
                    sales_person_id = int(sg["salesperson"])
                    brand_code = sg["brand"]
                    sales_goal = Decimal(sg["amount"])
                    sales_goal_code = sg["code"]
                    
                    command = f"INSERT INTO FACT_SALES_GOAL(year, month_numeric, sales_person_id, brand_code, sales_goal, sales_goal_code) VALUES({year}, {month_numeric}, {sales_person_id}, '{brand_code}', {sales_goal}, '{sales_goal_code}')"
                            
                    cursor.execute(command)
                    cursor.commit()          
                    successful_uploads += 1
                    
                except Exception as e:
                    print(f"Error with {sg}:\n{e}")
                    
                break
                
        print (f"\nSynchronization {float(successful_uploads)/float(len(sales_goal_rows))*100.0} %\n")
        conn.close()
        
    except Exception as e:
        print(f"\nSomething went wrong with database connection: \n{e}")

# test
obj = {
    "20207Bombillo25" : 
        {
            "amount": "2000", 
            "brand": "Bombillo", 
            "code": "20207Bombillo25", 
            "month": "7", 
            "salesperson": "25", 
            "year": "2020"
        }
    }

data = [obj]
try_upload_sales_goal(data)
