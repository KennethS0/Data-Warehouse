import os.path
import threading
import time
import subprocess
import json

def checking():
    csvProcessed = False
    jsonProcessed = False
    pathToCheck = os.getcwd()+"//Mongo-Sharding//dataFiles"
    pathToMove = os.getcwd()+"//Mongo-Sharding//processedFiles"
    
    while not csvProcessed or not jsonProcessed:

        directory= os.listdir(pathToCheck) 

        # Empty directory 
        while len(directory) == 0: 
            directory= os.listdir(pathToCheck) 

        # Not empty directory
        if not os.path.exists(os.getcwd()+"//Mongo-Sharding//processedFiles"):
            os.makedirs(os.getcwd()+"//Mongo-Sharding//processedFiles")

        time.sleep(1)

        for f in directory:
            filePath = pathToCheck+"//"+f
            if f.endswith('.csv') and not csvProcessed:
                os.replace(filePath, pathToMove+"//"+f)
                csvProcessed = True
                callMongoImport(pathToMove+"//"+f)
            elif (f.endswith('.txt') or f.endswith('.json')) and not jsonProcessed:
                modifyJSON(filePath)
                os.replace(filePath, pathToMove+"//"+f)
                jsonProcessed = True
                callMongoImport(pathToMove+"//"+f)


# t = threading.Thread(target=checking)
# t.start()
def modifyJSON(filePath):
    with open(filePath, "r") as jsonFile:
        data = json.load(jsonFile)
        data = data["Data"]
    with open(filePath, "w") as jsonFile:
        json.dump(data, jsonFile)   

def callMongoImport(filePath):
    process = subprocess.run(["mongoimport"
                            ,"--db", "users"
                            ,"--collection", "contacts"
                            ,"--file", filePath
                            ,"--jsonArray"], capture_output=True).stderr
    print(process)
