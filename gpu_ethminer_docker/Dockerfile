FROM nvidia/cuda:11.1.1-devel-ubuntu20.04

WORKDIR /

# Package and dependency setup
ENV DEBIAN_FRONTEND="noninteractive" TZ="US/"
RUN apt-get update \
    && apt-get -y install software-properties-common \
    && apt-get update
# set noninteractive installation
RUN export DEBIAN_FRONTEND=noninteractive
#install tzdata package
RUN apt-get install -y tzdata
# set your timezone
RUN ln -fs /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
RUN dpkg-reconfigure --frontend noninteractive tzdata
RUN  apt-get install -y git \
     cmake \
     opencl-headers \
     mesa-common-dev \
     build-essential \
     libdbus-1-dev \
     perl

# Git repo set up
RUN git clone https://github.com/ethereum-mining/ethminer.git; \
    cd ethminer; \
    git submodule update --init --recursive

# Build
RUN cd ethminer; \
    mkdir build; \
    cd build; \
    cmake .. -DCOMPUTE=75 -DETHASHCUDA=ON -DETHASHCL=OFF -DBINKERN=OFF; \
    cmake --build .; \
    make install;

# Env setup
ENV GPU_FORCE_64BIT_PTR=0
ENV GPU_MAX_HEAP_SIZE=100
ENV GPU_USE_SYNC_OBJECTS=1
ENV GPU_MAX_ALLOC_PERCENT=100
ENV GPU_SINGLE_ALLOC_PERCENT=100
