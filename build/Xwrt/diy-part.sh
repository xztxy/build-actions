
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# Modify default IP
#sed -i 's/192.168.1.1/192.168.15.1/g' package/base-files/luci2/bin/config_generate
#
########### 设置密码为空（可选） ###########
#sed -i 's@.*CYXluq4wUazHjmCDBCqXF*@#&@g' package/lean/default-settings/files/zzz-default-settings

# 交换LAN/WAN口
sed -i 's/"eth1 eth2" "eth0"/"eth0 eth1 eth2" "eth3"/g' target/linux/x86/base-files/etc/board.d/02_network
sed -i "s/'eth1 eth2' 'eth0'/'eth0 eth1 eth2' 'eth3'/g" target/linux/x86/base-files/etc/board.d/02_network
#sed -i "s/lan 'eth0'/lan 'eth0 eth1 eth2'/g" package/base-files/files/etc/board.d/99-default_network
#sed -i "s/wan 'eth1'/wan 'eth3'/g" package/base-files/files/etc/board.d/99-default_network
#sed -i "s/net\/eth1/net\/eth1/g" package/base-files/files/etc/board.d/99-default_network

# 修改主机名以及一些显示信息
#sed -i "s/hostname='*.*'/hostname='Momo'/" package/base-files/files/bin/config_generate
#sed -i "s/DISTRIB_ID='*.*'/DISTRIB_ID='OpenWrt'/g" package/base-files/files/etc/openwrt_release
#sed -i "s/DISTRIB_DESCRIPTION='*.*'/DISTRIB_DESCRIPTION='OpenWrt'/g"  package/base-files/files/etc/openwrt_release
#sed -i '/(<%=pcdata(ver.luciversion)%>)/a\      built by Momo' package/lean/autocore/files/x86/index.htm
#echo -n "$(date +'%Y%m%d')" > package/base-files/files/etc/openwrt_version
#curl -fsSL https://raw.githubusercontent.com/xztxy/New_lede_bianyi/refs/heads/main/banner_Momo > package/base-files/files/etc/banner

#下载nikki IP数据库
#mkdir -p package/base-files/files/etc/nikki/run
#curl -fsSL https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geosite.dat > package/base-files/files/etc/nikki/run/geosite.dat
#curl -fsSL https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geoip.metadb > package/base-files/files/etc/nikki/run/geoip.metadb
#curl -L -o ASN.mmdb https://github.com/mojolabs-id/GeoLite2-Database/releases/download/2025.04.28/GeoLite2-ASN.mmdb > package/base-files/files/etc/nikki/run/ASN.mmdb

##### 移除要替换的包
# 删除老argon
#rm -rf feeds/luci/themes/luci-theme-argon
#rm -rf feeds/luci/applications/luci-app-argon-config
# 删除英文版netdata
rm -rf feeds/luci/applications/luci-app-netdata

###### Git稀疏克隆
# 参数1是分支名, 参数2是仓库地址, 参数3是子目录，同一个仓库下载多个文件夹直接在后面跟文件名或路径，空格分开
function git_sparse_clone() {
  branch="$1" repourl="$2" && shift 2
  git clone --depth=1 -b $branch --single-branch --filter=blob:none --sparse $repourl
  repodir=$(echo $repourl | awk -F '/' '{print $(NF)}')
  cd $repodir && git sparse-checkout set $@
  mv -f $@ ../package
  cd .. && rm -rf $repodir
}

###### Themes
# 拉取argon主题
#git clone --depth=1 -b 18.06 https://github.com/jerrykuku/luci-theme-argon package/luci-theme-argon
#git clone --depth=1 -b 18.06 https://github.com/jerrykuku/luci-app-argon-config package/luci-app-argon-config
#git clone --depth=1 -b master https://github.com/jerrykuku/luci-theme-argon package/luci-theme-argon
#git clone --depth=1 -b master https://github.com/jerrykuku/luci-app-argon-config package/luci-app-argon-config
# 拉取酷猫主题
git clone --depth=1 -b js https://github.com/sirpdboy/luci-theme-kucat package/luci-theme-kucat
git clone --depth=1 -b main https://github.com/sirpdboy/luci-app-kucat-config package/luci-app-kucat-config
#拉取peditx主题
git clone --depth=1 -b main https://github.com/peditx/luci-theme-peditx package/luci-theme-peditx

###### 添加额外插件
# 拉取中文版netdata
git clone --depth=1 -b master https://github.com/sirpdboy/luci-app-netdata package/luci-app-netdata
# 添加Lucky
#git clone --depth=1 https://github.com/gdy666/luci-app-lucky package/lucky
git clone --depth=1 -b main https://github.com/gdy666/luci-app-lucky package/lucky
# 添加系统高级设置加强版
git clone --depth=1 -b main https://github.com/sirpdboy/luci-app-advancedplus package/luci-app-advancedplus
# 拉取定时设置
git clone --depth=1 https://github.com/sirpdboy/luci-app-autotimeset package/luci-app-autotimeset
# eqosplus定时限速
#git clone --depth=1 https://github.com/sirpdboy/luci-app-eqosplus package/luci-app-eqosplus
# 拉取文件管理
git clone --depth=1 https://github.com/sbwml/luci-app-filemanager package/luci-app-filemanager
# 家长控制
#git clone --depth=1 -b main https://github.com/sirpdboy/luci-app-parentcontrol package/luci-app-parentcontrol
# 添加ddns-go
#git clone --depth=1 https://github.com/sirpdboy/luci-app-ddns-go package/ddns-go
# 设备关机功能
git clone --depth=1 https://github.com/sirpdboy/luci-app-poweroffdevice package/luci-app-poweroffdevice
# 添加adguardhome,bypass，文件管理助手等
# luci-app-homeproxy
#git_sparse_clone main https://github.com/kenzok8/small-package luci-app-bypass luci-app-fileassistant luci-app-filebrowser luci-app-timecontrol luci-app-control-timewol luci-app-adguardhome filebrowser
# 添加lua-maxminddb
git_sparse_clone master https://github.com/kenzok8/openwrt-packages lua-maxminddb
# 添加istore
#git_sparse_clone main https://github.com/linkease/istore-ui app-store-ui
#git_sparse_clone main https://github.com/linkease/istore luci
# 添加xwan
#git_sparse_clone master https://github.com/x-wrt/com.x-wrt luci-app-xwan

##### 科学上网插件
#git clone --depth=1 -b master https://github.com/fw876/helloworld package/luci-app-ssr-plus
#git clone --depth=1 -b main https://github.com/xiaorouji/openwrt-passwall-packages package/openwrt-passwall
#git clone --depth=1 -b main https://github.com/xiaorouji/openwrt-passwall package/luci-app-passwall
#git clone --depth=1 -b main https://github.com/xiaorouji/openwrt-passwall2 package/luci-app-passwall2
#git_sparse_clone master https://github.com/vernesong/OpenClash luci-app-openclash
##添加MOMO
#git_sparse_clone main https://github.com/nikkinikki-org/OpenWrt-momo luci-app-momo momo

# 添加nikki
git clone --depth=1 -b main https://github.com/nikkinikki-org/OpenWrt-nikki package/OpenWrt-nikki
# #添加定时更新固件功能
# git clone --depth=1 -b main https://github.com/libntdll/luci-app-autoupdate package/luci-app-autoupdate

# 修改插件名字
#grep -rl '"终端"' . | xargs -r sed -i 's?"终端"?"TTYD"?g'
#grep -rl '"TTYD 终端"' . | xargs -r sed -i 's?"TTYD 终端"?"TTYD"?g'
#grep -rl '"网络存储"' . | xargs -r sed -i 's?"网络存储"?"NAS"?g'
#grep -rl '"实时流量监测"' . | xargs -r sed -i 's?"实时流量监测"?"流量"?g'
#grep -rl '"KMS 服务器"' . | xargs -r sed -i 's?"KMS 服务器"?"KMS激活"?g'
#grep -rl '"USB 打印服务器"' . | xargs -r sed -i 's?"USB 打印服务器"?"打印服务"?g'
#grep -rl '"Web 管理"' . | xargs -r sed -i 's?"Web 管理"?"Web管理"?g'
#grep -rl '"管理权"' . | xargs -r sed -i 's?"管理权"?"改密码"?g'
#grep -rl '"带宽监控"' . | xargs -r sed -i 's?"带宽监控"?"监控"?g'


# 整理固件包时候,删除您不想要的固件或者文件,让它不需要上传到Actions空间(根据编译机型变化,自行调整删除名称)
cat >"$CLEAR_PATH" <<-EOF
packages
config.buildinfo
feeds.buildinfo
sha256sums
version.buildinfo
profiles.json
openwrt-x86-64-generic-kernel.bin
openwrt-x86-64-generic.manifest
openwrt-x86-64-generic-squashfs-rootfs.img.gz
EOF

# 在线更新时，删除不想保留固件的某个文件，在EOF跟EOF之间加入删除代码，记住这里对应的是固件的文件路径，比如： rm -rf /etc/config/luci
cat >>$DELETE <<-EOF
EOF
