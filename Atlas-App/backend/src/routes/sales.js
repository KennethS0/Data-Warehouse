const express = require("express");
const router = express.Router();

const salesController = require("../controllers/salesController");

// GET Routes
router.get('/sales', salesController.getAll);
router.get('/sales/:client', salesController.getCostumerItems);


// POST Routes
router.post('/sales', salesController.addSale);


module.exports = router;