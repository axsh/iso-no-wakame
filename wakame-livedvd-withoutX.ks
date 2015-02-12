lang en_US.UTF-8
keyboard us
timezone Asia/Tokyo
auth --useshadow --enablemd5
selinux --disabled
firewall --disabled

#repo --name=base        --baseurl=http://192.168.122.1/centos/6.5/os/$basearch
#repo --name=updates     --baseurl=http://192.168.122.1/centos/6.5/updates/$basearch
#repo --name=extras      --baseurl=http://192.168.122.1/centos/6.5/extras/$basearch
#repo --name=libyaml     --baseurl=http://192.168.122.1/libyaml/
#repo --name=base        --baseurl=http://vault.centos.org/6.5/os/$basearch
#repo --name=updates     --baseurl=http://vault.centos.org/6.5/updates/$basearch
#repo --name=extras      --baseurl=http://vault.centos.org/6.5/extras/$basearch
repo --name=base        --baseurl=http://ftp.iij.ad.jp/pub/linux/centos/6.6/os/$basearch
repo --name=updates     --baseurl=http://ftp.iij.ad.jp/pub/linux/centos/6.6/updates/$basearch
repo --name=extras      --baseurl=http://ftp.iij.ad.jp/pub/linux/centos/6.6/extras/$basearch
repo --name=epel        --baseurl=http://download.fedoraproject.org/pub/epel/6/$basearch
repo --name=live        --baseurl=http://www.nanotechnologies.qc.ca/propos/linux/centos-live/$basearch/live
repo --name=wakame      --baseurl=http://dlc.wakame.axsh.jp/packages/rhel/6/master/current/
repo --name=wakame3rd   --baseurl=http://dlc.wakame.axsh.jp/packages/3rd/rhel/6/master/

services --disabled=NetworkManager,network,sshd

%pre

%packages
@base
@legacy-unix
@network-tools
@core
#-NetworkManager
-xorg-x11-drv-ati-firmware
subnetcalc
bash
kernel
syslinux
passwd
policycoreutils
chkconfig
authconfig
rootfiles
comps-extras
dhclient
livecd-tools
sudo
bridge-utils
openssh
openssh-clients
openssh-server
dnsmasq
vim-enhanced
dialog
httpd

wakame-vdc
wakame-vdc-dcmgr-vmapp-config
wakame-vdc-sta-vmapp-config
wakame-vdc-hva-common-vmapp-config
wakame-vdc-hva-kvm-vmapp-config
wakame-vdc-hva-lxc-vmapp-config
wakame-vdc-rack-config
wakame-vdc-webui-vmapp-config

%post

echo "Wakame-VDC LiveDVD release 15.02 (Final)" > /etc/redhat-release

LIVE_USER="wakame"

cat > /root/post-install << EOF_post
#!/bin/bash

# turn off firstboot for livecd boots
echo "RUN_FIRSTBOOT=NO" > /etc/sysconfig/firstboot

sed -i -e "s/^Defaults    requiretty/#Defaults    requiretty/" /etc/sudoers

## create the LiveCD default user
# add default user with no password
/usr/sbin/useradd -c "LiveMedia default user" $LIVE_USER
/usr/bin/passwd -d $LIVE_USER > /dev/null
# give default user sudo privileges
echo "$LIVE_USER     ALL=(ALL)     NOPASSWD: ALL" >> /etc/sudoers
/bin/sed -i -e "s|^\(exec /sbin/mingetty \)\(.*\)|\1 --autologin $LIVE_USER \2|" /etc/init/tty.conf

EOF_post

/bin/bash -x /root/post-install 2>&1 | tee /root/post-install.log

#echo "timeout 40;" > /etc/dhclient.conf
cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

%post --nochroot

cat > /root/postnochroot-install << EOF_postnochroot
#!/bin/bash

cp -r ./rpms ${INSTALL_ROOT}/tmp/
#/usr/sbin/chroot ${INSTALL_ROOT}/ /bin/rpm -Uvh --nodeps --force /tmp/rpms/kmod-openvswitch-2.3.0-1.el6.x86_64.rpm /tmp/rpms/openvswitch-2.3.0-1.x86_64.rpm
/usr/sbin/chroot ${INSTALL_ROOT}/ /bin/rpm -Uvh --nodeps --force /tmp/rpms/plymouth-0.8.3-27.el6.1.x86_64.rpm /tmp/rpms/plymouth-core-libs-0.8.3-27.el6.1.x86_64.rpm

cp -a ./setup_wakame-vdc.sh ${INSTALL_ROOT}/usr/local/bin/
chmod +x ${INSTALL_ROOT}/usr/local/bin/setup_wakame-vdc.sh
cp -a ./setup_wakame-vdc.hva.sh ${INSTALL_ROOT}/usr/local/bin/
chmod +x ${INSTALL_ROOT}/usr/local/bin/setup_wakame-vdc.hva.sh
cp -a ./wake-wakame-vdc ${INSTALL_ROOT}/usr/local/bin/
chmod +x ${INSTALL_ROOT}/usr/local/bin/wake-wakame-vdc

mkdir -p ${INSTALL_ROOT}/var/lib/wakame-vdc/images
cp -a ./ubuntu-lucid-kvm-md-32.raw.gz ${INSTALL_ROOT}/var/lib/wakame-vdc/images/

target=\`ls ${INSTALL_ROOT}/boot/|grep initramfs\`
target_count=0
for i in \$target; do
   target_version=\`echo \$i | sed -e "s|^initramfs-\\(.*\\).img$|\\1|"\`
   /usr/sbin/chroot ${INSTALL_ROOT}/ /sbin/dracut -f /boot/\$i \$target_version
   cp ${INSTALL_ROOT}/boot/\$i ${INSTALL_ROOT}/../iso-*/isolinux/initrd\${target_count}.img
   target_count=\$(( \$target_count + 1 ))
done
cp splash.jpg ${INSTALL_ROOT}/../iso-*/isolinux/
sed -i -e "s/ffffffff/ff00cc00/" ${INSTALL_ROOT}/../iso-*/isolinux/isolinux.cfg
sed -i -e "s/ff000000/ff008800/" ${INSTALL_ROOT}/../iso-*/isolinux/isolinux.cfg

mkdir -p ${INSTALL_ROOT}/tftpboot/{pxelinux.cfg,iso}
cp splash.jpg ${INSTALL_ROOT}/tftpboot/
cp ${INSTALL_ROOT}/usr/share/syslinux/pxelinux.0 ${INSTALL_ROOT}/tftpboot/

echo "RABBITMQ_NODE_IP_ADDRESS=0.0.0.0" >> ${INSTALL_ROOT}/etc/rabbitmq/rabbitmq-env.conf
cp etcd ${INSTALL_ROOT}/usr/local/bin/
cp etcdctl ${INSTALL_ROOT}/usr/local/bin/
chmod +x ${INSTALL_ROOT}/usr/local/bin/etcd
chmod +x ${INSTALL_ROOT}/usr/local/bin/etcdctl
cat >> ${INSTALL_ROOT}/etc/rc.local << EOF_rclocal
[[ `grep etcd_host /proc/cmdline | wc -l` -eq 0 ]] && sudo /bin/mount -o ro /dev/disk/by-label/Wakame-VDC.LiveDVD /tftpboot/iso/
sudo /usr/local/bin/etcd -listen-client-urls=http://0.0.0.0:4001 -listen-peer-urls=http://0.0.0.0:7001 > /var/log/etcd.log 2>&1 &
#sudo /usr/local/bin/wake-wakame-vdc >> /var/log/wakame-vdc.livedvd.log 2>&1
#sudo /usr/local/bin/setup_wakame-vdc.hva.sh >> /var/log/wakame-vdc.livedvd.log 2>&1
#sudo /sbin/service rabbitmq-server start >> /var/log/wakame-vdc.livedvd.log 2>&1
#sudo /sbin/service mysqld start >> /var/log/wakame-vdc.livedvd.log 2>&1
#sudo /sbin/start vdc-dcmgr >> /var/log/wakame-vdc.livedvd.log 2>&1
#sudo /sbin/start vdc-collector >> /var/log/wakame-vdc.livedvd.log 2>&1
#sudo /sbin/start vdc-hva >> /var/log/wakame-vdc.livedvd.log 2>&1
#sudo /sbin/start vdc-webui >> /var/log/wakame-vdc.livedvd.log 2>&1
EOF_rclocal

cp -a ./gems/gems/* ${INSTALL_ROOT}/opt/axsh/wakame-vdc/ruby/lib/ruby/gems/2.*/gems/
cp -a ./gems/specifications/* ${INSTALL_ROOT}/opt/axsh/wakame-vdc/ruby/lib/ruby/gems/2.*/specifications/
cp -a ./gems/cache/* ${INSTALL_ROOT}/opt/axsh/wakame-vdc/ruby/lib/ruby/gems/2.*/cache/

mkdir -p ${INSTALL_ROOT}/opt/axsh/wakame-vdc/demo.data
cp -a ./sg-demofgr.rule ${INSTALL_ROOT}/opt/axsh/wakame-vdc/demo.data/
cp -a ./pri.pem ${INSTALL_ROOT}/opt/axsh/wakame-vdc/demo.data/
chmod 400 ${INSTALL_ROOT}/opt/axsh/wakame-vdc/demo.data/pri.pem
cp -a ./pub.pem ${INSTALL_ROOT}/opt/axsh/wakame-vdc/demo.data/
chmod 400 ${INSTALL_ROOT}/opt/axsh/wakame-vdc/demo.data/pub.pem

EOF_postnochroot

/bin/bash -x /root/postnochroot-install 2>&1 | tee /root/postnochroot-install.log


