FROM eljenso/ansible_playbook
MAINTAINER Jonathan Diehl

COPY run ansible .

RUN chmod 600 config/ssh/*

ENTRYPOINT ["/bin/sh", "run"]
