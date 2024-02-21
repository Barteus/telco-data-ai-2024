juju run data-integrator/leader get-credentials -m pg

# update values based on action output
export PG_HOST=postgresql-k8s-primary.pg.svc.cluster.local:5432
export PG_USER=relation_id_X
export PG_PASSWORD=XXX
export PG_DATABASE=demo-db


cat <<EOF | kubectl apply -n admin -f -
apiVersion: v1
kind: Secret
metadata:
  name: pg-secret
type: Opaque
stringData:
  host: $PG_HOST
  user: $PG_USER
  password: $PG_PASSWORD
---
apiVersion: kubeflow.org/v1alpha1
kind: PodDefault
metadata:
  name: access-postgresql
spec:
  desc: Allow access to PostgreSQL
  env:
  - name: PG_HOST
    valueFrom:
      secretKeyRef:
        name: pg-secret
        key: host
        optional: false
  - name: PG_USER
    valueFrom:
      secretKeyRef:
        name: pg-secret
        key: user
        optional: false
  - name: PG_PASSWORD
    valueFrom:
      secretKeyRef:
        name: pg-secret
        key: password
        optional: false
  - name: PG_DATABASE
    value: $PG_DATABASE
  selector:
    matchLabels:
      access-pg: "true"
EOF