FROM hairyhenderson/gomplate:alpine

RUN apk add --repository "https://dl-cdn.alpinelinux.org/alpine/edge/testing" --no-cache kubectl bash