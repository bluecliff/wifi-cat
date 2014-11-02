# Wifidog Gateway修改方案

因为wifidog gateway的控制策略是通过建立iptables过滤策略实现的。我们的开发中需要对我们配置的第三方认证网站直接放行。
放行策略可以参考原版wifidog gateway对authserver的放行策略：也是添加iptables规则。

综上所述需要修改的文件有：

## 配置文件

增加一项OAuthServer。配置方法如下：

```c
OAuthServer {
    Hostname auth.ilesansfil.org
}

OAuthServer {
    Hostname auth2.ilesansfil.org
}
```
可以配置多项。

考虑到OAuthServer并不与gateWay之间有直接的交互关系。所以即使OAuth认证需要https完成，我们这里也不用设置专门的配置项
表明采用何种协议。只要在最终建立的对OAuth Server的iptabls规则中放行这个ip地址上的所有tcp访问就可以了，采取对
所有端口都放行的策略。当然如果要做到更细致的控制，也可以在配置中增添一项指定OAuth Server的端口，窃以为无此必要。

## conf.h文件

- 增加存储oauthserver的链表。
- 修改基本的sconfg结构，增加对oauthserver的支持。

## conf.c文件

- 增加读取oauthserver的函数
- 修改初始化函数，可以正确初始化oauthserver

## firewall.c文件

- 增加初始化oauthserver的iptables创建函数
- 增加初始化oauthserver的iptables删除函数
- 增加初始化oauthserver的iptables复制函数
- 增加对oauthserver的iptables处理逻辑
