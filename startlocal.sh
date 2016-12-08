#!/bin/bash

# Starts minikube, loads docker environment, builds docker images and runs a pod.

# This sets the nodes to auto-create a bzz-key. If false, the node will import key from secrets/geth
AUTOGENKEYS=true

echo "Starting miniKube..."

minikube start

echo "Setting up docker environment..."

eval $(minikube docker-env)

echo "Building docker image..."

docker build -t bzzd ./docker-container/

echo "Generating Kubernetes secrets..."


# Remove secrets if already loaded
kubectl delete secret secrets --ignore-not-found

if $AUTOGENKEYS ; then
# Start Node with generated keys
kubectl create secret generic secrets --from-file=startup=./secrets/bzzd-startup-script-auto-gen-keys.sh --from-file=key-filename=./secrets/geth/key-filename --from-file=key-data=./secrets/geth/key-data --from-file=password=./secrets/geth/default_pwd
else 
# Start Node with imported keys and environmental variables
kubectl create secret generic secrets --from-file=startup=./secrets/bzzd-startup-script.sh --from-file=key-filename=./secrets/geth/key-filename --from-file=key-data=./secrets/geth/key-data --from-file=password=./secrets/geth/default_pwd; 
fi

echo "Starting the pod...."
kubectl delete pod bzzd --ignore-not-found

kubectl create -f ./bzzdKube.yaml

echo "Pods:"

kubectl get pods

