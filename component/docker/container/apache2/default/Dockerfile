FROM alpine:3.6

LABEL maintainer="Skyflow Team - Franck Diomandé <fkdiomande@gmail.com>"

ARG APPLICATION_NAME={{ application.name }}
ARG SERVER_NAME={{ server.name }}
ARG SERVER_ADMIN={{ server.admin }}
ARG DIRECTORY_INDEX={{ directory.index }}
ARG DOCUMENT_ROOT=/var/www/$APPLICATION_NAME/{{ document.root }}
ARG SERVER_TYPE={{ server.type }}

ENV APPLICATION_NAME ${APPLICATION_NAME}
ENV SERVER_NAME ${SERVER_NAME}
ENV SERVER_ADMIN ${SERVER_ADMIN}
ENV DIRECTORY_INDEX ${DIRECTORY_INDEX}
ENV DOCUMENT_ROOT ${DOCUMENT_ROOT}
ENV SERVER_TYPE ${SERVER_TYPE}

WORKDIR /var/www/$APPLICATION_NAME

RUN apk add --no-cache $SERVER_TYPE

RUN mkdir -p /run/$SERVER_TYPE
RUN rm -rf /var/cache/apk/*

ENTRYPOINT ["httpd"]
CMD ["-D", "FOREGROUND"]

