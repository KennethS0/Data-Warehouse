import React, {Component} from 'react';
import './SalesForm.css';
class SalesForm extends Component {
    constructor(props) {
        super(props);
        this.state = {values: [{}]}; // Initializes a list of values
    }
    
    // Adds a new item to the list
    addNewItem() {
        this.setState(state => ({values: [...state.values, {}]}))
    }

    // Removes a specific item from the list
    removeItem(index) {
        let values = [...this.state.values];
        values.splice(index, 1);
        this.setState({values});
    }

    // Changes the value of a specific item
    handleChange(index, event) {
        let values = [...this.state.values]; // Gets every value
        const {name, value} = event.target;
        values[index][name] = value; 
        this.setState({ values }); // Updates every value
    }

    // Returns all item elements
    loadData() {
        return this.state.values.map((data, index) =>
            <div key={index}>
                <p>Item Code</p> 
                <input name="itemCode" type="text" value={data.itemCode || ""} onChange={this.handleChange.bind(this, index)}></input>

                <p>Unit Price</p>
                <input name="unitPrice" type="text" value={data.unitPrice || ""} onChange={this.handleChange.bind(this, index)}></input>

                <p>Amount</p>
                <input name="amount" type="text" value={data.amount || ""} onChange={this.handleChange.bind(this, index)}></input>

                <p>Tax</p>
                <input name="tax" type="text" value={data.tax || ""} onChange={this.handleChange.bind(this, index)}></input>

                <p>Line Total</p>

                <input type="button" value="Remove" onClick={this.removeItem.bind(this, index)}></input>
                <hr />
            </div>
        )
    }

    // Shows the component on screen
    render() {

        return (
            <form> 

                <div> 
                    <p>Client</p> 
                    <input type="text"></input>
                    <hr />
                </div>

                <p>Items</p>
                
                {this.loadData()}
                
                
                <input type="button" value="Add Item" onClick={this.addNewItem.bind(this)}></input>
                
                <p>Total</p>

                <input type="submit"></input>
            </form>
        );
    }
}

export default SalesForm;