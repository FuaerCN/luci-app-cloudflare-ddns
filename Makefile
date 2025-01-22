include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-cloudflare-ddns
PKG_VERSION:=1.0.0
PKG_RELEASE:=1

PKG_LICENSE:=MIT
PKG_MAINTAINER:=Your Name <your@email.com>

LUCI_TITLE:=LuCI support for Cloudflare DDNS
LUCI_DEPENDS:=+curl +luci-base
LUCI_PKGARCH:=all

include $(TOPDIR)/feeds/luci/luci.mk

# 添加安装前的准备工作
define Package/$(PKG_NAME)/preinst
#!/bin/sh
if [ -f /etc/init.d/cloudflare-ddns ]; then
    chmod 755 /etc/init.d/cloudflare-ddns
fi
exit 0
endef

# 添加安装后的处理
define Package/$(PKG_NAME)/postinst
#!/bin/sh
chmod 755 /etc/init.d/cloudflare-ddns
chmod 755 /usr/bin/cloudflare-ddns-update
if [ -z "$${IPKG_INSTROOT}" ]; then
    ( . /etc/uci-defaults/luci-cloudflare-ddns ) && rm -f /etc/uci-defaults/luci-cloudflare-ddns
    chmod 755 /etc/init.d/cloudflare-ddns
    /etc/init.d/cloudflare-ddns enable
fi
exit 0
endef

# 添加卸载前的处理
define Package/$(PKG_NAME)/prerm
#!/bin/sh
if [ -n "$${IPKG_INSTROOT}" ]; then
    exit 0
fi
if [ -f /etc/init.d/cloudflare-ddns ]; then
    chmod 755 /etc/init.d/cloudflare-ddns
    /etc/init.d/cloudflare-ddns disable
    /etc/init.d/cloudflare-ddns stop
fi
exit 0
endef

# call BuildPackage - OpenWrt buildroot signature 
