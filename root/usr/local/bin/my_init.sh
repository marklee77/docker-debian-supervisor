#!/bin/sh
if [ -d /etc/my_init.d ]; then
    find /etc/my_init.d -type f -maxdepth 1 | sort | while read SCRIPT; do
        if [ -x ${SCRIPT} ]; then
            ${SCRIPT}
        else
            /bin/sh ${SCRIPT}
        fi
    done
fi

exec /usr/bin/supervisord -c /etc/supervisord.conf
