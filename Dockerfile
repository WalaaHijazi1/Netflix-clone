# Use Node for both build and runtime
FROM node:20-alpine AS builder
WORKDIR /app

COPY package.json yarn.lock ./
RUN yarn install

COPY . .

ENV VITE_APP_TMDB_V3_API_KEY=${TMDB_V3_API_KEY}
ENV VITE_APP_API_ENDPOINT_URL="https://api.themoviedb.org/3"

RUN yarn build

# Install express and prom-client
RUN yarn add express prom-client

# Create a separate runtime stage
FROM node:20-alpine
WORKDIR /app

# Copy build artifacts from builder stage
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/server.js ./
COPY --from=builder /app/metrics.js ./

EXPOSE 3001
CMD ["node", "server.js"]