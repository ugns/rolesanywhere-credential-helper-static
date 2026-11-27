ENGINE ?= podman
.PHONY: build
build:
	$(ENGINE) build -t rolesanywhere-static-build -f Containerfile .
	@set -eu; cid=$$($(ENGINE) create rolesanywhere-static-build /unused); \
	trap '$(ENGINE) rm "$$cid" >/dev/null' EXIT; \
	mkdir -p dist; $(ENGINE) cp "$$cid:/dist/." dist/
