import express, { Application } from "express";
import bodyParser from "body-parser";
require("dotenv").config();
import { redisSession } from "./Redis/RedisInit";
import "./Mongo/MongoInit";
import { AuthenticationRouter, VaultRouter } from "./Routes";
import cookieParser from "cookie-parser";
import { validateServerKey } from "./Middleware/validateServerKey";
import { EnvironmentManager } from "./utils/EnvironmentManager";

const app: Application = express();

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(cookieParser());
app.use(validateServerKey);
app.use(redisSession);

app.use("/auth", AuthenticationRouter);
app.use("/vault", VaultRouter);

app.listen(EnvironmentManager.vars.NodeServerPort);
