# Dockerfile for reddit-mobile

FROM iron/base:edge

RUN echo '@edge http://nl.alpinelinux.org/alpine/edge/main' >> /etc/apk/repositories
RUN echo '@community http://nl.alpinelinux.org/alpine/edge/community' >> /etc/apk/repositories

RUN apk update && apk upgrade \
  && apk add nodejs@community python make gcc xmlparse \
  && rm -rf /var/cache/apk/*

ADD package.json package.json
RUN NODE_ENV=development npm install

ADD . .

ENTRYPOINT ["bin/hubot", "--alias", "';'", "-a", "slack", "-n", "exobot"]
