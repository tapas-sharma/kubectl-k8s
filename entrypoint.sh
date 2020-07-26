#!/bin/bash 

function move_default () {
    mv /usr/local/bin/defkubectl /usr/local/bin/kubectl
}

LATEST_STABLE=$(curl -sf https://storage.googleapis.com/kubernetes-release/release/stable.txt)
## start from the default version from dockerfile.
KUBECTL_VERSION="${KUBE_VERSION:-${KUBECTL_DEFAULT_VERSION}}"
## if we can get the latest version then use that, only if KUBE_VERSION is empty
if [[ -z "$KUBE_VERSION" && 0 -eq $? ]]; then
    KUBECTL_VERSION="${KUBE_VERSION:-${LATEST_STABLE}}"
fi
## If current version needed is the default version
## do not download but rename the one we downloaded while
## creating the container
if [ "$KUBECTL_VERSION" == "$KUBECTL_DEFAULT_VERSION" ]; then
    move_default
else
    curl -LsSf https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl
    if [ 0 -ne $? ]; then
        echo "Using default kubectl $KUBECTL_DEFAULT_VERSION cannot download the version given $KUBECTL_VERSION"
        move_default
    fi
fi
## just for redundancy
chmod +x /usr/local/bin/kubectl
## pass any args to the container to kubectl
kubectl $@