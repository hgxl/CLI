FROM alpine:{{ image.version }}

LABEL maintainer="Skyflow Team - Franck Diomandé <fkdiomande@gmail.com>"

RUN apk add --no-cache nodejs-npm  ruby-dev build-base libffi-dev ruby && \
    npm i -g gulp && echo "gem: --no-rdoc --no-ri" > /etc/gemrc && \
    gem install compass