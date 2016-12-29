VERSION ?= 1.0.0

default: build

clean:
	docker rmi bborbe/postgres-backup-build:$(VERSION)
	docker rmi bborbe/postgres-backup:$(VERSION)

setup:
	mkdir -p ./go/src/github.com/bborbe/postgres_backup_cron
	git clone https://github.com/bborbe/postgres_backup_cron.git ./go/src/github.com/bborbe/postgres_backup_cron
	go get -u github.com/Masterminds/glide
	cd ./go/src/github.com/bborbe/postgres_backup_cron && glide install

buildgo:
	CGO_ENABLED=0 GOOS=linux go build -ldflags "-s" -a -installsuffix cgo -o postgres_backup_cron ./go/src/github.com/bborbe/postgres_backup_cron/bin/postgres_backup_cron

build:
	docker build --build-arg VERSION=$(VERSION) --no-cache --rm=true -t bborbe/postgres-backup-build:$(VERSION) -f ./Dockerfile.build .
	docker run -t bborbe/postgres-backup-build:$(VERSION) /bin/true
	docker cp `docker ps -q -n=1 -f ancestor=bborbe/postgres-backup-build:$(VERSION) -f status=exited`:/postgres_backup_cron .
	docker rm `docker ps -q -n=1 -f ancestor=bborbe/postgres-backup-build:$(VERSION) -f status=exited`
	docker build --no-cache --rm=true --tag=bborbe/postgres-backup:$(VERSION) -f Dockerfile.static .
	rm postgres_backup_cron

run:
	docker run -e LOGLEVEL=debug bborbe/postgres-backup:$(VERSION)

shell:
	docker run -i -t bborbe/postgres-backup:$(VERSION) /bin/bash

upload:
	docker push bborbe/postgres-backup:$(VERSION)
