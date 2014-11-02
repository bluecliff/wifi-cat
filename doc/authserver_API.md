# authserver接口

1. /api/skywifi/auth/?stage=counters
   
   这个接口是由gateway发起的向authserver提供更新用户统计信息的接口，发起时间间隔是配置文件中的CheckInterval
   配置项决定。由thread_client_timeout_check线程发起。
   
   Example：
   
   /api/skywifi/auth/?stage=counters&ip=192.168.1.100&mac=00:23:54:70:41:AD&token=12345&incoming=1000&outgoing=10000&gw_id=1234
   
   返回参数可以用来控制在线用户的连接，比如踢人下线等。
   
   Auth: 0
   
   Auth: 6
   
   以上两个作用相同，都是踢掉用户
   
   Auth: 1 正常用户在线 

   **注意:返回代码里Auth和数码之间必须有一个空格隔开**

2. /api/skywifi/auth/?stage=logout
   
   这个接口是由gateway某用户被检测到离线时gateway发起的请求，通知authserver用户已经离线。
   由thread_client_timeout_check线程发起。
   
   Example：
   
   /api/skywifi/auth/?stage=logout&ip=192.168.1.100&mac=00:23:54:70:41:AD&token=12345&incoming=0&outgoing=0&gw_id=1234

   返回Auth:0

3. /api/skywifi/auth/?stage=login
   
   在每个用户第一次提交username和password后，由authserver重定向用户到gateway后，gateway将向这个接口进行
   验证。
   
   /api/skywifi/auth/?stage=login&ip=192.168.1.100&mac=00:23:54:70:41:AD&token=12345&incoming=0&outgoing=0&gw_id=1234

   返回Auth: -1 出错 gateway将给用户发送一个错误页面。
   
   返回Auth: 0 拒绝该用户上网，gateway把用户重定向到authserver的/gw_message/?message=denied
   
   返回Auth: 5 用户邮件没有验证，重定向到authserver的/gw_message/?message=activate
   
   返回Auth: 1 验证成功，重定向到authserver的portal/?gw_id=
   
   返回Auth: 6 验证失败，重定向到authserver的gw_message/?message=failed_validation

3. /api/skywifi/ping/
   
   这个接口由thread_ping线程定时发起，主要目的是向服务器提交一些路由器的工作信息。时间间隔是配置项checkinterval。
   格式：
   
   ```
       "GET %s%sgw_id=%s&sys_uptime=%lu&sys_memfree=%u&sys_load=%.2f&wifidog_uptime=%lu HTTP/1.0\r\n"
          "User-Agent: WiFiDog %s\r\n"
          "Host: %s\r\n"
          "\r\n",
          auth_server->authserv_path,
          auth_server->authserv_ping_script_path_fragment,
          config_get_config()->gw_id,
          sys_uptime,
          sys_memfree,
          sys_load,
          (long unsigned int)((long unsigned int)time(NULL) - (long unsigned int)started_time),
          VERSION,
          auth_server->authserv_hostname
    ```
    Example：
    ```
    /api/skywifi/ping/?gw_id=1234&sys_uptime=123456&sys_memfree=1234&sys_load=0.5&wifidog_uptime=1234
    ```
    等待时间，30秒。
    返回 Pong

4. /api/skywifi/login/
   
   该请求由用户浏览器发出，当用户请求任意页面时，会被重定向到gateway内置的libhttpd server上，成为一个404错误，
   gateway处理该错误的逻辑是返回给用户一个到authserver的重定向页面，完成认证。如下：

       %sgw_address=%s&gw_port=%d&gw_id=%s&url=%s",
            auth_server->authserv_login_script_path_fragment,
            config->gw_address,
            config->gw_port, 
            config->gw_id,
            url

   Example：
   
   /api/skywifi/login/?gw_address=192.168.1.1&gw_port=2345&gw_id=1234&url=http://sina.com.cn

   该请求应当返回一个到gateway的重定向页面。携带token

5. /api/skywifi/gw_message/?message=logged-out

   当用户主动下线，即gateway向/api/skywifi/auth/?stage=logout发起请求获取返回后，gateway将把用户重定向到该接口。
   Authserver应当给用户返回一个静态页面标识用户下线。

6. /api/skywifi/gw_message/?message=denied

   Authserver收到gateway的验证信息，返回给gateway拒绝用户上网时，gateway将把用户重定向到该接口，Authserver应当返回
   静态页面，提示用户被禁止上网。

7. /api/skywifi/gw_message/?message=activate
  
   Authserver收到gateway的验证信息，返回给gateway要求用户激活帐号时，gateway将把用户重定向到该接口，Authserver应当返
   回静态页面，提示用户验证帐号。**这个接口暂不使用。**

8. /api/skywifi/gw_message/?message=failed_validation

   Authserver收到gateway的验证信息，返回给gateway该账户验证失败时，gateway将把用户重定向到该接口，Authserver应当返
   回静态页面，提示用户验证失败。

9. /api/skywifi/portal/?gw_id=123456

   Authserver收到gateway的验证信息，返回给gateway允许用户上网时，gateway将把用户重定向到该接口，Authserver应当返回
   静态页面，提示用户现在可以上网。
