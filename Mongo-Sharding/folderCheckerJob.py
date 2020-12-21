import os.path
import threading
import time

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
            elif f.endswith('.txt') and not jsonProcessed:
                os.replace(filePath, pathToMove+"//"+f)
                jsonProcessed = True


t = threading.Thread(target=checking)
t.start()

