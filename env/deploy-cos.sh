#!/bin/bash

juju add-model cos mk8s
juju deploy cos-lite --trust

juju deploy cos-lite \
  --trust \
  --overlay ./cos/offers-overlay.yaml \
  --overlay ./cos/storage-small-overlay.yaml

juju offer cos.traefik:ingress

juju run traefik/0 show-proxied-endpoints --format=yaml \
  | yq '."traefik/0".results."proxied-endpoints"' \
  | jq

juju show-unit catalogue/0 | grep url

#User admin
juju run grafana/leader get-admin-password --model cos
