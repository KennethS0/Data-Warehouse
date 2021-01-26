
// Obtain the elements in variables
const year = document.getElementById('year');
const month = document.getElementById('month');
const brand = document.getElementById('brand');
const salesperson = document.getElementById('salesperson');
const amount = document.getElementById('amount');

// Reference to the firebase database
const database = firebase.database();

// Reference to the goals collection
const rootRef = database.ref('/salesgoal_col/');


// Shows the goals registred in the database
function showGoals(){
    rootRef.on('value', (snap) =>{
        var data = JSON.stringify(snap.val());
        var list = splitString(data);
        append_json(list);
    });
}
showGoals();

// Add documents into the database
addBtn.addEventListener('click', (e) => {
    e.preventDefault();
    let recordKey = year.value+month.value+brand.value+salesperson.value;
    rootRef.child(recordKey).set({
        code : recordKey,
        year: year.value,
        month : month.value,
        brand : brand.value,
        salesperson : salesperson.value,
        amount : amount.value
    });
});

// Update documents
updateBtn.addEventListener('click', (e) => {
    e.preventDefault();
    let recordKey = year.value+month.value+brand.value+salesperson.value; 
    rootRef.child(recordKey).update({
        amount : amount.value
    });
});

// Delete documents
removeBtn.addEventListener('click', (e) => {
    e.preventDefault();
    
    let recordKey = year.value+month.value+brand.value+salesperson.value; 
    rootRef.child(recordKey).remove()
    .then(() => {
        window.alert('User ' + recordKey + ' removed from DB!')
    })
    .catch(error => {
        window.alert(error)
    });
});

// Split the JSON by elements
function splitString(obj){

    var listaString = obj.split("},");

        if(listaString.length>1)
        {
            for(var i=0;i<listaString.length;i++)
            {
                var ens = listaString[i].split(":{");

                if(listaString[i] == listaString[listaString.length-1])
                {
                    listaString[i] = "{"+ens[1];

                    listaString[i] = listaString[i].substring(0, listaString[i].length - 1);
                }
                else{
                    listaString[i] = "{"+ens[1]+"}";
                } 
            }
        }
        else{
            for(var i=0;i<listaString.length;i++)
            {
                var ens = listaString[i].split(":{");

                listaString[i] = "{"+ens[1];

                listaString[i] = listaString[i].substring(0, listaString[i].length - 1);
            }
        }
        return listaString;

}

// Add the list of documents into the html table
function append_json(data){
    var table = document.getElementById('wtf');

    while(table.getElementsByTagName('tr').item(1) != null)
    {
        table.getElementsByTagName('tr').item(1).remove();
    }
  
    var count = 0;
    data.forEach(function(object) {
        count+=1;
        var jsonObject = JSON.parse(object);
        var tr = document.createElement('tr');
        tr.innerHTML = '<th scope="row">'+count+'</th>'+
        '<td>' + jsonObject.year + '</td>' +
        '<td>' + jsonObject.month + '</td>' +
        '<td>' + jsonObject.salesperson + '</td>' +
        '<td>' + jsonObject.brand + '</td>' +
        '<td>' + jsonObject.amount + '</td>';
        table.appendChild(tr);
    });
}
