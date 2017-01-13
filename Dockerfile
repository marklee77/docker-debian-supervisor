FROM alpine:latest
MAINTAINER Mark Stillwell <mark@stillwell.me>

RUN apk add --update --no-cache \
        dcron \
        logrotate \
        supervisor \
        syslog-ng

COPY root/etc/supervisord.conf /etc/
RUN chmod 0644 /etc/supervisord.conf

RUN rm /etc/syslog-ng/*
COPY root/etc/syslog-ng/syslog-ng.conf /etc/syslog-ng/
RUN chmod 0644 /etc/syslog-ng/syslog-ng.conf

RUN rm /etc/logrotate.d/*
COPY root/etc/logrotate.d/syslog-ng /etc/logrotate.d/
RUN chmod 0644 /etc/logrotate.d/syslog-ng

COPY root/usr/local/bin/my_init.sh /usr/local/bin/
RUN chmod 0755 /usr/local/bin/my_init.sh

RUN mkdir -m 0755 -p /etc/my_init.d

CMD ["/usr/local/bin/my_init.sh"]
