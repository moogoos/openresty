FROM openresty/openresty:focal


RUN apt-get install libssl-dev

RUN /usr/local/openresty/luajit/bin/luarocks install luajson

RUN /usr/local/openresty/luajit/bin/luarocks install luaossl CRYPTO_DIR=/usr/local/openresty/openssl/ OPENSSL_DIR=/usr/local/openresty/openssl/

