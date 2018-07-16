FROM golang:1.9.4-alpine

ENV PACKAGES "git"

RUN apk add --update $PACKAGES && rm -rf /var/cache/apk/*