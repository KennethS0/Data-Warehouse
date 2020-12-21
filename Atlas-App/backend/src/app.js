const express = require('express');
const morgan = require('morgan');
const cors = require('cors');
require('dotenv/config');

const app = express();

app.set("port", process.env.PORT || 5000);

/* Middlewares */
app.use(cors());
app.use(morgan("dev"));
app.use(express.json());

// Print JSONS
app.use( express.urlencoded({ extended: true }) );

module.exports = app;