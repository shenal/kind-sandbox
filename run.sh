#!/bin/bash
kind create cluster --config ./kind-multi-node.yml --kubeconfig ./kubeconfig
kind get kubeconfig --name=kind > ./kubeconfig 
sed -i 's%server: https://127.0.0.1:[0-9]*%server: https://127.0.0.1:6443%g' ./kubeconfig
docker exec -it kind-control-plane sh -c "apt-get update && apt-get install -y vim bash-completion && mkdir -p /root/.kube"
docker exec -it kind-control-plane bash -c "echo 'source /usr/share/bash-completion/bash_completion' >>~/.bashrc"
docker exec -it kind-control-plane bash -c "echo 'source <(kubectl completion bash)' >>~/.bashrc"
docker exec -it kind-control-plane bash -c "mkdir -p /etc/bash_completion.d"
docker exec -it kind-control-plane bash -c "kubectl completion bash >/etc/bash_completion.d/kubectl"
docker cp ./kubeconfig kind-control-plane:/root/.kube/config
docker exec -it kind-control-plane sh -c "kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/nginx-0.27.0/deploy/static/mandatory.yaml && kubectl patch deployments -n ingress-nginx nginx-ingress-controller -p '{\"spec\":{\"template\":{\"spec\":{\"containers\":[{\"name\":\"nginx-ingress-controller\",\"ports\":[{\"containerPort\":80,\"hostPort\":80},{\"containerPort\":443,\"hostPort\":443}]}],\"nodeSelector\":{\"ingress-ready\":\"true\"},\"tolerations\":[{\"key\":\"node-role.kubernetes.io/master\",\"operator\":\"Equal\",\"effect\":\"NoSchedule\"}]}}}}' && kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/nginx-0.27.0/deploy/static/provider/baremetal/service-nodeport.yaml"
docker exec -it kind-control-plane bash
