# Stage 1: Build
FROM node:20-alpine AS builder

WORKDIR /app
COPY package.json package-lock.json ./

# Cài đặt cả Medusa CLI và dependencies
RUN npm ci --include=dev && \
    npm install -g @medusajs/medusa-cli

COPY . .
RUN npm run build

# Stage 2: Production
FROM node:20-alpine
WORKDIR /app

# Copy cả node_modules và Medusa CLI
COPY --from=builder /app .
COPY --from=builder /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=builder /usr/local/bin/medusa /usr/local/bin/medusa

# Đảm bảo PATH chứa global node_modules
ENV PATH="/usr/local/bin:${PATH}"

CMD ["sh", "-c", "medusa migrate && medusa start"]