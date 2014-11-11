## gateway的配置文件

本文对应issure #1 #2 #3

gateway的配置文件包括两份，一是本地配置文件，二是云端配置文件，本地配置文件为存放在路由器的\etc\config\目录下。是gateway
启动时默认读取的配置。读取完成后，初始话gateway的配置。之后会从云端获取第二份配置文件，第二份配置文件由云端返回json格式数
据完成。

### 本地配置项

本地配置项主要是一些与AP本身性质相关的内容，包括网关地址，网卡名称等。和云端相关的一项是authserver的地址。gateway将根据
本地配置的authserver地址去请求获取云端配置项。

### 云端配置项

{
    "maxclients": 20,		/**< @brief Maximum number of clients allowed */
	"gw_name": "nodog",		/**< @brief Name of the gateway; e.g. its SSID */
	"gw_iprange": "192.168.1.1/16",		/**< @brief IP range on gw_interface we will manage */
	"remote_auth_dir": "/auth/auth/",	/**< @brief Path for remote auth */
	"remote_deny_dir": "/auth/deny/",	/**< @bref Path for remote deny */
	"redirectURL": "http://url.com",		/**< @brief URL to direct client to after authentication */
	"clienttimeout": 10,		/**< @brief How many CheckIntervals before an inactive client must be re-authenticated */
	"clientforceout": 10,		/**< @brief How many CheckIntervals before a client must be re-authenticated */
	"checkinterval": 360,		/**< @brief Period the the client timeout check thread will run, in seconds */
	"authenticate_immediately": true,	/**< @brief boolean, whether to auth noninteractively */
	"traffic_control": false,		/**< @brief boolean, whether to do tc */
	"download_limit": 100;		/**< @brief Download limit, kb/s */
	"upload_limit": 10		/**< @brief Upload limit, kb/s */
	"trustedmaclist":["0023547041AD","010304AADD"]; 	/**< @brief list of trusted macs */
	"trustediplist":["222.222.323.23"];     /**< @brief list of trusted servers' ip */
}

