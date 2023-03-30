#!/usr/bin/env zsh

pushd cluster-setup/tcp-forwarding || exit

gomplate && docker run -it -d --restart on-failure --name nginx-k3d-mirror --net=host -v "$PWD/nginx.conf":/etc/nginx/nginx.conf:ro nginx

popd