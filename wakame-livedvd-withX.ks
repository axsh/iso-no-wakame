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

### begin withX
xconfig --startxonboot
part / --size 6144 --fstype ext4
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

wakame-vdc
wakame-vdc-dcmgr-vmapp-config
wakame-vdc-sta-vmapp-config
wakame-vdc-hva-common-vmapp-config
wakame-vdc-hva-kvm-vmapp-config
wakame-vdc-hva-lxc-vmapp-config
wakame-vdc-rack-config
wakame-vdc-webui-vmapp-config


%post

cp -a /etc/resolv.conf /etc/resolv.conf.orig
echo "nameserver 192.168.122.1" >> /etc/resolv.conf
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
### begin withoutX
/bin/sed -i -e "s|^\(exec /sbin/mingetty \)\(.*\)|\1 --autologin $LIVE_USER \2|" /etc/init/tty.conf
### end withoutX
### begin withX
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

mkdir -p /home/$LIVE_USER/.config/Terminal
cat > /home/$LIVE_USER/.config/Terminal/terminalrc << EOF_terminalrc
[Configuration]
MiscAlwaysShowTabs=FALSE
MiscBell=FALSE
MiscBordersDefault=TRUE
MiscCursorBlinks=FALSE
MiscCursorShape=TERMINAL_CURSOR_SHAPE_BLOCK
MiscDefaultGeometry=80x24
MiscInheritGeometry=FALSE
MiscMenubarDefault=TRUE
MiscMouseAutohide=FALSE
MiscToolbarsDefault=TRUE
MiscConfirmClose=TRUE
MiscCycleTabs=TRUE
MiscTabCloseButtons=TRUE
MiscTabCloseMiddleClick=TRUE
MiscTabPosition=GTK_POS_TOP
MiscHighlightUrls=TRUE
FontName=Yutapon coding RegularBackslash 12
EOF_terminalrc

mkdir -p /home/$LIVE_USER/.config/xfce4/xfconf/xfce-perchannel-xml
cat > /home/$LIVE_USER/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml << EOF_xfwm4
<?xml version="1.0" encoding="UTF-8"?>

<channel name="xfwm4" version="1.0">
  <property name="general" type="empty">
    <property name="activate_action" type="string" value="bring"/>
    <property name="borderless_maximize" type="bool" value="true"/>
    <property name="box_move" type="bool" value="false"/>
    <property name="box_resize" type="bool" value="false"/>
    <property name="button_layout" type="string" value="O|SHMC"/>
    <property name="button_offset" type="int" value="0"/>
    <property name="button_spacing" type="int" value="0"/>
    <property name="click_to_focus" type="bool" value="true"/>
    <property name="focus_delay" type="int" value="250"/>
    <property name="cycle_apps_only" type="bool" value="false"/>
    <property name="cycle_draw_frame" type="bool" value="true"/>
    <property name="cycle_hidden" type="bool" value="true"/>
    <property name="cycle_minimum" type="bool" value="true"/>
    <property name="cycle_workspaces" type="bool" value="false"/>
    <property name="double_click_time" type="int" value="250"/>
    <property name="double_click_distance" type="int" value="5"/>
    <property name="double_click_action" type="string" value="maximize"/>
    <property name="easy_click" type="string" value="Alt"/>
    <property name="focus_hint" type="bool" value="true"/>
    <property name="focus_new" type="bool" value="true"/>
    <property name="frame_opacity" type="int" value="100"/>
    <property name="full_width_title" type="bool" value="true"/>
    <property name="inactive_opacity" type="int" value="100"/>
    <property name="maximized_offset" type="int" value="0"/>
    <property name="move_opacity" type="int" value="100"/>
    <property name="placement_ratio" type="int" value="20"/>
    <property name="placement_mode" type="string" value="center"/>
    <property name="popup_opacity" type="int" value="100"/>
    <property name="mousewheel_rollup" type="bool" value="true"/>
    <property name="prevent_focus_stealing" type="bool" value="false"/>
    <property name="raise_delay" type="int" value="250"/>
    <property name="raise_on_click" type="bool" value="true"/>
    <property name="raise_on_focus" type="bool" value="false"/>
    <property name="raise_with_any_button" type="bool" value="true"/>
    <property name="repeat_urgent_blink" type="bool" value="false"/>
    <property name="resize_opacity" type="int" value="100"/>
    <property name="restore_on_move" type="bool" value="true"/>
    <property name="scroll_workspaces" type="bool" value="true"/>
    <property name="shadow_delta_height" type="int" value="0"/>
    <property name="shadow_delta_width" type="int" value="0"/>
    <property name="shadow_delta_x" type="int" value="0"/>
    <property name="shadow_delta_y" type="int" value="-3"/>
    <property name="shadow_opacity" type="int" value="50"/>
    <property name="show_app_icon" type="bool" value="false"/>
    <property name="show_dock_shadow" type="bool" value="true"/>
    <property name="show_frame_shadow" type="bool" value="false"/>
    <property name="show_popup_shadow" type="bool" value="false"/>
    <property name="snap_resist" type="bool" value="false"/>
    <property name="snap_to_border" type="bool" value="true"/>
    <property name="snap_to_windows" type="bool" value="false"/>
    <property name="snap_width" type="int" value="10"/>
    <property name="theme" type="string" value="Agua"/>
    <property name="tile_on_move" type="bool" value="true"/>
    <property name="title_alignment" type="string" value="center"/>
    <property name="title_font" type="string" value="Yutapon coding RegularBackslash 9"/>
    <property name="title_horizontal_offset" type="int" value="0"/>
    <property name="title_shadow_active" type="string" value="false"/>
    <property name="title_shadow_inactive" type="string" value="false"/>
    <property name="title_vertical_offset_active" type="int" value="0"/>
    <property name="title_vertical_offset_inactive" type="int" value="0"/>
    <property name="toggle_workspaces" type="bool" value="false"/>
    <property name="unredirect_overlays" type="bool" value="true"/>
    <property name="urgent_blink" type="bool" value="false"/>
    <property name="use_compositing" type="bool" value="false"/>
    <property name="workspace_count" type="int" value="4"/>
    <property name="wrap_cycle" type="bool" value="true"/>
    <property name="workspace_names" type="array">
      <value type="string" value="Workspace 1"/>
      <value type="string" value="Workspace 2"/>
      <value type="string" value="Workspace 3"/>
      <value type="string" value="Workspace 4"/>
    </property>
    <property name="wrap_layout" type="bool" value="true"/>
    <property name="wrap_resistance" type="int" value="10"/>
    <property name="wrap_windows" type="bool" value="true"/>
    <property name="wrap_workspaces" type="bool" value="false"/>
  </property>
</channel>
EOF_xfwm4

cat > /home/$LIVE_USER/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml << EOF_xsettings
<?xml version="1.0" encoding="UTF-8"?>

<channel name="xsettings" version="1.0">
  <property name="Net" type="empty">
    <property name="ThemeName" type="string" value="MacOS-X"/>
    <property name="IconThemeName" type="Gant.Xfce"/>
    <property name="DoubleClickTime" type="int" value="250"/>
    <property name="DoubleClickDistance" type="int" value="5"/>
    <property name="DndDragThreshold" type="int" value="8"/>
    <property name="CursorBlink" type="bool" value="true"/>
    <property name="CursorBlinkTime" type="int" value="1200"/>
    <property name="SoundThemeName" type="string" value="default"/>
    <property name="EnableEventSounds" type="bool" value="false"/>
    <property name="EnableInputFeedbackSounds" type="bool" value="false"/>
  </property>
  <property name="Xft" type="empty">
    <property name="DPI" type="empty"/>
    <property name="Antialias" type="int" value="-1"/>
    <property name="Hinting" type="int" value="-1"/>
    <property name="HintStyle" type="string" value="hintnone"/>
    <property name="RGBA" type="string" value="none"/>
  </property>
  <property name="Gtk" type="empty">
    <property name="CanChangeAccels" type="bool" value="false"/>
    <property name="ColorPalette" type="string" value="black:white:gray50:red:purple:blue:light blue:green:yellow:orange:lavender:brown:goldenrod4:dodger blue:pink:light green:gray10:gray30:gray75:gray90"/>
    <property name="FontName" type="string" value="Yutapon coding Heavy Sl 10"/>
    <property name="IconSizes" type="string" value=""/>
    <property name="KeyThemeName" type="string" value=""/>
    <property name="ToolbarStyle" type="string" value="icons"/>
    <property name="ToolbarIconSize" type="int" value="3"/>
    <property name="IMPreeditStyle" type="string" value=""/>
    <property name="IMStatusStyle" type="string" value=""/>
    <property name="MenuImages" type="bool" value="true"/>
    <property name="ButtonImages" type="bool" value="true"/>
    <property name="MenuBarAccel" type="string" value="F10"/>
    <property name="CursorThemeName" type="string" value=""/>
    <property name="CursorThemeSize" type="int" value="0"/>
    <property name="IMModule" type="string" value=""/>
  </property>
</channel>
EOF_xsettings

cat > /home/$LIVE_USER/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml << EOF_xfce4panel
<?xml version="1.0" encoding="UTF-8"?>

<channel name="xfce4-panel" version="1.0">
  <property name="panels" type="uint" value="2">
    <property name="panel-0" type="empty">
      <property name="position" type="string" value="p=6;x=0;y=0"/>
      <property name="length" type="uint" value="100"/>
      <property name="position-locked" type="bool" value="true"/>
      <property name="plugin-ids" type="array">
        <value type="int" value="1"/>
        <value type="int" value="2"/>
        <value type="int" value="3"/>
        <value type="int" value="4"/>
        <value type="int" value="5"/>
        <value type="int" value="6"/>
        <value type="int" value="15"/>
      </property>
    </property>
    <property name="panel-1" type="empty">
      <property name="position" type="string" value="p=10;x=0;y=0"/>
      <property name="size" type="uint" value="40"/>
      <property name="position-locked" type="bool" value="true"/>
      <property name="plugin-ids" type="array">
        <value type="int" value="7"/>
        <value type="int" value="8"/>
        <value type="int" value="9"/>
        <value type="int" value="10"/>
        <value type="int" value="11"/>
        <value type="int" value="12"/>
        <value type="int" value="13"/>
        <value type="int" value="14"/>
      </property>
    </property>
  </property>
  <property name="plugins" type="empty">
    <property name="plugin-1" type="string" value="applicationsmenu"/>
    <property name="plugin-2" type="string" value="actions"/>
    <property name="plugin-3" type="string" value="tasklist"/>
    <property name="plugin-4" type="string" value="pager"/>
    <property name="plugin-5" type="string" value="clock"/>
    <property name="plugin-6" type="string" value="systray">
      <property name="names-visible" type="array">
        <value type="string" value="gnome-power-manager"/>
        <value type="string" value="networkmanager applet"/>
        <value type="string" value="gnome-volume-control-applet"/>
      </property>
    </property>
    <property name="plugin-15" type="string" value="xfce4-mixer-plugin"/>
    <property name="plugin-7" type="string" value="showdesktop"/>
    <property name="plugin-8" type="string" value="separator">
      <property name="style" type="uint" value="1"/>
    </property>
    <property name="plugin-9" type="string" value="launcher">
      <property name="items" type="array">
        <value type="string" value="14245876745.desktop"/>
      </property>
    </property>
    <property name="plugin-10" type="string" value="launcher">
      <property name="items" type="array">
        <value type="string" value="14245876746.desktop"/>
      </property>
    </property>
    <property name="plugin-11" type="string" value="launcher">
      <property name="items" type="array">
        <value type="string" value="14245876747.desktop"/>
      </property>
    </property>
    <property name="plugin-12" type="string" value="launcher">
      <property name="items" type="array">
        <value type="string" value="14245876758.desktop"/>
      </property>
    </property>
    <property name="plugin-13" type="string" value="separator">
      <property name="style" type="uint" value="1"/>
    </property>
    <property name="plugin-14" type="string" value="directorymenu">
      <property name="base-directory" type="string" value="/home/wakame"/>
    </property>
  </property>
</channel>
EOF_xfce4panel
rm -f /home/$LIVE_USER/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml
chown ${LIVE_USER}. -R /home/$LIVE_USER/.config
mkdir -p /home/$LIVE_USER/Desktop
cat > /home/$LIVE_USER/Desktop/Wakame-VDC.WebUI.desktop << EOF_webuiurl
[Desktop Entry]
Version=1.0
Type=Link
Name=Wakame-VDC WebUI
Comment=
Icon=gnome-fs-bookmark
URL=http://127.0.0.1:9000
EOF_webuiurl
chown ${LIVE_USER}. -R /home/$LIVE_USER/Desktop

### end withX

/opt/axsh/wakame-vdc/ruby/bin/gem install etcd
/opt/axsh/wakame-vdc/ruby/bin/gem install mixlib-log
/opt/axsh/wakame-vdc/ruby/bin/gem install rdialog

EOF_post

/bin/bash -x /root/post-install 2>&1 | tee /root/post-install.log

#echo "timeout 40;" > /etc/dhclient.conf
cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

%post --nochroot

cat > /root/postnochroot-install << EOF_postnochroot
#!/bin/bash

cp -r ./rpms ${INSTALL_ROOT}/tmp/
/usr/sbin/chroot ${INSTALL_ROOT}/ /bin/rpm -Uvh --nodeps --force /tmp/rpms/kmod-openvswitch-2.3.0-1.el6.x86_64.rpm /tmp/rpms/openvswitch-2.3.0-1.x86_64.rpm
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
cp stone ${INSTALL_ROOT}/usr/local/bin/
chmod +x ${INSTALL_ROOT}/usr/local/bin/etcd
chmod +x ${INSTALL_ROOT}/usr/local/bin/etcdctl
chmod +x ${INSTALL_ROOT}/usr/local/bin/stone
cat >> ${INSTALL_ROOT}/etc/rc.local << EOF_rclocal
[[ `grep etcd_host /proc/cmdline | wc -l` -eq 0 ]] && sudo /bin/mount -o ro /dev/disk/by-label/Wakame-VDC.LiveDVD /tftpboot/iso/
sudo /usr/local/bin/etcd -listen-client-urls=http://0.0.0.0:4001 -listen-peer-urls=http://0.0.0.0:7001 > /var/log/etcd.log 2>&1 &
sudo /usr/local/bin/wake-wakame-vdc >> /var/log/wakame-vdc.livedvd.log 2>&1
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

mv ${INSTALL_ROOT}/etc/resolv.conf.orig ${INSTALL_ROOT}/etc/resolv.conf

### begin withX
cp -r ./fonts/yutapon_coding ${INSTALL_ROOT}/usr/share/fonts/
cp -r ./fonts/yutaCo2 ${INSTALL_ROOT}/usr/share/fonts/

cp -r ./MacOS-X ${INSTALL_ROOT}/usr/share/themes/

### end withX

EOF_postnochroot

/bin/bash -x /root/postnochroot-install 2>&1 | tee /root/postnochroot-install.log


