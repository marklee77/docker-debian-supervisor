FROM debian:jessie
MAINTAINER Mark Stillwell <mark@stillwell.me>

RUN rm -f /etc/cron.*/*

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get -y install --no-install-recommends \
        cron \
        locales \
        logrotate \
        supervisor \
        syslog-ng-core && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/* && \
    rm -f /etc/cron.daily/{apt,dpkg,passwd}

RUN locale-gen C.UTF-8 && update-locale LANG=C.UTF-8
ENV LANG=C.UTF-8

COPY supervisord.conf /etc/supervisor/supervisord.conf
COPY my_init.sh /usr/local/bin/my_init.sh
RUN chmod 755 /usr/local/bin/my_init.sh
RUN mkdir -p /etc/my_init.d /var/log/supervisor

COPY syslog-ng.conf /etc/syslog-ng/syslog-ng.conf
COPY logrotate_syslog-ng /etc/logrotate.d/syslog-ng

VOLUME ["/var/log/supervisor"]
CMD ["/usr/local/bin/my_init.sh"]
