package kubernetes.admission

# Reject images that use the changeable :latest tag.
deny contains message if {
    container := input.spec.template.spec.containers[_]
    endswith(container.image, ":latest")
    message := "Container images must not use the :latest tag."
}

# Require the Pod to run as a non-root user.
deny contains message if {
    pod_security := object.get(input.spec.template.spec, "securityContext", {})
    object.get(pod_security, "runAsNonRoot", false) != true
    message := "The Pod must set runAsNonRoot to true."
}

# Prevent a container from gaining extra privileges.
deny contains message if {
    container := input.spec.template.spec.containers[_]
    container_security := object.get(container, "securityContext", {})
    object.get(container_security, "allowPrivilegeEscalation", true) != false
    message := "Containers must set allowPrivilegeEscalation to false."
}

# Require the container root filesystem to be read-only.
deny contains message if {
    container := input.spec.template.spec.containers[_]
    container_security := object.get(container, "securityContext", {})
    object.get(container_security, "readOnlyRootFilesystem", false) != true
    message := "Containers must set readOnlyRootFilesystem to true."
}

# Do not automatically mount a Kubernetes API token into the Pod.
deny contains message if {
    object.get(input.spec.template.spec, "automountServiceAccountToken", true) != false
    message := "Pods must set automountServiceAccountToken to false."
}
