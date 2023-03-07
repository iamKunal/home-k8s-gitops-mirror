FROM alpine

RUN apk add --no-cache github-cli


RUN --mount=type=secret,id=gh_token,dst=/root/.config/gh/hosts.yml,required=true gh extension install cli/gh-webhook

ENTRYPOINT ["gh"]