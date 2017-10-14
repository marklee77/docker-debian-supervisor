#!/bin/sh

log_dir=/var/log
[ -L "$log_dir" ] && log_dir="$(readlink "$log_dir")"
[ -d "$log_dir" ] || mkdir -m 0755 -p "$log_dir"

if [ -d /etc/my_init.d ]; then
    find /etc/my_init.d -type f -maxdepth 1 | sort | while read SCRIPT; do
        if [ -x ${SCRIPT} ]; then
            ${SCRIPT}
        else
            /bin/sh ${SCRIPT}
        fi
    done
fi

exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
