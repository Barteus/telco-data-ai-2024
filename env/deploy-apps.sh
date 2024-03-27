#!/bin/bash

juju add-model dbs localhost

juju switch dbs

#opensearch
lxc network set lxdbr0 ipv6.address none
sudo sysctl -w vm.max_map_count=262144 vm.swappiness=0 net.ipv4.tcp_retries2=5

juju model-config --file ./os-cloudinit-userdata.yaml
juju deploy opensearch --channel 2/edge

juju deploy tls-certificates-operator
juju config tls-certificates-operator generate-self-signed-certificates="true" ca-common-name="Demo CA"

juju relate tls-certificates-operator opensearch

juju status --watch 5s

#mongodb
lxc network set lxdbr0 ipv6.address none

juju switch dbs
juju deploy mongodb --channel 6/beta

#User: operator
juju run mongodb/leader get-password

juju status --watch 5s

#kubeflow + mlflow
juju add-model kubeflow mk8s

sudo sysctl -w fs.inotify.max_user_instances=1280 fs.inotify.max_user_watches=655360

juju switch kubeflow

juju deploy ./kubeflow-mlflow-bundle.yaml --trust

# Postgres on K8s
juju add-model pg mk8s

juju deploy postgresql-k8s --channel 14/stable --trust
juju deploy data-integrator --channel edge --config database-name=demo-db
juju integrate data-integrator postgresql-k8s

juju status --watch 5s

juju run data-integrator/leader get-credentials

# Spark History Server
juju add-model spark mk8s

# go to Kubeflow Minio and create bucket (history-server) & key (spark-events)
# you can upload empty file test.txt in s3://history-server/spark-events/test.txt
kubectl get secret minio-secret -n kubeflow -oyaml
kubectl get secret minio-secret -n kubeflow -oyaml | yq .data.MINIO_SECRET_KEY | base64 -d

juju deploy spark-history-server-k8s -n1 --channel 3.4/stable
juju deploy s3-integrator -n1 --channel edge
juju config s3-integrator bucket="history-server" path="spark-events" endpoint=http://minio.kubeflow:9000/
# change secret-key based on minio secret above
juju run s3-integrator/0 sync-s3-credentials access-key=minio secret-key="$(kubectl get secret minio-secret -n kubeflow -oyaml | yq .data.MINIO_SECRET_KEY | base64 -d)"
juju relate s3-integrator spark-history-server-k8s

juju consume admin/cos.traefik cos-traefik
juju relate cos-traefik spark-history-server-k8s

# Superset
juju add-model superset mk8s

juju deploy superset-k8s
juju deploy superset-k8s --config charm-function=beat superset-k8s-beat
juju deploy superset-k8s --config charm-function=worker superset-k8s-worker
juju deploy redis-k8s --channel latest/edge
juju relate redis-k8s superset-k8s
juju relate redis-k8s superset-k8s-beat
juju relate redis-k8s superset-k8s-worker

juju deploy postgresql-k8s --trust
juju relate postgresql-k8s superset-k8s
juju relate postgresql-k8s superset-k8s-beat
juju relate postgresql-k8s superset-k8s-worker

juju status --watch 5s

#Creds admin / admin
kubectl get svc superset-k8s -n superset

# Kafka
juju add-model kafka mk8s

juju deploy zookeeper-k8s -n 3 --channel=3/edge
juju deploy kafka-k8s -n 3 --channel=3/edge
juju relate kafka-k8s zookeeper-k8s

juju status --watch 5s

juju run kafka-k8s/leader get-admin-credentials





