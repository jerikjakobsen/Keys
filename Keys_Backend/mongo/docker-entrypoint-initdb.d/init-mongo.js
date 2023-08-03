db = db.getSiblingDB('keys')
db.createUser(
    {
      user: process.env.MONGO_DB_USER,
      pwd: process.env.MONGO_DB_PASSWORD,
      roles: [
        {
          role: process.env.MONGO_DB_BACKEND_PERMISSIONS,
          db: "keys"
        }
      ]
    }
  );
db.createCollection('users');

db.users.insertOne(
  {
    username: 'test',
    hash: '123445',
    email: 'test@test.com'
  }
);