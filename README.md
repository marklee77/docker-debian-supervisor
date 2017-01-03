marklee77/supervisor
====================

This docker image is intended to be a base for containers that run multiple
services. It first runs any setup scripts placed in /etc/my_init.d, then starts
up supervisor, along with syslog-ng and cron. Additional supervisor config
files can be placed in /etc/supervisor/conf.d. For an example image see
marklee77/slapd.

This work was inspired by phusion/baseimage, but is hopefully simpler and users
supervisor in place of runit.

author
======

Mark Stillwell <mark@stillwell.me>
