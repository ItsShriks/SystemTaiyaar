#!/bin/bash
xhost +local:docker
docker run -it -e DISPLAY="$DISPLAY" -v /tmp/.X11-unix:/tmp/.X11-unix ubuntu
