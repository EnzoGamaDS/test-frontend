# estágio de compilação
FROM node:18-alpine as build-stage
WORKDIR /app
COPY package*.json ./
RUN npm install -g npm@9.6.7
COPY . .
RUN npm run build

# estágio de produção
FROM nginx:stable-alpine as production-stage
COPY --from=build-stage /app/dist /usr/share/nginx/html
COPY --from=build-stage /app/.setup/nginx/ /etc/nginx/conf.d

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
