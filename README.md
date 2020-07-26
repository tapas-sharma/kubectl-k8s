# kubectl-k8s

[![Build Status](https://travis-ci.org/tapas-sharma/kubectl-k8s.svg?branch=master)](https://travis-ci.org/tapas-sharma/kubectl-k8s)

Run kubectl commands as a job or via this container

## Build Container
`make build`

## Run Container

### Get default version
`docker run --name kubectl --rm tapassharma/kubectl version --client`

### Run specific kubectl version
To get a specfic version of kubectl you can set `KUBE_VERSION` environment variable, this will override the default `kubectl` and download the version specified

`docker run --name kubectl --rm -e KUBE_VERSION=v1.18.5  tapassharma/kubectl version --client`

Here, we will use `kubectl` version v1.18.5

NOTE: Always add `v` to the version string i.e `v.1.18.5` or `v.1.18.6`