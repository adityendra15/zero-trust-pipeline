#!/usr/bin/env bash
set -euo pipefail

kubectl run smoke-test \
  --namespace zero-trust-pipeline \
  --image=curlimages/curl:8.12.1 \
  --restart=Never \
  --rm \
  --attach \
  --quiet \
  --overrides='{"spec":{"automountServiceAccountToken":false,"securityContext":{"runAsNonRoot":true,"runAsUser":10001,"runAsGroup":10001,"seccompProfile":{"type":"RuntimeDefault"}}}}' \
  --command -- \
  sh -c 'curl --fail --silent http://zero-trust-pipeline-app/health/ready'

echo
echo "Approved application health check passed inside the cluster."
