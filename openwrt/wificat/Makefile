#
# Copyright (C) 2013 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=wificat
PKG_FIXUP:=autoreconf
PKG_VERSION:=0.1
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)/
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=git@github.com:bluecliff/wifi-cat.git
PKG_SOURCE_VERSION:=master
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_BUILD_PARALLEL:=1
PKG_LICENSE:=GPL-2.0+

include $(INCLUDE_DIR)/package.mk


define Package/wificat
	SUBMENU:=Captive Portals
	SECTION:=net
	CATEGORY:=Network
	DEPENDS:=+libpthread +iptables-mod-ipopt
	TITLE:=Open public network gateway daemon
	URL:=https://github.com/bluecliff/wifi-cat
endef

define Package/wificat/description
	wificat offers a simple way to open a free hotspot providing
	restricted access to an internet connection.
endef

define Package/wificat/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/wificat $(1)/usr/bin/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/ndsctl $(1)/usr/bin/

	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) files/wificat.init $(1)/etc/init.d/$(PKG_NAME)

	$(INSTALL_DIR) $(1)/etc/$(PKG_NAME)/htdocs/images
	$(CP) $(PKG_BUILD_DIR)/resources/wificat.conf $(1)/etc/$(PKG_NAME)/
	$(CP) $(PKG_BUILD_DIR)/resources/wificat.html $(1)/etc/$(PKG_NAME)/htdocs/
	$(CP) $(PKG_BUILD_DIR)/resources/infoskel.html $(1)/etc/$(PKG_NAME)/htdocs/
	$(CP) $(PKG_BUILD_DIR)/resources/wificat.jpg $(1)/etc/$(PKG_NAME)/htdocs/images/
endef

define Package/wificat/conffiles
/etc/wificat/wificat.conf
endef

$(eval $(call BuildPackage,wificat))

