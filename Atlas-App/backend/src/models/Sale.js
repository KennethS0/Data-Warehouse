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

        items: [
            {
                item: {
                    type: String,
                    required: true,
                    minlength: 7,
                    maxlength: 7
                },
                unitPrice: {
                    type: Number,
                    required: true
                },
                tax: {
                    type: Number,
                    required: true
                },
                item_total: {
                    type: Number,
                    required: true
                }
            }
        ],

        sale_total: {
            type: Number,
            required: true
        }
    },
    {
        versionKey: false, 
        timestamps: true, // createdAt and updatedAt 
    }
);

module.exports = mongoose.model("Sale", saleSchema);