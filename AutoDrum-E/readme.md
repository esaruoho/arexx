Short:        Drum Machine Plug-in for Octamed SS 1.03c
Author:       dkrupicz@interlog.com
Uploader:     dkrupicz interlog com
Type:         mus/misc
Architecture: m68k-amigaos

This arexx script creates a drum machine with GUI on the Octamed SoundStudio
screen.  Using Amiga samples, and the first four tracker channels, the user
is able to select instruments, and easily edit drum beats.

Features:
- Extreme GUI
- Block playing control from the GUI window
- Scroll selection through samples
- Accent control using 0Cxx commands
- Erasing of tracks
- Range copying
- Multiple block length support
- Quick cycle-gadget interface when used with CycleToMenu.

'AutoDrum-e' requires:

   Rexxreqtools.library
   Rexxsupport.library
   Varexx.lha  gui system for arexx scripts
   OctaMed Sound Studio

   I recommend that you install the commodity 'Cycle to menu' by
   F. Giannici (available on Aminet..)  It makes the use of AutoDrum *A LOT*
   easier.

   'octamed-d.gui' must be located in 'ram:rexx/gui/resonance.gui'

The included Arexx script 'AutoDrum_Demo.rexx' is an interactive guide to the
GUI of AutoDrum
