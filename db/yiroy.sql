/*
Navicat MySQL Data Transfer

Source Server         : localhost
Source Server Version : 50614
Source Host           : localhost:3306
Source Database       : yiroy

Target Server Type    : MYSQL
Target Server Version : 50614
File Encoding         : 65001

Date: 2014-11-03 00:28:10
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `ap_custom`
-- ----------------------------
DROP TABLE IF EXISTS `ap_custom`;
CREATE TABLE `ap_custom` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `ap_mac` varchar(30) DEFAULT NULL COMMENT 'AP的MAC地址',
  `ap_hostname` varchar(100) DEFAULT NULL COMMENT 'AP主机名字',
  `ap_alias` varchar(100) DEFAULT NULL COMMENT 'ap别名',
  `ipaddress` varchar(50) DEFAULT NULL COMMENT '管理IP',
  `ap_status` int(11) DEFAULT '-1' COMMENT 'AP是否在用，1=再用，0=没用',
  `description` varchar(200) DEFAULT NULL COMMENT 'AP描述',
  `memtotal` int(11) DEFAULT NULL COMMENT 'APflash大小',
  `ap_version` varchar(100) DEFAULT NULL COMMENT 'AP软件版本',
  `ap_type` varchar(100) DEFAULT NULL COMMENT 'AP硬件型号',
  `apaddomain` bigint(20) DEFAULT NULL,
  `apcusdomain` bigint(20) DEFAULT NULL,
  `deliveryDate` datetime DEFAULT NULL COMMENT '出库日期',
  PRIMARY KEY (`id`),
  KEY `fk_ap_addomain` (`apaddomain`),
  KEY `fk_ap_cusdomain` (`apcusdomain`),
  CONSTRAINT `fk_ap_addomain` FOREIGN KEY (`apaddomain`) REFERENCES `domain_ad` (`id`),
  CONSTRAINT `fk_ap_cusdomain` FOREIGN KEY (`apcusdomain`) REFERENCES `domain_dev` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of ap_custom
-- ----------------------------

-- ----------------------------
-- Table structure for `ap_group`
-- ----------------------------
DROP TABLE IF EXISTS `ap_group`;
CREATE TABLE `ap_group` (
  `id` bigint(20) NOT NULL,
  `group_name` varchar(128) DEFAULT NULL COMMENT '组名称',
  `group_description` varchar(256) DEFAULT NULL COMMENT '组描述',
  `white_list` varchar(256) DEFAULT NULL COMMENT '白名单',
  `ssid` varchar(128) DEFAULT NULL,
  `addomain` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_group_addomain` (`addomain`),
  CONSTRAINT `fk_group_addomain` FOREIGN KEY (`addomain`) REFERENCES `domain_ad` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of ap_group
-- ----------------------------

-- ----------------------------
-- Table structure for `ap_group_third`
-- ----------------------------
DROP TABLE IF EXISTS `ap_group_third`;
CREATE TABLE `ap_group_third` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `fk_ap` bigint(20) DEFAULT NULL,
  `fk_group` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_ap_third_custom` (`fk_ap`),
  KEY `fk_ap_third_group` (`fk_group`),
  CONSTRAINT `fk_ap_third_custom` FOREIGN KEY (`fk_ap`) REFERENCES `ap_custom` (`id`),
  CONSTRAINT `fk_ap_third_group` FOREIGN KEY (`fk_group`) REFERENCES `ap_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of ap_group_third
-- ----------------------------

-- ----------------------------
-- Table structure for `domain_ad`
-- ----------------------------
DROP TABLE IF EXISTS `domain_ad`;
CREATE TABLE `domain_ad` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `adDomainName` varchar(128) DEFAULT NULL COMMENT '广告主名称',
  `adDomainNumber` varchar(128) DEFAULT NULL,
  `adDomainDescribe` varchar(128) DEFAULT NULL COMMENT '描述',
  `parentId` bigint(20) DEFAULT NULL,
  `phone` varchar(14) DEFAULT NULL,
  `email` varchar(128) DEFAULT NULL,
  `rootDomain` varchar(128) DEFAULT NULL COMMENT '域名',
  `createTime` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of domain_ad
-- ----------------------------

-- ----------------------------
-- Table structure for `domain_dev`
-- ----------------------------
DROP TABLE IF EXISTS `domain_dev`;
CREATE TABLE `domain_dev` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `cusDomainNumber` varchar(128) DEFAULT NULL COMMENT '客户域信息描述',
  `cusDomainName` varchar(128) DEFAULT NULL COMMENT '客户名称',
  `cusDomainDescribe` varchar(128) DEFAULT NULL COMMENT '描述',
  `parentCusDomainId` bigint(20) DEFAULT '1',
  `createTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  `rootDomain` varchar(128) DEFAULT NULL COMMENT '域名信息',
  `email` varchar(128) DEFAULT NULL COMMENT '客户邮箱',
  `phone` varchar(14) DEFAULT NULL COMMENT '客户电话',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of domain_dev
-- ----------------------------
INSERT INTO `domain_dev` VALUES ('1', '00001', '玴叒科技', '玴叒科技有限公司', null, '2014-11-02 17:45:32', 'yiroy.com', 'yica@yiroy.com', '18392041741');

-- ----------------------------
-- Table structure for `potal_img`
-- ----------------------------
DROP TABLE IF EXISTS `potal_img`;
CREATE TABLE `potal_img` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `page_id` varchar(128) NOT NULL COMMENT '页面容器id',
  `img` varchar(2000) NOT NULL COMMENT '图片地址或者广告内容',
  `instanceId` bigint(20) NOT NULL,
  `img_url` varchar(2000) DEFAULT NULL COMMENT '图片URL或者广告内容',
  PRIMARY KEY (`id`),
  KEY `fk_img_instance` (`instanceId`),
  CONSTRAINT `fk_img_instance` FOREIGN KEY (`instanceId`) REFERENCES `potal_instance` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of potal_img
-- ----------------------------

-- ----------------------------
-- Table structure for `potal_instance`
-- ----------------------------
DROP TABLE IF EXISTS `potal_instance`;
CREATE TABLE `potal_instance` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `instance_name` varchar(128) DEFAULT NULL COMMENT '实例名称',
  `description` varchar(256) DEFAULT NULL COMMENT '实例描述',
  `modelId` bigint(20) NOT NULL COMMENT '模板id',
  `weixin` int(1) NOT NULL DEFAULT '1' COMMENT '0=true,1=false',
  `qq` int(1) NOT NULL DEFAULT '1' COMMENT '0=true,1=false',
  `weibo` int(1) NOT NULL DEFAULT '1' COMMENT '0=true,1=false',
  `weixin_username` varchar(100) DEFAULT NULL COMMENT '微信公共账号名称，搜索微信用',
  `weixin_appid` varchar(100) DEFAULT NULL COMMENT '微信的APPID',
  `weixin_appsecret` varchar(100) DEFAULT NULL COMMENT '微信APP Secret',
  `redirect_page` varchar(500) DEFAULT NULL COMMENT '认证成功之后跳转的地址',
  PRIMARY KEY (`id`),
  KEY `fk_instance_modelId` (`modelId`),
  CONSTRAINT `fk_instance_modelId` FOREIGN KEY (`modelId`) REFERENCES `potal_model` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of potal_instance
-- ----------------------------

-- ----------------------------
-- Table structure for `potal_instanse_group`
-- ----------------------------
DROP TABLE IF EXISTS `potal_instanse_group`;
CREATE TABLE `potal_instanse_group` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `groupId` bigint(20) DEFAULT NULL,
  `instanceId` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_instance_groupe` (`groupId`),
  KEY `fk_group_instance` (`instanceId`),
  CONSTRAINT `fk_group_instance` FOREIGN KEY (`instanceId`) REFERENCES `potal_instance` (`id`),
  CONSTRAINT `fk_instance_groupe` FOREIGN KEY (`groupId`) REFERENCES `ap_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of potal_instanse_group
-- ----------------------------

-- ----------------------------
-- Table structure for `potal_model`
-- ----------------------------
DROP TABLE IF EXISTS `potal_model`;
CREATE TABLE `potal_model` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) DEFAULT NULL COMMENT '名称',
  `description` varchar(128) DEFAULT NULL COMMENT '描述',
  `filesrc` varchar(128) DEFAULT NULL COMMENT '存放模板文件目录',
  `imgsrc` varchar(128) DEFAULT NULL COMMENT '存放缩略图路径',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of potal_model
-- ----------------------------

-- ----------------------------
-- Table structure for `role`
-- ----------------------------
DROP TABLE IF EXISTS `role`;
CREATE TABLE `role` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `roleName` varchar(128) DEFAULT NULL COMMENT '角色名',
  `description` varchar(128) DEFAULT NULL COMMENT '角色描述',
  `permission` varchar(256) DEFAULT NULL COMMENT '权限列表',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of role
-- ----------------------------
INSERT INTO `role` VALUES ('1', '广告主', '广告主', null);
INSERT INTO `role` VALUES ('2', '设备主', '设备主', null);
INSERT INTO `role` VALUES ('3', '广告主和设备主', '既是广告主也是设备主', null);
INSERT INTO `role` VALUES ('4', '临时用户', '临时用户', null);
INSERT INTO `role` VALUES ('5', '电话申请用户', '电话申请用户', null);
INSERT INTO `role` VALUES ('6', 'qq登陆用户', 'qq登录用户', null);
INSERT INTO `role` VALUES ('7', 'sina登陆用户', 'sina登陆用户', null);
INSERT INTO `role` VALUES ('8', '微信登陆用户', '微信登陆用户', null);

-- ----------------------------
-- Table structure for `role_menu`
-- ----------------------------
DROP TABLE IF EXISTS `role_menu`;
CREATE TABLE `role_menu` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `description` varchar(1024) DEFAULT NULL COMMENT '描述',
  `resource_name` varchar(128) NOT NULL COMMENT '菜单名称',
  `url` varchar(128) DEFAULT NULL COMMENT '链接地址',
  `role_id` bigint(20) NOT NULL COMMENT '角色id',
  `parentId` bigint(20) DEFAULT NULL COMMENT '父节点id',
  `icon` varchar(128) DEFAULT NULL COMMENT '图标class',
  `isparent` int(2) DEFAULT '0' COMMENT '是否有子节点，1-有，0-没有，若有子节点添加左侧下箭头',
  PRIMARY KEY (`id`),
  KEY `fk_rolemenu_role` (`role_id`),
  CONSTRAINT `fk_rolemenu_role` FOREIGN KEY (`role_id`) REFERENCES `role` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of role_menu
-- ----------------------------

-- ----------------------------
-- Table structure for `users`
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `userId` varchar(128) NOT NULL,
  `password` varchar(128) NOT NULL,
  `cusDomain` bigint(20) DEFAULT NULL,
  `adDomain` bigint(20) DEFAULT NULL,
  `role` bigint(20) DEFAULT NULL,
  `userName` varchar(128) DEFAULT NULL,
  `email` varchar(128) DEFAULT NULL,
  `phone` varchar(14) DEFAULT NULL,
  `createTime` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `pk_users_addomain` (`adDomain`),
  KEY `pk_users_cusdomain` (`cusDomain`),
  KEY `pk_users_role` (`role`),
  CONSTRAINT `pk_users_addomain` FOREIGN KEY (`adDomain`) REFERENCES `domain_ad` (`id`),
  CONSTRAINT `pk_users_cusdomain` FOREIGN KEY (`cusDomain`) REFERENCES `domain_dev` (`id`),
  CONSTRAINT `pk_users_role` FOREIGN KEY (`role`) REFERENCES `role` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES ('1', 'admin', 'password', null, null, '1', 'demo', null, null, '2014-11-02 19:39:02');

-- ----------------------------
-- Table structure for `users_mac`
-- ----------------------------
DROP TABLE IF EXISTS `users_mac`;
CREATE TABLE `users_mac` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `userId` varchar(128) DEFAULT NULL,
  `password` varchar(128) DEFAULT NULL,
  `createTime` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `addomain` bigint(20) DEFAULT NULL,
  `cusdomain` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_mac_addomain` (`addomain`),
  KEY `fk_mac_cusdomain` (`cusdomain`),
  CONSTRAINT `fk_mac_addomain` FOREIGN KEY (`addomain`) REFERENCES `domain_ad` (`id`),
  CONSTRAINT `fk_mac_cusdomain` FOREIGN KEY (`cusdomain`) REFERENCES `domain_dev` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of users_mac
-- ----------------------------

-- ----------------------------
-- Table structure for `users_phone`
-- ----------------------------
DROP TABLE IF EXISTS `users_phone`;
CREATE TABLE `users_phone` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `userId` varchar(128) DEFAULT NULL,
  `password` varchar(128) DEFAULT NULL,
  `role` bigint(20) DEFAULT NULL,
  `createTime` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `invalidTime` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `userName` varchar(128) DEFAULT NULL,
  `phone` varchar(14) DEFAULT NULL,
  `addomain` bigint(20) DEFAULT NULL,
  `cusdomain` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_phone_role` (`role`),
  KEY `fk_phone_addomain` (`addomain`),
  KEY `fk_phone_cusdomain` (`cusdomain`),
  CONSTRAINT `fk_phone_addomain` FOREIGN KEY (`addomain`) REFERENCES `domain_ad` (`id`),
  CONSTRAINT `fk_phone_cusdomain` FOREIGN KEY (`cusdomain`) REFERENCES `domain_dev` (`id`),
  CONSTRAINT `fk_phone_role` FOREIGN KEY (`role`) REFERENCES `role` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of users_phone
-- ----------------------------

-- ----------------------------
-- Table structure for `users_temp`
-- ----------------------------
DROP TABLE IF EXISTS `users_temp`;
CREATE TABLE `users_temp` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` varchar(128) DEFAULT NULL,
  `password` varchar(128) DEFAULT NULL,
  `creat_time` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `invalid_time` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `cusDomain` bigint(20) DEFAULT NULL,
  `adDomain` bigint(20) DEFAULT NULL,
  `role` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `pk_temousers_role` (`role`),
  KEY `pk_tempusers_addomain` (`adDomain`),
  KEY `pk_tempusers_cusdomain` (`cusDomain`),
  CONSTRAINT `pk_temousers_role` FOREIGN KEY (`role`) REFERENCES `role` (`id`),
  CONSTRAINT `pk_tempusers_addomain` FOREIGN KEY (`adDomain`) REFERENCES `domain_ad` (`id`),
  CONSTRAINT `pk_tempusers_cusdomain` FOREIGN KEY (`cusDomain`) REFERENCES `domain_dev` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of users_temp
-- ----------------------------

-- ----------------------------
-- Table structure for `users_third`
-- ----------------------------
DROP TABLE IF EXISTS `users_third`;
CREATE TABLE `users_third` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` varchar(128) NOT NULL COMMENT 'social_uid',
  `sex` varchar(64) DEFAULT NULL COMMENT '性别',
  `birthday` varchar(64) DEFAULT NULL COMMENT '生日',
  `phone` varchar(64) DEFAULT NULL,
  `user_name` varchar(128) NOT NULL COMMENT '用户名',
  `password` varchar(128) DEFAULT NULL COMMENT '密码',
  `email` varchar(256) DEFAULT NULL COMMENT '邮箱',
  `address` varchar(256) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `last_login` datetime DEFAULT NULL,
  `province` varchar(50) DEFAULT NULL,
  `city` varchar(128) DEFAULT NULL,
  `media_type` varchar(128) DEFAULT NULL COMMENT '登录平台',
  `access_token` varchar(128) DEFAULT NULL COMMENT '用户登录access_token，有效期一个月',
  `role` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_qquser_role` (`role`),
  CONSTRAINT `fk_qquser_role` FOREIGN KEY (`role`) REFERENCES `role` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of users_third
-- ----------------------------

-- ----------------------------
-- Table structure for `users_third_domain`
-- ----------------------------
DROP TABLE IF EXISTS `users_third_domain`;
CREATE TABLE `users_third_domain` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `media_type` varchar(128) DEFAULT NULL,
  `cusdomain` bigint(20) DEFAULT NULL,
  `addomain` bigint(20) DEFAULT NULL,
  `userId` bigint(20) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_third_addomain` (`addomain`),
  KEY `fk_third_cusdomain` (`cusdomain`),
  KEY `fk_thirddomai_users` (`userId`),
  CONSTRAINT `fk_thirddomai_users` FOREIGN KEY (`userId`) REFERENCES `users_third` (`id`),
  CONSTRAINT `fk_third_addomain` FOREIGN KEY (`addomain`) REFERENCES `domain_ad` (`id`),
  CONSTRAINT `fk_third_cusdomain` FOREIGN KEY (`cusdomain`) REFERENCES `domain_dev` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of users_third_domain
-- ----------------------------

-- ----------------------------
-- Table structure for `users_weixin`
-- ----------------------------
DROP TABLE IF EXISTS `users_weixin`;
CREATE TABLE `users_weixin` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` varchar(128) NOT NULL COMMENT '用户账号，对应用户的openId',
  `subscribe` char(2) DEFAULT NULL COMMENT '是否关注该公众号，0表示没有关注拉取不到用户信息',
  `sex` varchar(64) DEFAULT NULL COMMENT '性别,1男2女0未知',
  `birthday` varchar(64) DEFAULT NULL COMMENT '生日',
  `mobilephone` varchar(64) DEFAULT NULL COMMENT '手机号码',
  `user_name` varchar(128) NOT NULL COMMENT '用户昵称',
  `password` varchar(128) DEFAULT NULL COMMENT '密码',
  `address` varchar(256) DEFAULT NULL COMMENT '地址',
  `created` datetime DEFAULT NULL COMMENT '创建用户时间',
  `last_login` datetime DEFAULT NULL COMMENT '最后登录时间',
  `description` varchar(1024) DEFAULT NULL,
  `subscribe_time` datetime DEFAULT NULL COMMENT '关注时间',
  `media_type` varchar(128) DEFAULT 'weixin',
  `invalid_time` datetime DEFAULT NULL COMMENT '失效时间',
  `role` bigint(20) DEFAULT NULL,
  `addomain` bigint(20) DEFAULT NULL,
  `cusdomain` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_weixin_addomain` (`addomain`),
  KEY `fk_weixin_cusdomain` (`cusdomain`),
  KEY `fk_weixin_role` (`role`),
  CONSTRAINT `fk_weixin_addomain` FOREIGN KEY (`addomain`) REFERENCES `domain_ad` (`id`),
  CONSTRAINT `fk_weixin_cusdomain` FOREIGN KEY (`cusdomain`) REFERENCES `domain_dev` (`id`),
  CONSTRAINT `fk_weixin_role` FOREIGN KEY (`role`) REFERENCES `role` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of users_weixin
-- ----------------------------
