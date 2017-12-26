FROM alpine:3.6

MAINTAINER Skyflow Team - Franck Diomandé 'fkdiomande@gmail.com'

ARG APPLICATION_NAME={{ application.name }}
ARG SERVER_NAME={{ server.name }}
ARG SERVER_ADMIN={{ server.admin }}
ARG DIRECTORY_INDEX={{ directory.index }}
ARG DOCUMENT_ROOT=/var/www/$APPLICATION_NAME/{{ document.root }}
ARG SERVER_TYPE={{ server.type }}
ARG PHP_VERSION=7
ARG PHP_MODULES='apache2'

ENV APPLICATION_NAME ${APPLICATION_NAME}
ENV SERVER_NAME ${SERVER_NAME}
ENV SERVER_ADMIN ${SERVER_ADMIN}
ENV DIRECTORY_INDEX ${DIRECTORY_INDEX}
ENV DOCUMENT_ROOT ${DOCUMENT_ROOT}
ENV SERVER_TYPE ${SERVER_TYPE}
ENV PHP_VERSION ${PHP_VERSION}
ENV PHP_MODULES ${PHP_MODULES}

WORKDIR /var/www/$APPLICATION_NAME

RUN apk add --no-cache $SERVER_TYPE php$PHP_VERSION
RUN for module in $PHP_MODULES; do apk add --no-cache php$PHP_VERSION-"$module" ; done

RUN mkdir -p /run/$SERVER_TYPE
RUN rm -rf /var/cache/apk/*

ENTRYPOINT ["httpd"]
CMD ["-D", "FOREGROUND"]

