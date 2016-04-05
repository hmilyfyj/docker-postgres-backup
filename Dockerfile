FROM postgres
MAINTAINER Benjamin Borbe <bborbe@rocketnews.de>

ENV POSTGRES_HOST localhost
ENV POSTGRES_PORT 5432
ENV POSTGRES_DB postgres
ENV POSTGRES_USER postgres
ENV POSTGRES_PASSWORD S3CR3T

RUN set -x \
    && apt-get update --quiet \
    && apt-get install --quiet --yes --no-install-recommends libdatetime-perl \
    && apt-get clean

ADD cron_postgres /etc/cron.d/postgres
ADD filter_new.pl /usr/local/bin/
ADD backup_postgresql.sh /usr/local/bin/

VOLUME ["/backup"]

ADD entrypoint.sh /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["/usr/sbin/cron","-f","-L","15"]