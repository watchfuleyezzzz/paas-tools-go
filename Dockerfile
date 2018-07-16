FROM golang:1.9.6-alpine

ENV PACKAGES "git make zip bash curl tzdata"

RUN apk add --update $PACKAGES && rm -rf /var/cache/apk/*