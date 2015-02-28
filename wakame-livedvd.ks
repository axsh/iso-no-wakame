lang en_US.UTF-8
keyboard us
#network --device eth0 --onboot yes --bridge br0
#network --device br0 --onboot yes --bootproto static --type bridge --ip 192.168.100.10 --netmask 255.255.0.0 --gateway 192.168.1.1 --hostname wakame-vdc-live
#network --device br0 --onboot yes --bootproto static --ip 10.0.2.15 --netmask 255.255.255.0 --gateway 10.0.2.2 --hostname wakame-vdc-live
timezone Asia/Tokyo
auth --useshadow --enablemd5
selinux --disabled
firewall --disabled

#repo --name=base        --baseurl=http://ftp.iij.ad.jp/pub/linux/centos/6.5/os/$basearch
#repo --name=updates     --baseurl=http://ftp.iij.ad.jp/pub/linux/centos/6.5/updates/$basearch
#repo --name=extras      --baseurl=http://ftp.iij.ad.jp/pub/linux/centos/6.5/extras/$basearch
repo --name=base        --baseurl=http://192.168.122.1/centos/6.5/os/$basearch
repo --name=updates     --baseurl=http://192.168.122.1/centos/6.5/updates/$basearch
repo --name=extras      --baseurl=http://192.168.122.1/centos/6.5/extras/$basearch
repo --name=epel        --baseurl=http://download.fedoraproject.org/pub/epel/6/$basearch
repo --name=libyaml     --baseurl=http://192.168.122.1/libyaml/
repo --name=live        --baseurl=http://www.nanotechnologies.qc.ca/propos/linux/centos-live/$basearch/live
repo --name=wakame      --baseurl=http://dlc.wakame.axsh.jp/packages/rhel/6/master/current/
repo --name=wakame3rd   --baseurl=http://dlc.wakame.axsh.jp/packages/3rd/rhel/6/master/
#repo --name=openvz-utils        --baseurl=http://dlc.wakame.axsh.jp/mirror/openvz/current/
#repo --name=openvz-kernel-rhel6 --baseurl=http://dlc.wakame.axsh.jp/mirror/openvz/kernel/branches/rhel6-2.6.32/042stab055.16/
#repo --name=wakameplus  --baseurl=file:///root/livedvd/dlc.openvnet.axsh.jp/packages/rhel/openvswitch/

xconfig --startxonboot
part / --size 6144 --fstype ext4
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
#@legacy-x-base
@core
@japanese-support
@xfce
-NetworkManager
subnetcalc
gdm
firefox
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
openssh
openssh-clients
openssh-server
vim-enhanced

#libyaml

#kmod-openvswitch
#openvswitch

#wakame-vdc-example-1box-full-vmapp-config
#wakame-vdc-example-1box-dcmgr-vmapp-config
#wakame-vdc-example-1box-proxy-vmapp-config
#wakame-vdc-example-1box-webui-vmapp-config
#wakame-vdc-example-1box-nsa-vmapp-config
#wakame-vdc-example-1box-sta-vmapp-config
#wakame-vdc-example-1box-hva-vmapp-config
#wakame-vdc-example-1box-admin-vmapp-config
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

#rpm -Uvh --force --nodeps http://dlc.wakame.axsh.jp/packages/3rd/rhel/6/master/wakame-vdc-ruby-2.0.0.247.axsh0-1.x86_64.rpm
#rpm -Uvh --force --nodeps http://dlc.openvnet.axsh.jp/packages/rhel/openvswitch/6.5/kmod-openvswitch-2.3.0-1.el6.x86_64.rpm
#rpm -Uvh --force --nodeps http://dlc.openvnet.axsh.jp/packages/rhel/openvswitch/6.5/openvswitch-2.3.0-1.x86_64.rpm
#yum -y install libyaml

# set the LiveMedia hostname
#sed -i -e 's/HOSTNAME=localhost.localdomain/HOSTNAME=wakame-vdc.live.example.com/g' /etc/sysconfig/network
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
<!--
  Default values for the X settings registry as described in
  http://www.freedesktop.org/wiki/Specifications/XSettingsRegistry
-->

<?xml version="1.0" encoding="UTF-8"?>
<channel name="xsettings" version="1.0">
  <property name="Net" type="empty">
    <property name="ThemeName" type="MacOS-X"/>
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
    <!-- <property name="Lcdfilter" type="string" value="none"/> -->
  </property>
  <property name="Gtk" type="empty">
    <property name="CanChangeAccels" type="bool" value="false"/>
    <property name="ColorPalette" type="string" value="black:white:gray50:red:purple:blue:light blue:green:yellow:orange:lavender:brown:goldenrod4:dodger blue:pink:light green:gray10:gray30:gray75:gray90"/>
    <property name="FontName" type="string" value="Yutapon coding RegularBackslash 9"/>
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

chown ${LIVE_USER}. -R /home/$LIVE_USER/.config

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

#sed -i -e 's/^id:3:/id:5:/' /etc/inittab

EOF_post

/bin/bash -x /root/post-install 2>&1 | tee /root/post-install.log

echo "timeout 40;" > /etc/dhclient.conf
cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

%post --nochroot

cat > /root/postnochroot-install << EOF_postnochroot
#!/bin/bash

/usr/sbin/chroot ${INSTALL_ROOT}/ /bin/rpm -qa | grep libyaml

cp -r ./rpms ${INSTALL_ROOT}/tmp/
#/usr/sbin/chroot ${INSTALL_ROOT}/ /bin/rpm -Uvh --nodeps --force /tmp/rpms/wakame-vdc-ruby-2.0.0.247.axsh0-1.x86_64.rpm /tmp/rpms/kmod-openvswitch-2.3.0-1.el6.x86_64.rpm /tmp/rpms/openvswitch-2.3.0-1.x86_64.rpm
/usr/sbin/chroot ${INSTALL_ROOT}/ /bin/rpm -Uvh --nodeps --force /tmp/rpms/kmod-openvswitch-2.3.0-1.el6.x86_64.rpm /tmp/rpms/openvswitch-2.3.0-1.x86_64.rpm
#/usr/sbin/chroot ${INSTALL_ROOT}/ /bin/rpm -Uvh --nodeps --force /tmp/rpms/wakame-vdc-ruby-2.0.0.247.axsh0-1.x86_64.rpm /tmp/rpms/kmod-openvswitch-2.3.0-1.el6.x86_64.rpm /tmp/rpms/openvswitch-2.3.0-1.x86_64.rpm /tmp/rpms/libyaml-0.1.6-1.el6.x86_64.rpm
#yum --installroot=${INSTALL_ROOT}/ --disablerepo=\* --skip-broken localinstall ./rpms/wakame-vdc-ruby-* ./rpms/kmod-openvswitch-* ./rpms/openvswitch-*

cp -r ./fonts/yutapon_coding ${INSTALL_ROOT}/usr/share/fonts/
cp -r ./fonts/yutaCo2 ${INSTALL_ROOT}/usr/share/fonts/

cp -a ./net-setup ${INSTALL_ROOT}/usr/local/bin/
chmod +x ${INSTALL_ROOT}/usr/local/bin/net-setup
cp -a ./install_guide_demo_data_for_kvm.sh ${INSTALL_ROOT}/usr/local/bin/
chmod +x ${INSTALL_ROOT}/usr/local/bin/install_guide_demo_data_for_kvm.sh

mkdir -p ${INSTALL_ROOT}/var/lib/wakame-vdc/images
cp -a ./ubuntu-lucid-kvm-md-32.raw.gz ${INSTALL_ROOT}/var/lib/wakame-vdc/images/

cp -r ./MacOS-X ${INSTALL_ROOT}/usr/share/themes/

EOF_postnochroot

/bin/bash -x /root/postnochroot-install 2>&1 | tee /root/postnochroot-install.log


