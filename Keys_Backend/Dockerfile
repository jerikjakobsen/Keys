FROM node:alpine

WORKDIR /app

RUN npm install -g nodemon ts-node

COPY . .

RUN npm install

EXPOSE 26000

CMD ["npm", "run", "start"]