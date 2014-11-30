lang en_US.UTF-8
keyboard us
#network --device eth0 --onboot yes --bridge br0
#network --device br0 --onboot yes --bootproto static --type bridge --ip 192.168.100.10 --netmask 255.255.0.0 --gateway 192.168.1.1 --hostname wakame-vdc-live
#network --device br0 --onboot yes --bootproto static --ip 10.0.2.15 --netmask 255.255.255.0 --gateway 10.0.2.2 --hostname wakame-vdc-live
timezone Asia/Tokyo
auth --useshadow --enablemd5
selinux --disabled
firewall --disabled

repo --name=base        --baseurl=http://ftp.iij.ad.jp/pub/linux/centos/6.5/os/$basearch
repo --name=updates     --baseurl=http://ftp.iij.ad.jp/pub/linux/centos/6.5/updates/$basearch
repo --name=extras      --baseurl=http://ftp.iij.ad.jp/pub/linux/centos/6.5/extras/$basearch
#repo --name=base        --baseurl=http://192.168.122.1/centos/6.5/os/$basearch
#repo --name=updates     --baseurl=http://192.168.122.1/centos/6.5/updates/$basearch
#repo --name=extras      --baseurl=http://192.168.122.1/centos/6.5/extras/$basearch
repo --name=epel        --baseurl=http://download.fedoraproject.org/pub/epel/6/$basearch
repo --name=live        --baseurl=http://www.nanotechnologies.qc.ca/propos/linux/centos-live/$basearch/live
repo --name=wakame      --baseurl=http://dlc.wakame.axsh.jp/packages/rhel/6/master/current/
repo --name=wakame3rd   --baseurl=http://dlc.wakame.axsh.jp/packages/3rd/rhel/6/master/
#repo --name=openvz-utils        --baseurl=http://dlc.wakame.axsh.jp/mirror/openvz/current/
#repo --name=openvz-kernel-rhel6 --baseurl=http://dlc.wakame.axsh.jp/mirror/openvz/kernel/branches/rhel6-2.6.32/042stab055.16/

xconfig --startxonboot
services --disabled=NetworkManager

%pre

%packages
@base
@basic-desktop
@fonts
@general-desktop
@graphical-admin-tools
@hardware-monitoring
@input-methods
@internet-applications
@internet-browser
@legacy-unix
@legacy-x
@network-tools
@x11
@legacy-x-base
@core
@japanese-support
@xfce
-NetworkManager
subnetcalc
gdm
firefox
bash
kernel
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
openssh
openssh-clients
openssh-server
vim-enhanced

wakame-vdc
wakame-vdc-dcmgr-vmapp-config
wakame-vdc-hva-common-vmapp-config
wakame-vdc-hva-kvm-vmapp-config
wakame-vdc-rack-config
wakame-vdc-webui-vmapp-config

%post

LIVE_USER="wakame"

cat > /root/post-install << EOF_post
#!/bin/bash

# set the LiveMedia hostname
sed -i -e 's/HOSTNAME=localhost.localdomain/HOSTNAME=wakame-vdc.live.example.com/g' /etc/sysconfig/network
#echo "10.0.2.15 wakame-vdc.live.example.com wakame-vdc" >> /etc/hosts
#/bin/hostname wakame-vdc.live.example.com

# turn off firstboot for livecd boots
echo "RUN_FIRSTBOOT=NO" > /etc/sysconfig/firstboot

## create the LiveCD default user
# add default user with no password
/usr/sbin/useradd -c "LiveMedia default user" $LIVE_USER
/usr/bin/passwd -d $LIVE_USER > /dev/null
# give default user sudo privileges
echo "$LIVE_USER     ALL=(ALL)     NOPASSWD: ALL" >> /etc/sudoers

## configure default user's desktop
# set up timed auto-login at 10 seconds
sed -i -e 's/\[daemon\]/[daemon]\nTimedLoginEnable=true\nTimedLogin=$LIVE_USER\nTimedLoginDelay=10/' /etc/gdm/custom.conf
# disable screensaver locking
gconftool-2 --direct --config-source=xml:readwrite:/etc/gconf/gconf.xml.defaults -s -t bool /apps/gnome-screensaver/lock_enabled false >/dev/null

sed -i -e "s|^STARTKDE.*|\0\nSTARTXFCE=\"\$(which startxfce4 2>/dev/null)\"/" /etc/X11/xinit/Xclients
sed -i -e "s|PREFERRED=\"\$STARTKDE.*|\0\n    elif [ \"\$DESKTOP\" = \"XFCE\" ]; then\n\tPREFERRED=\"\$STARTXFCE\"|" /etc/X11/xinit/Xclients
cat > /home/$LIVE_USER/.dmrc << EOF_dmrc
[Desktop]
Language=en_US.utf8
Session=xfce
EOF_dmrc
chown $LIVE_USER. /home/$LIVE_USER/.dmrc
cat /etc/sysconfig/desktop << EOF_sysconfig_desktop
DESKTOP=XFCE
DISPLAYMANAGER=GNOME
EOF_sysconfig_desktop

# network
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

EOF_post

/bin/bash -x /root/post-install 2>&1 | tee /root/post-install.log

echo "timeout 40;" > /etc/dhclient.conf
cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

%post --nochroot

cat > /root/postnochroot-install << EOF_postnochroot
#!/bin/bash

cp -r ./rpms ${INSTALL_ROOT}/tmp/
/usr/sbin/chroot ${INSTALL_ROOT}/ /bin/rpm -Uvh --nodeps --force /tmp/rpms/wakame-vdc-ruby-2.0.0.247.axsh0-1.x86_64.rpm /tmp/rpms/kmod-openvswitch-2.3.0-1.el6.x86_64.rpm /tmp/rpms/openvswitch-2.3.0-1.x86_64.rpm

cp -a ./net-setup ${INSTALL_ROOT}/usr/local/bin/
chmod +x ${INSTALL_ROOT}/usr/local/bin/net-setup
cp -a ./install_guide_demo_data_for_kvm.sh ${INSTALL_ROOT}/usr/local/bin/
chmod +x ${INSTALL_ROOT}/usr/local/bin/install_guide_demo_data_for_kvm.sh

mkdir -p ${INSTALL_ROOT}/var/lib/wakame-vdc/images
cp -a ./ubuntu-lucid-kvm-md-32.raw.gz ${INSTALL_ROOT}/var/lib/wakame-vdc/images/

EOF_postnochroot

/bin/bash -x /root/postnochroot-install 2>&1 | tee /root/postnochroot-install.log


