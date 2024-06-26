#!/usr/local/bin/wish

# this program sets the IP address of the switcher module
# set setup [tabnotebook_page .main "JE Bus Setup"]
package require dns
global setup
global IP1 IP2 IP3 IP4

tk appname IPConfigure
wm title . "Washington University Switcher IP Address"
set widgetDemo 1

set setup [tabnotebook_page .main "Network Setup"]

## Top level
frame $setup.ip
pack $setup.ip  -fill x -fill y

## Default IP address of switcher module
## can be overridden by the GUI later
#set IP1 35
#set IP2 9
#set IP3 56
#set IP4 192

#This is the name of the pico switcher to be used to find the IP address

#set hostname picosw1.nscl.msu.edu
set hostname 10.32.8.111
#set ipadd [::dns::address [::dns::resolve $hostname]]
set ipadd 10.32.8.112

puts "defined hostname is $hostname"

set var [list IP1 IP2 IP3 IP4]
set m 0

foreach i $var {
    set $i [lindex [split $ipadd "."] $m]
    incr m

}

puts "found ip of host is $ipadd"


#set IP1 10
#set IP2 65
#set IP3 40
#set IP4 130

label $setup.ip.title -text "Signal Switcher IP Address"  
pack $setup.ip.title -side top

for {set x 1} {$x < 5} {incr x} {
    entry $setup.ip.$x -width 10 -relief sunken -textvariable "IP$x"
    pack $setup.ip.$x -side left
}
button $setup.ip.load -text "Load IP Address" \
    -command {LoadIP}
pack $setup.ip.load -side top
pack $setup

######### end of TK stuff now proc's #########

proc LoadIP {} {
    global IP1 IP2 IP3 IP4
    Load_IP $IP1 $IP2 $IP3 $IP4
}
LoadIP

proc Quit {} {
    global shaperflag discflag
    set check 0

    if {$shaperflag == 1 || $discflag == 1} {
	set check [tk_dialog .quit "Exiting Program" \
		       "You have made changes since you last saved\n Exit losing changes?" \
		       warning 1 "Exit anyway"  Cancel]
    }

    if {$check == 0} exit
}

