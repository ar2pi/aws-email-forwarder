SHELL := /bin/bash
.SHELLFLAGS: -ceu

ENVS := dev qa stg prd
env := $(filter $(MAKECMDGOALS), $(ENVS))
ifeq ($(env),)
	env = dev
endif

REGIONS := us-east-1
region := $(filter $(MAKECMDGOALS), $(REGIONS))
ifeq ($(region),)
	region = us-east-1
endif

%:
	@:

.PHONY: install
install:
	curl -o- -L https://slss.io/install | VERSION=3.8.0 bash
	curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip
	unzip awscliv2.zip
	sudo ./aws/install --update
	rm -rf ./aws*
	rm -rf ~/.tfenv && git clone https://github.com/tfutils/tfenv.git ~/.tfenv
	sudo ln -f -s ~/.tfenv/bin/* /usr/local/bin
	tfenv install

.PHONY: init
init:
	git config --local core.hooksPath hooks
# @TODO: use shared sls/tf aws-cli profile instead of default
	aws configure
	@cd terraform && \
	terraform init -reconfigure && \
	for e in $(ENVS); do \
		for r in $(REGIONS); do \
			terraform workspace new $$e-$$r; \
		done; \
	done; \
	terraform workspace select default

.PHONY: fmt
fmt:
	@cd terraform && \
	terraform fmt -recursive -write=true

.PHONY: validate
validate: fmt
	@cd terraform && \
	terraform get && \
	terraform validate

.PHONY: deploy
deploy: validate
	@echo "Deploying $(env)/$(region)"
	@cd terraform && \
	terraform workspace select $(env)-$(region) && \
	terraform apply -auto-approve -var-file=env/$(env)/terraform.tfvars -var-file=env/$(env)/$(region).tfvars
	@cd src && \
	sls deploy --stage $(env) --region $(region)

.PHONY: remove
remove:
	@echo "Removing $(env)/$(region)"
	@cd terraform && \
	terraform apply -destroy -var-file=env/$(env)/terraform.tfvars -var-file=env/$(env)/$(region).tfvars
	@cd src && \
	sls remove --stage $(env) --region $(region)
