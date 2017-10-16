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
        /var/cache/apk/*

RUN mkdir -m 0755 -p /data
VOLUME ["/data"]

RUN mkdir -m 0755 -p /etc/my_init.d

COPY root/usr/local/sbin/my_init.sh /usr/local/sbin/
RUN chmod 0755 /usr/local/sbin/my_init.sh

COPY root/etc/my_init.d/05-ssmtp-setup /etc/my_init.d/
RUN chmod 0755 /etc/my_init.d/05-ssmtp-setup
RUN ln -s /data/ssmtp/ssmtp.conf /etc/ssmtp/ssmtp.conf

COPY root/etc/my_init.d/05-syslog-setup /etc/my_init.d/
RUN chmod 0755 /etc/my_init.d/05-syslog-setup
RUN ln -s /data/syslog-ng/syslog-ng.conf /etc/syslog-ng/syslog-ng.conf

EXPOSE 601

RUN mkdir -m 0755 -p /etc/supervisor/conf.d
COPY root/etc/supervisord.conf /etc/
RUN chmod 0644 /etc/supervisord.conf

CMD ["/usr/local/sbin/my_init.sh"]
