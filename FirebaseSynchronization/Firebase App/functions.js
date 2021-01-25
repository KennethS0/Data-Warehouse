// obtener los elementos en variables
const year = document.getElementById('year');
const month = document.getElementById('month');
const brand = document.getElementById('brand');
const salesperson = document.getElementById('salesperson');
const amount = document.getElementById('amount');

// en estas const para manejar f{acilemtne la base de datos.}
const database = firebase.database();

// referencia a la collection test_col para utilizar las funciones sobre esta colección
const rootRef = database.ref('/salesgoal_col/');


function showGoals(){
    rootRef.on('value', (snap) =>{

        var data = JSON.stringify(snap.val());
        var list = splitString(data);
        append_json(list);
    });

}

showGoals();






// se le agrega el listener al botón ADD .... 
addBtn.addEventListener('click', (e) => {
    e.preventDefault(); // evita el submit 
    // --get the autoKey rootRef.push().key: con esta instruccion se obtiene
    let recordKey = year.value+month.value+brand.value+salesperson.value; //DMR: en este caso se construye la llave, sino se puede generar
 
    // se hace un set, que es un UPSERT, actualiza o inserta, segun si la llave existe o no
    rootRef.child(recordKey).set({
        code : recordKey,
        year: year.value,
        month : month.value,
        brand : brand.value,
        salesperson : salesperson.value,
        amount : amount.value
    });
});

// se le agrega el listener al botón update
updateBtn.addEventListener('click', (e) => {
    e.preventDefault();
    // forma la llave para actualizar el monto
    let recordKey = year.value+month.value+brand.value+salesperson.value; 
    // hace update del amount
    rootRef.child(recordKey).update({
        amount : amount.value
    });
});

// se agrega el listener al botón remove
removeBtn.addEventListener('click', (e) => {
    e.preventDefault();
    //forma la llave y elimina
    let recordKey = year.value+month.value+brand.value+salesperson.value; 
    rootRef.child(recordKey).remove()
    .then(() => {
        window.alert('User ' + recordKey + ' removed from DB!')
    })
    .catch(error => {
        window.alert(error)
    });
});

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


// se agrega el listener al botón show goals
// syncBtn.addEventListener('click', (e) => {
//     e.preventDefault();

//     postData('data to process');

// });