#!/bin/bash

set -ue

function get_macaddr() {
  for nic in `ip a | grep "^[0-9]*:" | awk '{print $2}' | tr -d ':' | grep -v ^lo | grep ^br`; do
    ret=`ethtool $nic | grep "Link detected: yes" | wc -l`;
    [[ 1 -eq $ret ]] && ip a | grep -A 1 $nic | grep "link/ether" | awk '{print $2}' | tr -d ':' && break;
  done
}

function get_ipaddr() {
  for nic in `ip a | grep "^[0-9]*:" | awk '{print $2}' | tr -d ':' | grep -v ^lo | grep ^br`; do
    ret=`ethtool $nic | grep "Link detected: yes" | wc -l`;
    [[ 1 -eq $ret ]] && ip a | grep -A 2 $nic | grep "inet " | awk '{print $2}' | cut -d'/' -f1 && break;
  done
}

etcd_host=""
etcd_port=""

for params in `cat /proc/cmdline`; do
  case $params in
    etcd_host=*)
      eval "$params"
      ;;
    etcd_port=*)
      eval "$params"
      ;;
  esac
done

# Put the configuration files in place
sudo cp /opt/axsh/wakame-vdc/dcmgr/config/hva.conf.example /etc/wakame-vdc/hva.conf

# Set hva node id
node_id=`get_macaddr`
echo "NODE_ID=node${node_id}" >> /etc/default/vdc-hva

ip=`get_ipaddr`

if [[ -z "${etcd_host}" ]]; then
  echo "/usr/local/bin/etcdctl set hva/hosts/node${node_id} \"${ip}\""
  /usr/local/bin/etcdctl set hva/hosts/node${node_id} "${ip}"
else
  echo "AMQP_ADDR=${etcd_host}" >> /etc/default/vdc-hva
  echo "AMQP_PORT=5672" >> /etc/default/vdc-hva
  #echo "/usr/local/bin/etcdctl --peers http://${etcd_host}:${etcd_port} set hva/hosts/node${node_id} \"${ip}\""
  #/usr/local/bin/etcdctl --peers http://${etcd_host}:${etcd_port} set hva/hosts/node${node_id} "${ip}"
  echo "curl -L http://${etcd_host}:${etcd_port}/v2/keys/hva/hosts/node${node_id} -X PUT -d value=\"${ip}\""
  /usr/bin/curl -L http://${etcd_host}:${etcd_port}/v2/keys/hva/hosts/node${node_id} -X PUT -d value="${ip}"
  sleep 10
  while true; do
     result=`/usr/bin/curl -L http://${etcd_host}:${etcd_port}/v2/keys/hva/boot -X GET`
     echo "hva/boot result: $result" >> /var/log/wakame-vdc.hva.node.log 2>&1
     if [[ "$result" == *"go ahead"* ]]; then
        sudo /sbin/start vdc-hva >> /var/log/wakame-vdc.hva.node.log 2>&1
        exit 0
     fi
  done
fi



