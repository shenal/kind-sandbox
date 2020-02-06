#!/bin/bash
kind delete cluster
rm -rf ./kubeconfig
docker system prune -f
