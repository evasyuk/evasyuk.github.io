# stage1 as builder
FROM node:10-alpine as builder

WORKDIR /usr/app

# copy the package.json to install dependencies
COPY cfg /usr/app/cfg
COPY src /usr/app/src
COPY .babelrc /usr/app/.babelrc
COPY package.json /usr/app/package.json
COPY package-lock.json /usr/app/package-lock.json

# Install the dependencies and make the folder
RUN npm install

# Build the project and copy the files
RUN npm run build

RUN rm -rf /usr/app/src /usr/app/package.json package-lock.json .babelrc

########################################################################################################################
########################################################################################################################
########################################################################################################################


FROM nginx:alpine

#!/bin/sh

COPY --from=builder /usr/app/cfg/nginx.conf /etc/nginx/nginx.conf

## Remove default nginx index page
RUN rm -rf /usr/share/nginx/html/*

# Copy from the stahg 1
COPY --from=builder /usr/app/index.html /usr/app/i.js /usr/share/nginx/html/

EXPOSE 3000 5599

ENTRYPOINT ["nginx", "-g", "daemon off;"]