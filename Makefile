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

# 定义文件安装规则
define Package/$(PKG_NAME)/conffiles
/etc/config/cloudflare-ddns
endef

define Package/$(PKG_NAME)/postinst
#!/bin/sh
if [ -z "$${IPKG_INSTROOT}" ]; then
    rm -f /tmp/luci-indexcache
    rm -f /tmp/luci-modulecache/*
    ( . /etc/uci-defaults/luci-cloudflare-ddns ) && rm -f /etc/uci-defaults/luci-cloudflare-ddns
    chmod 755 /etc/init.d/cloudflare-ddns >/dev/null 2>&1
    chmod 755 /usr/bin/cloudflare-ddns-update >/dev/null 2>&1
    /etc/init.d/cloudflare-ddns enable >/dev/null 2>&1
fi
exit 0
endef

define Package/$(PKG_NAME)/prerm
#!/bin/sh
if [ -n "$${IPKG_INSTROOT}" ]; then
    exit 0
fi
if [ -f /etc/init.d/cloudflare-ddns ]; then
    /etc/init.d/cloudflare-ddns disable
    /etc/init.d/cloudflare-ddns stop
fi
exit 0
endef

# 定义文件安装
define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	
	$(INSTALL_DATA) ./luasrc/controller/*.lua $(1)/usr/lib/lua/luci/controller/
	$(INSTALL_DATA) ./luasrc/model/cbi/*.lua $(1)/usr/lib/lua/luci/model/cbi/
	$(INSTALL_BIN) ./root/etc/init.d/cloudflare-ddns $(1)/etc/init.d/
	$(INSTALL_BIN) ./root/usr/bin/cloudflare-ddns-update $(1)/usr/bin/
	$(INSTALL_CONF) ./root/etc/config/cloudflare-ddns $(1)/etc/config/
	$(INSTALL_BIN) ./root/etc/uci-defaults/luci-cloudflare-ddns $(1)/etc/uci-defaults/
endef

# call BuildPackage - OpenWrt buildroot signature 
