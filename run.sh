#!/bin/bash
kind create cluster --config ./kind-multi-node.yml --kubeconfig ./kubeconfig
kind get kubeconfig --name=kind > ./kubeconfig 
sed -i 's%server: https://127.0.0.1:[0-9]*%server: https://127.0.0.1:6443%g' ./kubeconfig
docker exec -it kind-control-plane sh -c "apt-get update && apt-get install -y vim-tiny && mkdir -p /root/.kube" 
docker cp ./kubeconfig kind-control-plane:/root/.kube/config
docker exec -it kind-control-plane bash
