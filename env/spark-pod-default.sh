cat <<EOF | kubectl apply -n admin -f -
apiVersion: kubeflow.org/v1alpha1
kind: PodDefault
metadata:
  name: pyspark
spec:
  annotations:
    traffic.sidecar.istio.io/excludeOutboundPorts: 37371,6060
    traffic.sidecar.istio.io/excludeInboundPorts: 37371,6060
  args:
  - --namespace
  - admin
  - --username
  - spark2
  - --conf
  - spark.driver.port=37371
  - --conf
  - spark.blockManager.port=6060
  desc: Configure Canonical PySpark
  selector:
    matchLabels:
      canonical-pyspark: "true"
EOF