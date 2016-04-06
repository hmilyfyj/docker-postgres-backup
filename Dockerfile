FROM postgres
MAINTAINER Benjamin Borbe <bborbe@rocketnews.de>

ENV POSTGRES_HOST localhost
ENV POSTGRES_PORT 5432
ENV POSTGRES_DB postgres
ENV POSTGRES_USER postgres
ENV POSTGRES_PASSWORD S3CR3T

RUN set -x \
	&& apt-get update --quiet \
	&& apt-get upgrade --quiet --yes \
	&& apt-get install --quiet --yes --no-install-recommends libdatetime-perl \
	&& apt-get autoremove --yes \
	&& apt-get clean

ADD filter_new.pl /usr/local/bin/
ADD backup_postgresql.sh /usr/local/bin/
ADD postgres-cron /etc/cron.d/postgres-cron
ADD hello-cron /etc/cron.d/hello-cron

VOLUME ["/backup"]

ADD entrypoint.sh /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

RUN chmod 644 /etc/cron.d/*
RUN touch /var/log/cron.log

CMD ["/bin/sh","-c","/usr/sbin/cron -L 15 && tail -F /var/log/cron.log"]