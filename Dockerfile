# syntax=docker/dockerfile:1.4

ARG TARGETOS
ARG TARGETARCH

FROM quay.io/projectquay/golang:1.24 AS builder

WORKDIR /app
COPY go.mod .
COPY main.go .
# COPY . .

# Build the application
# RUN make build
RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -o app .

FROM scratch
WORKDIR /
COPY --from=builder /app .
ENTRYPOINT ["/app"]