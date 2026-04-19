.PHONY: start install build spec validate-docs

install:
	npm install

start:
	hugo server

build:
	hugo

spec:
	@./specs/scripts/generate-cli-spec.sh

validate-docs:
	@./specs/scripts/validate-docs.sh
