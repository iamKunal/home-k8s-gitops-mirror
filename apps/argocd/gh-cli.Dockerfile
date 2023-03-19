FROM debian

ARG VERSION
ENV VERSION=${VERSION:-2.24.3}

RUN apt-get update && apt-get install -y wget && wget https://github.com/cli/cli/releases/download/v${VERSION}/gh_${VERSION}_linux_amd64.deb && apt-get install -y ./gh_${VERSION}_linux_amd64.deb


RUN --mount=type=secret,id=gh_token,dst=/root/.config/gh/hosts.yml,required=true gh extension install cli/gh-webhook

ENTRYPOINT ["gh"]
