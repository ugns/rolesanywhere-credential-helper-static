FROM docker.io/library/golang:1.27.3-alpine@sha256:fa3d596898d9f126af7c01d14ee7597bab3f39cccf392ef36b69fe77cd681f18 AS build
RUN apk add --no-cache git gcc musl-dev binutils
WORKDIR /build
COPY upstream.lock musl-checksums.txt ./
COPY scripts/build scripts/verify ./scripts/
RUN sh scripts/build && sh scripts/verify
FROM scratch
COPY --from=build /build/dist/ /dist/
