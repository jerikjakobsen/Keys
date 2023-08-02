import express, {Application} from 'express'
import redis from 'redis'
import bodyParser from 'body-parser'
require("dotenv").config()

import connectRedis from 'connect-redis';
import session from 'express-session';

const app: Application = express();
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));


const RedisStore = new connectRedis(session)

const redisClient = redis.createClient({
    host: 'localhost',
    port: process.env.REDIS_PORT
})
redisClient.on('error', function (err: Error) {
    console.log('Could not establish a connection with redis. ' + err);
});

redisClient.on('connect', function (err: Error) {
    console.log('Connected to redis successfully');
});
//Configure session middleware
app.use(session({
    store: new RedisStore({ client: redisClient }),
    secret: process.env.REDIS_SECRET,
    resave: false,
    saveUninitialized: false,
    cookie: {
        secure: false, // if true only transmit cookie over https
        httpOnly: false, // if true prevent client side JS from reading the cookie 
        maxAge: Int(process.env.TOKEN_EXPIRY) // session max age in miliseconds
    }
}))