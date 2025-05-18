# syntax=docker/dockerfile:1.4

ARG TARGETOS
ARG TARGETARCH

FROM quay.io/projectquay/golang:1.24 AS builder

WORKDIR /app
COPY . .

# Build the application
RUN make build

FROM scratch
WORKDIR /
COPY --from=builder /app .
ENTRYPOINT ["/app"]