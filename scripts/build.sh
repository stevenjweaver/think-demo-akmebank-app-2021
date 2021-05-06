#!/usr/bin/env bash

set -euo pipefail

export IMG=${ICR_REGISTRY_REGION}.icr.io/${ICR_REGISTRY_NAMESPACE}/account-command-ms
export TAG=${IMAGE_TAG}
cd account-command-ms 
make build
make push
DIGEST="$(docker inspect --format='{{index .RepoDigests 0}}' "${IMG}:${TAG}" | awk -F@ '{print $2}')"
if which save_artifact >/dev/null; then
  save_artifact account-command-ms type=image "name=${IMG}:${TAG}" "digest=${DIGEST}"
fi
cd ..

IMG=${ICR_REGISTRY_REGION}.icr.io/${ICR_REGISTRY_NAMESPACE}/account-query-ms
cd account-query-ms
make build
make push
DIGEST="$(docker inspect --format='{{index .RepoDigests 0}}' "${IMG}:${TAG}" | awk -F@ '{print $2}')"
if which save_artifact >/dev/null; then
  save_artifact account-query-ms type=image "name=${IMG}:${TAG}" "digest=${DIGEST}"
fi
cd ..

IMG=${ICR_REGISTRY_REGION}.icr.io/${ICR_REGISTRY_NAMESPACE}/akmebank-ui
cd akmebank-ui
make build
make push
DIGEST="$(docker inspect --format='{{index .RepoDigests 0}}' "${IMG}:${TAG}" | awk -F@ '{print $2}')"
if which save_artifact >/dev/null; then
  save_artifact akmebank-ui type=image "name=${IMG}:${TAG}" "digest=${DIGEST}"
fi
cd ..
