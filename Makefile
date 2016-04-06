default: build

clean:
	docker rmi bborbe/postgres-backup-build
	docker rmi bborbe/postgres-backup

setup:
	go get github.com/bborbe/postgres_backup_cron/bin/postgres_backup_cron

buildgo:
	CGO_ENABLED=0 GOOS=linux go build -ldflags "-s" -a -installsuffix cgo -o postgres_backup_cron ./go/src/github.com/bborbe/postgres_backup_cron/bin/postgres_backup_cron

build:
	docker build --no-cache --rm=true -t bborbe/postgres-backup-build -f ./Dockerfile.build .
	docker run -t bborbe/postgres-backup-build /bin/true
	docker cp `docker ps -q -n=1 -f ancestor=bborbe/postgres-backup-build -f status=exited`:/postgres_backup_cron .
	docker rm `docker ps -q -n=1 -f ancestor=bborbe/postgres-backup-build -f status=exited`
	docker build --no-cache --rm=true --tag=bborbe/postgres-backup -f Dockerfile.static .
	rm postgres_backup_cron

run:
	docker run bborbe/postgres-backup

shell:
	docker run -i -t bborbe/postgres-backup:latest /bin/bash

upload:
	docker push bborbe/postgres-backup
