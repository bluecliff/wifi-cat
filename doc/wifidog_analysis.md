# 代码分析
 
## main()

 1. 初始化一个s\_config指针，指向一个static的全局s\_config变量，该全局变量在conf.c中定义。
    通过读取参数，文件等方法初始化配置结构，并验证配置是否有效。初始化完成之后可以通过调用

    ```
    s_config *config = config_get_config();

    获取到全局的配置结构的指针。

 2. 初始话用户链表，也是一个全局的链表变量，定义在client_list.c中，firstclient作为全局变量指针
    指向该结构的首节点，初始化为NULL。可以通过调用

    ```
    t_client * client_get_first_client(void)

    函数来获取全局链表指针。

3. 注册信号，信号处理函数

4. 查看本次启动是否由程序本身重启的，若是，则把上次运行程序已经链接上的客户列表拷贝到当前程序的链接表，之后再关闭上
    一次程序的进程。

5. 检查是否damon运行，是的话创建daemon进程。

6. 进入main_loop()

## main_loop

1. 创建httpserver，使用了httpd这个嵌入式webserver，主要提供对客户端访问gateway时的请求做出响应。

2. 重建firewall规则，每次重启都要重建。

3. 创建线程thread_client_timeout_check，负责按照checkinterval配置的时间定期检查用户是否下线，若下线，则从用户列表中
   删除用户并向authserver发起logout请求。若未下线，则向authserver发起counters请求，更新该用户的上线时间，流量等统计
   信息。

4. 创建线程thread_wdctl，该线程是控制线程的server线程，通过unix socket和client通信。完成消息查询等。提供的查询
   消息有status,stop,reset,restart。

5. 进入监听阶段，启动内置的libhttpd web server监听新连接，未认证用户都会被重定向到gateway的内置server上，由server返
   回给用户认证页面。并且监听用户的登出操作。
