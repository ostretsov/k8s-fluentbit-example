FROM golang@sha256:cee6f4b901543e8e3f20da3a4f7caac6ea643fd5a46201c3c2387183a332d989 as builder
RUN apk update && apk add --no-cache git ca-certificates tzdata && update-ca-certificates

RUN adduser -D -g '' appuser

WORKDIR $GOPATH/src/log-producer
COPY main.go .

RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-w -s" -a -installsuffix cgo -o /go/bin/log-producer .

###

FROM scratch

COPY --from=builder /usr/share/zoneinfo /usr/share/zoneinfo
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /etc/passwd /etc/passwd

COPY --from=builder /go/bin/log-producer /go/bin/log-producer

USER appuser

ENTRYPOINT ["/go/bin/log-producer"]
