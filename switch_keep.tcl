#!/usr/local/bin/wish

# this is the GUI for the 32 to 8 channel signal multiplexer
# it uses switch.cpp as the back end to create the net packets
# to actually control the device.

tk appname switch
wm title . "Signal Switcher Control"
set widgetDemo 1


global switcher
global .main
global tnInfo

#source notebook.tcl
#source tabnbook.tcl
#source mclistbox.tcl

set switcher [tabnotebook_page .main "Switcher"]



# set all  chans to off
    global chanValue(1) chanValue(2) chanValue(3) chanValue(4)
    global chanValue(5) chanValue(6) chanValue(7) chanValue(8)
    set barColor(1) #ffff00
    set barColor(2) #0000ff
    set barColor(3) #ff00ff
    set barColor(4) #00ff00
    set barColor(5) #7f7f7f
    set barColor(6) #7f7f00
    set barColor(7) #00007f
    set barColor(8) #123456


for {set x 1} {$x < 9} {incr x} {
    set chanValue($x) 0
}


## Top level
frame $switcher.chan -relief groove -borderwidth 5

# frame .mb
#for {set x 1} {$x < 9} {incr x} {
#    frame $switcher.channel.$x
#}

label $switcher.credit -text "Written by Jon Elson"
pack $switcher.credit -fill x -side top

pack $switcher -side left -fill x -fill y
for {set x 1} {$x < 9} {incr x} {
    frame $switcher.chan.$x -relief groove -borderwidth 5
# 	-command "SetChan $x" \

    scale $switcher.chan.$x.scale \
	-length 100\
	-width 11 \
	-variable chanValue($x) \
	-from 0  \
	-orient h \
	-to 32 \
	-tickinterval 0 \
        -troughcolor $barColor($x)
    bind $switcher.chan.$x.scale <ButtonRelease-1> \
	{SetChan $x chanValue($x)}
    label $switcher.chan.$x.label \
	-text "Output$x"
    pack $switcher.chan.$x.label $switcher.chan.$x.scale -side left
    pack  $switcher.chan.$x -fill x -side top
}
pack $switcher.chan

tabnotebook_refresh .main
tabnotebook_display .main Switcher


proc SetChan {chan value} {
#    puts stdout [format "SetChan %d %d" $chan $value]
    Set_Chan $chan $value
}

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

proc FileDialog {wind ent operation} {
    #   Type names              Extension(s)    Mac File Type(s)
    #
    #---------------------------------------------------------
    set types {
        {"Setup files"          {.setup .Setup} }
	{"All files"            *}
    }
    if {$operation == "load"} {
        set file [tk_getOpenFile -filetypes $types -parent $wind]
        puts "filename is $file"
        ReadSetupFile $file
#        reload
    } else {
        set file [tk_getSaveFile -filetypes $types -parent $wind \
            -initialfile Untitled -defaultextension .setup]
        puts "filename is $file"
        WriteSetupFile $file
    }
    UpdatePage
}
