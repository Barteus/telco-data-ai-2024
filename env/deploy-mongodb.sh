#opensearch
lxc network set lxdbr0 ipv6.address none

juju deploy mongodb --channel 6/beta

#User: operator
juju run mongodb/leader get-password

juju status --watch 5s