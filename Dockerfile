FROM ubuntu:14.04

RUN apt update -qq
RUN apt install -y git screen curl netcat
RUN apt install -y automake autoconf pkg-config libcurl4-openssl-dev libjansson-dev libssl-dev libgmp-dev zlib1g-dev make g++

# USER pi

RUN git clone https://github.com/tpruvot/cpuminer-multi.git
RUN cd cpuminer-multi
WORKDIR /cpuminer-multi

RUN ./autogen.sh
# RPi Config:
RUN ./configure --disable-assembly CFLAGS="-Ofast -march=native" --with-crypto --with-curl
# Basic *Unix config:
# RUN ./configure CFLAGS="*-march=native*" --with-crypto --with-curl
RUN make

COPY ./src ./

CMD [ "./mine.sh" ]
