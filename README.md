# Postgresql Backup

## Start Postgres

```
docker run \
--name db \
--env POSTGRES_DB=mydb \
--env POSTGRES_USER=myuser \
--env POSTGRES_PASSWORD=mypassword \
--env PGDATA=/var/lib/postgresql/data/pgdata \
postgres:9.6.1-alpine
```

## Backup once

```
docker run \
--env HOST=db \
--env PORT=5432 \
--env DATABASE=mydb \
--env USERNAME=myuser \
--env PASSWORD=mypassword \
--env ONE_TIME=true \
--env LOCK=/postgres_backup_cron.lock \
--env TARGETDIR=/backup \
--volume /tmp:/backup \
--link db:db \
bborbe/postgres-backup:latest \
-logtostderr \
-v=1
```

`ls /tmp/postgres_mydb_*.dump`

## Backup every hour

```
docker run \
--env HOST=db \
--env PORT=5432 \
--env DATABASE=mydb \
--env USERNAME=myuser \
--env PASSWORD=mypassword \
--env WAIT=1h \
--env ONE_TIME=false \
--env LOCK=/postgres_backup_cron.lock \
--env TARGETDIR=/backup \
--volume /tmp:/backup \
--link db:db \
bborbe/postgres-backup:latest \
-logtostderr \
-v=1
```

`ls /tmp/postgres_mydb_*.dump`

## Copyright and license

    Copyright (c) 2016, Benjamin Borbe <bborbe@rocketnews.de>
    All rights reserved.
    
    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions are
    met:
    
       * Redistributions of source code must retain the above copyright
         notice, this list of conditions and the following disclaimer.
       * Redistributions in binary form must reproduce the above
         copyright notice, this list of conditions and the following
         disclaimer in the documentation and/or other materials provided
         with the distribution.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
    "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
    LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
    A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
    OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
    SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
    LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
    DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
    THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
    (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
    OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
