import Redis from 'ioredis'
const RedisStore = require('connect-redis').default
require('dotenv').config()
import session from './Sessions'

const redisClient = new Redis({
    port: Number(process.env.REDIS_PORT!),
    host: process.env.REDIS_HOST!,
    password: process.env.REDIS_SECRET!
})

redisClient.on('error', function (err: Error) {
    console.log('Could not establish a connection with redis. ' + err);
});

redisClient.on('connect', function (err: Error) {
    console.log('Connected to redis successfully');
});

const redisStore = new RedisStore({
    client: redisClient
})

const redisSession = session({
    store: redisStore,
    secret: process.env.SESSION_SECRET!,
    resave: false,
    saveUninitialized: false
})

export {
    redisSession
}