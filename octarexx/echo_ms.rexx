/* tempo */
address 'OCTAMED_REXX'
options results

'sg_gettempo var tempo'
'sg_gettempolpb var lines'

ekko = 240000 % tempo % lines

wi_showstring 'Echo rate changed to ' ekko 'ms.'
sg_mixecho rate ekko

/* This program sets the ECHO ms rate to the correct value   */
/* depending on the tempo and line per beat value so that    */
/* the echo rate will be in time with the tempo of the music */

/* tempo must be in BPM for this to work !!                  */

