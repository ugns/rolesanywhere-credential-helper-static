FROM docker.io/library/golang:1.27.4-alpine@sha256:70bd7ddea8b6cbe5d6943cde279d6b67feb10cc924fb9100d1d8757c1575b280 AS build
RUN apk add --no-cache git gcc musl-dev binutils
WORKDIR /build
COPY upstream.lock musl-checksums.txt ./
COPY licenses/gcc/ ./licenses/gcc/
COPY scripts/build scripts/verify ./scripts/
RUN sh scripts/build && sh scripts/verify
FROM scratch
COPY --from=build /build/dist/ /dist/
