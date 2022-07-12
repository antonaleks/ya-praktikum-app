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
FROM node:alpine as app
EXPOSE 80
WORKDIR /app
RUN npm install -g http-server
COPY --from=builder /usr/src/app/dist .
ENTRYPOINT http-server /app/frontend -p 80 --proxy ${BACKEND_URL}