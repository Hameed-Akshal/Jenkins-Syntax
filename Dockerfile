FROM node:21.5-alpine as build-step

WORKDIR /app

COPY package*.json ./

RUN npm install --legacy-peer-deps 

COPY . .

RUN npm run build

# Use the official Apache HTTP Server image
FROM httpd:2-alpine

RUN mkdir -p /usr/local/apache2/htdocs
RUN mkdir -p /usr/local/apache2/logs

COPY --from=build-step /app/build /usr/local/apache2/htdocs/

COPY ./.htaccess /usr/local/apache2/htdocs/

# Enable mod_rewrite and set AllowOverride
RUN sed -i 's/#LoadModule rewrite_module/LoadModule rewrite_module/' /usr/local/apache2/conf/httpd.conf
RUN sed -i 's/AllowOverride None/AllowOverride All/' /usr/local/apache2/conf/httpd.conf

EXPOSE 80
