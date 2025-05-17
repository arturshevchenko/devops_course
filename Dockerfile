# syntax=docker/dockerfile:1.4
ARG TARGETOS
ARG TARGETARCH

FROM quay.io/projectquay/golang:1.21 AS builder

WORKDIR /app
COPY . .

RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -o app

FROM quay.io/projectquay/golang:1.21

WORKDIR /app
COPY --from=builder /app/app .

COPY . .

CMD ["go", "test", "./..."]
