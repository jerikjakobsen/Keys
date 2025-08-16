import { EnvironmentManager } from "../utils/EnvironmentManager";
const mongoose = require("mongoose");

mongoose.connect(
  `mongodb://${EnvironmentManager.vars.MongoDBUser}:${EnvironmentManager.vars.MongoDBPassword}@${EnvironmentManager.vars.MongoDBHost}:${EnvironmentManager.vars.MongoDBPort}/keys`,
);
