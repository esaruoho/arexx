# OctaMED AREXX / REXX
This is a stash of rare AREXX / REXX scripts for OctaMED use. Some of them are from aminet, others from long-dead websites, some from "The Zone". Always looking for more, thank you.

## aminet

### OctaScripts & OctaScripts2.lha
- Source: https://aminet.net/package/mus/edit/OctaScripts
- Source: https://aminet.net/package/mus/edit/OctaScripts2
- Author: Johan Persson / fash@swipnet.se

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
- Source: https://aminet.net/package/util/rexx/8med
- Author: Fred Brooker / Contortion, halloran@sci.muni.cz

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


### Octarexx

- Source: https://aminet.net/package/mus/misc/octarexx
- Author: David T. Krupicz

```
Short:        3 useful Octamed SoundStudio Arexx scripts
Author:       David T. Krupicz
Uploader:     David T  Krupicz <dkrupicz interlog com>
Type:         mus/misc
Architecture: generic

Flip_Track.rexx      flips a track or selected range upside-down
Echo_Ms.rexx         sets MIX mode echo rate to sync with BPM
Sysestocc_gui.rexx   patch librarian for Chroma Polaris keyboard owners
```

### Octahigh

- Source: http://www.aminet.net/package/mus/misc/octahigh
- Author: Kjetil S. Matheussen

```
Short:        Two arexx-scripts for octamed.
Author:       kjetilma@ifi.uio.no (Kjetil S. Matheussen)
Uploader:     kjetilma ifi uio no (Kjetil S  Matheussen)
Type:         mus/misc
Requires:     Octamed 6 or OSS
Architecture: generic

Two rexx-scripts that makes the cursor
move to the next or previous highlightened
line in Octamed.
```

### Octaflip

- Source: https://aminet.net/package/mus/misc/octaflip
- Author: Kjetil S. Matheussen

```
Short:        6 arexx-scripts for octamed.
Author:       kjetilma@ifi.uio.no (Kjetil S. Matheussen)
Uploader:     kjetilma ifi uio no (Kjetil S  Matheussen)
Type:         mus/misc
Architecture: generic

Six rexx-scripts that flips a range, a track
or a block in Octamed.

When you flip, you do this:

This..becomes...this.
--------------------
C-2   ------->  F-4
---   ------->  ---
F-4   ------->  C-2


In other words: You play your music backwards!


flip_allcmd.omed      - flips range or track, and all cmd-pages.
flip_nocmd.omed       - flips range or track, but not the cmd-information.
flip_onlycmd.omed     - flips range or track, but _only_ the current cmd-information.
flipblock_nocmd.omed  - flips the current block, but not the cmd-information.
flipblock_allcmd.omed - flips the current block, and all cmd-pages.
flipblock_highlights.omed - do only flip the highlights on the current block.

Note: flipblock_nocmd and flipblock_allcmd allso flips the highlights.


All scripts made by Kjetil S. Matheussen 1998.
Based on an arexx-script made by David t. Krupicz. But that one is
nearly totally rewritten.

P.S. You may think this sounds stupid? Try it, and you will
discover new melodies and sounds. BTW: The classic componist,
and the maker of the 12-tone music, Arnold Shoenberg, used
this technik alot in his music. So, why can't you to???
```
