# Zero-Trust CI/CD Pipeline with Policy-as-Code Gates

This intentionally small repository implements the resume claims:

- A candidate container image is built and pushed as `candidate-<commit>`.
- Trivy performs a blocking CVE scan and writes JSON.
- Snyk performs blocking software-composition analysis and writes JSON.
- Conftest evaluates Kubernetes YAML with OPA/Rego and writes JSON.
- Kubescape runs a blocking CIS Benchmark check and writes JSON.
- OPA Gatekeeper acts as a real Kubernetes admission controller.
- Reports and the SBOM are uploaded as a GitHub Actions artifact.
- A failed mandatory gate blocks promotion and opens a GitHub Issue.
- Only a fully passing candidate is retagged as `approved-<commit>`.
- Kubernetes deploys only the approved image.

## Zero Trust and least privilege

- Every candidate is verified before trust is granted.
- Gates fail closed.
- Gatekeeper rejects Pods that do not require non-root execution.
- The container uses UID 10001, a read-only root filesystem, dropped capabilities and no privilege escalation.
- The Pod does not automatically receive a service-account token.
- Images use immutable commit-based tags rather than `latest`.
- GitHub Actions receives only read-content, write-package and write-issue permissions.

## Required GitHub secret

Create a free Snyk account and add a repository secret named:

```text
SNYK_TOKEN
```

Never commit the token to a file.

## Passing demonstration

Run the workflow manually with `demo_failure = none`.

Expected result: all gates pass, an `approved-<commit>` image appears in GHCR, and Kubernetes deploys it.

## Failing demonstration

Run the workflow manually with `demo_failure = policy`.

The intentionally insecure manifest uses `latest`, lacks non-root enforcement, permits privilege escalation and lacks limits.

Expected evidence:

- Conftest and Kubescape fail.
- JSON reports remain downloadable.
- An automated GitHub Issue opens.
- No approved image is created.
- No approved image is deployed.

## Local policy demonstration

```bash
./scripts/run-policy-demo.sh
```

The secure manifest passes and the insecure manifest is blocked.

## Image promotion

```text
candidate-<commit>
      |
      | all mandatory gates pass
      v
approved-<commit>
      |
      v
Kubernetes deployment
```
