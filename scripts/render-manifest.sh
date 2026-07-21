#!/usr/bin/env bash
set -euo pipefail

: "${APPROVED_IMAGE:?APPROVED_IMAGE must be set}"
: "${APPROVED_VERSION:?APPROVED_VERSION must be set}"

sed \
  -e "s|APPROVED_IMAGE_PLACEHOLDER|${APPROVED_IMAGE}|g" \
  -e "s|APPROVED_VERSION_PLACEHOLDER|${APPROVED_VERSION}|g" \
  kubernetes/deployment.yaml > rendered-deployment.yaml

echo "Rendered Kubernetes Deployment using approved image: ${APPROVED_IMAGE}"
