SHELL := /bin/bash

.SHELLFLAGS: -ceu

.PHONY: install
install:
	curl -o- -L https://slss.io/install | VERSION=3.8.0 bash
	curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip
	unzip awscliv2.zip
	sudo ./aws/install
	rm -rvf aws*
	git config --local core.hooksPath hooks

.PHONY: configure
configure:
	aws configure

.PHONY: deploy
deploy:
	sls deploy --stage prd --region us-east-1

.PHONY: remove
deploy:
	sls remove
