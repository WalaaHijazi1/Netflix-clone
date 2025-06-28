# === Stage 1: Build the frontend ===
FROM node:22 AS builder
WORKDIR /app

COPY ./package.json .
COPY ./yarn.lock .
RUN yarn install

COPY . .

ARG TMDB_V3_API_KEY
ENV VITE_APP_TMDB_V3_API_KEY=${TMDB_V3_API_KEY}
ENV VITE_APP_API_ENDPOINT_URL="https://api.themoviedb.org/3"

# Build the frontend
RUN yarn build

# === Stage 2: Serve with NGINX and support Prometheus ===
FROM nginx:stable-alpine

# Remove default NGINX html
WORKDIR /usr/share/nginx/html
RUN rm -rf ./*

# Copy built frontend
COPY --from=builder /app/dist .

# Set custom NGINX config via Kubernetes ConfigMap at runtime
# NOTE: Do NOT COPY nginx.conf here; it will be mounted by K8s to /etc/nginx/nginx.conf

# Expose app and metrics ports
EXPOSE 80 9111

# Start NGINX in foreground
ENTRYPOINT ["nginx", "-g", "daemon off;"]
