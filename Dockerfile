FROM debian:jessie
MAINTAINER Mark Stillwell <mark@stillwell.me>

RUN rm -f /etc/cron.*/*

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get -y install --no-install-recommends \
        ca-certificates \
        cron \
        locales \
        logrotate \
        ssmtp \
        supervisor \
        syslog-ng-core && \
    rm -rf \
        /etc/cron.daily/{apt,dpkg,passwd} \
        /etc/logrotate.d/* \
        /etc/ssmtp/* \
        /etc/syslog-ng/* \
        /var/lib/apt/lists/* \
        /var/cache/apt/*

RUN mkdir -m 0755 -p /etc/ssl/common

RUN locale-gen C.UTF-8 && update-locale LANG=C.UTF-8
ENV LANG=C.UTF-8

RUN mkdir -m 0755 -p /etc/my_init.d

COPY root/usr/local/sbin/my_init.sh /usr/local/sbin/
RUN chmod 0755 /usr/local/sbin/my_init.sh

COPY root/etc/my_init.d/05-ssmtp-setup /etc/my_init.d/
RUN chmod 0755 /etc/my_init.d/05-ssmtp-setup

COPY root/etc/my_init.d/05-syslog-setup /etc/my_init.d/
RUN chmod 0755 /etc/my_init.d/05-syslog-setup

COPY root/etc/supervisor/supervisord.conf /etc/supervisor/
RUN chmod 0644 /etc/supervisor/supervisord.conf

EXPOSE 601

CMD ["/usr/local/sbin/my_init.sh"]
