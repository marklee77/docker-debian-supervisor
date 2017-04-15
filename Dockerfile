FROM debian:jessie
MAINTAINER Mark Stillwell <mark@stillwell.me>

RUN rm -f /etc/cron.*/*

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get -y install --no-install-recommends \
        cron \
        locales \
        logrotate \
        ssmtp \
        supervisor \
        syslog-ng-core && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/* && \
    rm -f /etc/cron.daily/{apt,dpkg,passwd}

RUN locale-gen C.UTF-8 && update-locale LANG=C.UTF-8
ENV LANG=C.UTF-8

RUN rm /etc/logrotate.d/*

RUN rm /etc/ssmtp/*
COPY root/etc/my_init.d/05-ssmtp-setup /etc/my_init.d/
RUN chmod 0755 /etc/my_init.d/05-ssmtp-setup

COPY root/etc/supervisor/supervisord.conf /etc/supervisor/
RUN chmod 0644 /etc/supervisor/supervisord.conf

RUN rm -rf /etc/syslog-ng/*
COPY root/etc/my_init.d/05-syslog-setup /etc/my_init.d/
RUN chmod 0755 /etc/my_init.d/05-syslog-setup

COPY root/usr/local/sbin/my_init.sh /usr/local/sbin/
RUN chmod 0755 /usr/local/sbin/my_init.sh

RUN mkdir -m 0755 -p /etc/my_init.d

EXPOSE 601

CMD ["/usr/local/sbin/my_init.sh"]
