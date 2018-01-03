FROM ubuntu:xenial
LABEL maintainer="Mark Stillwell <mark@stillwell.me>"

RUN rm -f /etc/cron.*/*

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get -y install --no-install-recommends \
        cron \
        language-pack-en \
        ssmtp \
        supervisor \
        syslog-ng-core && \
    rm -rf \
        /etc/ssmtp/* \
        /etc/syslog-ng/* \
        /var/cache/apt/* \
        /var/lib/apt/lists/*

RUN mkdir -m 0755 -p /data && \
    rm -rf /run /var/run && \
    ln -s /run /var/run && \
    ln -s /tmp/run /run
VOLUME ["/data", "/tmp"]

RUN locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8 LC_TYPE=en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_TYPE en_US.UTF-8

COPY root/etc/supervisor/supervisord.conf /etc/supervisor/
RUN chmod 0644 /etc/supervisor/supervisord.conf

RUN mkdir -m 0755 -p /etc/my_init.d /usr/local/share/my_init

COPY root/etc/my_init.d/05-ssmtp-setup /etc/my_init.d/
RUN chmod 0755 /etc/my_init.d/05-ssmtp-setup
RUN ln -s /data/ssmtp/ssmtp.conf /etc/ssmtp/ssmtp.conf

COPY root/etc/my_init.d/05-syslog-setup /etc/my_init.d/
RUN chmod 0755 /etc/my_init.d/05-syslog-setup
RUN ln -s /data/syslog-ng/syslog-ng.conf /etc/syslog-ng/syslog-ng.conf
RUN rm -rf /var/lib/syslog-ng && \
    ln -s /tmp/syslog-ng /var/lib/syslog-ng
EXPOSE 601

COPY root/usr/local/share/my_init/functions.sh /usr/local/share/my_init/
COPY root/usr/local/sbin/my_init.sh /usr/local/sbin/
RUN chmod 0755 /usr/local/sbin/my_init.sh /usr/local/share/my_init/functions.sh
CMD ["/usr/local/sbin/my_init.sh"]
