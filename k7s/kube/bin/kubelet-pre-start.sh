#!/bin/bash
# Open ipvs
modprobe -- ip_vs
modprobe -- ip_vs_rr
modprobe -- ip_vs_wrr
modprobe -- ip_vs_sh

version_ge(){
    test "$(echo "$@" | tr ' ' '\n' | sort -rV | head -n 1)" == "$1"
}

kernel_version=$(uname -r | cut -d- -f1)
if version_ge "${kernel_version}" 4.19; then
  modprobe -- nf_conntrack
else
  modprobe -- nf_conntrack_ipv4
fi

cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.conf.all.rp_filter = 1
EOF
sysctl --system
sysctl -w net.ipv4.ip_forward=1
swapoff -a
exit 0
