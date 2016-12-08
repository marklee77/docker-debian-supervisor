FROM debian:jessie
MAINTAINER Mark Stillwell <mark@stillwell.me>

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get -y install apt-utils supervisor && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/*

COPY supervisord.conf /etc/supervisor/supervisord.conf
COPY my_init.sh /usr/local/bin/my_init.sh
RUN chmod 755 /usr/local/bin/my_init.sh

RUN mkdir -p /etc/my_init.d /var/log/supervisor

CMD ["/usr/local/bin/my_init.sh"]
