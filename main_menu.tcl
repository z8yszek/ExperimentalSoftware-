#!/usr/local/bin/wish

wm title . "Signal Switcher Controller"

global switcher
global setup
global .main
global tnInfo
#Create frames

# buttons

source notebook.tcl
source tabnbook.tcl
source mclistbox.tcl

tabnotebook_create .main
pack .main -expand 1 -fill both

#set switcher [tabnotebook_page .main Switcher]
#tabnotebook_display .main Switcher

# set setup [tabnotebook_page .main  "Network Setup"]

source setup.tcl
source switch.tcl

tabnotebook_display .main "Switcher"