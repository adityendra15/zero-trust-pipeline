# Resume Claim Map

## Trivy CVE gate

The workflow builds a candidate image and runs Trivy with JSON output and a non-zero exit code for critical, fixed vulnerabilities.

## Snyk software-composition gate

Snyk scans `requirements.txt`, checks the installed Python dependency tree, writes `reports/snyk.json`, and fails on high-severity findings.

## OPA/Rego policy gate

`policy/deployment.rego` denies mutable `:latest` images and weak Kubernetes security settings. The workflow fails when the returned deny list is not empty.

## Kubescape CIS check

Kubescape scans the selected Deployment against control `C-0210`, a control included in the Kubernetes CIS Benchmark frameworks. It writes a JSON report and requires 100% compliance for that control.

## Structured reports and remediation issues

All four tools write JSON. The workflow creates `gate-summary.json`, uploads the reports, and opens a GitHub Issue when any gate fails.

## Zero Trust and least privilege

The candidate is not trusted merely because it built successfully. It must pass every gate before promotion. The container and Pod use a non-root user, disable privilege escalation, use a read-only root filesystem, drop Linux capabilities, and avoid automatically mounting a Kubernetes API token.
