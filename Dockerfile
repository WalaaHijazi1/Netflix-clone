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

RUN yarn build

# === Stage 2: Serve with NGINX and enable /stub_status ===
FROM nginx:stable-alpine

# Remove default content
WORKDIR /usr/share/nginx/html
RUN rm -rf ./*

# Copy built frontend
COPY --from=builder /app/dist .

# Copy custom nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose default port
EXPOSE 80

ENTRYPOINT ["nginx", "-g", "daemon off;"]