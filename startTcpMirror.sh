#!/usr/bin/env zsh

pushd cluster-setup/tcp-forwarding || exit

gomplate && docker run -it -d --restart on-failure --name nginx-kind-mirror --net=host -v "$PWD/nginx.conf":/etc/nginx/nginx.conf:ro nginx

popd