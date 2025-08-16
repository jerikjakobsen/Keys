require("dotenv").config();

type EnvVarDefinition<T extends string | number> = {
  key: string;
  type: "string" | "number";
  default?: T;
  optional?: boolean;
};

class EnvironmentManager {
  static vars: {
    RedisSecret: string;
    RedisHost: string;
    TokenExpiry: number;
    RedisPort: number;
    MongoDBUser: string;
    MongoDBPassword: string;
    MongoDBBackendPermissions: string;
    MongoDBHost: string;
    MongoDBPort: number;
    MongoInitDBRootUsername: string;
    MongoInitDBRootPassword: string;
    MongoInitDBDatabase: string;
    NodeServerPort: number;
    SessionSecret: string;
    HashSecret: string;
    HashPower: number;
    HashLength: number;
    HashTimeCost: number;
    AWSAccessKeyId: string;
    AWSSecretAccessKey: string;
    AWSBucket: string;
    AWSRegion: string;
    ServerKey: string;
  };

  private static schema: Record<
    keyof typeof EnvironmentManager.vars,
    EnvVarDefinition<any>
  > = {
    RedisSecret: { key: "REDIS_SECRET", type: "string" },
    RedisHost: { key: "REDIS_HOST", type: "string" },
    TokenExpiry: { key: "TOKEN_EXPIRY", type: "number" },
    RedisPort: { key: "REDIS_PORT", type: "number" },
    MongoDBUser: { key: "MONGO_DB_USER", type: "string" },
    MongoDBPassword: { key: "MONGO_DB_PASSWORD", type: "string" },

    MongoDBBackendPermissions: {
      key: "MONGO_DB_BACKEND_PERMISSIONS",
      type: "string",
    },
    MongoDBHost: { key: "MONGO_DB_HOST", type: "string" },
    MongoDBPort: { key: "MONGO_DB_PORT", type: "number" },
    MongoInitDBRootUsername: {
      key: "MONGO_INITDB_ROOT_USERNAME",
      type: "string",
    },
    MongoInitDBRootPassword: {
      key: "MONGO_INITDB_ROOT_PASSWORD",
      type: "string",
    },
    MongoInitDBDatabase: { key: "MONGO_INITDB_DATABASE", type: "string" },

    NodeServerPort: { key: "NODE_SERVER_PORT", type: "number" },
    SessionSecret: { key: "SESSION_SECRET", type: "string" },
    HashSecret: { key: "HASH_SECRET", type: "string" },
    HashPower: { key: "HASH_POWER", type: "number" },
    HashLength: { key: "HASH_LENGTH", type: "number" },
    HashTimeCost: { key: "HASH_TIME_COST", type: "number" },

    AWSAccessKeyId: { key: "AWS_ACCESS_KEY_ID", type: "string" },
    AWSSecretAccessKey: { key: "AWS_SECRET_ACCESS_KEY", type: "string" },
    AWSBucket: { key: "AWS_BUCKET", type: "string" },
    AWSRegion: { key: "AWS_REGION", type: "string" },
    ServerKey: { key: "SERVER_KEY", type: "string" },
  };

  static {
    const values: any = {};
    for (const [field, config] of Object.entries(EnvironmentManager.schema)) {
      const raw = process.env[config.key];

      if (
        (raw === undefined || raw.trim() === "") &&
        config.default === undefined &&
        !config.optional
      ) {
        throw new Error(`Missing required environment variable: ${config.key}`);
      }

      let parsed: any = raw ?? config.default;

      if (config.type === "number") {
        parsed = Number(parsed);
        if (isNaN(parsed)) {
          throw new Error(
            `Environment variable ${config.key} must be a valid number`,
          );
        }
      }

      values[field] = parsed;
    }

    EnvironmentManager.vars = values;
  }
}

export { EnvironmentManager };
