SHELL := /bin/bash
.SHELLFLAGS: -ceu

ENVS := dev qa stg prd
env := $(filter $(MAKECMDGOALS), $(ENVS))
ifeq ($(env),)
	env = dev
endif

REGIONS := us-east-2
region := $(filter $(MAKECMDGOALS), $(REGIONS))
ifeq ($(region),)
	region = us-east-2
endif

%:
	@:

.PHONY: install
install:
	curl -o- -L https://slss.io/install | VERSION=3.15.2 bash
	curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip
	unzip awscliv2.zip
	sudo ./aws/install --update
	rm -rf ./aws*
	rm -rf ~/.tfenv && git clone https://github.com/tfutils/tfenv.git ~/.tfenv
	sudo ln -f -s ~/.tfenv/bin/* /usr/local/bin
	tfenv install

.PHONY: install-macos
install-macos:
	curl -o- -L https://slss.io/install | VERSION=3.15.2 bash
	curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o AWSCLIV2.pkg
	sudo installer -pkg ./AWSCLIV2.pkg -target /
	rm -rf ./AWS*
	rm -rf ~/.tfenv && git clone https://github.com/tfutils/tfenv.git ~/.tfenv
	sudo ln -f -s ~/.tfenv/bin/* /usr/local/bin
	tfenv install

.PHONY: init
init:
	git config --local core.hooksPath hooks
# @TODO: use shared sls/tf aws-cli profile instead of default
	aws configure
	@cd terraform && \
	terraform init && \
	for e in $(ENVS); do \
		for r in $(REGIONS); do \
			terraform workspace new $$e-$$r; \
		done; \
	done; \
	terraform workspace select default

.PHONY: deploy-tf-state-backend
deploy-tf-state-backend:
	@cd terraform && \
	terraform plan -target=module.tfstate_backend -out=tfstate_backend.tfplan && \
	terraform apply -auto-approve tfstate_backend.tfplan && \
	rm tfstate_backend.tfplan
	@echo "Edit terraform backend to include the newly created state backend, then run 'make migrate-tf-state' before 'make deploy'"

.PHONY: migrate-tf-state
migrate-tf-state:
	@cd terraform && \
	terraform init -migrate-state && \
	rm -rf *tfstate*
	@echo "You can now run 'make deploy'"

.PHONY: fmt-tf
fmt-tf:
	@cd terraform && \
	terraform fmt -recursive -write=true

.PHONY: validate-tf
validate-tf:
	@cd terraform && \
	terraform get && \
	terraform validate

.PHONY: plan-tf
plan-tf: fmt-tf validate-tf
	@echo "Plan output for $(env)/$(region)"
	@cd terraform && \
	terraform workspace select $(env)-$(region) && \
	terraform plan -var-file=env/$(env)/terraform.tfvars -var-file=env/$(env)/$(region).tfvars

.PHONY: deploy-tf
deploy-tf: fmt-tf validate-tf
	@echo "Deploying $(env)/$(region)"
	@cd terraform && \
	terraform workspace select $(env)-$(region) && \
	terraform apply -auto-approve -var-file=env/$(env)/terraform.tfvars -var-file=env/$(env)/$(region).tfvars

.PHONY: deploy-sls
deploy-sls:
	@cd serverless && \
	sls deploy --stage $(env) --region $(region)

.PHONY: deploy
deploy: deploy-tf deploy-sls

.PHONY: remove-tf
remove-tf:
	@echo "Removing $(env)/$(region)"
	@cd terraform && \
	terraform apply -destroy -var-file=env/$(env)/terraform.tfvars -var-file=env/$(env)/$(region).tfvars

.PHONY: remove-sls
remove-sls:
	@cd serverless && \
	sls remove --stage $(env) --region $(region)

.PHONY: remove
remove: remove-tf remove-sls
