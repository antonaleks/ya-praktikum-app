### STAGE 1: Biuld Environment ###
FROM node:14.17.3 as builder
ENV BACKEND_URL=http://localhost:8080
# Create app directory
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

### STAGE 2: Production Environment ###
FROM nginx:stable-alpine
EXPOSE 80
COPY --from=builder /usr/src/app/dist/frontend /usr/share/nginx/html
CMD ["nginx", "-g", "daemon off;"]