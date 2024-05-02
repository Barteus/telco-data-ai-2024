# telco-data-ai-2024

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

## Enable PostgreSQL in Kubeflow user namespace

Log into the Kubeflow Dashboard using credentails: admin / admin

Add PodDefaults for Notebook creation using script: [postgres-pod-default.sh](./env/postgres-pod-default.sh)

# Access

Connect to the VM using sshuttle and expose networks

```shell
sshuttle -r ubuntu@0.0.0.0 10.0.0.0/8
```

## Access to Spark enabled notebook

1. Go to Kubeflow Dashboard
2. Select Notebook tab
3. Create new notebook
   1. Custom notebook -> Custom image: `docker.io/edeusebio85/charmed-spark-jupyter@sha256:722d027ce6a371d063c8945c808274351ffc49f5368cdf6697394078f46fc29d`
   2. Advanced options -> Configurations: select all from drop-down
4. Go to notebook and create new notebook in Jupyter UI.
   1. Run example [spark notebook](./notebooks/examples/spark.ipynb)

## Access to PostgreSQL enabled notebook

1. Go to Kubeflow Dashboard
2. Select Notebook tab
3. Create new notebook
   1. Use default scipy notebook image
   2. Advanced options -> Configurations: Allow access to PostgreSQL
4. Go to notebook and create new notebook in Jupyter UI.
   1. Run example [postgresql notebook](./notebooks/examples/postgres.ipynb)
