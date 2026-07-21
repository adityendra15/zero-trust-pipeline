package main

import rego.v1

deny contains msg if {
    input.kind == "Deployment"
    some container in input.spec.template.spec.containers
    endswith(container.image, ":latest")
    msg := sprintf("container %q must not use the mutable latest tag", [container.name])
}

deny contains msg if {
    input.kind == "Deployment"
    not input.spec.template.spec.securityContext.runAsNonRoot
    msg := "pod securityContext.runAsNonRoot must be true"
}

deny contains msg if {
    input.kind == "Deployment"
    some container in input.spec.template.spec.containers
    not container.securityContext.readOnlyRootFilesystem
    msg := sprintf("container %q must use a read-only root filesystem", [container.name])
}

deny contains msg if {
    input.kind == "Deployment"
    some container in input.spec.template.spec.containers
    container.securityContext.allowPrivilegeEscalation
    msg := sprintf("container %q must disable privilege escalation", [container.name])
}

deny contains msg if {
    input.kind == "Deployment"
    some container in input.spec.template.spec.containers
    not container.resources.limits.cpu
    msg := sprintf("container %q must define a CPU limit", [container.name])
}

deny contains msg if {
    input.kind == "Deployment"
    some container in input.spec.template.spec.containers
    not container.resources.limits.memory
    msg := sprintf("container %q must define a memory limit", [container.name])
}
