#!/bin/sh
set -o xtrace

export RG=kapil-demo-resources
export AKS_NAME=kapil-demo

az aks get-credentials --resource-group ${RG} --name ${AKS_NAME}