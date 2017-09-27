FROM alpine:latest
MAINTAINER Mark Stillwell <mark@stillwell.me>

RUN apk add --update-cache --no-cache \
        dcron \
        logrotate \
        ssmtp \
        supervisor \
        syslog-ng && \
    rm -rf \
        /etc/logrotate.d/* \
        /etc/ssmtp/* \
        /etc/syslog-ng/* \
        /var/cache/apk/* \
        /var/log/*

COPY root/usr/local/sbin/my_init.sh /usr/local/sbin/
RUN chmod 0755 /usr/local/sbin/my_init.sh

COPY root/etc/supervisord.conf /etc/
RUN chmod 0644 /etc/supervisord.conf

RUN mkdir -m 0755 -p /etc/my_init.d /etc/supervisor/conf.d

COPY root/etc/my_init.d/05-ssmtp-setup /etc/my_init.d/
RUN chmod 0755 /etc/my_init.d/05-ssmtp-setup

COPY root/etc/my_init.d/05-syslog-setup /etc/my_init.d/
RUN chmod 0755 /etc/my_init.d/05-syslog-setup

EXPOSE 601

CMD ["/usr/local/sbin/my_init.sh"]
