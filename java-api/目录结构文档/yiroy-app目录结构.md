# 项目结构 #
10/31/2014 10:07:25 AM 
> 
	/src/main/java:  （放置java代码的目录）
		- com.yiroy.www.auth 放置功能模块代码
		- com.yiroy.www.basic 已经封装的action,dao,service公用方法，所有的action，service,dao都需要继承此包
		- com.yiroy.www.codeauth 此包里面封装了代码自动生成的方法，只要在beanuntiltest的main方法里面指定实体  
		                         类就可以自动在service和dao包里面生成相应的类文件
		- com.yiroy.www.model 此包里面放置了所有的实体类
		- com.yiroy.www.test  此包下面放置了测试用的类
		- com.yiroy.www.untils 此包下面放置所有的公用工具包
	/src/main/resources:  （放置配置文件的目录）
		- applicationContext.xml:   核心配置文件
		- spring-mvc.xml:           springmvc的配置文件
		- config.properties ：      数据库的配置文件
		- message_*.properties:     国际化配置文件
		- log4j.properties:    		log4j日志配置文件
	pom.xml: maven配置文件
	/src/main/webapp/
		-resources: 放置静态文件的文件夹
		-WEB-INF/pages ：放置jsp文件的目录


