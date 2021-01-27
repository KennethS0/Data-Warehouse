import os.path
import threading
import time
import subprocess
import logging
import FilesModifier as fm

logging.basicConfig(filename=os.getcwd()+'//uploadedData.log', level=logging.DEBUG)

# Thread that is checking if there is a CSV or JSON file into dataFiles folder
# if there is a file then is processed, imported and moved to processedFiles folder
def checking():
    pathToCheck = os.getcwd()+"//dataFiles"
    pathToMove = os.getcwd()+"//processedFiles"
    
    while True:

        directory = os.listdir(pathToCheck) 

        # Empty directory 
        while len(directory) == 0: 
            directory= os.listdir(pathToCheck) 

        # Not empty directory
        if not os.path.exists(os.getcwd()+"//processedFiles"):
            os.makedirs(os.getcwd()+"//processedFiles")

        time.sleep(1)

        for f in directory:
            filePath = pathToCheck+"//"+f
            if f.endswith('.csv'):
                fm.modifyCSV(filePath)
                os.replace(filePath, pathToMove+"//"+f)
                callMongoImport(pathToMove+"//"+f, "--headerline","csv")
            elif (f.endswith('.txt') or f.endswith('.json')):
                fm.modifyJSON(filePath)
                os.replace(filePath, pathToMove+"//"+f)
                callMongoImport(pathToMove+"//"+f,"--jsonArray","json")

# Calls the MongoImport command with the corresponding parameters and data
# to import the content into the sharding 
def callMongoImport(filePath, readType, fileType):
    process = subprocess.run(["mongoimport"
                            ,"--host=localhost:20006"
                            ,"--db", "test"
                            ,"--collection", "ventas"
                            ,"--type", fileType
                            ,"--file", filePath
                            ,readType], capture_output=True, check=False)
    if process.returncode == 0:
        logging.info(process.stderr.decode("utf-8"))
    else:
        logging.error(process.stderr.decode("utf-8"))
    print(process.stderr.decode("utf-8"))

t = threading.Thread(target=checking)
t.start()

# callMongoImport("C://Users//emema//Desktop//CSV_301-400.csv", "--headerline", "csv")
# callMongoImport("C://Users//emema//Desktop//ContactsNew.json","--jsonArray", "json")
