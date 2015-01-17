//damon add 2014/12/10
//向指定服务器地址发起http请求，并处理http响应
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/stat.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <errno.h>
#include <unistd.h>
#include <string.h>
#include <syslog.h>

#include "util.h"
#include "common.h"
#include "safe.h"
#include "debug.h"


int _resolve_host(int level,char *hostname,char* ip)
{
    struct in_addr *h_addr;
    char * popular_servers[] = {
        "www.baidu.com",
        "www.qq.com",
        NULL
    };
    char ** popularserver;
    /*
     * Let's resolve the hostname of the top server to an IP address
     */
    debug(LOG_DEBUG, "Resolving auth server [%s]", hostname);
    level++;
    h_addr = wd_gethostbyname(hostname);
    if (!h_addr) {
        /*
         * DNS resolving it failed
         *
         * Can we resolve any of the popular servers ?
         */
        debug(LOG_DEBUG, "Level %d: Resolving auth server [%s] failed",level, hostname);
        for (popularserver = popular_servers; *popularserver; popularserver++) {
            debug(LOG_DEBUG, "Level %d: Resolving popular server [%s]",level, *popularserver);
            h_addr = wd_gethostbyname(*popularserver);
            if (h_addr) {
                debug(LOG_DEBUG, "Level %d: Resolving popular server [%s] succeeded = [%s]",level, *popularserver, inet_ntoa(*h_addr));
                break;
            }
            else {
                debug(LOG_DEBUG, "Level %d: Resolving popular server [%s] failed",level, *popularserver);
            }
        }
        /*
         * If we got any h_addr buffer for one of the popular servers, in other
         * words, if one of the popular servers resolved, we'll assume the DNS
         * works, otherwise we'll deal with net connection or DNS failure.
         */
        if (h_addr) {
            free (h_addr);
            /*
             * Yes The auth server's DNS server is probably dead. Try Again
             */
            debug(LOG_DEBUG, "Level %d: Try resolve auth server [%s] again",level,hostname); 
            return _resolve_host(level,hostname,ip);
        }
        else {
            /*
             * No
             * It's probably safe to assume that the internet connection is malfunctioning
             * and nothing we can do will make it work
             */
            debug(LOG_DEBUG, "Level %d: Failed to resolve auth server and all popular servers. "
                    "The internet connection is probably down", level);
            return(-1);
        }
    }
    else {
        /*
         * DNS resolving was successful
         */
        strncpy(ip,inet_ntoa(*h_addr),16);
        debug(LOG_DEBUG, "Level %d: Resolving auth server [%s] succeeded = [%s]", level, hostname, ip);
        return 1;
    }
}

int resolve_host(char *hostname,char *ip)
{
    return _resolve_host(0,hostname,ip);
}

/* Helper function called by connect_auth_server() to do the actual work including 
   recursion
 * DO NOT CALL DIRECTLY
 @param level recursion level indicator must be 0 when not called by _connect_auth_server()
 */
int _connect_auth_server(char* ip,int port) {
    struct sockaddr_in server_addr;
    int sockfd;
    /*
         * Connect to ip
         */
        debug(LOG_DEBUG, "Connecting to auth server %s:%d",ip,port);
        server_addr.sin_family = AF_INET;
        server_addr.sin_port = htons(port);
        server_addr.sin_addr.s_addr = inet_addr(ip);
        memset(&(server_addr.sin_zero), '\0', sizeof(server_addr.sin_zero));
        if ((sockfd = socket(AF_INET, SOCK_STREAM, 0)) == -1) {
            debug(LOG_ERR, "Failed to create a new SOCK_STREAM socket: %s", strerror(errno));
            return(-1);
        }
        if (connect(sockfd, (struct sockaddr *)&server_addr, sizeof(struct sockaddr)) == -1) {
            /*
             * Failed to connect
             */
            debug(LOG_DEBUG, "Failed to connect to auth server %s:%d (%s).", ip,port,strerror(errno));
            close(sockfd);
            return -1;
        }
        else {
            /*
             * We have successfully connected
             */
            debug(LOG_DEBUG, "Successfully connected to auth server %s:%d",ip,port);
            return sockfd;
        }
}

int connect_auth_server(char* ip,int port) {
    int sockfd;
    int level=0;
    while((++level)<=5)
    {
        sockfd = _connect_auth_server(ip,port);
        if (sockfd == -1) {
            debug(LOG_ERR, "Level: %d,Failed to connect to auth servers.",level);
        }
        else {
            debug(LOG_DEBUG, "Connected to auth server");
            return sockfd;
        }
    }
    
    return (-1);
}

//get config from auth server
int config_request(char *ip,int port,char *path,int id,char *version,char *buf)
{
    int sockfd;
    ssize_t numbytes;
    size_t totalbytes;
    int done, nfds;
    fd_set readfds;
    struct timeval timeout;
    sockfd = connect_auth_server(ip,port);
    if (sockfd == -1) {
        /* Could not connect to auth server */
        return (-1);
    }
    memset(buf, 0, MAX_BUF);
    snprintf(buf, MAX_BUF - 1,
            "GET %s?uid=%d HTTP/1.0\r\n"
            "User-Agent: WiFiCat %s\r\n"
            "Host: %s\r\n"
            "\r\n",
            path,
            id,
            version,
            ip);
    debug(LOG_DEBUG, "Sending HTTP request to auth server: [%s]", buf);
    
    send(sockfd, buf, strlen(buf), 0);
    debug(LOG_DEBUG, "Reading response");
    numbytes = totalbytes = 0;
    done = 0;
    do {
        FD_ZERO(&readfds);
        FD_SET(sockfd, &readfds);
        timeout.tv_sec = 30; /* 30 second is as good a timeout as any */
        timeout.tv_usec = 0;
        nfds = sockfd + 1;
        nfds = select(nfds, &readfds, NULL, NULL, &timeout);
        if (nfds > 0) {
            /** We don't have to use FD_ISSET() because there
             *  was only one fd. */
            numbytes = read(sockfd, buf + totalbytes, MAX_BUF - (totalbytes + 1));
            if (numbytes < 0) {
                debug(LOG_ERR, "An error occurred while reading from auth server: %s", strerror(errno));
                close(sockfd);
                return (-1);
            }
            else if (numbytes == 0) {
                done = 1;
            }
            else {
                totalbytes += numbytes;
                debug(LOG_DEBUG, "Read %d bytes, total now %d", numbytes, totalbytes);
            }
        }
        else if (nfds == 0) {
            debug(LOG_ERR, "Timed out reading data via select() from auth server");
            close(sockfd);
            return (-1);
        }
        else if (nfds < 0) {
            debug(LOG_ERR, "Error reading data via select() from auth server: %s", strerror(errno));
            close(sockfd);
            return (-1);
        }
    } while (!done);
     
    close(sockfd);

    buf[totalbytes] = '\0';
    debug(LOG_DEBUG, "HTTP Response from Server: [%s]", buf);
    return 1;
}
