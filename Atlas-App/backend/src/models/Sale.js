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
        },

        items: [
            {
                item: {
                    type: String,
                    required: true
                },
                unitPrice: {
                    type: Number,
                    required: true
                },
                tax: {
                    type: Number,
                    required: true
                },
                total: {
                    type: Number,
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