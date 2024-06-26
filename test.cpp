#include <iostream>
#include <fstream>
#include <netdb.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <stdio.h>
#include <string.h>
using namespace std;

int main()
{

  ifstream namef;
  namef.open("config.txt");

  string comment;
  string host;
  getline(namef,comment);
  getline(namef,host);
  cout << host << endl;
  
  unsigned long int ipaddr;
  struct hostent* pEntry;

  ipaddr = inet_addr(host.c_str());
  if(ipaddr == INADDR_NONE) {
    pEntry = gethostbyname(host.c_str());
    if(pEntry) memcpy(&ipaddr,pEntry->h_addr,4);
  }
  if(!pEntry)
    cout << "Null return from gethostbyname" << endl;

  struct in_addr **addr_list;
  addr_list = (struct in_addr **)pEntry->h_addr_list;
  char * ipAddr = inet_ntoa(*addr_list[0]);
  cout << ipAddr<< endl;

  int a,b,c,d;
  sscanf(ipAddr,"%d.%d.%d.%d",&a,&b,&c,&d);

  cout << "A = " << a << " B = " << b << " C = " << c << " D = " << d << endl;

  return 1;
}
