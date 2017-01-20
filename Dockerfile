FROM alpine:latest
MAINTAINER Mark Stillwell <mark@stillwell.me>

RUN apk add --update --no-cache \
        dcron \
        logrotate \
        supervisor \
        syslog-ng

RUN rm /etc/logrotate.d/*

COPY root/etc/supervisord.conf /etc/
RUN chmod 0644 /etc/supervisord.conf

RUN rm /etc/syslog-ng/*
COPY root/etc/syslog-ng/syslog-ng.conf /etc/syslog-ng/
RUN chmod 0644 /etc/syslog-ng/syslog-ng.conf

COPY root/usr/local/bin/my_init.sh /usr/local/bin/
RUN chmod 0755 /usr/local/bin/my_init.sh

RUN mkdir -m 0755 -p /etc/my_init.d /etc/supervisor.d

CMD ["/usr/local/bin/my_init.sh"]
