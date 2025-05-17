# ==== Конфігурація ====
IMAGE_NAME=golang
REGISTRY=quay.io/projectquay

# ==== Платформи ====
LINUX_PLATFORMS=linux_amd64 linux_arm64
MACOS_PLATFORMS=darwin_amd64 darwin_arm64
WINDOWS_PLATFORMS=windows_amd64

ALL_PLATFORMS=$(LINUX_PLATFORMS) $(MACOS_PLATFORMS) $(WINDOWS_PLATFORMS)

# ==== Загальні шаблони ====
define build_target
$(1):
	docker buildx build \
		--platform $(subst _,/,$(1)) \
		--tag $(REGISTRY)/$(IMAGE_NAME):$(1) \
		--build-arg TARGETOS=$(word 1,$(subst _, ,$(1))) \
		--build-arg TARGETARCH=$(word 2,$(subst _, ,$(1))) \
		--load \
		.
endef

$(foreach plat,$(ALL_PLATFORMS),$(eval $(call build_target,$(plat))))

# ==== Групові команди ====
linux: $(LINUX_PLATFORMS)
macos: $(MACOS_PLATFORMS)
windows: $(WINDOWS_PLATFORMS)

all: $(ALL_PLATFORMS)

# ==== Clean ====
clean:
	@for platform in $(ALL_PLATFORMS); do \
		docker rmi $(REGISTRY)/$(IMAGE_NAME):$$platform || true; \
	done
