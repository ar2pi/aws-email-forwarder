SHELL := /bin/bash
.SHELLFLAGS: -ceu

ENVS := dev qa stg prd
.PHONY: $(ENVS)
$(ENVS):
	@:

env := $(filter $(MAKECMDGOALS), $(ENVS))
ifeq ($(env),)
	env = dev
endif

.PHONY: install
install:
	curl -o- -L https://slss.io/install | VERSION=3.8.0 bash
	curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip
	unzip awscliv2.zip
	sudo ./aws/install --update
	rm -rv ./aws*
	curl https://releases.hashicorp.com/terraform/1.1.7/terraform_1.1.7_linux_amd64.zip -o terraform.zip
	unzip terraform.zip
	sudo mv terraform /usr/local/bin
	rm -rv ./terraform*
	git config --local core.hooksPath hooks

.PHONY: configure
configure:
	aws configure

.PHONY: deploy
deploy:
	@echo "Deploying $(env)"
	@cd src && \
	sls deploy --stage $(env) --region us-east-1

.PHONY: remove
remove:
	@echo "Removing $(env)"
	@cd src && \
	sls remove --stage $(env) --region us-east-1
