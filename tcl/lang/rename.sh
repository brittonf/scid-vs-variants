#!/bin/sh

for i in czech.tcl hungary.tcl   nederlan.tcl  polish.tcl  deutsch.tcl  francais.tcl  italian.tcl   norsk.tcl   portbr.tcl port.tcl russian.tcl  serbian.tcl  swedish.tcl spanish.tcl greek.tcl ; do 
if [ -e $i.new ] ; then
  mv $i $i.bak
  mv $i.new $i
fi
done
