#!/bin/bash
# update apt
apt-get update
apt-get install libgl1-mesa-glx -y
# install pip requirements
pip install -r requirements.txt
