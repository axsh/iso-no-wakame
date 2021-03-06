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
repo --name=base        --baseurl=http://ftp.iij.ad.jp/pub/linux/centos/6.7/os/$basearch
repo --name=updates     --baseurl=http://ftp.iij.ad.jp/pub/linux/centos/6.7/updates/$basearch
repo --name=extras      --baseurl=http://ftp.iij.ad.jp/pub/linux/centos/6.7/extras/$basearch
repo --name=epel        --baseurl=http://download.fedoraproject.org/pub/epel/6/$basearch
#repo --name=live        --baseurl=http://www.nanotechnologies.qc.ca/propos/linux/centos-live/$basearch/live
#repo --name=wakame      --baseurl=http://dlc.wakame.axsh.jp/packages/rhel/6/master/current/
repo --name=wakame      --baseurl=http://dlc.wakame.axsh.jp/packages/rhel/6/develop/current/
repo --name=wakame3rd   --baseurl=http://dlc.wakame.axsh.jp/packages/3rd/rhel/6/master/

### begin withX
xconfig --startxonboot
#part / --size 6144 --fstype ext4
### end withX

services --disabled=NetworkManager,network,sshd

%pre

%packages
@base
@legacy-unix
@network-tools
@core
### begin withX
@basic-desktop
@fonts
@general-desktop
@graphical-admin-tools
@input-methods
@internet-applications
@internet-browser
@x11
@xfce
firefox
xkeyboard-config
### end withX
#-NetworkManager
#-xorg-x11-drv-ati-firmware
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
zenity
screen
patch
strace
ltrace
gdb

-aic94xx-firmware
-atmel-firmware
-bfa-firmware
-ipw2100-firmware
-ipw2200-firmware
-ivtv-firmware
-iwl100-firmware
-iwl1000-firmware
-iwl3945-firmware
-iwl4965-firmware
-iwl5000-firmware
-iwl5150-firmware
-iwl6000-firmware
-iwl6000g2a-firmware
-iwl6050-firmware
-libertas-usb8388-firmware
-ql2100-firmware
-ql2200-firmware
-ql23xx-firmware
-ql2400-firmware
-ql2500-firmware
-rt61pci-firmware
-rt73usb-firmware
-xorg-x11-drv-ati-firmware
-zd1211-firmware
-ModemManager
-NetworkManager
-NetworkManager-glib
-NetworkManager-gnome
-cdparanoia
-cdparanoia-libs
-cdrdao
-cups-libs
-evolution
-evolution-data-server
-evolution-help
-evolution-mapi
-ghostscript
-ghostscript-fonts
-evince
-evince-dvi
-evince-libs
-libspectre
-glusterfs
-glusterfs-api
-glusterfs-libs
-samba-common
-samba-winbind
-samba-winbind-clients
-samba4-libs
-abyssinica-fonts
-cjkuni-fonts
-cjkuni-uming-fonts
-dejavu-fonts
-dejavu-sans-fonts
-dejavu-sans-mono-fonts
-dejavu-serif-fonts
-google-crosextra-caladea-fonts
-google-crosextra-carlito-fonts
-jomolhari-fonts
-khmeros-base-fonts
-khmeros-fonts
-kurdit-unikurd-web-fonts
-liberation-fonts
-liberation-mono-fonts
-liberation-sans-fonts
-liberation-serif-fonts
-lklug-fonts
-lohit-assamese-fonts
-lohit-bengali-fonts
-lohit-devanagari-fonts
-lohit-gujarati-fonts
-lohit-kannada-fonts
-lohit-oriya-fonts
-lohit-punjabi-fonts
-lohit-tamil-fonts
-lohit-telugu-fonts
-madan-fonts
-paktype-fonts
-paktype-naqsh-fonts
-paktype-tehreer-fonts
-sil-padauk-fonts
-smc-fonts
-smc-meera-fonts
-stix-fonts
-thai-scalable-fonts
-thai-scalable-waree-fonts
-tibetan-machine-uni-fonts
-un-core-dotum-fonts
-un-core-fonts
-urw-fonts
-vlgothic-fonts
-vlgothic-fonts
-wqy-zenhei-fonts
-b43-fwcutter
-b43-openfwwf
-bind-libs
-bind-utils
-dvd+rw-tools
-brasero
-brasero-libs
-brasero-nautilus
-rhythmbox
-sound-juicer
-ekiga
-pidgin
-man
-man-pages
-man-pages-overrides
-abrt
-abrt-addon-ccpp
-abrt-addon-kerneloops
-abrt-addon-python
-abrt-cli
-abrt-libs
-abrt-tui
-cdparanoia-libs
-cheese
-gnome-applets
-gstreamer-plugins-bad-free
-gstreamer-plugins-base
-gstreamer-plugins-bood
-totem
-totem-mozplugin
-totem-nautilus
-xfce4-mixer
-compiz
-compiz-gnome
-docbook-dtds
-firstboot
-system-config-date
-system-config-date-docs
-system-config-kdump
-system-config-services
-system-config-services-docs
-system-config-users
-system-config-users-docs
-yelp
-m17n-contrib

wakame-vdc
wakame-vdc-dcmgr-vmapp-config
wakame-vdc-sta-vmapp-config
wakame-vdc-hva-common-vmapp-config
wakame-vdc-hva-kvm-vmapp-config
wakame-vdc-hva-lxc-vmapp-config
wakame-vdc-rack-config
wakame-vdc-webui-vmapp-config
wakame-vdc-client-mussel


%post

#cp -a /etc/resolv.conf /etc/resolv.conf.orig
#echo "nameserver 192.168.122.1" >> /etc/resolv.conf
echo "nameserver 157.7.180.133" >> /etc/resolv.conf
echo "nameserver 210.157.3.4" >> /etc/resolv.conf
echo "Wakame-vdc LiveDVD release 16.1 (FINAL)" > /etc/redhat-release

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
### begin withoutX
/bin/sed -i -e "s|^\(exec /sbin/mingetty \)\(.*\)|\1 --autologin $LIVE_USER \2|" /etc/init/tty.conf
### end withoutX
### begin withX
sed -i -e 's/\[daemon\]/[daemon]\nTimedLoginEnable=true\nTimedLogin=$LIVE_USER\nTimedLoginDelay=10/' /etc/gdm/custom.conf
# disable screensaver locking
gconftool-2 --direct --config-source=xml:readwrite:/etc/gconf/gconf.xml.defaults -s -t bool /apps/gnome-screensaver/lock_enabled false >/dev/null
sed -i -e "s|^STARTKDE.*|\0\nSTARTXFCE=\"\$(which startxfce4 2>/dev/null)\"/" /etc/X11/xinit/Xclients
sed -i -e "s|PREFERRED=\"\$STARTKDE.*|\0\n    elif [ \"\$DESKTOP\" = \"XFCE\" ]; then\n\tPREFERRED=\"\$STARTXFCE\"|" /etc/X11/xinit/Xclients

cat /etc/sysconfig/desktop << EOF_sysconfig_desktop
DESKTOP=XFCE
DISPLAYMANAGER=GNOME
EOF_sysconfig_desktop

cat /etc/rabbitmq/rabbitmq.config << EOF_rabbitmq_config
[
  {rabbit, [{disk_free_limit, 200000000}]}
].
EOF_rabbitmq_config



### end withX
cat /etc/resolv.conf

/opt/axsh/wakame-vdc/ruby/bin/gem install etcd
/opt/axsh/wakame-vdc/ruby/bin/gem install mixlib-log
/opt/axsh/wakame-vdc/ruby/bin/gem install rdialog
/opt/axsh/wakame-vdc/ruby/bin/gem install net-dhcp
#/opt/axsh/wakame-vdc/ruby/bin/gem install fuguta
#/opt/axsh/wakame-vdc/ruby/bin/gem install Zenity.rb

EOF_post

/bin/bash -x /root/post-install 2>&1 | tee /root/post-install.log

echo "timeout 20;" > /etc/dhclient.conf
cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

%post --nochroot

cat > /root/postnochroot-install << EOF_postnochroot
#!/bin/bash

cp -r ./rpms ${INSTALL_ROOT}/tmp/
/usr/sbin/chroot ${INSTALL_ROOT}/ /bin/rpm -Uvh --nodeps --force /tmp/rpms/kmod-openvswitch-2.3.0-1.el6.x86_64.rpm /tmp/rpms/openvswitch-2.3.0-1.x86_64.rpm
/usr/sbin/chroot ${INSTALL_ROOT}/ /bin/rpm -Uvh --nodeps --force /tmp/rpms/plymouth-0.8.3-27.el6.1.x86_64.rpm /tmp/rpms/plymouth-core-libs-0.8.3-27.el6.1.x86_64.rpm
cp -a ./WakameLiveDVDBackground0-1024x768.png ${INSTALL_ROOT}/opt/axsh/wakame-vdc/
cp -a ./WakameLiveDVDBackground1-1024x768.png ${INSTALL_ROOT}/opt/axsh/wakame-vdc/
cp -a ./WakameLiveDVDBackground2-1024x768.png ${INSTALL_ROOT}/opt/axsh/wakame-vdc/
chown root. ${INSTALL_ROOT}/opt/axsh/wakame-vdc/WakameLiveDVDBackground0-1024x768.png
chown root. ${INSTALL_ROOT}/opt/axsh/wakame-vdc/WakameLiveDVDBackground1-1024x768.png
chown root. ${INSTALL_ROOT}/opt/axsh/wakame-vdc/WakameLiveDVDBackground2-1024x768.png
chmod 644 ${INSTALL_ROOT}/opt/axsh/wakame-vdc/WakameLiveDVDBackground0-1024x768.png
chmod 644 ${INSTALL_ROOT}/opt/axsh/wakame-vdc/WakameLiveDVDBackground1-1024x768.png
chmod 644 ${INSTALL_ROOT}/opt/axsh/wakame-vdc/WakameLiveDVDBackground2-1024x768.png
ln -s /opt/axsh/wakame-vdc/WakameLiveDVDBackground2-1024x768.png ${INSTALL_ROOT}/opt/axsh/wakame-vdc/WakameLiveDVDBackground-1024x768.png
cp -a ./wallpaper4-3_A.png ${INSTALL_ROOT}/opt/axsh/wakame-vdc/
cp -a ./wallpaper4-3_B.png ${INSTALL_ROOT}/opt/axsh/wakame-vdc/
cp -a ./setup_wakame-vdc.sh ${INSTALL_ROOT}/usr/local/bin/
chown root. ${INSTALL_ROOT}/usr/local/bin/setup_wakame-vdc.sh
chmod 755 ${INSTALL_ROOT}/usr/local/bin/setup_wakame-vdc.sh
cp -a ./setup_wakame-vdc.hva.sh ${INSTALL_ROOT}/usr/local/bin/
chown root. ${INSTALL_ROOT}/usr/local/bin/setup_wakame-vdc.hva.sh
chmod 755 ${INSTALL_ROOT}/usr/local/bin/setup_wakame-vdc.hva.sh
cp -a ./wake-wakame-vdc ${INSTALL_ROOT}/usr/local/bin/
chmod +x ${INSTALL_ROOT}/usr/local/bin/wake-wakame-vdc
cp -a ./zenity-progress-conditioner.rb ${INSTALL_ROOT}/usr/local/bin/
chmod +x ${INSTALL_ROOT}/usr/local/bin/zenity-progress-conditioner.rb
cp -a ./add_hosts.sh ${INSTALL_ROOT}/usr/local/bin/
chown root. ${INSTALL_ROOT}/usr/local/bin/add_hosts.sh
chmod 755 ${INSTALL_ROOT}/usr/local/bin/add_hosts.sh

mkdir -p ${INSTALL_ROOT}/var/lib/wakame-vdc/images
#cp -a ./centos-6.6.x86_64.lxc.md.raw.gz ${INSTALL_ROOT}/var/lib/wakame-vdc/images/
#cp -a ./ubuntu-lucid-kvm-md-32.raw.gz ${INSTALL_ROOT}/var/lib/wakame-vdc/images/
cp -a ./ubuntu-14.04.3-x86_64-30g-passwd-login-enabled.raw.gz ${INSTALL_ROOT}/var/lib/wakame-vdc/images/
sed -i 's/512\*1024/512\*1024\*4/' ${INSTALL_ROOT}/usr/share/dracut/modules.d/90dmsquash-live/dmsquash-live-root

target=\`ls ${INSTALL_ROOT}/boot/|grep initramfs\`
target_count=0
for i in \$target; do
   target_version=\`echo \$i | sed -e "s|^initramfs-\\(.*\\).img$|\\1|"\`
   /usr/sbin/chroot ${INSTALL_ROOT}/ /sbin/dracut -f -I /sbin/busybox /boot/\$i \$target_version
   cp ${INSTALL_ROOT}/boot/\$i ${INSTALL_ROOT}/../iso-*/isolinux/initrd\${target_count}.img
   target_count=\$(( \$target_count + 1 ))
done
cp splash.jpg ${INSTALL_ROOT}/../iso-*/isolinux/
sed -i -e "s/ffffffff/ff2da94f/" ${INSTALL_ROOT}/../iso-*/isolinux/isolinux.cfg
sed -i -e "s/ff000000/ff2d654f/" ${INSTALL_ROOT}/../iso-*/isolinux/isolinux.cfg
cat >> ${INSTALL_ROOT}/../iso-*/isolinux/isolinux.cfg << EOF_isolinux
label linux0
  menu label Auto_boxes
  kernel vmlinuz0
  append initrd=initrd0.img root=live:CDLABEL=Wakame-vdc.LiveDVD rootfstype=auto ro liveimg quiet  rhgb rd_NO_LUKS rd_NO_MD rd_NO_DM mode=auto_boxes
label linux0
  menu label Manual_1box
  kernel vmlinuz0
  append initrd=initrd0.img root=live:CDLABEL=Wakame-vdc.LiveDVD rootfstype=auto ro liveimg quiet  rhgb rd_NO_LUKS rd_NO_MD rd_NO_DM mode=manual_1box
label linux0
  menu label Manual_boxes
  kernel vmlinuz0
  append initrd=initrd0.img root=live:CDLABEL=Wakame-vdc.LiveDVD rootfstype=auto ro liveimg quiet  rhgb rd_NO_LUKS rd_NO_MD rd_NO_DM mode=manual_boxes
EOF_isolinux


mkdir -p ${INSTALL_ROOT}/tftpboot/{pxelinux.cfg,iso}
cp splash.jpg ${INSTALL_ROOT}/tftpboot/
cp ${INSTALL_ROOT}/usr/share/syslinux/pxelinux.0 ${INSTALL_ROOT}/tftpboot/

echo "RABBITMQ_NODE_IP_ADDRESS=0.0.0.0" >> ${INSTALL_ROOT}/etc/rabbitmq/rabbitmq-env.conf
cat >> ${INSTALL_ROOT}/etc/rabbitmq/rabbitmq.config << EOF_rabbitmq_config
[
  {rabbit, [{disk_free_limit, 100000000}]}
].
EOF_rabbitmq_config

cp etcd ${INSTALL_ROOT}/usr/local/bin/
cp etcdctl ${INSTALL_ROOT}/usr/local/bin/
cp stone ${INSTALL_ROOT}/usr/local/bin/
chmod +x ${INSTALL_ROOT}/usr/local/bin/etcd
chmod +x ${INSTALL_ROOT}/usr/local/bin/etcdctl
chmod +x ${INSTALL_ROOT}/usr/local/bin/stone
cat >> ${INSTALL_ROOT}/etc/rc.local << EOF_rclocal
if [[ \\\`grep etcd_host /proc/cmdline | wc -l\\\` -eq 0 ]]; then
   if [[ \\\`grep boxes /proc/cmdline | wc -l\\\` -ne 0 ]]; then
      #sudo /bin/mount -o ro /dev/disk/by-label/Wakame-vdc.LiveDVD /tftpboot/iso/
      #sudo dd if=/dev/sr0 of=/dev/shm/Wakame-vdc.LiveDVD.iso
      sudo dd if=/dev/sr0 of=/tmp/Wakame-vdc.LiveDVD.iso
      cd /dev/shm/
      sudo /usr/bin/livecd-iso-to-pxeboot /tmp/Wakame-vdc.LiveDVD.iso
      sudo rm -f /tmp/Wakame-vdc.LiveDVD.iso
      cd /tftpboot/
      ln -s /dev/shm/tftpboot/vmlinuz0
      ln -s /dev/shm/tftpboot/initrd0.img
   fi
   sudo /usr/local/bin/etcd -listen-client-urls=http://0.0.0.0:4001 -listen-peer-urls=http://0.0.0.0:7001 > /var/log/etcd.log 2>&1 &
   sudo echo 1 > /proc/sys/net/ipv4/ip_forward
else
   sudo mkdir -p /var/lib/dhclient/
   sudo /usr/sbin/brctl addbr br0
   sudo /usr/sbin/brctl addif br0 eth0
   sudo /sbin/dhclient -1 -q -lf /var/lib/dhclient/dhclient-br0.leases -pf /var/run/dhclient-br0.pid br0 >> /var/log/wakame-vdc.livedvd.log 2>&1 &
   sudo /sbin/ifconfig eth0 0.0.0.0 up >> /var/log/wakame-vdc.livedvd.log 2>&1 &
   sleep 20
   sudo /usr/local/bin/setup_wakame-vdc.hva.sh >> /var/log/wakame-vdc.livedvd.log 2>&1 &
   /usr/local/bin/add_hosts.sh
   exit 0
fi
if [[ 1 -eq \\\`grep manual_1box /proc/cmdline | wc -l\\\` ]]; then
   cp /opt/axsh/wakame-vdc/demo.data/manual_1box_launcher /home/wakame/Desktop/WakeWakamevdc.desktop
elif [[ 1 -eq \\\`grep manual_boxes /proc/cmdline | wc -l\\\` ]]; then
   cp /opt/axsh/wakame-vdc/demo.data/manual_boxes_launcher /home/wakame/Desktop/WakeWakamevdc.desktop
elif [[ 1 -eq \\\`grep auto_boxes /proc/cmdline | wc -l\\\` ]]; then
   cp /opt/axsh/wakame-vdc/demo.data/auto_boxes_launcher /home/wakame/Desktop/WakeWakamevdc.desktop
else
   sudo /usr/local/bin/wake-wakame-vdc auto_1box >> /var/log/wakame-vdc.livedvd.log 2>&1
fi
/usr/local/bin/add_hosts.sh
mkdir -p /lxc/cgroup
mount -t cgroup lxc /lxc/cgroup
EOF_rclocal

#cp -a ./gems/gems/* ${INSTALL_ROOT}/opt/axsh/wakame-vdc/ruby/lib/ruby/gems/2.*/gems/
#cp -a ./gems/specifications/* ${INSTALL_ROOT}/opt/axsh/wakame-vdc/ruby/lib/ruby/gems/2.*/specifications/
#cp -a ./gems/cache/* ${INSTALL_ROOT}/opt/axsh/wakame-vdc/ruby/lib/ruby/gems/2.*/cache/

mkdir -p ${INSTALL_ROOT}/opt/axsh/wakame-vdc/demo.data
cp -a ./sg-demofgr.rule ${INSTALL_ROOT}/opt/axsh/wakame-vdc/demo.data/
cp -a ./pri.pem ${INSTALL_ROOT}/opt/axsh/wakame-vdc/demo.data/
chmod 400 ${INSTALL_ROOT}/opt/axsh/wakame-vdc/demo.data/pri.pem
cp -a ./pub.pem ${INSTALL_ROOT}/opt/axsh/wakame-vdc/demo.data/
chmod 400 ${INSTALL_ROOT}/opt/axsh/wakame-vdc/demo.data/pub.pem
cp -a ./manual_1box_launcher ${INSTALL_ROOT}/opt/axsh/wakame-vdc/demo.data/
chown root. ${INSTALL_ROOT}/opt/axsh/wakame-vdc/demo.data/manual_1box_launcher
cp -a ./manual_boxes_launcher ${INSTALL_ROOT}/opt/axsh/wakame-vdc/demo.data/
chown root. ${INSTALL_ROOT}/opt/axsh/wakame-vdc/demo.data/manual_boxes_launcher
cp -a ./auto_boxes_launcher ${INSTALL_ROOT}/opt/axsh/wakame-vdc/demo.data/
chown root. ${INSTALL_ROOT}/opt/axsh/wakame-vdc/demo.data/auto_boxes_launcher
#sed -i -e "s|lxc-create -f|lxc-create -t /bin/true -f|" ${INSTALL_ROOT}/opt/axsh/wakame-vdc/dcmgr/lib/dcmgr/drivers/hypervisor/linux_hypervisor/linux_container/lxc.rb

mv ${INSTALL_ROOT}/etc/resolv.conf.orig ${INSTALL_ROOT}/etc/resolv.conf

### begin withX
cp -r ./fonts/yutapon_coding ${INSTALL_ROOT}/usr/share/fonts/
cp -r ./fonts/yutaCo2 ${INSTALL_ROOT}/usr/share/fonts/

cp -r ./MacOS-X ${INSTALL_ROOT}/usr/share/themes/

cp icons/16x16.wakamevdc-logo.png ${INSTALL_ROOT}/usr/share/icons/gnome/16x16/apps/wakamevdc-logo.png
cp icons/22x22.wakamevdc-logo.png ${INSTALL_ROOT}/usr/share/icons/gnome/22x22/apps/wakamevdc-logo.png
cp icons/24x24.wakamevdc-logo.png ${INSTALL_ROOT}/usr/share/icons/gnome/24x24/apps/wakamevdc-logo.png
cp icons/32x32.wakamevdc-logo.png ${INSTALL_ROOT}/usr/share/icons/gnome/32x32/apps/wakamevdc-logo.png
cp icons/48x48.wakamevdc-logo.png ${INSTALL_ROOT}/usr/share/icons/gnome/48x48/apps/wakamevdc-logo.png

cp ./home/wakame/.dmrc ${INSTALL_ROOT}/home/wakame/
cp -r ./home/wakame/.config ${INSTALL_ROOT}/home/wakame/
/usr/sbin/chroot ${INSTALL_ROOT}/ chown wakame. /home/wakame/.dmrc
/usr/sbin/chroot ${INSTALL_ROOT}/ chown wakame. -R /home/wakame/.config
mkdir -p ${INSTALL_ROOT}/home/wakame/Desktop
cp ./README.desktop ${INSTALL_ROOT}/home/wakame/Desktop/
/usr/sbin/chroot ${INSTALL_ROOT}/ chown wakame. -R /home/wakame/Desktop
#cp ./fix-lxc-driver.patch ${INSTALL_ROOT}/opt/axsh/wakame-vdc/
cp ./muscle-training.sh ${INSTALL_ROOT}/opt/axsh/wakame-vdc/
cp ./vifs.json ${INSTALL_ROOT}/opt/axsh/wakame-vdc/
#cd ${INSTALL_ROOT}/opt/axsh/wakame-vdc/
#patch -p1 < ./fix-lxc-driver.patch
#cd -
#sed -e "s/^-A INPUT .*//" ${INSTALL_ROOT}/etc/sysconfig/iptables
mv ${INSTALL_ROOT}/opt/axsh/wakame-vdc/dcmgr/vendor ${INSTALL_ROOT}/opt/axsh/wakame-vdc/dcmgr/vendor.orig
cp -r /mnt/livecd/livedvd/wakame-vdc/dcmgr/vendor ${INSTALL_ROOT}/opt/axsh/wakame-vdc/dcmgr
cd ${INSTALL_ROOT}/opt/axsh/wakame-vdc/dcmgr
/usr/sbin/chroot ${INSTALL_ROOT} /opt/axsh/wakame-vdc/ruby/bin/bundle install
cd -

### end withX

rm -rf ${INSTALL_ROOT}/usr/share/{doc,man,info}

EOF_postnochroot

/bin/bash -x /root/postnochroot-install 2>&1 | tee /root/postnochroot-install.log

#for i in `find ${INSTALL_ROOT}/bin/ ${INSTALL_ROOT}/usr/ ${INSTALL_ROOT}/opt/ -type f`; do
#A=`file $i | cut -d':' -f2 | grep archive`
#if [[ ! -z $A ]]; then
#  strip -S $i
#fi
#B=`file $i | cut -d':' -f2 | grep "not stripped"`
#if [[ ! -z $B ]]; then
#  C=`echo $i | grep lib`
#  if [[ ! -z $C ]]; then
#    strip -S $i
#  else
#    strip $i
#  fi
#fi
#done

