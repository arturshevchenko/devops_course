# Параметри
IMAGE_NAME=test-app
REGISTRY=quay.io/your-org
PLATFORMS=linux/amd64 linux/arm64 darwin/amd64 darwin/arm64 windows/amd64

# Build for selected platform
define make_build_target
$(1):
	docker buildx build \
		--platform $(subst _,/,$(1)) \
		--tag $(REGISTRY)/$(IMAGE_NAME):$(1) \
		--build-arg TARGETOS=$(word 1,$(subst _, ,$(1))) \
		--build-arg TARGETARCH=$(word 2,$(subst _, ,$(1))) \
		--output type=docker \
		.
endef

# Генеруємо цілі (наприклад, make linux_amd64)
$(foreach plat,$(subst /,_,${PLATFORMS}),$(eval $(call make_build_target,$(plat))))

# Clean – видалення образів
clean:
	@for platform in $(subst /,_,${PLATFORMS}); do \
		docker rmi $(REGISTRY)/$(IMAGE_NAME):$$platform || true; \
	done
