
#ifndef CENTERSERVER_H
#define CENTERSERVER_H

int resolve_host(char *hostname,char* ip);
//int http_get_request(char *ip,int port,char *path,int id,char *version,char *buf);
int http_get_request(char *ip,int port,char *path,char* query,char *version,char *buf);

#endif
