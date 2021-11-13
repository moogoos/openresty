FROM openresty/openresty:focal


RUN echo "deb http://security.ubuntu.com/ubuntu bionic-security main" > /etc/apt/sources.list.d/bionic.list

RUN apt-get update

RUN apt-get install libssl1.0-dev -y

RUN /usr/local/openresty/luajit/bin/luarocks install luajson \
    &&  /usr/local/openresty/luajit/bin/luarocks install luacrypto

