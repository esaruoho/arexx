/*
   PlotCMD v1.21 - GUI script (run with MUIRexx)
   For use with OctaMED Soundstudio
   Read the PlotCMD doc for details
*/

Window_PublicScreen	=	0x804278e4
String_Accept		=	0x8042e3e1
String_MaxLen		=	0x80424984
FixWidthTxt		=	0x8042d044

address PLOTCMD

window ID PAGE TITLE """PlotCMD""" COMMAND """quit""" PORT PLOTCMD ATTRS Window_PublicScreen "OCTAMED"
 label CENTER "\0333Presets:"
 group HORIZ
  image COMMAND "PlotCMD:preset_fadein.omed"	SPEC "4:PlotCMD:pic_fadein.ilbm"
  image COMMAND "PlotCMD:preset_fadeout.omed"	SPEC "4:PlotCMD:pic_fadeout.ilbm"
  image COMMAND "PlotCMD:preset_sine.omed"	SPEC "4:PlotCMD:pic_sine.ilbm"
  image COMMAND "PlotCMD:preset_invsine.omed"	SPEC "4:PlotCMD:pic_invsine.ilbm"
  image COMMAND "PlotCMD:preset_cosine.omed"	SPEC "4:PlotCMD:pic_cosine.ilbm"
  image COMMAND "PlotCMD:preset_invcosine.omed" SPEC "4:PlotCMD:pic_invcosine.ilbm"
  image COMMAND "PlotCMD:preset_random.omed"	SPEC "4:PlotCMD:pic_random.ilbm"
  image COMMAND "PlotCMD:preset_grabtrack.omed" SPEC "4:PlotCMD:pic_grabtrack.ilbm"
 endgroup
 space 1
 label CENTER "\0333Modify:"
 group HORIZ
  label "Frequency:"
  button COMMAND """PlotCMD:mod_multiply.omed"""	LABEL "x2"
  button COMMAND """PlotCMD:mod_divide.omed"""		LABEL "/2"
  space HORIZ VALUE 7
  label "Volume:"
  button COMMAND """PlotCMD:mod_volume.omed 80"""	LABEL "-"
  button COMMAND """PlotCMD:mod_volume.omed 125"""	LABEL "+"
  space HORIZ VALUE 7
  label "Position:"
  image COMMAND """PlotCMD:mod_left.omed"""	SPEC "4:PlotCMD:pic_left.ilbm"
  image COMMAND """PlotCMD:mod_up.omed"""	SPEC "4:PlotCMD:pic_up.ilbm"
  image COMMAND """PlotCMD:mod_down.omed"""	SPEC "4:PlotCMD:pic_down.ilbm"
  image COMMAND """PlotCMD:mod_right.omed"""	SPEC "4:PlotCMD:pic_right.ilbm"
 endgroup
 space 1
 label CENTER "\0333Command:"
 group HORIZ
  button COMMAND """PlotCMD:cmd_0-40.omed 0C"""		LABEL "Velocity"
  button COMMAND """PlotCMD:cmd_0-7F.omed 17"""		LABEL "MIDI Vol"
  button COMMAND """PlotCMD:cmd_0-7F.omed 0E"""		LABEL "MIDI Pan"
  button COMMAND """PlotCMD:cmd_80-0-7F.omed 13"""	LABEL "Pitch Bend"
  button COMMAND """PlotCMD:cmd_0-7F.omed 04"""		LABEL "Mod Wheel"
  button COMMAND """PlotCMD:cmd_0-7F.omed 0D"""		LABEL "Aftertouch"
 endgroup
 group HORIZ
  string ID CMDST ATTRS String_MaxLen 3 String_Accept '"=0123456789abcdefABCDEF"' FixWidthTxt "MMM"
  label "->"
  button COMMAND """PlotCMD:cmd_0-7F.omed ENTRY""" ATTRS FixWidthTxt "MMMMM" LABEL "0-7F"
  button COMMAND """PlotCMD:cmd_0-FF.omed ENTRY""" ATTRS FixWidthTxt "MMMMM" LABEL "0-FF"
 endgroup
endwindow
