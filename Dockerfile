FROM golang:1.21.0-alpine3.18 as builder
MAINTAINER xtaci <daniel820313@gmail.com>
ENV GO111MODULE=on
RUN apk add git
COPY ./ /repos
RUN <<EOT
set -eux
git clone /repos kcptun
cd kcptun

VERSION=v20230811
go build -mod=vendor -ldflags "-X main.VERSION=v20230811 -s -w" -o /client github.com/xtaci/kcptun/client
go build -mod=vendor -ldflags "-X main.VERSION=v20230811 -s -w" -o /server github.com/xtaci/kcptun/server
EOT

FROM alpine:3.18
RUN apk add --no-cache iptables tzdata
COPY --from=builder /client /bin
COPY --from=builder /server /bin
EXPOSE 29900/udp
EXPOSE 12948
