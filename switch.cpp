#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include "TCLThread.h"


//         #include <jebus.h>
#define num_channels  8
#define num_inputs 32
#define PORT        2020
             /* REPLACE with your server machine name*/
//#define HOST        "128.252.127.195"
#define HOST        "10.65.40.130"
#define DIRSIZE     8192

// global variables for net socket
char hostname[100];
char    dir[DIRSIZE];
int	sd;
struct sockaddr_in sin;
struct sockaddr_in pin;
struct hostent *hp;
int i,j,k, charptr;
char charbuf [50];
int   SockOpen = 0;

// local data base
static unsigned int InputChan[num_channels];

FILE *dbfile;

unsigned int Get_Chan(int chan) {
  unsigned int input;
  input = InputChan[chan];
  printf("get_Chan  %d selected %d\n",chan, input);
  return (input);
}

void Set_Chan(unsigned int chan, int value) {

  InputChan[chan] = value;
  //  printf("set_Chan  chan = %d value = %d\n",chan,value);
  if (SockOpen == 1) {
    //  load_channel(chan,value);
    // send data 3 times with sync code 0xffff preceding
    charptr = 0;
    for (j=1; j < 4; j++) {
      charbuf[charptr++] = 0xff;
      charbuf[charptr++] = 0xff;
      for (i=1; i < 9; i++) {
	//	  sprintf(charbuf,"%3x",i);
	/* send a message to the server PORT on machine HOST */
	charbuf[charptr++] = InputChan[i];
	//	printf("sending message %2x\n",charbuf[0] & 0xff);
      }
    }
    if (send(sd, charbuf, charptr-1, 0) == -1) {
      perror ("send");
      exit(1);
    }
  }
  /* spew-out the results and bail out of here! */
  printf(".");//%s\n", dir);
  fflush(stdout);
 return;
}

void Load_IP (int ip1, int ip2, int ip3, int ip4) {
  //printf("IP Address = %d %d %d %d\n",ip1, ip2, ip3, ip4);
  sprintf(hostname,"%d.%d.%d.%d\00",ip1,ip2,ip3,ip4);
  printf("Host String = %s\n",hostname);
  if (ip1 == 0) {        // use default IP address
    strcpy(hostname,HOST);
  }
    /* go find out about the desired host machine */
  if ((hp = gethostbyname(hostname)) == 0) {
  printf("hp = %x\n",hp);
    perror("Error - gethostbyname");
    exit(1);
  }
  /* fill in the socket structure with host information */
  memset(&pin, 0, sizeof(pin));
  pin.sin_family = AF_INET;
  pin.sin_addr.s_addr = ((struct in_addr *)(hp->h_addr))->s_addr;
  pin.sin_port = htons(PORT);
  
  /* grab an Internet domain socket */
  if ((sd = socket(AF_INET, SOCK_STREAM, 0)) == -1) {
    perror("socket");
    exit(1);
  }
  
  /* connect to PORT on HOST */
  if (connect(sd,(struct sockaddr *)  &pin, sizeof(pin)) == -1) {
    perror("connect");
    exit(1);
  }
  SockOpen = 1;           // mark socket as open for communication
  //  return;
}


void ReadSetupFile(char* filename) {
  int i,j,k,group,dt,dm,st,sm,addr,chan;

  printf("Opening file '%s' for reading.\n",filename);
  dbfile = fopen(filename,"r");
  if (dbfile == NULL)
    printf("file could not be opened for reading.\n");
  else {
    fscanf(dbfile," ");    // gobble something at beginning ?
    // read in module map
    for (i=1;i<=num_channels;i++) {
      //      printf("Reading line %d of module map\n",i);
      fscanf(dbfile,"%d\n",&InputChan[i]);
      //      printf("Read completed of line %d of module map\n",i);
    fclose(dbfile);
    }
  }
  for (i=1;i<=num_channels;i++) {
    //	load_channel(chan,InputChan[chan]);
  }
}
  
void WriteSetupFile(char* filename) {
  int i,j,k;

  dbfile = fopen(filename,"w");
  if (dbfile == NULL)
    printf("file could not be opened for writing.\n");
  else {
    // write module map
    for (i=1;i<=num_channels;i++) {
      fprintf(dbfile,"%d\n",InputChan[i]);
    }
    fclose(dbfile);
  }
}
  

int main ()
  {
    TCLTK  interp;
    //    char* TclArgs[]={"CHIP", "./mball.tcl"};
    char* TclArgs[]={"CHIP", "./main_menu.tcl"};

  printf("starting interpreter\n");
  interp.Start(2,TclArgs);
  while(1)
    sleep(100);

  }


/* {
	close(sd);
}
*/
 
