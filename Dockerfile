FROM openresty/openresty:focal

## Need this to support old luacrypto libssl 1.0 which is not supported in 1.1
RUN echo "deb http://security.ubuntu.com/ubuntu bionic-security main" > /etc/apt/sources.list.d/bionic.list

RUN apt-get update

RUN apt-get install libssl1.0-dev -y

RUN /usr/local/openresty/luajit/bin/luarocks install luajson \
    &&  /usr/local/openresty/luajit/bin/luarocks install luacrypto

COPY conf/nginx.conf /usr/local/openresty/nginx/conf/nginx.conf

COPY lua/handler.lua /usr/local/openresty/nginx/lua/handler.lua
