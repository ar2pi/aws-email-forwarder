SHELL := /bin/bash

.SHELLFLAGS: -ceu

.PHONY: install
install:
	curl -o- -L https://slss.io/install | VERSION=3.8.0 bash
	git config --local core.hooksPath hooks

# .PHONY: build
# build:
# 	mkdocs build

# .PHONY: serve
# serve:
# 	mkdocs serve

# .PHONY: deploy
# deploy:
# 	cd $(GH_PAGE) && mkdocs gh-deploy --config-file ../mkdocs.yml --remote-branch main

# .PHONY: update-build-version
# update-build-version:
# 	git submodule update --remote --checkout
# 	git add $(GH_PAGE)
# 	git -c user.name="🤖" -c user.email="bot@ar2pi.net" commit --author "🤖 <bot@ar2pi.net>" -m "ci: update build version"

# .PHONY: publish
# publish: deploy update-build-version
# 	git push --no-verify
