FROM armv7/armhf-ubuntu:15.10

RUN apt-get install -y postgresql

EXPOSE 5432

CMD \
    pg_createcluster -u 0 `ls /etc/postgresql` main && \
    service postgresql start && \
    tail -f -n 50 /var/log/postgresql/postgresql-`ls /etc/postgresql`-main.log \
    || \
    service postgresql start && \
    tail -f -n 50 /var/log/postgresql/postgresql-`ls /etc/postgresql`-main.log
