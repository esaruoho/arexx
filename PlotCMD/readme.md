
                  PlotCMD v1.21 (99-03-17)
          An ARexx plug-in for OctaMED Soundstudio


INTRODUCTION
------------------------------------------------------------
PlotCMD let's you make note command changes in OctaMED
Soundstudio in a graphical way. You can plot a curve in
OctaMED's sample editor, or choose a pre-defined one, and
then apply it to a track's command levels.
This way you won't have to "hard code" volume fadings,
filter sweeps etc. into the tracker.


HISTORY
------------------------------------------------------------
v1.21 Added nice pictures, "Random" button and manual
      command entry
v1.0  First released


REQUIREMENTS    (can be found on Aminet)
------------------------------------------------------------
- OctaMED Soundstudio
- MUIRexx (which requires MUI 3.0+)
- MOOS (for mathemathical operations)


INSTALLATION
------------------------------------------------------------
Copy the "PlotCMD" dir to wherever you want. Assign
"PlotCMD:" to that dir. Set up a keyboard shortcut in
OctaMED ("Settings"/"Keyboard Shortcuts" in the menu) as
follows:

Action:	 "Launch Program"
Command: "MUIRexx:MUIRexx PlotCMD:PlotCMD.rexx PORT PLOTCMD"

If you have WB 2.x (no datatypes support) or if you have
problems with the MUI images, use "PlotCMD_NOPICS.rexx"
istead of "PlotCMD.rexx". It has the same functions but no
good looking images.


HOW IT WORKS
------------------------------------------------------------
The "Presets:" buttons calculates different waveforms to be
used later on. Pressing one of these doesn't alter the
track, just the sample. The length of the rendered sample
will be the length of the current block.

The "Modify:" buttons modifies the waveform. Could be done
with the sample editor as well, but these make things
easier. All pretty self-explaining...

"Command:" buttons: Pressing one of these applies the
waveform to the commands on the current track (and the
current Cmd Page).
The top row buttons (Velocity, MIDI Vol...) are pre-defined.
The differences between these buttons are the command number
+ the way the data is beeing formatted (0-$40, 0-$7F etc).
Bottom row: The string gadget let's you enter a command
number (in hex) which is applied by pressing one of the two
buttons to the right. Again, these two buttons decide how
the data is formatted.

Note that all operations are performed on the last sample
(#1V).


BUGS
------------------------------------------------------------
- Tons of strange unprecise decimal roundings everywhere...
- Maybe strange colors on the images (?).
- Only tested on my 060 - I don't know how fast it is on a
  slow machine.


AUTHOR
------------------------------------------------------------
Johan Persson
fash@swipnet.se
http://fly.to/fash
