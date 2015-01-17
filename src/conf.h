/********************************************************************\
 * This program is free software; you can redistribute it and/or    *
 * modify it under the terms of the GNU General Public License as   *
 * published by the Free Software Foundation; either version 2 of   *
 * the License, or (at your option) any later version.              *
 *                                                                  *
 * This program is distributed in the hope that it will be useful,  *
 * but WITHOUT ANY WARRANTY; without even the implied warranty of   *
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the    *
 * GNU General Public License for more details.                     *
 *                                                                  *
 * You should have received a copy of the GNU General Public License*
 * along with this program; if not, contact:                        *
 *                                                                  *
 * Free Software Foundation           Voice:  +1-617-542-5942       *
 * 59 Temple Place - Suite 330        Fax:    +1-617-542-2652       *
 * Boston, MA  02111-1307,  USA       gnu@gnu.org                   *
 *                                                                  *
\********************************************************************/

/* $Id: conf.h 1162 2007-01-06 23:51:02Z benoitg $ */
/** @file conf.h
    @brief Config file parsing
    @author Copyright (C) 2004 Philippe April <papril777@yahoo.com>
    @author Copyright (C) 2007 Paul Kube <nodogsplash@kokoro.ucsd.edu>
*/

#ifndef _CONF_H_
#define _CONF_H_

#define VERSION "0.1"

/*@{*/
/** Defines */
/** How many times should we try detecting the interface with the default route
 * (in seconds).  If set to 0, it will keep retrying forever */
#define NUM_EXT_INTERFACE_DETECT_RETRY 0
/** How long we should wait per try
 *  to detect the interface with the default route if it isn't up yet (interval in seconds) */
#define EXT_INTERFACE_DETECT_RETRY_INTERVAL 1
#define MAC_ALLOW 0 /** macmechanism to block MAC's unless allowed */
#define MAC_BLOCK 1 /** macmechanism to allow MAC's unless blocked */

/** Defaults configuration values */
#ifndef SYSCONFDIR
#define DEFAULT_CONFIGFILE "/etc/wificat/wificat.conf"
#else
#define DEFAULT_CONFIGFILE SYSCONFDIR"/wificat/wificat.conf"
#endif
#define DEFAULT_DAEMON 1
#define DEFAULT_DEBUGLEVEL LOG_NOTICE
#define DEFAULT_MAXCLIENTS 20
#define DEFAULT_GATEWAY_IPRANGE "0.0.0.0/0"
#define DEFAULT_GATEWAYNAME "wificat"
#define DEFAULT_GATEWAYPORT 2050
#define DEFAULT_REMOTE_AUTH_PORT 80
#define DEFAULT_CHECKINTERVAL 60
#define DEFAULT_CLIENTTIMEOUT 10
#define DEFAULT_CLIENTFORCEOUT 360
#define DEFAULT_WEBROOT "/etc/wificat/htdocs"
#define DEFAULT_SPLASHPAGE "wificat.html"
#define DEFAULT_INFOSKELPAGE "infoskel.html"
#define DEFAULT_IMAGESDIR "images"
#define DEFAULT_PAGESDIR "pages"
#define DEFAULT_AUTHDIR "wificat_auth"
#define DEFAULT_DENYDIR "wificat_deny"
#define DEFAULT_MACMECHANISM MAC_BLOCK
#define DEFAULT_PASSWORD_AUTH 0
#define DEFAULT_USERNAME_AUTH 0
#define DEFAULT_PASSWORD_ATTEMPTS 5
#define DEFAULT_AUTHENTICATE_IMMEDIATELY 0
#define DEFAULT_SET_MSS 1
#define DEFAULT_MSS_VALUE 0
#define DEFAULT_TRAFFIC_CONTROL 0
#define DEFAULT_UPLOAD_LIMIT 0
#define DEFAULT_DOWNLOAD_LIMIT 0
#define DEFAULT_DOWNLOAD_IMQ 0
#define DEFAULT_UPLOAD_IMQ 1
#define DEFAULT_LOG_SYSLOG 0
#define DEFAULT_SYSLOG_FACILITY LOG_DAEMON
#define DEFAULT_NDSCTL_SOCK "/tmp/ndsctl.sock"
#define DEFAULT_INTERNAL_SOCK "/tmp/ndsctl.sock"
#define DEFAULT_FW_MARK_AUTHENTICATED 0x400
#define DEFAULT_FW_MARK_TRUSTED 0x200
#define DEFAULT_FW_MARK_BLOCKED 0x100
/* N.B.: default policies here must be ACCEPT, REJECT, or RETURN
 * In the .conf file, they must be allow, block, or passthrough
 * Mapping between these enforced by parse_empty_ruleset_policy() */
#define DEFAULT_EMPTY_TRUSTED_USERS_POLICY "ACCEPT"
#define DEFAULT_EMPTY_TRUSTED_USERS_TO_ROUTER_POLICY "ACCEPT"
#define DEFAULT_EMPTY_USERS_TO_ROUTER_POLICY "REJECT"
#define DEFAULT_EMPTY_AUTHENTICATED_USERS_POLICY "RETURN"
#define DEFAULT_EMPTY_PREAUTHENTICATED_USERS_POLICY "REJECT"

//damon add on 14/12/11
#define DEFAULT_REMOTE_AUTH_ACTION "yes"
#define DEFAULT_AUTH_SERVER "manage.yiroy.com"
#define DEFAULT_AUTH_PORT 80
#define DEFAULT_AUTH_PATH "/wificat/auth/"
#define DEFAULT_CONFIG_PATH "/wificat/config/"
#define DEFAULT_NET_TRAFFIC_PATH "/wificat/nettraffic/"

//damon end

/*@}*/

/**
* Firewall targets
*/
typedef enum {
	TARGET_DROP,
	TARGET_REJECT,
	TARGET_ACCEPT,
	TARGET_LOG,
	TARGET_ULOG
} t_firewall_target;

/**
 * Firewall rules
 */
typedef struct _firewall_rule_t {
	t_firewall_target target;	/**< @brief t_firewall_target */
	char *protocol;		/**< @brief tcp, udp, etc ... */
	char *port;			/**< @brief Port to block/allow */
	char *mask;			/**< @brief Mask for the rule *destination* */
	struct _firewall_rule_t *next;
} t_firewall_rule;

/**
 * Firewall rulesets
 */
typedef struct _firewall_ruleset_t {
	char *name;
	char *emptyrulesetpolicy;
	t_firewall_rule *rules;
	struct _firewall_ruleset_t *next;
} t_firewall_ruleset;

/**
 * MAC Addresses
 */
typedef struct _MAC_t {
	char *mac;
	struct _MAC_t *next;
} t_MAC;

//damon add on 14/12/11
//ip list node
typedef struct _IP_t {
    char *ip;
    struct _IP_t *next;
} t_IP;
//damon end
/**
 * Configuration structure
 */
typedef struct {
	char configfile[255];		/**< @brief name of the config file */
	char *ndsctl_sock;		/**< @brief ndsctl path to socket */
	char *internal_sock;		/**< @brief internal path to socket */
	int daemon;			/**< @brief if daemon > 0, use daemon mode */
	int debuglevel;		/**< @brief Debug information verbosity */
	int maxclients;		/**< @brief Maximum number of clients allowed */
	char *ext_interface;		/**< @brief Interface to external network */
	char *gw_name;		/**< @brief Name of the gateway; e.g. its SSID */
	char *gw_interface;		/**< @brief Interface we will manage */
	char *gw_iprange;		/**< @brief IP range on gw_interface we will manage */
	char *gw_address;		/**< @brief Internal IP address for our web server */
	char *gw_mac;		/**< @brief MAC address of the interface we manage */
	unsigned int gw_port;		/**< @brief Port the webserver will run on */
	char *remote_auth_action;	/**< @brief Path for remote auth */
	char enable_preauth;    /**< @brief enable pre-authentication support */
	char *bin_voucher;    /**< @brief enable voucher support */
	char force_voucher;    /**< @brief force voucher */
	char *webroot;		/**< @brief Directory containing splash pages, etc. */
	char *splashpage;		/**< @brief Name of main splash page */
	char *infoskelpage;		/**< @brief Name of info skeleton page */
	char *imagesdir;		/**< @brief Subdir of webroot containing .png .gif files etc */
	char *pagesdir;		/**< @brief Subdir of webroot containing other .html files */
	char *redirectURL;		/**< @brief URL to direct client to after authentication */
	char *authdir;		/**< @brief Notional relative dir for authentication URL */
	char *denydir;		/**< @brief Notional relative dir for denial URL */
	int passwordauth;		/**< @brief boolean, whether to use password authentication */
	int usernameauth;		/**< @brief boolean, whether to use username authentication */
	char *username;		/**< @brief Username for username authentication */
	char *password;		/**< @brief Password for password authentication */
	int passwordattempts;		/**< @brief Number of attempted password authentications allowed */
	int clienttimeout;		/**< @brief How many CheckIntervals before an inactive client
				   must be re-authenticated */
	int clientforceout;		/**< @brief How many CheckIntervals before a client
				   must be re-authenticated */
	int checkinterval;		/**< @brief Period the the client timeout check
				   thread will run, in seconds */
	int authenticate_immediately;	/**< @brief boolean, whether to auth noninteractively */
	int set_mss;			/**< @brief boolean, whether to set mss */
	int mss_value;		/**< @brief int, mss value; <= 0 clamp to pmtu */
	int traffic_control;		/**< @brief boolean, whether to do tc */
	int download_limit;		/**< @brief Download limit, kb/s */
	int upload_limit;		/**< @brief Upload limit, kb/s */
	int download_imq;		/**< @brief Number of IMQ handling download */
	int upload_imq;		/**< @brief Number of IMQ handling upload */
	int log_syslog;		/**< @brief boolean, whether to log to syslog */
	int syslog_facility;		/**< @brief facility to use when using syslog for logging */
	int macmechanism; 		/**< @brief mechanism wrt MAC addrs */
	t_firewall_ruleset *rulesets;	/**< @brief firewall rules */
	t_MAC *trustedmaclist; 	/**< @brief list of trusted macs */
	t_MAC *blockedmaclist; 	/**< @brief list of blocked macs */
	t_MAC *allowedmaclist; 	/**< @brief list of allowed macs */
	unsigned int  FW_MARK_AUTHENTICATED;    /**< @brief iptables mark for authenticated packets */
	unsigned int  FW_MARK_BLOCKED;          /**< @brief iptables mark for blocked packets */
	unsigned int  FW_MARK_TRUSTED;          /**< @brief iptables mark for trusted packets */
    
    //damon add on 14/12/11
    char *auth_server;
    unsigned int auth_port;
    char *auth_path;
    char *config_path;
    char *net_traffic_path;
    t_IP *free_ip_list;
    int uid;
    //damon end
} s_config;

/** @brief Get the current gateway configuration */
s_config *config_get_config(void);

/** @brief Initialise the conf system */
void config_init(void);

/** @brief Initialize the variables we override with the command line*/
void config_init_override(void);

/** @brief Reads the configuration file */
void config_read(const char *filename);

/** @brief Check that the configuration is valid */
void config_validate(void);

//damon add 2014/12/11
//get config from server
void config_from_server();
void free_ip_init();
//end

/** @brief Fetch a firewall rule list, given name of the ruleset. */
t_firewall_rule *get_ruleset_list(const char *);

/** @brief Fetch a firewall ruleset, given its name. */
t_firewall_ruleset *get_ruleset(const char *);

/** @brief Add a firewall ruleset with the given name, and return it. */
static t_firewall_ruleset *add_ruleset(char *);

/** @brief Say if a named firewall ruleset is empty. */
int is_empty_ruleset(const char *);

/** @brief Get a named empty firewall ruleset policy, given ruleset name. */
char * get_empty_ruleset_policy(const char *);

void parse_trusted_mac_list(char *);
void parse_blocked_mac_list(char *);
void parse_allowed_mac_list(char *);
int check_ip_format(const char *);
int check_mac_format(char *);

/** config API, used in commandline.c */
int set_log_level(int);
int set_password(char *);
int set_username(char *);



#define LOCK_CONFIG() do { \
	debug(LOG_DEBUG, "Locking config"); \
	pthread_mutex_lock(&config_mutex); \
	debug(LOG_DEBUG, "Config locked"); \
} while (0)

#define UNLOCK_CONFIG() do { \
	debug(LOG_DEBUG, "Unlocking config"); \
	pthread_mutex_unlock(&config_mutex); \
	debug(LOG_DEBUG, "Config unlocked"); \
} while (0)

#endif /* _CONF_H_ */
