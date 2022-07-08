# syntax=docker/dockerfile:1
FROM ubuntu:20.04 AS builder

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -yq --no-install-recommends \
    build-essential \
    wget \
    curl \
    gcc \
    make \
    tzdata \
    git \
    libreadline-dev \
    libncurses-dev \
    libssl-dev \
    zlib1g-dev \
    cmake \
    g++ 

WORKDIR /tmp

RUN wget --no-check-certificate https://github.com/SoftEtherVPN/SoftEtherVPN/releases/download/5.01.9674/softether-vpn-src-5.01.9674.tar.gz

RUN tar xvfz softether-vpn-src-5.01.9674.tar.gz

WORKDIR /tmp/SoftEtherVPN-5.01.9674

RUN ./configure

RUN make -C tmp

RUN make -C tmp install DESTDIR=/vpn


###
FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -yq --no-install-recommends \
    libreadline8 \
    libssl1.1

RUN apt autoremove && apt clean

WORKDIR /root
COPY --from=builder /vpn/* /usr/

CMD ["/usr/local/libexec/softether/vpnclient/vpnclient", "execsvc"]
