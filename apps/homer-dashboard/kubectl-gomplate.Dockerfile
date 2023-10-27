FROM bitnami/kubectl as kubectl

FROM hairyhenderson/gomplate:alpine

COPY --from=kubectl /opt/bitnami/kubectl/bin/kubectl /usr/local/bin/

RUN apk add --no-cache bash
