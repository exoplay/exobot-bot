FROM node:0.10-onbuild
CMD ["bin/hubot --alias ';' -a slack -n exobot"]
