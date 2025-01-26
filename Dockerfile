FROM node:18-alpine

WORKDIR /app

# Copy package files và cài đặt dependencies
COPY package*.json ./
RUN npm install --include=dev  # Cài đặt cả devDependencies
RUN npm install -g @medusajs/medusa-cli  # Cài đặt Medusa CLI toàn cục

# Copy mã nguồn và build
COPY . .
RUN npm run build

# Chạy migrations và khởi động server
CMD ["sh", "-c", "medusa migrations run && medusa start"]