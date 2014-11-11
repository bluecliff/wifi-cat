## gateway认证过程

gateway的认证过程包括一下几步。

1. 用户随机发起一个http请求，gateway将拦截该请求，重定向到gateway_addr:gateway_port.
2. gatewany监听gateway_addr:gateway_port，根据监听到的请求获取访问用户的ip和mac.
3. gateway相应给用户一个302，把用户重定向到authserver,重定向地址中带有用户的token,redir_url两个参数。
4. authserver应当给用户一个登录页面，即我们的推送页面protal。
5. 用户在protal页面中选择电话，微博等登录方式，将直接向对应的oauth服务器发起认证。
6. 对应的oauth服务器完成认证后，将给用户一个返回302跳转，可以跳转到authserver.
7. authserver再给用户返回一个302跳转到redir_url，跳转地址中应当带上token.
8. redir_url实际上是本地gateway的地址和监听端口。gateway将验证token有效性，并使用户上线。
9. gateway将给用户一个302返回，使用户跳转到云端配置项中指定的跳转地址。

**注意**认证过程中多次使用302跳转，实现数据的交互。在使用电话认证时，不许跳转到其他服务器。