#!/bin/bash

for_each_line() {
  while IFS= read -r line; do
    printf '%s\n' "$line"
    line=$line "$@"
  done
}

run_gomplate() {
  gomplate -o "${OUTPUT_DIR:-.}"/config.yml
  echo "Applied new homer configuration via gomplate"

}

FIFO_FILE="/tmp/gom${RANDOM}"

mkfifo $FIFO_FILE

kubectl get httpproxies --watch --all-namespaces > $FIFO_FILE &
kubectl get configmap --watch > $FIFO_FILE &

for_each_line run_gomplate < $FIFO_FILE