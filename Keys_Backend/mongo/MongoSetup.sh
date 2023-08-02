#!/bin/bash

set -a
[ -f .env ] && . .env
set +a

echo "Waiting for MongoDB to start..."
until mongosh --eval "db.adminCommand('ping')" >/dev/null 2>&1; do
  sleep 1
done

echo "Checking if user 'backend' already exists..."
USER_EXISTS=$(mongo --quiet --eval 'db.getUser('$MONGO_DB_USER')' admin)
if [[ -n "$USER_EXISTS" ]]; then
  echo "User 'backend' already exists. Skipping user creation."
else
  echo "Creating user 'backend' and assigning permissions..."
  mongo --eval "
    db.createUser({
      user: '$MONGO_DB_USER',
      pwd: '$MONGO_DB_PASSWORD',
      roles: ['$MONGO_DB_BACKEND_PERMISSIONS']
    });
  " admin
fi

echo "Creating collection 'users' if it does not already exist..."
mongo --eval "
  if (!db.getCollectionNames().includes('users')) {
    db.createCollection('users');
  }
" admin

echo "MongoDB setup completed!"