/*
 *  Sale Schema  
 */

const mongoose = require('mongoose');
const { Schema } = mongoose;

const saleSchema = new Schema (
    {
        client: {
            type: String,
            required: true,
            minlength: 7,
            maxlength: 7
        },

        currency: {
            type: String,
            required: true,
            minlength: 3,
            maxlength: 3
        },
        
        salesman: {
            type: Number,
            required: true
        },

        items: [
            {
                item_code: {
                    type: String,
                    required: true,
                    minlength: 7,
                    maxlength: 7
                },
                unit_price: {
                    type: mongoose.Types.Decimal128,
                    required: true
                },
                amount: {
                    type: Number,
                    required: true
                },
                tax_percentage: { // Percentage
                    type: mongoose.Types.Decimal128,
                    required: true
                },
                untaxed_item_total: { // unitPrice * amount
                    type: mongoose.Types.Decimal128,
                    required: true
                },
                tax_total: { // untaxed_item_total * (1 + tax_percentage/100)
                    type: mongoose.Types.Decimal128,
                    required: true
                },
                profit: {
                    type: mongoose.Types.Decimal128,
                    required: true
                }
            }
        ]
    },
    {
        versionKey: false, 
        timestamps: true, // createdAt and updatedAt 
    }
);

module.exports = mongoose.model("Sale", saleSchema);