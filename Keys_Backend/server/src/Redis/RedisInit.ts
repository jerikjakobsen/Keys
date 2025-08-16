import Redis from "ioredis";
const RedisStore = require("connect-redis").default;
import { EnvironmentManager } from "../utils/EnvironmentManager";
import session from "express-session";

const redisClient = new Redis({
  port: EnvironmentManager.vars.RedisPort,
  host: EnvironmentManager.vars.RedisHost,
  password: EnvironmentManager.vars.RedisSecret,
});

redisClient.on("error", function (err: Error) {
  if (err) {
    console.error(err);
  } else {
    console.log("Could not establish a connection with redis. " + err);
  }
});

redisClient.on("connect", function (err: Error) {
  if (err) {
    console.error(err);
  } else {
    console.log("Connected to redis successfully");
  }
});

const redisStore = new RedisStore({
  client: redisClient,
});
const redisSession = session({
  store: redisStore,
  secret: EnvironmentManager.vars.SessionSecret,
  resave: false,
  saveUninitialized: false,
});

export { redisSession };
