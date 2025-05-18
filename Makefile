IMAGE_NAME=golang
REGISTRY=quay.io/projectquay
BUILDX=buildx

PLATFORMS=linux_amd64 linux_arm64 darwin_amd64 darwin_arm64 windows_amd64

.PHONY: all clean $(PLATFORMS) init-module

init-module:
	@if [ ! -f go.mod ]; then \
		go mod init devops_course && \
		go mod tidy; \
	fi

build: init-module
	CGO_ENABLED=0 go build -o app .

define PLATFORM_template
$(1):
	docker buildx build \
		--platform $(subst _,/,$(1)) \
		--build-arg TARGETOS=$(word 1,$(subst _, ,$(1))) \
		--build-arg TARGETARCH=$(word 2,$(subst _, ,$(1))) \
		--output type=docker \
		--tag $(REGISTRY)/test-app:$(1) \
		.
endef

$(foreach plat,$(PLATFORMS),$(eval $(call PLATFORM_template,$(plat))))

all: $(PLATFORMS)

image:
	docker buildx build \
		--platform linux/amd64 \
		--build-arg TARGETOS=linux \
		--build-arg TARGETARCH=amd64 \
		--output type=docker \
		--tag quay.io/projectquay/test-app:linux_amd64 \
		.

clean:
	@for platform in $(PLATFORMS); do \
		docker rmi $(REGISTRY)/test-app:$$platform || true; \
	done