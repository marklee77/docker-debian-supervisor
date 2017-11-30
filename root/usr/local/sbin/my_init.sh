#!/bin/sh

mkdir -m 1755 -p /tmp/run
mkdir -m 1755 -p /tmp/run/lock

if [ -d /etc/my_init.d ]; then
    find /etc/my_init.d -maxdepth 1 -type f | sort | while read SCRIPT; do
        if [ -x ${SCRIPT} ]; then
            ${SCRIPT}
        else
            /bin/sh ${SCRIPT}
        fi
    done
fi

exec /usr/bin/supervisord -c /etc/supervisord.conf
