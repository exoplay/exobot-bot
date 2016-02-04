# Dockerfile for reddit-mobile

FROM iron/node

ADD package.json package.json
RUN NODE_ENV=development npm install

ADD . .

ENTRYPOINT ["bin/hubot", "--alias", "';'", "-a", "slack", "-n", "exobot"]
