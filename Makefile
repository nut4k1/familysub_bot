# use it

APP_PWD=$$(pwd)

build-api:
	docker build -t familysub_bot .

run-api:
	docker run -it -v ${APP_PWD}:/familysub_bot familysub_bot bash