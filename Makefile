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

# call BuildPackage - OpenWrt buildroot signature 
