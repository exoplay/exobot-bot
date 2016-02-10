FROM iron/base:edge

RUN echo '@edge http://nl.alpinelinux.org/alpine/edge/main' >> /etc/apk/repositories
RUN echo '@community http://nl.alpinelinux.org/alpine/edge/community' >> /etc/apk/repositories

RUN apk update && apk upgrade && apk add\
  nodejs@community \
  && rm -rf /var/cache/apk/*

WORKDIR /tmp
ADD package.json .
ADD node_modules ./node_modules
ADD bin ./bin
ADD scripts ./scripts

ENTRYPOINT ["/tmp/bin/hubot", "--alias", "';'", "-a", "slack", "-n", "exobot"]
