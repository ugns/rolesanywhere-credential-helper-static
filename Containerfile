FROM docker.io/library/golang:1.27.3-alpine AS build
RUN apk add --no-cache git gcc musl-dev binutils
WORKDIR /build
COPY VERSION UPSTREAM_COMMIT ./
COPY scripts/build scripts/verify ./scripts/
RUN sh scripts/build && sh scripts/verify
FROM scratch
COPY --from=build /build/dist/ /dist/
