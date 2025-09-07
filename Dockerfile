FROM ubuntu:22.04

# Instalar dependencias básicas
RUN apt-get update && apt-get install -y \
    build-essential cmake git python3 python3-pip wget unzip \
    && rm -rf /var/lib/apt/lists/*

# Instalar TFD
RUN git clone https://github.com/aiplan4eu/tfd.git /tfd \
    && cd /tfd \
    && mkdir build && cd build \
    && cmake .. \
    && make \
    && make install

WORKDIR /pddl

ENTRYPOINT ["/tfd/build/tfd"]

