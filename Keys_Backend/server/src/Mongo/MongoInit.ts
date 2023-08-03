const mongoose = require('mongoose')
import dotenv from 'dotenv'
dotenv.config()

mongoose.connect(`mongodb://${process.env.MONGO_DB_USER}:${process.env.MONGO_DB_PASSWORD}@${process.env.MONGO_DB_HOST}:27017/keys`)