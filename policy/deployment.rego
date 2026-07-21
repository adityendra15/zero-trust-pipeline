package main

import rego.v1

is_deployment if input.kind == "Deployment"

containers contains container if {
  is_deployment
  container := input.spec.template.spec.containers[_]
}

deny contains msg if {
  container := containers[_]
  endswith(container.image, ":latest")
  msg := sprintf("Container %q uses the mutable latest tag.", [container.name])
}

deny contains msg if {
  is_deployment
  not input.spec.template.spec.securityContext.runAsNonRoot
  msg := "Pod securityContext.runAsNonRoot must be true."
}

deny contains msg if {
  container := containers[_]
  container.securityContext.allowPrivilegeEscalation != false
  msg := sprintf("Container %q must disable privilege escalation.", [container.name])
}

deny contains msg if {
  container := containers[_]
  container.securityContext.readOnlyRootFilesystem != true
  msg := sprintf("Container %q must use a read-only root filesystem.", [container.name])
}

deny contains msg if {
  container := containers[_]
  not "ALL" in container.securityContext.capabilities.drop
  msg := sprintf("Container %q must drop all Linux capabilities.", [container.name])
}

deny contains msg if {
  container := containers[_]
  not container.resources.requests.cpu
  msg := sprintf("Container %q must define a CPU request.", [container.name])
}

deny contains msg if {
  container := containers[_]
  not container.resources.requests.memory
  msg := sprintf("Container %q must define a memory request.", [container.name])
}

deny contains msg if {
  container := containers[_]
  not container.resources.limits.cpu
  msg := sprintf("Container %q must define a CPU limit.", [container.name])
}

deny contains msg if {
  container := containers[_]
  not container.resources.limits.memory
  msg := sprintf("Container %q must define a memory limit.", [container.name])
}

deny contains msg if {
  container := containers[_]
  not container.livenessProbe
  msg := sprintf("Container %q must define a liveness probe.", [container.name])
}

deny contains msg if {
  container := containers[_]
  not container.readinessProbe
  msg := sprintf("Container %q must define a readiness probe.", [container.name])
}

deny contains msg if {
  is_deployment
  input.spec.template.spec.automountServiceAccountToken != false
  msg := "Automatic service-account token mounting must be disabled."
}
