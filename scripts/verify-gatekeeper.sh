#!/usr/bin/env bash
set -euo pipefail

mkdir -p reports

if kubectl apply -f gatekeeper/insecure-pod.yaml >reports/gatekeeper-evidence.txt 2>&1; then
  echo "Gatekeeper verification failed: insecure Pod was admitted." | tee -a reports/gatekeeper-evidence.txt
  kubectl delete pod gatekeeper-denial-test -n zero-trust-pipeline --ignore-not-found
  exit 1
fi

if ! grep -qiE "denied|runAsNonRoot|non-root" reports/gatekeeper-evidence.txt; then
  echo "Gatekeeper rejected the Pod, but the expected policy message was not found." | tee -a reports/gatekeeper-evidence.txt
  exit 1
fi

echo "Gatekeeper verified: the deliberately insecure Pod was rejected." | tee -a reports/gatekeeper-evidence.txt
