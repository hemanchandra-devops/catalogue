# FROM node:20
# WORKDIR /app
# COPY package.json .
# COPY server.js .
# RUN npm install
# EXPOSE 8080
# ENV MONGO="true" \
#     MONGO_URL="mongodb://mongodb:27017/catalogue" 
# CMD ["node", "server.js"]

FROM node:20.20.2-alpine3.22 AS build
WORKDIR /app
COPY package.json .
COPY server.js .
RUN npm install

FROM node:20.20.2-alpine3.22
WORKDIR /app
RUN apk update && apk upgrade && \
    addgroup -S roboshop && \
    adduser -S roboshop -G roboshop
LABEL com.project="roboshop" \
      component="catalogue" \
      created_by="hemanchandra"
EXPOSE 8080
COPY --from=build --chown=roboshop:roboshop /app .
ENV MONGO="true" \
    MONGO_URL="mongodb://mongodb:27017/catalogue"
USER roboshop 
ENTRYPOINT ["node"]
CMD ["server.js"]