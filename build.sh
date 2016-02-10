#!/bin/sh
docker build -t exobotbuild -f DockerfileBuild .
docker run -v "/var/run/docker.sock:/var/run/docker.sock" --privileged --rm exobotbuild
