FROM node:18-alpine

WORKDIR /app

# Copy package files và cài đặt dependencies
COPY package*.json ./
RUN npm install

# Copy mã nguồn và build
COPY . .
RUN npm run build

# Chạy migrations và khởi động server
CMD ["sh", "-c", "medusa migrations run && medusa start"]