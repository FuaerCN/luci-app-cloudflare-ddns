include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-cloudflare-ddns
PKG_VERSION:=1.0.0
PKG_RELEASE:=1

PKG_LICENSE:=MIT
PKG_MAINTAINER:=Your Name <your@email.com>

LUCI_TITLE:=LuCI support for Cloudflare DDNS
LUCI_DEPENDS:=+curl +luci-base
LUCI_PKGARCH:=all

# 在 include luci.mk 之前定义安装规则
define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	
	cp -pR ./luasrc/* $(1)/usr/lib/lua/luci/
	$(INSTALL_BIN) ./root/etc/init.d/cloudflare-ddns $(1)/etc/init.d/
	$(INSTALL_BIN) ./root/usr/bin/cloudflare-ddns-update $(1)/usr/bin/
	$(INSTALL_CONF) ./root/etc/config/cloudflare-ddns $(1)/etc/config/
	$(INSTALL_BIN) ./root/etc/uci-defaults/luci-cloudflare-ddns $(1)/etc/uci-defaults/
endef

include $(TOPDIR)/feeds/luci/luci.mk

define Package/$(PKG_NAME)/conffiles
/etc/config/cloudflare-ddns
endef

define Package/$(PKG_NAME)/postinst
#!/bin/sh
[ -n "$${IPKG_INSTROOT}" ] && exit 0
rm -rf /tmp/luci-*
chmod 755 /etc/init.d/cloudflare-ddns
chmod 755 /usr/bin/cloudflare-ddns-update
( . /etc/uci-defaults/luci-cloudflare-ddns ) && rm -f /etc/uci-defaults/luci-cloudflare-ddns
/etc/init.d/cloudflare-ddns enable >/dev/null 2>&1
exit 0
endef

define Package/$(PKG_NAME)/prerm
#!/bin/sh
[ -n "$${IPKG_INSTROOT}" ] && exit 0
/etc/init.d/cloudflare-ddns disable
/etc/init.d/cloudflare-ddns stop
exit 0
endef

# call BuildPackage - OpenWrt buildroot signature 
