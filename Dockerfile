# Dockerfile for reddit-mobile

FROM iron/node

WORKDIR /app
ADD . /app

ENTRYPOINT ["bin/hubot", "--alias", "';'", "-a", "slack", "-n", "exobot"]
