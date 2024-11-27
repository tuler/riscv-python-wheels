# syntax=docker.io/docker/dockerfile:1.4
FROM --platform=linux/riscv64 cartesi/python:3.10-slim-jammy

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    autoconf \
    automake \
    bc \
    bison \
    build-essential \
    cmake \
    curl \
    flex \
    gcc \
    g++ \
    gawk \
    git \
    gfortran \
    gfortran-11 \
    libexpat-dev \
    libgfortran-11-dev \
    libgfortran5 \
    libglib2.0-dev \
    libgmp-dev \
    libjpeg-dev \
    liblapack-dev \
    libmpc-dev \
    libmpfr-dev \
    libopenblas-dev \
    libprotobuf-dev \
    libssl-dev \
    libtool \
    make \
    patchutils \
    pkg-config \
    protobuf-compiler \
    python3 \
    texinfo \
    zlib1g-dev


RUN pip install --upgrade pip

RUN pip install torch --index-url https://think-and-dev.github.io/riscv-python-wheels/pip-index/ --extra-index-url https://pypi.org/simple

WORKDIR /opt/cartesi/dapp