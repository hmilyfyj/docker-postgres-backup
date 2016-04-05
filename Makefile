default: build

clean:
	docker rmi bborbe/postgres-backup

build:
	docker build --no-cache --rm=true -t bborbe/postgres-backup .

run:
	docker run -v /tmp:/backup bborbe/postgres-backup:latest

shell:
	docker run -i -t bborbe/postgres-backup:latest /bin/bash

upload:
	docker push bborbe/postgres-backup
