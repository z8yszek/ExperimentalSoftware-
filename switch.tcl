#!/usr/local/bin/wish

# this is the GUI for the 32 to 8 channel signal multiplexer
# it uses switch.cpp as the back end to create the net packets
# to actually control the device.

tk appname switch
wm title . "Signal Switcher Control"
#wm geometry . 800x400
set widgetDemo 1


global switcher
global .main
global tnInfo

#source notebook.tcl
#source tabnbook.tcl
#source mclistbox.tcl

set switcher [tabnotebook_page .main "Switcher"]

# set all  chans to off
    global chanValue1 chanValue2 chanValue3 chanValue4
    global chanValue5 chanValue6 chanValue7 chanValue8
    set barColor(1) #ffff00
    set barColor(2) #0000ff
    set barColor(3) #ff00ff
    set barColor(4) #00ff00
    set barColor(5) #ffff00
    set barColor(6) #0000ff
    set barColor(7) #ff00ff
    set barColor(8) #00ff00
#   set barColor(5) #7f7f7f
#   set barColor(6) #7f7f00
#   set barColor(7) #00007f
#   set barColor(8) #123456

for {set x 1} {$x < 9} {incr x} {
    set chanValue$x 0
}


## Top level
frame $switcher.chan -relief groove -borderwidth 5
frame $switcher.info1 -relief groove -borderwidth 5 
frame $switcher.info2 -relief groove -borderwidth 5

# frame .mb
#for {set x 1} {$x < 9} {incr x} {
#    frame $switcher.channel.$x
#}

label $switcher.credit -text "Written by Jon Elson"
pack $switcher.credit -fill x -side top

pack $switcher
#-side left -fill x -fill y

	    set bgcolor green

for {set x 1} {$x < 9} {incr x} {


    if {$x < 5} {
	    set bgcolor lightgrey
    } else {
    set bgcolor darkgrey
    }

    frame $switcher.chan.$x -relief groove -borderwidth 5     -background $bgcolor \

    scale $switcher.chan.$x.scale \
	-length 340\
	-width 15 \
	-variable chanValue$x \
 	-command "SetChan $x" \
	-from 0  \
	-orient h \
	-to 31 \
	-tickinterval 0 \
        -background $bgcolor \
        -troughcolor $barColor($x)

#    bind $switcher.chan.$x.scale <ButtonRelease-1> \
\#	{SetChan $x {chanValue$x}}
    label $switcher.chan.$x.label \
        -background $bgcolor \
	-text "Output $x" 
    pack $switcher.chan.$x.label $switcher.chan.$x.scale -side left
    pack  $switcher.chan.$x -fill x -side top
}

set empty_space ""
# Open the text file for reading
set file [open "channels.txt" "r"]
# Read and print each line of the file
while {[gets $file line] != -1} {
    set nwords [split $line]
    set values_temp ""
    if {[llength $nwords] >= 1} {
        set key [lindex $nwords 0]
	for {set c 1} {$c < [llength $nwords]} {incr c} {
	    set value_temp [lindex $nwords $c]
	    append values_temp $value_temp " "
	}
	set values [lsearch -all -inline -not $values_temp {}]
        set chname($key) $values
    }
}   

# Close the file handle
close $file
#parray chname
for {set x 0} {$x < 32} {incr x} {

    if {$x < 16} {
	set i 1;
    } else {
	set i 2;
    }
    set chname_s "-"
    if {[info exists chname($x)] && $chname($x) ne "" } {
	set chname_s $chname($x)
    }
    label $switcher.info$i.l$x -text "$x: $chname_s"
    #$chname($x)" 
    pack $switcher.info$i.l$x -anchor w
}

pack $switcher.chan -side left -fill both -expand true
pack $switcher.info1 -side left -fill both -expand true
pack $switcher.info2 -side left -fill both -expand true

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
