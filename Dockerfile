FROM alpine:3.9 AS node-exporter-builder

COPY --from=golang:1.11-alpine /usr/local/go /usr/local/go

RUN ln -s /usr/local/go/bin/go /usr/local/bin/go \
 && apk add git gcc musl-dev \
 && mkdir -p ~/go/src/github.com/prometheus/node_exporter \
 && git clone -b v0.17.0 https://github.com/prometheus/node_exporter.git ~/go/src/github.com/prometheus/node_exporter \
 && cd ~/go/src/github.com/prometheus/node_exporter \
 && go build

FROM alpine:3.9 AS node-exporter

COPY --from=node-exporter-builder /root/go/src/github.com/prometheus/node_exporter/node_exporter /usr/local/bin/node_exporter

RUN node_exporter --version
