# Sử dụng Node.js 18
FROM node:18-alpine

# Thiết lập thư mục làm việc
WORKDIR /app

# Copy package files
COPY package*.json ./

# Cài đặt dependencies
RUN npm install --production

# Copy toàn bộ source code
COPY . .

# Build ứng dụng
RUN npm run build

# Expose port 9000 (port mặc định của Medusa)
EXPOSE 9000

# Chạy migrations và khởi động server
CMD ["sh", "-c", "medusa migrate && medusa start"]