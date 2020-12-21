const Sale = require('../models/Sale');

/* 
    All functions related to sales manipulation in the database
*/ 

const salesController = {};

// Adds a new sale to the database.
salesController.addSale = async(req, res) => {
    const newSale = new Sale(req.body);

    try {
        await newSale.save();
        res.status(201).send({newSale});
    } catch (error) {
        res.status(400).send(error);
    }
}

// Gets all sales in the database.
salesController.getAll = async(req, res) => {
    
    try {
        const sales = await Sale.find();
        res.status(202).send(sales);
    } catch (error) {
        res.status(404).send(error);
    }
}

// Gets all the items bought by one customer
salesController.getCostumerItems = async(req, res) => {
    try {
        const sales = await Sale.find({client: req.params.client});
        res.status(202).send(sales);
    } catch (error) {
        res.status(404).send(error);
    }
}


module.exports = salesController;