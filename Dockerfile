FROM alpine:latest
MAINTAINER Mark Stillwell <mark@stillwell.me>

RUN apk add --update --no-cache \
        dcron \
        logrotate \
        ssmtp \
        supervisor \
        syslog-ng

RUN rm /etc/logrotate.d/*

RUN rm /etc/ssmtp/*
COPY root/etc/my_init.d/05-ssmtp-setup /etc/my_init.d/
RUN chmod 0755 /etc/my_init.d/05-ssmtp-setup

COPY root/etc/supervisord.conf /etc/
RUN chmod 0644 /etc/supervisord.conf

RUN rm -rf /etc/syslog-ng/*
COPY root/etc/my_init.d/05-syslog-setup /etc/my_init.d/
RUN chmod 0755 /etc/my_init.d/05-syslog-setup

COPY root/usr/local/bin/my_init.sh /usr/local/bin/
RUN chmod 0755 /usr/local/bin/my_init.sh

RUN mkdir -m 0755 -p /etc/my_init.d /etc/supervisor/conf.d

EXPOSE 601

CMD ["/usr/local/bin/my_init.sh"]
