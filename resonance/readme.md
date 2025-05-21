Short:        Analog resonance for Octamed SS ( Arexx )
Author:       dkrupicz@interlog.com
Uploader:     dkrupicz interlog com
Type:         mus/misc
Architecture: generic

This arexx script will take a sample loaded into OctaMED Sound Studio and
add analog - style 'resonance' to the sample based on the values of various
parameters in a GUI window which pops up on the OCSS screen

The frequency, mix level, decay rate, frequency modifier, active threshold
and computation distance can all be changed.  'Resonance' acts on the current
selected range in the OCSS Sample Editor window.

'Resonance' requires:

   Rexxmathlib.library
   Rexxreqtools.library
   Rexxsupport.library
   Varexx.lha  gui system for arexx scripts
   OctaMed Sound Studio

   'resonance.gui' must be located in 'ram:rexx/gui/resonance.gui'

'Resonance' is slow (approx 13 sec for 256 bytes on my 68020 ) , but it does
a good job of imitating the resonant filters of analog synths such as the
TB-303.   It is best used on short samples ie: bass drums etc...
