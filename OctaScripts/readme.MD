Short:    3 ARexx scripts for OctaMED SoundStudio
Author:   fash@swipnet.se (Johan Persson)
Uploader: fash@swipnet.se (Johan Persson)
Type:     mus/edit

---------------------------------------------------------

3 small ARexx scripts for use with OctaMED (tested with
OctaMED Soundstudio but probably works with earlier
versions as well).


"SwapInNrTrack" - Replaces instrument number under cursor
                  with the selected instrument's number
                  (on current track).

"SwapInNrBlock" - Replaces instrument number under cursor
                  with the selected instrument's number
                  (on current block).

"Crossfade" - Cross fades sample ala Protracker. Doesn't
              work with stereo samples because of a bug
              in OctaMED.

---------------------------------------------------------

Made in August 1999 by Johan Persson. Contact me for
anything at fash@swipnet.se

-----
-------------------------------------------------------------------------
                "Project Info" v1.0 - documentation
-------------------------------------------------------------------------

ARexx script for use with OctaMED.

This is one of my first encounters with ARexx, so it's really lousy
written. It works fine for me though...


-------------------------------------------------------------------------
                              Features
-------------------------------------------------------------------------
  displays...

- Module status (saved/unsaved)
- Tempo (BPM)
- Estimated time (only works if speed is set to '3' and all blocks
                  have a length of 64 lines, but still gives an idea
                  of the actual song length)
- Nr. of unused blocks
- Nr. of 8-bit samples used
- Nr. of 16-bit samples used
- Nr. of MIDI instruments used
- Nr. of times each MIDI channel (1-16) has been used

+ Button to delete unused blocks (all/defined)

I also wanted to display the module length (in bytes), but this is not
possible due to a bug in OctaMED. Executing ARexx command
SG_GETFILESIZE returns the file size, but also makes OctaMED believe
that the current module has been saved.

-------------------------------------------------------------------------
                             Requirements
-------------------------------------------------------------------------

- Tested with OctaMED Soundstudio v1.03c (ARexx v3), might work
  with OctaMED v6 too.
- Rexxreqtools.library (available on Aminet...)


-------------------------------------------------------------------------
                                Author
-------------------------------------------------------------------------

Johan Persson

planet4@swipnet.se
http://home6.swipnet.se/~w-68753/johan.html


--
-------------------------------------------------------------------------
ARexx scripts for use with OctaMED. Tested with OctaMED Soundstudio
v1.03c (ARexx v3), but might work with OctaMED v6 too.
-------------------------------------------------------------------------

Here are some scripts that have been very useful to me. It's no
complicated stuff but could at least serve as an inspirational source
(?)...

-------------------------------------------------------------------------
                           What's the use?
-------------------------------------------------------------------------

"AboveCMD_cpy"      - Copies the command from the above line and pastes
                      it on the current one.

"AboveCMD_dec"      - Copies the command from the above line, decreases
                      it and pastes it on the current one.

"AboveCMD_inc"      - Copies the command from the above line, increases
                      it and pastes it on the current one.

Original idea from ProTracker...
The difference between these scripts and similar ones are that these
only act if EDIT is ON and they work correctly when jumping from
the end to the start of the block.
They tend to be a bit slow (if you compare them with the original
Protracker functions). I copy mine to RAM: every startup, but I really
don't know how much speed you gain on this... Maybe they speed up a bit
if you remove the comments and empty lines?

"MIDIchannel+1"     - Increases the MIDI channel on the current
                      instrument and sets the volume to 64 if it was 0
                      from the beginning. This is beacuse not defined
                      instuments always has the MIDI channel and the
                      volume set to zero.

"MIDIchannel-1"     - Guess what it does... No need for volume checking
                      here...

"MIDIpreset+1"      - Increases/decreases the MIDI preset in the valid
"MIDIpreset-1"        range (0-128).

"MIDIpreset_Random" - Picks a random MIDI preset between 1 and 128.

"Project_Info"      - See the separate doc!


-------------------------------------------------------------------------
                             Installation
-------------------------------------------------------------------------

Just add a hotkey in menu 'Settings/Keyboard shortcuts'. Set 'Action'
to 'Execute ARexx File' and 'Command' to 'Rexx:SCRIPTNAME' (or whereever
you place the script file). Make sure you have RexxMast running.


-------------------------------------------------------------------------
                                Author
-------------------------------------------------------------------------

Johan Persson

planet4@swipnet.se
http://home6.swipnet.se/~w-68753/johan.html
