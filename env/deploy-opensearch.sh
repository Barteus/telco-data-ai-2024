#opensearch
juju add-model opensearch localhost
lxc network set lxdbr0 ipv6.address none
sudo sysctl -w vm.max_map_count=262144 vm.swappiness=0 net.ipv4.tcp_retries2=5

juju model-config --file ./os-cloudinit-userdata.yaml
juju deploy opensearch --channel 2/edge

juju deploy tls-certificates-operator
juju config tls-certificates-operator generate-self-signed-certificates="true" ca-common-name="Demo CA"

juju relate tls-certificates-operator opensearch

juju status --watch 5s