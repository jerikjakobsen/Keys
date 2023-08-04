import express, {Application} from 'express'
import bodyParser from 'body-parser'
require("dotenv").config()
import {redisSession} from './Redis/RedisInit';
import './Mongo/MongoInit'
import * as routes from './Routes'
import updateKDBX from './Routes/UpdateKDBX';

const app: Application = express();
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.use(redisSession)

app.listen(process.env.NODE_SERVER_PORT!)

app.post('/login', routes.login)
app.post('/createAccount', routes.createAccount)
app.post('/updateKDBX', routes.updateKDBX)
app.get('/getKDBX', routes.getKDBX)