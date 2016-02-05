# Dockerfile for reddit-mobile

FROM mhart/alpine-node:5.5

RUN apk add --update make gcc g++ python

ADD package.json package.json
RUN NODE_ENV=development npm install

RUN apk del make gcc g++ python && \
    rm -rf /tmp/* /var/cache/apk/* /root/.npm /root/.node-gyp

ADD . .

# start the server
ENTRYPOINT ["bin/hubot", "--alias", "';'", "-a", "slack", "-n", "exobot"]
