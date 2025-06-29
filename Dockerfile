# Step 1: Build the app
FROM node:16.17.0-alpine as builder

# Set working directory
WORKDIR /app

# Copy dependencies files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Pass build-time arguments and environment variables
ARG TMDB_V3_API_KEY
ENV VITE_APP_TMDB_V3_API_KEY=${TMDB_V3_API_KEY}
ENV VITE_APP_API_ENDPOINT_URL="https://api.themoviedb.org/3"

# Build the Vite frontend
RUN npm run build

# Step 2: Serve with NGINX
FROM nginx:stable-alpine

# Clean default NGINX static assets
RUN rm -rf /usr/share/nginx/html/*

# Copy built files from previous stage
COPY --from=builder /app/dist /usr/share/nginx/html

# Expose default HTTP port
EXPOSE 80

# Start NGINX
CMD ["nginx", "-g", "daemon off;"]
