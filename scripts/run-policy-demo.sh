#!/usr/bin/env bash
set -euo pipefail

echo "Secure manifest should pass:"
docker run --rm -v "$PWD:/project" -w /project openpolicyagent/conftest:v0.68.2 \
  test kubernetes/deployment.yaml --policy policy

echo
echo "Insecure manifest should be rejected:"
set +e
docker run --rm -v "$PWD:/project" -w /project openpolicyagent/conftest:v0.68.2 \
  test kubernetes/insecure-deployment.yaml --policy policy
STATUS=$?
set -e

if [ "$STATUS" -eq 0 ]; then
  echo "ERROR: insecure manifest unexpectedly passed"
  exit 1
fi

echo "Expected result: the insecure manifest was blocked."
