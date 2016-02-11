#!/bin/sh
docker build -t exobotbuild -f DockerfileBuild .
docker run --name exobotbuild -v "/var/run/docker.sock:/var/run/docker.sock" --privileged --rm exobotbuild
