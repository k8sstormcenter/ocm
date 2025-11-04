REGISTRY ?= ghcr.io/k8sstormcenter/ocm

.PHONY: print-registry
print-registry: ## Print the registry URL
	@echo $(REGISTRY)

## OCM

OCM_VERSION_RAW=$(shell git describe --tags --always --dirty --match 'ocm-*')
OCM_VERSION=$(patsubst ocm-%,%,$(OCM_VERSION_RAW))

print-ocm-version: ## Print the OCM version
	@# @echo $(OCM_VERSION)	
	@cat .VERSION

.PHONY: ocm-package
ocm-package:
	@echo "Processing OCM component-constructor.yaml files..."
	@find . -name "component-constructor.yaml" -type f | while read -r file; do \
		echo "Processing $$file..."; \
		dir=$$(dirname "$$file"); \
		(cd "$$dir" && rm -rf ./ctf && ocm add components --create --file ./ctf ./component-constructor.yaml artifactVersion=$(OCM_VERSION)) || echo "Failed to process $$file"; \
	done
	@echo "OCM package processing complete."

.PHONY: ocm-transfer
ocm-transfer:
	@echo "Start transfer of OCM CTF to $(REGISTRY)..."
	@find . -name "component-constructor.yaml" -type f | while read -r file; do \
		dir=$$(dirname "$$file"); \
		echo " $$dir/ctf/"; \
		(cd "$$dir" && ocm transfer ctf --overwrite ./ctf $(REGISTRY) --enforce) || echo "Failed to process $$file"; \
	done
	@echo "OCM package transfer completed."
