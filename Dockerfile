# syntax=docker/dockerfile:1.4

ARG TARGETOS
ARG TARGETARCH

FROM quay.io/projectquay/golang:1.21 AS build

WORKDIR /app
COPY . .

RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -o /out/app

FROM scratch
COPY --from=build /out/app /app
ENTRYPOINT ["/app"]
