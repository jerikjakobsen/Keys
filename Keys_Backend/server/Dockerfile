FROM node:alpine

WORKDIR /app

RUN npm install -g nodemon ts-node

COPY ./src ./src
COPY ./package-lock.json ./package-lock.json
COPY ./package.json ./package.json
COPY ./tsconfig.json ./tsconfig.json

RUN npm install

EXPOSE ${NODE_SERVER_PORT}

CMD ["npm", "run", "start"]