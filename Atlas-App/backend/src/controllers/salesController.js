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


module.exports = salesController;