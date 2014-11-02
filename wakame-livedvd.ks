lang en_US.UTF-8
keyboard us
#network --device eth0 --onboot yes --bridge br0
#network --device br0 --onboot yes --bootproto static --type bridge --ip 192.168.100.10 --netmask 255.255.0.0 --gateway 192.168.1.1 --hostname wakame-vdc-live
#network --device br0 --onboot yes --bootproto static --ip 10.0.2.15 --netmask 255.255.255.0 --gateway 10.0.2.2 --hostname wakame-vdc-live
timezone Asia/Tokyo
auth --useshadow --enablemd5
selinux --disabled
firewall --disabled

repo --name=base        --baseurl=http://ftp.iij.ad.jp/pub/linux/centos/6/os/$basearch
repo --name=updates     --baseurl=http://ftp.iij.ad.jp/pub/linux/centos/6/updates/$basearch
repo --name=extras      --baseurl=http://ftp.iij.ad.jp/pub/linux/centos/6/extras/$basearch
repo --name=epel        --baseurl=http://download.fedoraproject.org/pub/epel/6/$basearch
repo --name=live        --baseurl=http://www.nanotechnologies.qc.ca/propos/linux/centos-live/$basearch/live
repo --name=wakame      --baseurl=http://dlc.wakame.axsh.jp/packages/rhel/6/master/current/
repo --name=wakame3rd   --baseurl=http://dlc.wakame.axsh.jp/packages/3rd/rhel/6/master/
#repo --name=openvz-utils        --baseurl=http://dlc.wakame.axsh.jp/mirror/openvz/current/
#repo --name=openvz-kernel-rhel6 --baseurl=http://dlc.wakame.axsh.jp/mirror/openvz/kernel/branches/rhel6-2.6.32/042stab055.16/

%packages
bash
kernel
#kernel-firmware
#vzkernel-firmware
#vzkernel
syslinux
passwd
policycoreutils
chkconfig
authconfig
rootfiles
comps-extras
xkeyboard-config
dhclient
livecd-tools
sudo
bridge-utils

#wakame-vdc-example-1box-full-vmapp-config
wakame-vdc-example-1box-dcmgr-vmapp-config
wakame-vdc-example-1box-proxy-vmapp-config
wakame-vdc-example-1box-webui-vmapp-config
wakame-vdc-example-1box-nsa-vmapp-config
wakame-vdc-example-1box-sta-vmapp-config
#wakame-vdc-example-1box-hva-vmapp-config
wakame-vdc-example-1box-admin-vmapp-config
wakame-vdc-hva-kvm-vmapp-config

%post

LIVE_USER="wakame"

cat > /root/post-install << EOF_post
#!/bin/bash

yum install --disablerepo=updates -y http://dlc.openvnet.axsh.jp/packages/rhel/openvswitch/6/kmod-openvswitch-2.3.0-1.el6.x86_64.rpm
yum install --disablerepo=updates -y http://dlc.openvnet.axsh.jp/packages/rhel/openvswitch/6/openvswitch-2.3.0-1.x86_64.rpm

# set the LiveMedia hostname
sed -i -e 's/HOSTNAME=localhost.localdomain/HOSTNAME=wakame-vdc.live.example.com/g' /etc/sysconfig/network
echo "10.0.2.15 wakame-vdc.live.example.com wakame-vdc" >> /etc/hosts
/bin/hostname wakame-vdc.live.example.com

## create the LiveCD default user
# add default user with no password
/usr/sbin/useradd -c "LiveMedia default user" $LIVE_USER
/usr/bin/passwd -d $LIVE_USER > /dev/null
# give default user sudo privileges
echo "$LIVE_USER     ALL=(ALL)     NOPASSWD: ALL" >> /etc/sudoers

# network
#cat > /etc/sysconfig/network-scripts/ifcfg-venet0 << EOF_ifcfg_venet0
#DEVICE=venet0
#ONBOOT=yes
#STARTMODE=onboot
#
#EOF_ifcfg_venet0

cat > /etc/sysconfig/network-scripts/ifcfg-eth0 << EOF_ifcfg_eth0
DEVICE=eth0
TYPE=Ethernet
ONBOOT=no
NM_CONTROLLED=no
BOOTPROTO=none
BRIDGE=br0

EOF_ifcfg_eth0

cat > /etc/sysconfig/network-scripts/ifcfg-br0 << EOF_ifcfg_br0
DEVICE=br0
TYPE=Bridge
BOOTPROTO=static
ONBOOT=no
IPV4_FAILURE_FATAL=yes
NM_CONTROLLED=no
DEFROUTE=yes
PEERDNS=yes
PEERROUTES=yes
IPV6INIT=no
GATEWAY=GATEWAY_ADDRESS
IPADDR=IP_ADDRESS
NETMASK=SUBNETMASK

EOF_ifcfg_br0

#cat > /etc/sysconfig/network-scripts/ifcfg-eth1 << EOF_ifcfg_eth1
#DEVICE=eth1
#TYPE=Ethernet
#ONBOOT=yes
#NM_CONTROLLED=no
#BOOTPROTO=none
#IPV6INIT=no
#BRIDGE=br1
#
#EOF_ifcfg_eth1

#cat > /etc/sysconfig/network-scripts/ifcfg-br1 << EOF_ifcfg_br1
#DEVICE=br1
#TYPE=Bridge
#ONBOOT=yes
#NM_CONTROLLED=no
#BOOTPROTO=static
#IPV6INIT=no
#GATEWAY=192.168.124.1
#IPADDR=192.168.124.20
#NETMASK=255.255.255.0

#EOF_ifcfg_br1


EOF_post

/bin/bash -x /root/post-install 2>&1 | tee /root/post-install.log

echo "timeout 40;" > /etc/dhclient.conf
cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

%post --nochroot

cat > /root/postnochroot-install << EOF_postnochroot
#!/bin/bash

cp -a ./net-setup ${INSTALL_ROOT}/usr/local/bin/
chmod +x ${INSTALL_ROOT}/usr/local/bin/net-setup

EOF_postnochroot

/bin/bash -x /root/postnochroot-install 2>&1 | tee /root/postnochroot-install.log


