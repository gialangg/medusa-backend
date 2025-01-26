FROM node:18-alpine

WORKDIR /app

COPY package*.json ./
RUN npm install --legacy-peer-deps  # Fix xung đột dependencies

COPY . .
RUN npm run build


RUN npm run start
