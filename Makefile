#
#  Makefile to build a Tcl/Tk control program for Beagle Board
#  controller for 8-channel signal switcher.
#

CC = gcc $(CAMAC)
INCLUDEDIR=-I. -I$(INSTDIR)/Include -I$(DESTROOT)/Include \
	   -I/usr/local/include -I/usr/include/tcl8.6
#/usr/opt/daq/8.2/TclLibs

LDFLAGS=-L$(INSTDIR)/Lib -L/usr/lib/ -ltcl8.6 -ltk8.6 $($(VMEDEVICE)LIBS) \
	-lpthread 
COMMONSW= -pthread -c    -D__unix__ -D_NEED_BOOL_T  $(INCLUDEDIR)
OPTSW   =  -g $(COMMONSW)
NOOPTSW = -g $(COMMONSW)
CPP = g++
# note: called procedures MUST be before calling proc!
PROGOBJS= TCLThread.o switch_wrap.o switch.o

all : Program

Program: $(PROGOBJS)
	g++ -o switch  $(PROGOBJS) $(LDFLAGS)

test: test.o	
	g++ -o test test.o 	

TCLThread.o: TCLThread.cpp
	$(CPP) $(OPTSW) $<

switch.o: switch.cpp
	$(CPP) $(OPTSW) $<

switch_wrap.o: switch_wrap.cxx
	$(CPP) $(OPTSW) $<

switch_wrap.cxx: switch.swi
	swig -tcl -c++ $<

clean:
	rm -f *.o

depend:
	gcc -MM $(CPPFLAGS) *.cpp

