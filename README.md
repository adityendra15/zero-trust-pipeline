# Zero-Trust CI/CD Pipeline with Policy-as-Code Gates

This is a deliberately small learning project. A GitHub Actions workflow builds one Docker image and treats it as untrusted until four independent security gates approve it:

1. Trivy checks the candidate image for critical known vulnerabilities.
2. Snyk checks the Python dependency tree for high-severity known vulnerabilities.
3. OPA evaluates a short Rego policy against the Kubernetes Deployment.
4. Kubescape checks the Deployment against CIS Benchmark control C-0210, which requires the RuntimeDefault seccomp profile.

Each tool writes a JSON report. The workflow combines the results into `gate-summary.json`. If any gate fails, the image is not pushed to GitHub Container Registry and the workflow opens a GitHub Issue. If every gate passes, the commit-tagged image is pushed.

The manual workflow input `demonstrate_failure` selects `demo/insecure-deployment.yaml`. That file is intentionally unsafe and exists only to demonstrate gate failure, blocked promotion, JSON evidence, and automatic issue creation.

## Required repository secret

The GitHub repository must contain a secret named `SNYK_TOKEN`.

## Honest scope

This is a learning implementation, not a production platform. It demonstrates the security-gate flow at a basic level without cloud infrastructure, multiple services, Helm, Terraform, or a permanent Kubernetes cluster.
