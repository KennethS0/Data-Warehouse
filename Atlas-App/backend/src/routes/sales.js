const express = require("express");
const router = express.Router();

const salesController = require("../controllers/salesController");


// POST Routes
router.post('/', salesController.addSale);


module.exports = router;