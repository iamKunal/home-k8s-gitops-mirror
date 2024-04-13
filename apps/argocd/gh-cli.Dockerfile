FROM debian

ARG VERSION
ENV VERSION=${VERSION:-2.39.1}

RUN apt-get update && apt-get install -y wget jq && wget https://github.com/cli/cli/releases/download/v${VERSION}/gh_${VERSION}_linux_amd64.deb && apt-get install -y ./gh_${VERSION}_linux_amd64.deb


RUN --mount=type=secret,id=gh_token,dst=/root/.config/gh/hosts.yml,required=true gh extension install cli/gh-webhook

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
