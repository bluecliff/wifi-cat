## 登录认证流程

1. 用户发起一个请求。

2. gateway会拦截这个请求，把用户定向到authserver的/api/skywifi/login/?gw_address=192.168.1.1&gw_port=2345&gw_id=1234&url=http://sina.com.cn这个接口。

3. authserver根据传来的gw_id来给用户返回一个带有微博oauth链接的页面。

4. 用户选择微博oauth链接到微博的服务器。

5. 微博的服务器返回给用户填写帐号密码的表单。用户提交表单。

6. 微博服务器验证用户之后返回给用户一个token，并把用户带着这个token重定向到authserver，向authserver发起请求。

7. authserver拿着token去微博服务器验证后获取到相关权限。返回给用户一个带着token=id的重定向，目标为gateway的
   /wifidog/auth，携带的token以get参数提交给gateway

8. gateway将向authserver的/api/skywifi/auth/?stage=login&ip=192.168.1.100&mac=00:23:54:70:41:AD&token=12345&incoming=0&outgoing=0&gw_id=1234发起验证请求。

9. authserver验证成功后返回给gateway成功码。

10. gateway获取成功代码后向用户返回一个重定向到authserver的 /api/skywifi/portal/?gw_id=123456接口的请求。

11. authserver向用户发送一个认证成功页面。

## 登出流程

用户登出有两种方式，一种是gateway检测不到用户一段时间，认为用户离线。这时向/api/skywifi/auth/?stage=logout&ip=192.168.1.100&mac=00:23:54:70:41:AD&token=12345&incoming=0&outgoing=0&gw_id=1234发起请求，标识用户下线。

另一种下线方式是用户主动下线，用户访问带着token和logout的cookie变量访问gateway的/wifidog/auth。gateway就会发起下线请
求到authserver的/api/skywifi/auth/?stage=logout&ip=192.168.1.100&mac=00:23:54:70:41:AD&token=12345&incoming=0&outgoing=0&gw_id=1234。获取返回后会把用户重定向到/api/skywifi/gw_message/?message=logged-out。authserver给用户返回
一个下线成功提示页面。

## 心跳包流程

心跳包有两种，时间间隔都是checkInteval配置项所指定的秒数。

- /api/skywifi/auth/?stage=counters 具体API格式见API文档，该心跳包向Authserver提交每个在线用户的上网数据包统计。

- /api/skywifi/ping/ 具体格式建API文档，该心跳包向Authserver提交路由器的工作状态。
