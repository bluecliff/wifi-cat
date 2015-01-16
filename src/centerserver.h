
#ifndef CENTERSERVER_H
#define CENTERSERVER_H

int resolve_host(char *hostname,char* ip);
int config_request(char *ip,int port,char *path,int id,char *version,char *buf);

#endif
