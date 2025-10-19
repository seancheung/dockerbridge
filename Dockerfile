FROM alpine:3.6
LABEL maintainer="Sean Cheung <theoxuanx@gmail.com>"

RUN set -ex \
    && echo "Install Dependencies..." \
    && apk add --update --no-cache nginx nginx-mod-stream bash  \
    && mkdir -p /etc/nginx/http /etc/nginx/stream /run/nginx \
    && rm /etc/nginx/conf.d/default.conf

COPY nginx/*.conf /etc/nginx/
COPY entrypoint.sh /entrypoint.sh

VOLUME ["/etc/nginx/http", "/etc/nginx/stream", "/var/log/nginx"]

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/sbin/nginx", "-g", "daemon off;"]