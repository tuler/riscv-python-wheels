# syntax=docker.io/docker/dockerfile:1.4
FROM --platform=linux/riscv64 cartesi/python:3.10-slim-jammy

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    build-essential cmake autotools-dev autoconf automake gfortran \
    gfortran-11 libgfortran-11-dev libgfortran5 pkg-config libopenblas-dev \
    liblapack-dev libssl-dev gcc g++ git make python3 \
    curl libmpc-dev \
    libmpfr-dev libgmp-dev gawk bison flex texinfo gperf \
    libtool patchutils bc zlib1g-dev libexpat-dev libglib2.0-dev libjpeg-dev

RUN pip install --upgrade pip

RUN pip install torch --index-url http://host.docker.internal:8000 --trusted-host host.docker.internal --extra-index-url https://pypi.org/simple

WORKDIR /opt/cartesi/dapp