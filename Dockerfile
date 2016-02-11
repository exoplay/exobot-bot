FROM iron/node:dev

WORKDIR /tmp
ADD package.json .
ADD node_modules ./node_modules
ADD bin ./bin
ADD scripts ./scripts

ENTRYPOINT /tmp/bin/hubot --alias ';' -a slack -n exobot
