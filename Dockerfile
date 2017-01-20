FROM ubuntu:xenial
MAINTAINER Mark Stillwell <mark@stillwell.me>

RUN rm -f /etc/cron.*/*

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get -y install --no-install-recommends \
        cron \
        language-pack-en \
        logrotate \
        supervisor \
        syslog-ng-core && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/*

RUN locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8 LC_TYPE=en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_TYPE en_US.UTF-8

RUN rm /etc/logrotate.d/*

RUN rm /etc/supervisor/*
COPY root/etc/supervisor/supervisord.conf /etc/supervisor/
RUN chmod 0644 /etc/supervisor/supervisord.conf

RUN rm /etc/syslog-ng/*
COPY root/etc/syslog-ng/syslog-ng.conf /etc/syslog-ng/
RUN chmod 0644 /etc/syslog-ng/syslog-ng.conf

COPY root/usr/local/bin/my_init.sh /usr/local/bin/
RUN chmod 0755 /usr/local/bin/my_init.sh

RUN mkdir -m 0755 -p /etc/my_init.d

CMD ["/usr/local/bin/my_init.sh"]
