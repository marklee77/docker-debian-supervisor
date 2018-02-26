FROM debian:stretch-slim
LABEL maintainer="Mark Stillwell <mark@stillwell.me>"

RUN rm -f /etc/cron.*/*

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get -y install --no-install-recommends \
        cron \
        locales \
        ssmtp \
        supervisor \
        syslog-ng-core && \
    rm -rf \
        /etc/cron.daily/{apt,dpkg,passwd} \
        /etc/ssmtp/* \
        /etc/syslog-ng/* \
        /var/cache/apt/* \
        /var/lib/apt/lists/*

RUN locale-gen C.UTF-8 && update-locale LANG=C.UTF-8
ENV LANG=C.UTF-8

RUN mkdir -m 0755 -p /etc/my_init.d /usr/local/share/my_init
COPY root/usr/local/share/my_init/functions.sh /usr/local/share/my_init/
COPY root/usr/local/sbin/my_init.sh /usr/local/sbin/
RUN chmod 0755 /usr/local/sbin/my_init.sh /usr/local/share/my_init/functions.sh
CMD ["/usr/local/sbin/my_init.sh"]

COPY root/etc/supervisor/supervisord.conf /etc/supervisor/
RUN chmod 0644 /etc/supervisor/supervisord.conf

COPY root/etc/my_init.d/05-ssmtp-setup /etc/my_init.d/
RUN chmod 0755 /etc/my_init.d/05-ssmtp-setup

COPY root/etc/my_init.d/05-syslog-setup /etc/my_init.d/
RUN chmod 0755 /etc/my_init.d/05-syslog-setup
