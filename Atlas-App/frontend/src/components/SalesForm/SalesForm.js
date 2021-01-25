import React, {Component} from 'react';
import axios from 'axios';
import './SalesForm.css';


class SalesForm extends Component {
    
    
    constructor(props) {
        super(props);
        this.state = {client: "", salesman: '', currency: "USD", items: [{}]}; // Initializes a list of items

        this.server = 'http://localhost:';
        this.port = '3000';

        this.onSubmit = this.onSubmit.bind(this);


        this.currencyOptions = [
            {value: "USD", key: 1},
            {value: "CRC", key: 2}
        ];
    }
    
    
    // Adds a new item to the list
    addNewItem() {
        this.setState(state => ({items: [...state.items, {}]}))
    }

    
    // Removes a specific item from the list
    removeItem(index) {
        let items = [...this.state.items];
        items.splice(index, 1);
        this.setState({items});
    }


    // Changes the value of a specific item
    handleItemCodeChange(index, event) {
        const re = /^[0-9\b]+$/;

        let items = [...this.state.items]; // Gets every value
        const {name, value} = event.target;
        
        if ((event.target.value === '' || re.test(event.target.value)) && event.target.value.length <= 6) {
            items[index][name] = value; 
            this.setState({ items }); // Updates every value
        }
    }

    // Changes the value of a specific item (FLOAT)
    handleItemFloatChange(index, event) {
        // Allows numbers with only four decimal points
        const re =  /^\d*\.?(?:\d{1,4})?$/;

        let items = [...this.state.items]; // Gets every value
        const {name, value} = event.target;
        
        if (event.target.value === '' || re.test(event.target.value)) {
            items[index][name] = value; 
            this.setState({ items }); // Updates every value
        }
    }   

    // Changes the value of a specific item (INT)
    handleItemIntChange(index, event) {
        const re = /^[0-9\b]+$/;

        let items = [...this.state.items]; // Gets every value
        const {name, value} = event.target;
        
        if (event.target.value === '' || re.test(event.target.value)) {
            items[index][name] = value; 
            this.setState({ items }); // Updates every value
        }
    }


    // Client Code
    handleClientChange(event) {
        const re = /^[0-9\b]+$/;

        if ((event.target.value === '' || re.test(event.target.value)) && event.target.value.length <= 6) {
            this.setState({client: event.target.value});
        }
    }

    // Salesman Code
    handleSalesmanChange(event) {
        const re = /^[0-9\b]+$/;

        if ((event.target.value === '' || re.test(event.target.value))) {
            this.setState({salesman: event.target.value});
        }
    }

    // Currency
    handleCurrencyChange(event) {
        this.setState({currency: event.target.value});
    }


    // Uploads the information
    onSubmit(event) {
        if (this.state.items.length < 1) {
            // TODO - ADD ALERT
            
            return
        };

        let items = [...this.state.items];

        const clientCode = 'C' + (this.state.client+'').padStart(6,'0');
        
        // Changes salesman if its not found
        if (this.state.salesman === '') this.setState({salesman: -1});

        // Calculate item_total and sale_total
        items.forEach(data => {
            // Code
            data["item_code"] = 'A' + (data.item_code+'').padStart(6,'0');

            // Tax Correction
            data["tax_percentage"] = data.tax_percentage / 100;

            // Untaxed Item Total
            data["untaxed_item_total"] = data.amount * data.unit_price;

            // Total Tax Amount
            data["tax_total"] = data.untaxed_item_total * data.tax_percentage;
        });

        // Once the state is changed the data is uploaded to the database
        this.setState({client: clientCode, items}, () => {
                axios.post(this.server + this.port + '/sales', this.state)
                .then(res => console.log(res.data));
        });   
    }


    // Returns all item elements
    loadItems() {
        return this.state.items.map((data, index) =>
            <div key={index} className="itemData">
                <p>Item Code</p> 
                <input required name="item_code" type="text" value={data.item_code || ""} onChange={this.handleItemCodeChange.bind(this, index)}></input>

                <p>Unit Price</p>
                <input required name="unit_price" type="text" value={data.unit_price || ""} onChange={this.handleItemFloatChange.bind(this, index)}></input>

                <p>Amount</p>
                <input required name="amount" type="text" value={data.amount || ""} onChange={this.handleItemIntChange.bind(this, index)}></input>

                <p>Tax Percentage</p>
                <input required name="tax_percentage" type="text" value={data.tax_percentage || ""} onChange={this.handleItemFloatChange.bind(this, index)}></input>

                <p>Profit</p>
                <input required name="profit" type="text" value={data.profit || ""} onChange={this.handleItemFloatChange.bind(this, index)}></input>

                <input required type="button" value="Remove" onClick={this.removeItem.bind(this, index)}></input>
                <hr />
            </div>
        )
    }


    // Shows the component on screen
    render() {
        return (
            <form onSubmit={this.onSubmit}>
            
                <div className="header"> 
                    
                    <div className="headerField">
                        <p>Client</p> 
                        <input required 
                            name="client" 
                            type="text" 
                            value={this.state.client} 
                            onChange={this.handleClientChange.bind(this)}></input>
                    </div>

                    <div className="headerField">
                        <p>Salesman</p> 
                        <input
                            name="salesman" 
                            type="text" 
                            value={this.state.salesman} 
                            onChange={this.handleSalesmanChange.bind(this)}></input>
                    </div>
                    
                    <div className="headerField">
                        <p>Currency</p>

                        <select value={this.state.currency} onChange={this.handleCurrencyChange.bind(this)}>
                            {this.currencyOptions.map((opt) => (
                                <option value={opt.value}>{opt.value}</option>
                            ))}
                        </select>
                    </div>

                </div>
                
                <div className="main">
                    <p>Items</p>
                    <hr></hr>
                    
                    {this.loadItems()} 
                    
                    <input type="button" value="Add Item" onClick={this.addNewItem.bind(this)}></input>

                    <button type="submit">Submit</button>
                </div>
            </form>
        );
    }
}

export default SalesForm;