# Zero-Trust CI/CD Pipeline with Policy-as-Code Gates

A learning project that demonstrates verification before approval. Every container image begins as an untrusted `candidate-<commit-sha>` artifact. It is promoted to `approved-<commit-sha>` and deployed only after all mandatory security gates pass.

## Mandatory gates

1. **Trivy** scans the candidate container image for fixable HIGH and CRITICAL CVEs.
2. **Snyk** performs software-composition analysis of Python dependencies at the HIGH severity threshold.
3. **Conftest with OPA/Rego** enforces custom Kubernetes policy-as-code rules.
4. **Kubescape** performs a CIS-oriented Kubernetes manifest scan with a compliance threshold.
5. **OPA Gatekeeper** runs inside a temporary Kind cluster and must reject a deliberately insecure Pod.

## Delivery flow

```text
push to main
  -> tests
  -> build and publish candidate image
  -> Trivy + Snyk + Conftest + Kubescape gates
  -> upload structured reports
  -> all gates pass?
       no: open remediation issue; no approval or deployment
       yes: promote to approved image
  -> create temporary Kind cluster
  -> install Gatekeeper
  -> prove insecure workload is denied
  -> deploy only the approved image
  -> validate application health
```

## Image tags

- `candidate-<full-git-sha>` means built but not yet trusted.
- `approved-<full-git-sha>` means the same image passed every mandatory gate.

## Reports

The workflow uploads JSON reports from Trivy, Snyk, Conftest, and Kubescape. It also saves Gatekeeper denial evidence.

## Important scope limitation

This is a demonstration project. It uses a temporary Kind cluster inside GitHub Actions, a small Flask application, selected policies, and chosen thresholds. It is not a complete production Zero-Trust platform or a permanent cloud deployment.

## Required repository secret

Create a GitHub Actions repository secret named `SNYK_TOKEN`. The workflow intentionally fails closed when this secret is missing.
