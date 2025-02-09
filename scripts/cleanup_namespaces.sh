#!/bin/bash

# List of namespaces stuck in terminating state
namespaces=("databases" "infrastructure" "kserve" "messaging" "monitoring" "services" "storage")

# Iterate over each namespace
for ns in "${namespaces[@]}"; do
  echo "Processing namespace: $ns"

  # Check if the namespace exists
  if kubectl get namespace $ns &>/dev/null; then
    echo "Namespace $ns exists. Proceeding with cleanup."

    # List all resources in the namespace
    resources=$(kubectl api-resources --verbs=list --namespaced -o name | xargs -n 1 kubectl get -n $ns --no-headers --ignore-not-found -o custom-columns=NAME:.metadata.name,KIND:.kind)

    # Iterate over each resource and remove finalizers
    while read -r resource; do
      name=$(echo $resource | awk '{print $1}')
      kind=$(echo $resource | awk '{print $2}')
      if [ -n "$name" ] && [ -n "$kind" ]; then
        echo "Removing finalizers from $kind/$name in namespace $ns"
        kubectl patch $kind $name -n $ns -p '{"metadata":{"finalizers":[]}}' --type=merge
      fi
    done <<< "$resources"

    # Remove finalizers from the namespace itself
    echo "Removing finalizers from namespace $ns"
    kubectl get namespace $ns -o json | jq '.spec.finalizers=[]' | kubectl replace --raw "/api/v1/namespaces/$ns/finalize" -f -

  else
    echo "Namespace $ns does not exist. Skipping."
  fi
done

echo "Completed processing namespaces."
