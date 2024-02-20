# telco-data-ai-2024

**Work in Progress**

# TODO

Tools to install:

- [x] Opensearch
- [x] Kubeflow + MLflow
- [x] MongoDB
- [x] COS
- [x] Superset
- [x] PostgreSQL
- [x] Kafka
- [x] Spark History Server

Example notebooks/programs:

- [ ] Access OpenSearch
- [ ] Access PostgreSQL
- [ ] Access MongoDB
- [ ] Spark example with Minio access
- [ ] Produce + Consume Kafka
- [ ] Superset dashboard from MongoDB, PostgreSQL, Opensearch
- [ ] Spark example with push metrics

Other:
- [ ] Add list of URLs or way to get URL + user + password for each tool

# Installation

Create a VM with minimum 8 vCPU, 64GB RAM and 150GB disk.

Go to the folder "env" and run commands in the script files:

1. [setup-vm.sh](./env/setup-vm.sh)
2. [deploy-cos.sh](./env/deploy-cos.sh)
3. [deploy-apps.sh](./env/deploy-apps.sh)

## Enable Spark in Kubeflow user namespace

Log into the Kubeflow Dashboard using credentails: admin / admin

Run enable spark service account in the admin namespace - [enable-spark-ckf.sh](./env/enable-spark-ckf.sh)

Add PodDefaults for Notebook creation using script: [spark-pod-default.sh](./env/spark-pod-default.sh)

# Access

Connect to the VM using sshuttle and expose networks

```shell
sshuttle -r ubuntu@0.0.0.0 10.0.0.0/8
```

Start spark enabled notebook using image: `docker.io/edeusebio85/charmed-spark-jupyter@sha256:722d027ce6a371d063c8945c808274351ffc49f5368cdf6697394078f46fc29d`
