#!/bin/bash
kind delete cluster
rm -rf ./kubeconfig
docker container prune -f
