#!/bin/bash

sudo snap install spark-client --channel 3.4/edge

# adjust minio credentails using: 
# kubectl get secret minio-secret -n kubeflow -oyaml 
# secret is base64 encoded!

export AWS_S3_ENDPOINT=http://minio.kubeflow:9000
export AWS_S3_BUCKET=history-server
export AWS_ACCESS_KEY=minio
export AWS_SECRET_KEY=O6BN9GTPFF4HGKURIZ83U8HKY3RBLE

# Make sure you log into Kubeflow and create "admin" namespace

spark-client.service-account-registry create \
  --username spark --namespace admin \
  --properties-file ./spark/s3.conf \
  --properties-file ./spark/spark-logs.conf


