FROM node:21.5-alpine as build-step

WORKDIR /app

COPY package*.json ./

RUN npm install --legacy-peer-deps 

COPY . .

RUN npm run build

#nginx
FROM nginx:1.25.2-alpine

COPY --from=build-step /app/build   /usr/share/nginx/html

COPY ./nginx/nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
