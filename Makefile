VERSION ?= latest
REGISTRY ?= docker.io

default: build

clean:
	docker rmi $(REGISTRY)/bborbe/postgres-backup-build:$(VERSION)
	docker rmi $(REGISTRY)/bborbe/postgres-backup:$(VERSION)

checkout:
	git -C sources pull || git clone https://github.com/bborbe/postgres_backup_cron.git sources

setup:
	go get -u github.com/Masterminds/glide
	cd ./go/src/github.com/bborbe/postgres_backup_cron && glide install

buildgo:
	CGO_ENABLED=0 GOOS=linux go build -ldflags "-s" -a -installsuffix cgo -o postgres_backup_cron ./go/src/github.com/bborbe/postgres_backup_cron/bin/postgres_backup_cron

build:
	docker build --build-arg VERSION=$(VERSION) --no-cache --rm=true -t $(REGISTRY)/bborbe/postgres-backup-build:$(VERSION) -f ./Dockerfile.build .
	docker run -t $(REGISTRY)/bborbe/postgres-backup-build:$(VERSION) /bin/true
	docker cp `docker ps -q -n=1 -f ancestor=$(REGISTRY)/bborbe/postgres-backup-build:$(VERSION) -f status=exited`:/postgres_backup_cron .
	docker rm `docker ps -q -n=1 -f ancestor=$(REGISTRY)/bborbe/postgres-backup-build:$(VERSION) -f status=exited`
	docker build --no-cache --rm=true --tag=$(REGISTRY)/bborbe/postgres-backup:$(VERSION) -f Dockerfile.static .
	rm postgres_backup_cron

runpostgres:
	docker kill db || true
	docker rm db || true
	docker run \
	--name db \
	--env POSTGRES_DB=mydb \
	--env POSTGRES_USER=myuser \
	--env POSTGRES_PASSWORD=mypassword \
	--env PGDATA=/var/lib/postgresql/data/pgdata \
	postgres:9.6.1-alpine

run:
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
	$(REGISTRY)/bborbe/postgres-backup:$(VERSION) \
	-logtostderr \
	-v=1

shell:
	docker run -i -t $(REGISTRY)/bborbe/postgres-backup:$(VERSION) /bin/bash

upload:
	docker push $(REGISTRY)/bborbe/postgres-backup:$(VERSION)
