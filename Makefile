# using the chart name and version from chart's metadata
CHART_NAME ?= $(shell awk '/^name:/ { print $$2 }' Chart.yaml)
CHART_VERSION ?= $(shell awk '/^version:/ { print $$2 }' Chart.yaml)

# release directory where the Tekton resources are rendered into.
RELEASE_DIR ?= /tmp/$(CHART_NAME)-$(CHART_VERSION)

# bats entry point and default flags
BATS_CORE = ./test/.bats/bats-core/bin/bats
BATS_FLAGS ?= --print-output-on-failure --show-output-of-passing-tests --verbose-run

# path to the bats test files, overwite the variables below to tweak the test scope
INTEGRATION_TESTS ?= ./test/integration/*.bats
E2E_TESTS ?= ./test/e2e/*.bats

# generic arguments employed on most of the targets
ARGS ?=

# making sure the variables declared in the Makefile are exported to the excutables/scripts invoked
# on all targets
.EXPORT_ALL_VARIABLES:

# uses helm to render the resource templates to the stdout
define render-template
	@helm template $(ARGS) $(CHART_NAME) .
endef

# renders the task resource file printing it out on the standard output
helm-template:
	$(call render-template)

# renders and installs the resources (task)
install:
	$(call render-template) |kubectl $(ARGS) apply -f -

# pepare a release
prepare-release:
	mkdir -p $(RELEASE_DIR)/task/$(CHART_NAME) || true
	helm template $(ARGS) . > $(RELEASE_DIR)/task/$(CHART_NAME)/$(CHART_NAME).yaml
	cp README.md $(RELEASE_DIR)/task/$(CHART_NAME)/
	go run github.com/openshift-pipelines/tektoncd-catalog/cmd/catalog-cd@main release --output release --version $(CHART_VERSION) $(RELEASE_DIR)/task/$(CHART_NAME)
	@echo "Now you can release:"
	@echo "  git tag v$(CHART_VERSION) && git push v$(CHART_VERSION)"
	@echo "  gh release create v$(CHART_VERSION) --generate-notes"
	@echo "  gh release upload v$(CHART_VERSION) release/catalog.yaml"
	@echo "  gh release upload v$(CHART_VERSION) release/resources.tar.gz"

# packages the helm-chart as a single tarball, using it's name and version to compose the file
helm-package: clean
	helm package $(ARGS) .
	tar -ztvpf $(CHART_NAME)-$(CHART_VESION).tgz

# removes the package helm chart, and also the chart-releaser temporary directories
clean:
	rm -rf $(CHART_NAME)-*.tgz > /dev/null 2>&1 || true

# run the integration tests, does not require a kubernetes instance
test-integration:
	$(BATS_CORE) $(BATS_FLAGS) $(ARGS) $(INTEGRATION_TESTS)

# run end-to-end tests against the current kuberentes context, it will required a cluster with tekton
# pipelines and other requirements installed, before start testing the target invokes the
# installation of the current project's task (using helm).
test-e2e: install
	$(BATS_CORE) $(BATS_FLAGS) $(ARGS) $(E2E_TESTS)

# Run all the end-to-end tests against the current openshift context.
# It is used mainly by the CI and ideally shouldn't differ that much from test-e2e
.PHONY: prepare-e2e-openshift
prepare-e2e-openshift:
	./hack/install-osp.sh $(OSP_VERSION)
.PHONY: test-e2e-openshift
test-e2e-openshift: prepare-e2e-openshift
test-e2e-openshift: test-e2e

# act runs the github actions workflows, so by default only running the test workflow (integration
# and end-to-end) to avoid running the release workflow accidently
act: ARGS = --workflows=./.github/workflows/test.yaml
act:
	act $(ARGS)
