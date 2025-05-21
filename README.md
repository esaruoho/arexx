# Arexx
I've found it immensely hard to just find OctaMED AREXX/REXX stuff. This Repository tries to collect them together and functions as a notepad and as a stash.


## Aminet

### OctaScripts & OctaScripts2.lha
Source: https://aminet.net/package/mus/edit/OctaScripts
Source: https://aminet.net/package/mus/edit/OctaScripts2
Author: Johan Persson / fash@swipnet.se

```
-------------------------------------------------------------------------
ARexx scripts for use with OctaMED. Tested with OctaMED Soundstudio
v1.03c (ARexx v3), but might work with OctaMED v6 too.
-------------------------------------------------------------------------


Here are some scripts that have been very useful to me. It's no
complicated stuff but could at least serve as an inspirational source
(?)...


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

"MIDIchannel+1"     - Increases the MIDI channel on the current
                      instrument.

"MIDIchannel-1"     - Guess what it does...

"MIDIpreset+1"      - Increases/decreases the MIDI preset in the valid
"MIDIpreset-1"        range (0-128).

"MIDIpreset_Random" - Picks a random MIDI preset between 1 and 128.

"Project_Info"      - Lotsa things! (Type of samples used, delete
                      unused blocks, length of song...)
-------------------------------------------------------------------------
```

and

```
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
```
and
```
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
```

### 8med.lha
Source: https://aminet.net/package/util/rexx/8med
Author: Fred Brooker / Contortion, halloran@sci.muni.cz

```
This file will contain all MY own AREXX Octamed v6.0
related work. You can also contribute with scripts of your
own if you like the idea - no binaries, no illegals. ;)

This pack gets updated once a month, look for a site address
below.

All my work keep being copyrighted as long as you use my
ideas and the main part of the code, neither I do not ask
 you to pay, register nor send me a postcard.

Anyway if you feel so, do NOT hesitate to warm your mailer up!


             =================================
             Cheers, Fred Brooker / Contortion
                   halloran@sci.muni.cz
             =================================


               Archive address:

 ftp://ftp.chemi.muni.cz/amiga/arexx/8med.lha
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
```



