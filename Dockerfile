FROM node:18-alpine

WORKDIR /app

# Bước 1: Copy package files và cài đặt dependencies
COPY package*.json ./
RUN npm install --include=dev  # Cài đặt cả devDependencies
RUN npm install @medusajs/medusa-cli  # Cài đặt medusa-cli cục bộ

# Bước 2: Copy mã nguồn và build
COPY . .
RUN npm run build

# Bước 3: Chạy migrations và khởi động server với npx
CMD ["sh", "-c", "npx medusa migrations run && npx medusa start"]