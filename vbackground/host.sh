#!/bin/bash
# install v4l2 loopback
sudo apt-get install v4l2loopback-utils -y
sudo modprobe v4l2loopback exclusive_caps=1 video_nr=2 # creates /dev/video2
docker run --gpus all -it --rm --shm-size=1g --ulimit memlock=-1 --ulimit stack=67108864 -v /home/dsingal/repos/virtual_webcam_background/:/workspace/virtual_webcam_background  --device=/dev/video2 --device=/dev/video0 nvcr.io/nvidia/tensorflow:20.12-tf2-py3
