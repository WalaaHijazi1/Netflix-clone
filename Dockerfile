FROM node:16-alpine
WORKDIR /app

COPY package.json yarn.lock ./
RUN yarn install

COPY . .

ENV VITE_APP_TMDB_V3_API_KEY=${TMDB_V3_API_KEY}
ENV VITE_APP_API_ENDPOINT_URL="https://api.themoviedb.org/3"

RUN yarn build

EXPOSE 3000
CMD ["node", "server.js"]
