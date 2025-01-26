FROM node:18-alpine AS builder

WORKDIR /app

# Copy cả lockfile
COPY package.json package-lock.json ./

# Cập nhật npm và cài đặt dependencies
RUN npm install -g npm@latest && \
    npm ci --production

COPY . .
RUN npm run build

FROM node:18-alpine
WORKDIR /app

COPY --from=builder /app .
RUN npm install -g @medusajs/medusa-cli

CMD ["sh", "-c", "medusa migrate && medusa start"]