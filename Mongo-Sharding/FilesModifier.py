import json
import csv

numOfMonth = {"ene":"01", "feb":"02", "mar":"03", "abr":"04", "may":"05", "jun":"06"
           ,"jul":"07", "ago":"08", "sep":"09", "oct":"10", "nov":"11", "dic":"12"}

# Modifys the JSON that is passed by parameter
def modifyJSON(filePath):
    with open(filePath, "r") as jsonFile:
        data = json.load(jsonFile)
        data = data["Data"]
    with open(filePath, "w") as jsonFile:
        json.dump(data, jsonFile)   

# Modifys the CSV that is passed by parameter
def modifyCSV(filePath):
    newLines = [['Factura','Fecha','FechaVencimiento','Cliente','Producto','Cantidad', 'Moneda', 'Total', 'Almacen', 'Vendedor', 'TotalUSD', 'Impuesto', 'ImpuestoUSD', 'Tipo de cambio', 'Ganacia', 'GananciaUSD']]
    with open(filePath, "r") as csvFile:
        data = csv.reader(csvFile,delimiter=";")
        next(data, None)
        for row in data:
            newLines.append(modifyClientCSV(row))
    with open(filePath, "w", newline='') as csvFile:
        wr = csv.writer(csvFile, delimiter=',')
        wr.writerows(newLines) 
        
# Modifys the line(client) of the CSV that is passed by the parameter        
def modifyClientCSV(client):
    newClient = []

    newClient.append( str(f"{int(client[0][3:]):09d}") ) # Add receipt without "FA " 
    newClient.append( str("20"+client[2][4:] + numOfMonth[client[2][:3]] + f"{int(client[1]):02d}") ) # Add date with the right format
    newClient.append( str("20"+client[4][4:] + numOfMonth[client[4][:3]] + f"{int(client[3]):02d}") ) # # Add expiration date with the right format
    newClient.append( str("C"+f"{int(client[5]):06d}") ) # Add client with the right format
    newClient.append( str("A"+f"{int(client[6]):06d}") ) # Add articule with the right format
    for data in range(7,len(client)):
        newClient.append( str(client[data]) ) # Add the other data
    return newClient