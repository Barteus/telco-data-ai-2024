#!/bin/bash

sudo snap install juju --channel 3.1/stable
mkdir -p ~/.local/share/juju

sudo snap install kubectl --classic
mkdir -p ~/.kube

sudo snap install microk8s --classic --channel=1.28/stable
sudo usermod -a -G microk8s ubuntu
sudo chown -R ubuntu ~/.kube
newgrp microk8s # or restart the console

microk8s status
microk8s enable dns hostpath-storage ingress metallb:10.64.140.43-10.64.140.49 rbac
microk8s config > ~/.kube/config
kubectl get po -A

juju bootstrap localhost
juju add-k8s mk8s --cluster-name=microk8s-cluster
