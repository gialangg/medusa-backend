FROM node:18-alpine

WORKDIR /app

# Install dependencies với legacy-peer-deps để fix xung đột
COPY package*.json ./
RUN npm install --legacy-peer-deps

# Copy mã nguồn và build
COPY . .
RUN npm run build

# Chạy migrations và khởi động server
CMD ["sh", "-c", "npx medusa migrations run && npx medusa start"]