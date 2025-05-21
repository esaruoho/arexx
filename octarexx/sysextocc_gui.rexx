/* chroma polaris SYSEX to OctaMED SS 05xx CC converter */

/* this program requires octamed soundstudio and a 121 byte SYSEX dump file named  */
/* "ram:sysex" , created by the SyX program, utilizing the Chroma Polaris keyboard */
/* Press   LOWER FUNCTION , CASETTE , 12   to cause a patch dump through SYSEX     */
/* Then run this arexx program with the octamed cursor in a blank track            */
/* This will write the corresponding CC data into octamed to program the patch     */

/* can now handle banks of up to 12 sysex dumps */

if ~ 'SHOW'('L',"rexxsupport.library") then DO
   'ADDLIB'('rexxsupport.library',0,-30,0)
   END

if ~ 'SHOW'('L',"rexxarplib.library") then DO
   'ADDLIB'('rexxarplib.library',0,-30,0)
   END

address 'OCTAMED_REXX'
'wi_showstring Octamed Sysex Pull (c) 1997 D. Krupicz'
address 'REXX'

filename = 'GETFILE'('10','10','sysex:','sysex','Select Sysex File...','OCTAMED')

result = 'OPEN'( 'file' , filename , 'R' )         /* open file "ram:default" for input   */

if result = 0 then DO
   address 'OCTAMED_REXX'
   wi_request '"Cannot open file."' '"Okay"'
   address 'rexx'
   EXIT
END

/* to calculate offset... a sysex dump is 121 bytes long, ie 0..120 */
/* byte 0 of the second sysex dump is equal to 121 * 1 */
/* byte 0 of sysex dump x is equal to 0 + 121 * x */

offset = 0
/* say datatype( offset ) */

address 'OCTAMED_REXX'
wi_request '"Offset select"' '"Zero|Cursor..."' VAR selection
/* say 'offsetselect' selection */
IF selection = 1 THEN DO
   offset = 0
   END
ELSE DO
   ed_getcurrline var current_line
/*    say current_line */
   offset = 121 * (current_line - 1)
   END

/* say "offset" offset */

address 'REXX'

/*  ( this is old code intended for 121 byte single files. the offset of 12 is for sysex
   saved by octamed...did this ever work properly though?... */
/*
if  'RIGHT'( 'LEFT'( 'STATEF'(filename) , 8 ) , 3 ) ~= '121' THEN DO
   if  'RIGHT'( 'LEFT'( 'STATEF'(filename) , 8 ) , 3 ) = '133' THEN DO
      offset = 12
   END
   ELSE DO
      address 'OCTAMED_REXX'
      wi_request '"File Not of Required Type" "Okay"'
      EXIT
   END
END
*/

/* osc 1 ring mod */
   'SEEK'( 'file' , 54 + offset , 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )               /* read character                      */
   byte1 = convert( hex )                    /* convert to xxxxxxx byte string      */

   bit = 'LEFT'( ('RIGHT'( byte1 , 4 )) , 1)

   if bit = 0 then DO
      address 'OCTAMED_REXX'
      'op_update off'
      ed_setblocklines 74
      'wi_showstring Octamed Sysex Pull (c) 1997 D. Krupicz'
      'ed_goto line 0'
      'ed_setdata cmdnum 5 qual 28'
      'ed_advanceline down'
      'ed_setdata qual 128'
      'ed_advanceline down'
      address 'REXX'
      END

   if bit = 1 then DO
      address 'OCTAMED_REXX'
      'op_update off'
      ed_setblocklines 74
      'wi_showstring Octamed Sysex Pull (c) 1997 D. Krupicz'
      'ed_goto line 0'
      'ed_setdata cmdnum 5 qual 28'
      'ed_advanceline down'
      'ed_setdata qual 1'
      'ed_advanceline down'
      address 'REXX'
       END

/* osc 1 swp pwm */
   'SEEK'( 'file' , 61 + offset, 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )               /* read character                      */
   byte1 = convert( hex )                    /* convert to xxxxxxx byte string      */

   bit = 'LEFT'( ('RIGHT'( byte1 , 2 )) , 1)
   if bit = 0 then DO
      address 'OCTAMED_REXX'
      'ed_setdata cmdnum 5 qual 98'
      'ed_advanceline down'
      'ed_setdata qual 128'
      'ed_advanceline down'
      address 'REXX'
      END

   if bit = 1 then DO
      address 'OCTAMED_REXX'
      'ed_setdata cmdnum 5 qual 98'
      'ed_advanceline down'
      'ed_setdata qual 1'
      'ed_advanceline down'
      address 'REXX'
      END

/* osc 1 saw pulse */
   'SEEK'( 'file' , 57 + offset, 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )               /* read character                      */
   byte1 = convert( hex )                    /* convert to xxxxxxx byte string      */

   bit = 'LEFT'( ('RIGHT'( byte1 , 2 )) , 1)
   if bit = 0 then DO
      address 'OCTAMED_REXX'
      'ed_setdata cmdnum 5 qual 30'
      'ed_advanceline down'
      'ed_setdata qual 128'
      'ed_advanceline down'
      address 'REXX'
      END

   if bit = 1 then DO
      address 'OCTAMED_REXX'
      'ed_setdata cmdnum 5 qual 30'
      'ed_advanceline down'
      'ed_setdata qual 1'
      'ed_advanceline down'
      address 'REXX'
      END

/* osc1 transpose   44 ....h...  46 .......c  47 ....defg  00cdefgh                 */
   byte = 0                                          /* initialize data byte                */
   'SEEK'( 'file' , 44 + offset, 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )                       /* read character                      */
   byte1 = convert( hex )                            /* convert to xxxxxxx byte string      */
   if ( 'LEFT'( ('RIGHT'( byte1 , 4 )) , 1) ) = 1 THEN byte = byte + 1

   'SEEK'( 'file' , 46 + offset, 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )                       /* read character                      */
   byte1 = convert( hex )                            /* convert to xxxxxxx byte string      */
   if ( 'RIGHT'( byte1 , 1 ) ) = 1 THEN  byte = byte + 32

   'SEEK'( 'file' , 47 + offset, 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )                       /* read character                      */
   byte1 = convert( hex )                            /* convert to xxxxxxx byte string      */
   if ( 'LEFT'( ('RIGHT'( byte1 , 4 )) , 1) ) = 1 THEN  byte = byte + 16
   if ( 'LEFT'( ('RIGHT'( byte1 , 3 )) , 1) ) = 1 THEN  byte = byte + 8
   if ( 'LEFT'( ('RIGHT'( byte1 , 2 )) , 1) ) = 1 THEN  byte = byte + 4
   if ( 'RIGHT'( byte1 , 1 ) ) = 1 THEN  byte = byte + 2
   if byte = 0 THEN byte = 128

  address 'OCTAMED_REXX'
    'wi_showstring Octamed Sysex Pull (c) 1997 D. Krupicz ... working.'
    'ed_setdata cmdnum 5 qual 22'
    'ed_advanceline down'
    'ed_setdata qual 'byte' '
    'ed_advanceline down'
   address 'REXX'

/* osc1 pulse width 57 ....h...  59 ......bc  56 ....defg  0bcdefgh                 */
   byte = 0                                  /* initialize data byte                */
   'SEEK'( 'file' , 57 + offset, 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )               /* read character                      */
   byte1 = convert( hex )                    /* convert to xxxxxxx byte string      */
   if ( 'LEFT'( ('RIGHT'( byte1 , 4 )) , 1) ) = 1 THEN byte = byte + 1

   'SEEK'( 'file' , 59 + offset, 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )               /* read character                      */
   byte1 = convert( hex )                    /* convert to xxxxxxx byte string      */
   if ( 'RIGHT'( byte1 , 1 ) ) = 1 THEN  byte = byte + 32
   if ( 'LEFT'( ('RIGHT'( byte1 , 2 )) , 1) ) = 1 THEN  byte = byte + 64

   'SEEK'( 'file' , 56 + offset, 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )               /* read character                      */
   byte1 = convert( hex )                    /* convert to xxxxxxx byte string      */
   if ( 'LEFT'( ('RIGHT'( byte1 , 4 )) , 1) ) = 1 THEN  byte = byte + 16
   if ( 'LEFT'( ('RIGHT'( byte1 , 3 )) , 1) ) = 1 THEN  byte = byte + 8
   if ( 'LEFT'( ('RIGHT'( byte1 , 2 )) , 1) ) = 1 THEN  byte = byte + 4
   if ( 'RIGHT'( byte1 , 1 ) ) = 1 THEN  byte = byte + 2
   if byte = 0 THEN byte = 128

   address 'OCTAMED_REXX'
    'ed_setdata cmdnum 5 qual 96'
    'ed_advanceline down'
    'ed_setdata qual 'byte' '
    'ed_advanceline down'
   address 'REXX'

/* osc1 pulse mod   61 ....h...  63 ......bc  60 ....defg  0bcdefgh                 */
   byte = 0                                  /* initialize data byte                */
   'SEEK'( 'file' , 61 + offset, 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )               /* read character                      */
   byte1 = convert( hex )                    /* convert to xxxxxxx byte string      */
   if ( 'LEFT'( ('RIGHT'( byte1 , 4 )) , 1) ) = 1 THEN byte = byte + 1

   'SEEK'( 'file' , 63 + offset, 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )               /* read character                      */
   byte1 = convert( hex )                    /* convert to xxxxxxx byte string      */
   if ( 'RIGHT'( byte1 , 1 ) ) = 1 THEN  byte = byte + 32
   if ( 'LEFT'( ('RIGHT'( byte1 , 2 )) , 1) ) = 1 THEN  byte = byte + 64

   'SEEK'( 'file' , 60 + offset, 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )               /* read character                      */
   byte1 = convert( hex )                    /* convert to xxxxxxx byte string      */
   if ( 'LEFT'( ('RIGHT'( byte1 , 4 )) , 1) ) = 1 THEN  byte = byte + 16
   if ( 'LEFT'( ('RIGHT'( byte1 , 3 )) , 1) ) = 1 THEN  byte = byte + 8
   if ( 'LEFT'( ('RIGHT'( byte1 , 2 )) , 1) ) = 1 THEN  byte = byte + 4
   if ( 'RIGHT'( byte1 , 1 ) ) = 1 THEN  byte = byte + 2
   if byte = 0 THEN byte = 128

   address 'OCTAMED_REXX'
    'ed_setdata cmdnum 5 qual 100'
    'ed_advanceline down'
    'ed_setdata qual 'byte' '
    'ed_advanceline down'
   address 'REXX'

/* osc 2 sync */
   'SEEK'( 'file' , 57 + offset, 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )               /* read character                      */
   byte1 = convert( hex )                    /* convert to xxxxxxx byte string      */

   bit = 'RIGHT'( byte1 , 1 )
   if bit = 0 then DO
      address 'OCTAMED_REXX'
      'ed_setdata cmdnum 5 qual 29'
      'ed_advanceline down'
      'ed_setdata qual 128'
      'ed_advanceline down'
      address 'REXX'
      END

   if bit = 1 then DO
      address 'OCTAMED_REXX'
      'ed_setdata cmdnum 5 qual 29'
      'ed_advanceline down'
      'ed_setdata qual 1'
      'ed_advanceline down'
      address 'REXX'
      END

/* osc 2 swp pwm */
   'SEEK'( 'file' , 61 + offset, 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )               /* read character                      */
   byte1 = convert( hex )                    /* convert to xxxxxxx byte string      */

   bit = 'LEFT'( ('RIGHT'( byte1 , 3 )) , 1)
   if bit = 0 then DO
      address 'OCTAMED_REXX'
      'ed_setdata cmdnum 5 qual 99'
      'ed_advanceline down'
      'ed_setdata qual 128'
      'ed_advanceline down'
      address 'REXX'
      END

   if bit = 1 then DO
      address 'OCTAMED_REXX'
      'ed_setdata cmdnum 5 qual 99'
      'ed_advanceline down'
      'ed_setdata qual 1'
      'ed_advanceline down'
      address 'REXX'
      END

/* osc 2 saw pulse */
   'SEEK'( 'file' , 57 + offset, 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )               /* read character                      */
   byte1 = convert( hex )                    /* convert to xxxxxxx byte string      */

   bit = 'LEFT'( ('RIGHT'( byte1 , 3 )) , 1)
   if bit = 0 then DO
      address 'OCTAMED_REXX'
      'ed_setdata cmdnum 5 qual 31'
      'ed_advanceline down'
      'ed_setdata qual 128'
      'ed_advanceline down'
      address 'REXX'
      END

   if bit = 1 then DO
      address 'OCTAMED_REXX'
      'ed_setdata cmdnum 5 qual 31'
      'ed_advanceline down'
      'ed_setdata qual 1'
      'ed_advanceline down'
      address 'REXX'
      END

/* osc2 transpose   46 ....fgh.  49 .....cde  00cdefgh                 */
   byte = 0                                  /* initialize data byte                */
   'SEEK'( 'file' , 46 + offset, 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )               /* read character                      */
   byte1 = convert( hex )                    /* convert to xxxxxxx byte string      */
   if ( 'LEFT'( ('RIGHT'( byte1 , 4 )) , 1) ) = 1 THEN  byte = byte + 4
   if ( 'LEFT'( ('RIGHT'( byte1 , 3 )) , 1) ) = 1 THEN  byte = byte + 2
   if ( 'LEFT'( ('RIGHT'( byte1 , 2 )) , 1) ) = 1 THEN  byte = byte + 1

   'SEEK'( 'file' , 49 + offset, 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )               /* read character                      */
   byte1 = convert( hex )                    /* convert to xxxxxxx byte string      */
   if ( 'LEFT'( ('RIGHT'( byte1 , 3 )) , 1) ) = 1 THEN  byte = byte + 32
   if ( 'LEFT'( ('RIGHT'( byte1 , 2 )) , 1) ) = 1 THEN  byte = byte + 16
   if ( 'RIGHT'( byte1 , 1 ) ) = 1 THEN  byte = byte + 8
   if byte = 0 THEN byte = 128

   address 'OCTAMED_REXX'
    'wi_showstring Octamed Sysex Pull (c) 1997 D. Krupicz ... working..'
    'ed_setdata cmdnum 5 qual 23'
    'ed_advanceline down'
    'ed_setdata qual 'byte' '
    'ed_advanceline down'
   address 'REXX'

/* osc2 pulse width 61 .......b  59 ....gh..  58 ....cdef  0bcdefgh                 */
   byte = 0                                  /* initialize data byte                */
   'SEEK'( 'file' , 61 + offset, 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )               /* read character                      */
   byte1 = convert( hex )                    /* convert to xxxxxxx byte string      */
   if ( 'RIGHT'( byte1 , 1 ) ) = 1 THEN byte = byte + 64

   'SEEK'( 'file' , 59 + offset, 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )               /* read character                      */
   byte1 = convert( hex )                    /* convert to xxxxxxx byte string      */
   if ( 'LEFT'( ('RIGHT'( byte1 , 4 )) , 1) ) = 1 THEN  byte = byte + 2
   if ( 'LEFT'( ('RIGHT'( byte1 , 3 )) , 1) ) = 1 THEN  byte = byte + 1

   'SEEK'( 'file' , 58 + offset, 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )               /* read character                      */
   byte1 = convert( hex )                    /* convert to xxxxxxx byte string      */
   if ( 'LEFT'( ('RIGHT'( byte1 , 4 )) , 1) ) = 1 THEN  byte = byte + 32
   if ( 'LEFT'( ('RIGHT'( byte1 , 3 )) , 1) ) = 1 THEN  byte = byte + 16
   if ( 'LEFT'( ('RIGHT'( byte1 , 2 )) , 1) ) = 1 THEN  byte = byte + 8
   if ( 'RIGHT'( byte1 , 1 ) ) = 1 THEN  byte = byte + 4
   if byte = 0 THEN byte = 128

   address 'OCTAMED_REXX'
    'ed_setdata cmdnum 5 qual 97'
    'ed_advanceline down'
    'ed_setdata qual 'byte' '
    'ed_advanceline down'
   address 'REXX'

/* osc2 pulse mod   65 .....b..  63 ....gh..  62 ....cdef  0bcdefgh                 */
   byte = 0                                  /* initialize data byte                */
   'SEEK'( 'file' , 65 + offset, 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )               /* read character                      */
   byte1 = convert( hex )                    /* convert to xxxxxxx byte string      */
   if ( 'LEFT'( ('RIGHT'( byte1 , 3 )) , 1) ) = 1 THEN byte = byte + 64

   'SEEK'( 'file' , 63 + offset, 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )               /* read character                      */
   byte1 = convert( hex )                    /* convert to xxxxxxx byte string      */
   if ( 'LEFT'( ('RIGHT'( byte1 , 4 )) , 1) ) = 1 THEN  byte = byte + 2
   if ( 'LEFT'( ('RIGHT'( byte1 , 3 )) , 1) ) = 1 THEN  byte = byte + 1

   'SEEK'( 'file' , 62 + offset, 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )               /* read character                      */
   byte1 = convert( hex )                    /* convert to xxxxxxx byte string      */
   if ( 'LEFT'( ('RIGHT'( byte1 , 4 )) , 1) ) = 1 THEN  byte = byte + 32
   if ( 'LEFT'( ('RIGHT'( byte1 , 3 )) , 1) ) = 1 THEN  byte = byte + 16
   if ( 'LEFT'( ('RIGHT'( byte1 , 2 )) , 1) ) = 1 THEN  byte = byte + 8
   if ( 'RIGHT'( byte1 , 1 ) ) = 1 THEN  byte = byte + 4
   if byte = 0 THEN byte = 128

   address 'OCTAMED_REXX'
    'ed_setdata cmdnum 5 qual 101'
    'ed_advanceline down'
    'ed_setdata qual 'byte' '
    'ed_advanceline down'
   address 'REXX'

/* sweep sine square */
   'SEEK'( 'file' , 26 + offset, 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )               /* read character                      */
   byte1 = convert( hex )                    /* convert to xxxxxxx byte string      */

   bit = ( 'RIGHT'( byte1 , 1 ) )
   if bit = 0 then DO
      address 'OCTAMED_REXX'
      'ed_setdata cmdnum 5 qual 6'
      'ed_advanceline down'
      'ed_setdata qual 128'
      'ed_advanceline down'
      address 'REXX'
      END

   if bit = 1 then DO
      address 'OCTAMED_REXX'
      'ed_setdata cmdnum 5 qual 6'
      'ed_advanceline down'
      'ed_setdata qual 1'
      'ed_advanceline down'
      address 'REXX'
      END

/* sweep rate       24 .......b  22 ....gh..  25 ....cdef  0bcdefgh                 */
   byte = 0                                  /* initialize data byte                */
   'SEEK'( 'file' , 24 + offset, 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )               /* read character                      */
   byte1 = convert( hex )                    /* convert to xxxxxxx byte string      */
   if ( 'RIGHT'( byte1 , 3 ) ) = 1 THEN byte = byte + 64

   'SEEK'( 'file' , 22 + offset, 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )               /* read character                      */
   byte1 = convert( hex )                    /* convert to xxxxxxx byte string      */
   if ( 'LEFT'( ('RIGHT'( byte1 , 4 )) , 1) ) = 1 THEN  byte = byte + 2
   if ( 'LEFT'( ('RIGHT'( byte1 , 3 )) , 1) ) = 1 THEN  byte = byte + 1

   'SEEK'( 'file' , 25 + offset, 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )               /* read character                      */
   byte1 = convert( hex )                    /* convert to xxxxxxx byte string      */
   if ( 'LEFT'( ('RIGHT'( byte1 , 4 )) , 1) ) = 1 THEN  byte = byte + 32
   if ( 'LEFT'( ('RIGHT'( byte1 , 3 )) , 1) ) = 1 THEN  byte = byte + 16
   if ( 'LEFT'( ('RIGHT'( byte1 , 2 )) , 1) ) = 1 THEN  byte = byte + 8
   if ( 'RIGHT'( byte1 , 1 ) ) = 1 THEN  byte = byte + 4
   if byte = 0 THEN byte = 128

   address 'OCTAMED_REXX'
    'ed_setdata cmdnum 5 qual 4'
    'ed_advanceline down'
    'ed_setdata qual 'byte' '
    'ed_advanceline down'
   address 'REXX'

/* filter noise */
   'SEEK'( 'file' , 65 + offset, 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )               /* read character                      */
   byte1 = convert( hex )                    /* convert to xxxxxxx byte string      */

   bit = ( 'LEFT'( ('RIGHT'( byte1 , 2 )) , 1) )
   if bit = 0 then DO
      address 'OCTAMED_REXX'
      'ed_setdata cmdnum 5 qual 102'
      'ed_advanceline down'
      'ed_setdata qual 128'
      'ed_advanceline down'
      address 'REXX'
      END

   if bit = 1 then DO
      address 'OCTAMED_REXX'
      'ed_setdata cmdnum 5 qual 102'
      'ed_advanceline down'
      'ed_setdata qual 1'
      'ed_advanceline down'
      address 'REXX'
      END

/* filter cutoff    67 .......b  65 ....gh..  64 ....cdef  0bcdefgh                 */
   byte = 0                                  /* initialize data byte                */
   'SEEK'( 'file' , 67 + offset, 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )               /* read character                      */
   byte1 = convert( hex )                    /* convert to xxxxxxx byte string      */
   if ( 'RIGHT'( byte1 , 1 ) ) = 1 THEN byte = byte + 64

   'SEEK'( 'file' , 65 + offset, 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )               /* read character                      */
   byte1 = convert( hex )                    /* convert to xxxxxxx byte string      */
   if ( 'LEFT'( ('RIGHT'( byte1 , 4 )) , 1) ) = 1 THEN  byte = byte + 2
   if ( 'LEFT'( ('RIGHT'( byte1 , 3 )) , 1) ) = 1 THEN  byte = byte + 1

   'SEEK'( 'file' , 64 + offset, 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )               /* read character                      */
   byte1 = convert( hex )                    /* convert to xxxxxxx byte string      */
   if ( 'LEFT'( ('RIGHT'( byte1 , 4 )) , 1) ) = 1 THEN  byte = byte + 32
   if ( 'LEFT'( ('RIGHT'( byte1 , 3 )) , 1) ) = 1 THEN  byte = byte + 16
   if ( 'LEFT'( ('RIGHT'( byte1 , 2 )) , 1) ) = 1 THEN  byte = byte + 8
   if ( 'RIGHT'( byte1 , 1 ) ) = 1 THEN  byte = byte + 4
   if byte = 0 THEN byte = 128

   address 'OCTAMED_REXX'
    'ed_setdata cmdnum 5 qual 103'
    'ed_advanceline down'
    'ed_setdata qual 'byte' '
    'ed_advanceline down'
   address 'REXX'

/* filter resonance 67 ....fgh.  00000fgh                                           */
   byte = 0
   'SEEK'( 'file' , 67 + offset, 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )               /* read character                      */
   byte1 = convert( hex )                    /* convert to xxxxxxx byte string      */
   if ( 'LEFT'( ('RIGHT'( byte1 , 4 )) , 1) ) = 1 THEN  byte = byte + 4
   if ( 'LEFT'( ('RIGHT'( byte1 , 3 )) , 1) ) = 1 THEN  byte = byte + 2
   if ( 'LEFT'( ('RIGHT'( byte1 , 2 )) , 1) ) = 1 THEN  byte = byte + 1
   if byte = 0 THEN byte = 128

   address 'OCTAMED_REXX'
    'ed_setdata cmdnum 5 qual 104'
    'ed_advanceline down'
    'ed_setdata qual 'byte' '
    'ed_advanceline down'
   address 'REXX'

/* sweep depth      69 .....bcd  66 ....efgh  0bcdefgh                              */
   byte = 0
   'SEEK'( 'file' , 69 + offset, 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )               /* read character                      */
   byte1 = convert( hex )                    /* convert to xxxxxxx byte string      */
   if ( 'LEFT'( ('RIGHT'( byte1 , 3 )) , 1) ) = 1 THEN  byte = byte + 64
   if ( 'LEFT'( ('RIGHT'( byte1 , 2 )) , 1) ) = 1 THEN  byte = byte + 32
   if ( 'RIGHT'( byte1 , 1 ) ) = 1 THEN  byte = byte + 16

   'SEEK'( 'file' , 66 + offset, 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )               /* read character                      */
   byte1 = convert( hex )                    /* convert to xxxxxxx byte string      */
   if ( 'LEFT'( ('RIGHT'( byte1 , 4 )) , 1) ) = 1 THEN  byte = byte + 8
   if ( 'LEFT'( ('RIGHT'( byte1 , 3 )) , 1) ) = 1 THEN  byte = byte + 4
   if ( 'LEFT'( ('RIGHT'( byte1 , 2 )) , 1) ) = 1 THEN  byte = byte + 2
   if ( 'RIGHT'( byte1 , 1 ) ) = 1 THEN  byte = byte + 1
   if byte = 0 THEN byte = 128

   address 'OCTAMED_REXX'
    'wi_showstring Octamed Sysex Pull (c) 1997 D. Krupicz ... working...'
    'ed_setdata cmdnum 5 qual 105'
    'ed_advanceline down'
    'ed_setdata qual 'byte' '
    'ed_advanceline down'
   address 'REXX'

/* envelope depth   69 ....h...  71 ......bc  68 ....defg  0bcdefgh                 */
   byte = 0                                  /* initialize data byte                */
   'SEEK'( 'file' , 69 + offset, 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )               /* read character                      */
   byte1 = convert( hex )                    /* convert to xxxxxxx byte string      */
   if ( 'LEFT'( ('RIGHT'( byte1 , 4 )) , 1) ) = 1 THEN byte = byte + 1

   'SEEK'( 'file' , 71 + offset, 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )               /* read character                      */
   byte1 = convert( hex )                    /* convert to xxxxxxx byte string      */
   if ( 'RIGHT'( byte1 , 1 ) ) = 1 THEN  byte = byte + 32
   if ( 'LEFT'( ('RIGHT'( byte1 , 2 )) , 1) ) = 1 THEN  byte = byte + 64

   'SEEK'( 'file' , 68 + offset, 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )               /* read character                      */
   byte1 = convert( hex )                    /* convert to xxxxxxx byte string      */
   if ( 'LEFT'( ('RIGHT'( byte1 , 4 )) , 1) ) = 1 THEN  byte = byte + 16
   if ( 'LEFT'( ('RIGHT'( byte1 , 3 )) , 1) ) = 1 THEN  byte = byte + 8
   if ( 'LEFT'( ('RIGHT'( byte1 , 2 )) , 1) ) = 1 THEN  byte = byte + 4
   if ( 'RIGHT'( byte1 , 1 ) ) = 1 THEN  byte = byte + 2
   if byte = 0 THEN byte = 128

   address 'OCTAMED_REXX'
    'ed_setdata cmdnum 5 qual 106'
    'ed_advanceline down'
    'ed_setdata qual 'byte' '
    'ed_advanceline down'
   address 'REXX'

/* keyboard track   73 .......b  71 ....gh..  70 ....cdef  0bcdefgh                 */
   byte = 0                                  /* initialize data byte                */
   'SEEK'( 'file' , 73 + offset, 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )               /* read character                      */
   byte1 = convert( hex )                    /* convert to xxxxxxx byte string      */
   if ( 'RIGHT'( byte1 , 1 ) ) = 1 THEN byte = byte + 64

   'SEEK'( 'file' , 71 + offset, 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )               /* read character                      */
   byte1 = convert( hex )                    /* convert to xxxxxxx byte string      */
   if ( 'LEFT'( ('RIGHT'( byte1 , 4 )) , 1) ) = 1 THEN  byte = byte + 2
   if ( 'LEFT'( ('RIGHT'( byte1 , 3 )) , 1) ) = 1 THEN  byte = byte + 1

   'SEEK'( 'file' , 70 + offset, 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )               /* read character                      */
   byte1 = convert( hex )                    /* convert to xxxxxxx byte string      */
   if ( 'LEFT'( ('RIGHT'( byte1 , 4 )) , 1) ) = 1 THEN  byte = byte + 32
   if ( 'LEFT'( ('RIGHT'( byte1 , 3 )) , 1) ) = 1 THEN  byte = byte + 16
   if ( 'LEFT'( ('RIGHT'( byte1 , 2 )) , 1) ) = 1 THEN  byte = byte + 8
   if ( 'RIGHT'( byte1 , 1 ) ) = 1 THEN  byte = byte + 4
   if byte = 0 THEN byte = 128

   address 'OCTAMED_REXX'
    'ed_setdata cmdnum 5 qual 107'
    'ed_advanceline down'
    'ed_setdata qual 'byte' '
    'ed_advanceline down'
   address 'REXX'

/* envelope fixed touch */
   'SEEK'( 'file' , 32 + offset, 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )               /* read character                      */
   byte1 = convert( hex )                    /* convert to xxxxxxx byte string      */

   bit = 'LEFT'( ('RIGHT'( byte1 , 2 )) , 1)
   if bit = 0 then DO
      address 'OCTAMED_REXX'
      'ed_setdata cmdnum 5 qual 12'
      'ed_advanceline down'
      'ed_setdata qual 128'
      'ed_advanceline down'
      address 'REXX'
      END

   if bit = 1 then DO
      address 'OCTAMED_REXX'
      'ed_setdata cmdnum 5 qual 12'
      'ed_advanceline down'
      'ed_setdata qual 1'
      'ed_advanceline down'
      address 'REXX'
      END

/* envelope attack  32 ....gh..  35 ....cdef  00cdefgh                 */
   byte = 0                                  /* initialize data byte                */
   'SEEK'( 'file' , 32 + offset, 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )               /* read character                      */
   byte1 = convert( hex )                    /* convert to xxxxxxx byte string      */
   if ( 'LEFT'( ('RIGHT'( byte1 , 4 )) , 1) ) = 1 THEN  byte = byte + 2
   if ( 'LEFT'( ('RIGHT'( byte1 , 3 )) , 1) ) = 1 THEN  byte = byte + 1

   'SEEK'( 'file' , 35 + offset, 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )               /* read character                      */
   byte1 = convert( hex )                    /* convert to xxxxxxx byte string      */
   if ( 'LEFT'( ('RIGHT'( byte1 , 4 )) , 1) ) = 1 THEN  byte = byte + 32
   if ( 'LEFT'( ('RIGHT'( byte1 , 3 )) , 1) ) = 1 THEN  byte = byte + 16
   if ( 'LEFT'( ('RIGHT'( byte1 , 2 )) , 1) ) = 1 THEN  byte = byte + 8
   if ( 'RIGHT'( byte1 , 1 ) ) = 1 THEN  byte = byte + 4
   if byte = 0 THEN byte = 128

   address 'OCTAMED_REXX'
    'wi_showstring Octamed Sysex Pull (c) 1997 D. Krupicz ... working....'
    'ed_setdata cmdnum 5 qual 13'
    'ed_advanceline down'
    'ed_setdata qual 'byte' '
    'ed_advanceline down'
   address 'REXX'

/* envelope decay   37 ......cd  34 ....efgh  00cdefgh                 */
   byte = 0                                  /* initialize data byte                */
   'SEEK'( 'file' , 37 + offset, 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )               /* read character                      */
   byte1 = convert( hex )                    /* convert to xxxxxxx byte string      */
   if ( 'LEFT'( ('RIGHT'( byte1 , 2 )) , 1) ) = 1 THEN  byte = byte + 32
   if ( 'RIGHT'( byte1 , 1 ) ) = 1 THEN  byte = byte + 16

   'SEEK'( 'file' , 34 + offset, 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )               /* read character                      */
   byte1 = convert( hex )                    /* convert to xxxxxxx byte string      */
   if ( 'LEFT'( ('RIGHT'( byte1 , 4 )) , 1) ) = 1 THEN  byte = byte + 8
   if ( 'LEFT'( ('RIGHT'( byte1 , 3 )) , 1) ) = 1 THEN  byte = byte + 4
   if ( 'LEFT'( ('RIGHT'( byte1 , 2 )) , 1) ) = 1 THEN  byte = byte + 2
   if ( 'RIGHT'( byte1 , 1 ) ) = 1 THEN  byte = byte + 1
   if byte = 0 THEN byte = 128

   address 'OCTAMED_REXX'
    'ed_setdata cmdnum 5 qual 14'
    'ed_advanceline down'
    'ed_setdata qual 'byte' '
    'ed_advanceline down'
   address 'REXX'

/* envelope sustain   37 ....gh..  36 ....cdef  00cdefgh                 */
   byte = 0                                  /* initialize data byte                */
   'SEEK'( 'file' , 37 + offset, 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )               /* read character                      */
   byte1 = convert( hex )                    /* convert to xxxxxxx byte string      */
   if ( 'LEFT'( ('RIGHT'( byte1 , 4 )) , 1) ) = 1 THEN  byte = byte + 2
   if ( 'LEFT'( ('RIGHT'( byte1 , 3 )) , 1) ) = 1 THEN  byte = byte + 1

   'SEEK'( 'file' , 36 + offset, 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )               /* read character                      */
   byte1 = convert( hex )                    /* convert to xxxxxxx byte string      */
   if ( 'LEFT'( ('RIGHT'( byte1 , 4 )) , 1) ) = 1 THEN  byte = byte + 32
   if ( 'LEFT'( ('RIGHT'( byte1 , 3 )) , 1) ) = 1 THEN  byte = byte + 16
   if ( 'LEFT'( ('RIGHT'( byte1 , 2 )) , 1) ) = 1 THEN  byte = byte + 8
   if ( 'RIGHT'( byte1 , 1 ) ) = 1 THEN  byte = byte + 4
   if byte = 0 THEN byte = 128

   address 'OCTAMED_REXX'
    'ed_setdata cmdnum 5 qual 15'
    'ed_advanceline down'
    'ed_setdata qual 'byte' '
    'ed_advanceline down'
   address 'REXX'

/* envelope sustain decay   38 ......cd  39 ....efgh  00cdefgh                 */
   byte = 0                                  /* initialize data byte                */
   'SEEK'( 'file' , 38 + offset, 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )               /* read character                      */
   byte1 = convert( hex )                    /* convert to xxxxxxx byte string      */
   if ( 'LEFT'( ('RIGHT'( byte1 , 2 )) , 1) ) = 1 THEN  byte = byte + 32
   if ( 'RIGHT'( byte1 , 1 ) ) = 1 THEN  byte = byte + 16

   'SEEK'( 'file' , 39 + offset, 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )               /* read character                      */
   byte1 = convert( hex )                    /* convert to xxxxxxx byte string      */
   if ( 'LEFT'( ('RIGHT'( byte1 , 4 )) , 1) ) = 1 THEN  byte = byte + 8
   if ( 'LEFT'( ('RIGHT'( byte1 , 3 )) , 1) ) = 1 THEN  byte = byte + 4
   if ( 'LEFT'( ('RIGHT'( byte1 , 2 )) , 1) ) = 1 THEN  byte = byte + 2
   if ( 'RIGHT'( byte1 , 1 ) ) = 1 THEN  byte = byte + 1
   if byte = 0 THEN byte = 128

   address 'OCTAMED_REXX'
    'ed_setdata cmdnum 5 qual 16'
    'ed_advanceline down'
    'ed_setdata qual 'byte' '
    'ed_advanceline down'
   address 'REXX'

/* envelope release   38 ....gh..  41 ....cdef  00cdefgh                 */
   byte = 0                                  /* initialize data byte                */
   'SEEK'( 'file' , 38 + offset, 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )               /* read character                      */
   byte1 = convert( hex )                    /* convert to xxxxxxx byte string      */
   if ( 'LEFT'( ('RIGHT'( byte1 , 4 )) , 1) ) = 1 THEN  byte = byte + 2
   if ( 'LEFT'( ('RIGHT'( byte1 , 3 )) , 1) ) = 1 THEN  byte = byte + 1

   'SEEK'( 'file' , 41 + offset, 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )               /* read character                      */
   byte1 = convert( hex )                    /* convert to xxxxxxx byte string      */
   if ( 'LEFT'( ('RIGHT'( byte1 , 4 )) , 1) ) = 1 THEN  byte = byte + 32
   if ( 'LEFT'( ('RIGHT'( byte1 , 3 )) , 1) ) = 1 THEN  byte = byte + 16
   if ( 'LEFT'( ('RIGHT'( byte1 , 2 )) , 1) ) = 1 THEN  byte = byte + 8
   if ( 'RIGHT'( byte1 , 1 ) ) = 1 THEN  byte = byte + 4
   if byte = 0 THEN byte = 128

   address 'OCTAMED_REXX'
    'ed_setdata cmdnum 5 qual 17'
    'ed_advanceline down'
    'ed_setdata qual 'byte' '
    'ed_advanceline down'
   address 'REXX'

/* volume envelope touch */
   'SEEK'( 'file' , 40 + offset, 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )               /* read character                      */
   byte1 = convert( hex )                    /* convert to xxxxxxx byte string      */

   bit = 'RIGHT'( byte1 , 1 )
   if bit = 0 then DO
      address 'OCTAMED_REXX'
      'ed_setdata cmdnum 5 qual 18'
      'ed_advanceline down'
      'ed_setdata qual 128'
      'ed_advanceline down'
      address 'REXX'
      END

   if bit = 1 then DO
      address 'OCTAMED_REXX'
      'ed_setdata cmdnum 5 qual 18'
      'ed_advanceline down'
      'ed_setdata qual 1'
      'ed_advanceline down'
      address 'REXX'
      END

/* volume attack 40 ....fgh.  43 .....CDe   00cdefgh                 */
   byte = 0                                  /* initialize data byte                */
   'SEEK'( 'file' , 40 + offset, 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )               /* read character                      */
   byte1 = convert( hex )                    /* convert to xxxxxxx byte string      */
   if ( 'LEFT'( ('RIGHT'( byte1 , 4 )) , 1) ) = 1 THEN  byte = byte + 4
   if ( 'LEFT'( ('RIGHT'( byte1 , 3 )) , 1) ) = 1 THEN  byte = byte + 2
   if ( 'LEFT'( ('RIGHT'( byte1 , 2 )) , 1) ) = 1 THEN  byte = byte + 1

   'SEEK'( 'file' , 43 + offset, 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )               /* read character                      */
   byte1 = convert( hex )                    /* convert to xxxxxxx byte string      */
   if ( 'LEFT'( ('RIGHT'( byte1 , 3 )) , 1) ) = 1 THEN  byte = byte + 32
   if ( 'LEFT'( ('RIGHT'( byte1 , 2 )) , 1) ) = 1 THEN  byte = byte + 16
   if ( 'RIGHT'( byte1 , 1 ) ) = 1 THEN  byte = byte + 8
   if byte = 0 THEN byte = 128

   address 'OCTAMED_REXX'
    'ed_setdata cmdnum 5 qual 19'
    'ed_advanceline down'
    'ed_setdata qual 'byte' '
    'ed_advanceline down'
   address 'REXX'

/* volume decay     43 ....h...  45 .......c  42 ....defg  0bcdefgh                 */
   byte = 0                                  /* initialize data byte                */
   'SEEK'( 'file' , 43 + offset, 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )               /* read character                      */
   byte1 = convert( hex )                    /* convert to xxxxxxx byte string      */
   if ( 'LEFT'( ('RIGHT'( byte1 , 4 )) , 1) ) = 1 THEN byte = byte + 1

   'SEEK'( 'file' , 45 + offset, 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )               /* read character                      */
   byte1 = convert( hex )                    /* convert to xxxxxxx byte string      */
   if ( 'RIGHT'( byte1 , 1 ) ) = 1 THEN  byte = byte + 32

   'SEEK'( 'file' , 42 + offset, 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )               /* read character                      */
   byte1 = convert( hex )                    /* convert to xxxxxxx byte string      */
   if ( 'LEFT'( ('RIGHT'( byte1 , 4 )) , 1) ) = 1 THEN  byte = byte + 16
   if ( 'LEFT'( ('RIGHT'( byte1 , 3 )) , 1) ) = 1 THEN  byte = byte + 8
   if ( 'LEFT'( ('RIGHT'( byte1 , 2 )) , 1) ) = 1 THEN  byte = byte + 4
   if ( 'RIGHT'( byte1 , 1 ) ) = 1 THEN  byte = byte + 2
   if byte = 0 THEN byte = 128

   address 'OCTAMED_REXX'
    'ed_setdata cmdnum 5 qual 20'
    'ed_advanceline down'
    'ed_setdata qual 'byte' '
    'ed_advanceline down'
   address 'REXX'

/* volume release   45 ....fgh.  44 .....cde  00cdefgh                 */
   byte = 0                                  /* initialize data byte                */
   'SEEK'( 'file' , 45 + offset, 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )               /* read character                      */
   byte1 = convert( hex )                    /* convert to xxxxxxx byte string      */
   if ( 'LEFT'( ('RIGHT'( byte1 , 4 )) , 1) ) = 1 THEN  byte = byte + 4
   if ( 'LEFT'( ('RIGHT'( byte1 , 3 )) , 1) ) = 1 THEN  byte = byte + 2
   if ( 'LEFT'( ('RIGHT'( byte1 , 2 )) , 1) ) = 1 THEN  byte = byte + 1

   'SEEK'( 'file' , 44 + offset, 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )               /* read character                      */
   byte1 = convert( hex )                    /* convert to xxxxxxx byte string      */
   if ( 'LEFT'( ('RIGHT'( byte1 , 3 )) , 1) ) = 1 THEN  byte = byte + 32
   if ( 'LEFT'( ('RIGHT'( byte1 , 2 )) , 1) ) = 1 THEN  byte = byte + 16
   if ( 'RIGHT'( byte1 , 1 ) ) = 1 THEN  byte = byte + 8
   if byte = 0 THEN byte = 128

   address 'OCTAMED_REXX'
    'ed_setdata cmdnum 5 qual 21'
    'ed_advanceline down'
    'ed_setdata qual 'byte' '
    'ed_advanceline down'
   address 'REXX'

/* Instr Volume   21 ....fgh.  20 ....bcde  0bcdefgh                 */
   byte = 0                                  /* initialize data byte                */
   'SEEK'( 'file' , 21 + offset, 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )               /* read character                      */
   byte1 = convert( hex )                    /* convert to xxxxxxx byte string      */
   if ( 'LEFT'( ('RIGHT'( byte1 , 4 )) , 1) ) = 1 THEN  byte = byte + 4
   if ( 'LEFT'( ('RIGHT'( byte1 , 3 )) , 1) ) = 1 THEN  byte = byte + 2
   if ( 'LEFT'( ('RIGHT'( byte1 , 2 )) , 1) ) = 1 THEN  byte = byte + 1

   'SEEK'( 'file' , 20 + offset, 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )               /* read character                      */
   byte1 = convert( hex )                    /* convert to xxxxxxx byte string      */
   if ( 'LEFT'( ('RIGHT'( byte1 , 4 )) , 1) ) = 1 THEN  byte = byte + 64
    if ( 'LEFT'( ('RIGHT'( byte1 , 3 )) , 1) ) = 1 THEN  byte = byte + 32
   if ( 'LEFT'( ('RIGHT'( byte1 , 2 )) , 1) ) = 1 THEN  byte = byte + 16
   if ( 'RIGHT'( byte1 , 1 ) ) = 1 THEN  byte = byte + 8
   if byte = 0 THEN byte = 128

   address 'OCTAMED_REXX'
    'ed_setdata cmdnum 5 qual 2'
    'ed_advanceline down'
    'ed_setdata qual 'byte' '
    'ed_advanceline down'
   address 'REXX'

/* Vibrato Delay   26 ....fgh.  29 .....cde  00cdefgh                 */
   byte = 0                                  /* initialize data byte                */
   'SEEK'( 'file' , 26 + offset , 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )               /* read character                      */
   byte1 = convert( hex )                    /* convert to xxxxxxx byte string      */
   if ( 'LEFT'( ('RIGHT'( byte1 , 4 )) , 1) ) = 1 THEN  byte = byte + 4
   if ( 'LEFT'( ('RIGHT'( byte1 , 3 )) , 1) ) = 1 THEN  byte = byte + 2
   if ( 'LEFT'( ('RIGHT'( byte1 , 2 )) , 1) ) = 1 THEN  byte = byte + 1

   'SEEK'( 'file' , 29 + offset, 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )               /* read character                      */
   byte1 = convert( hex )                    /* convert to xxxxxxx byte string      */
/*   if ( 'LEFT'( ('RIGHT'( byte1 , 4 )) , 1) ) = 1 THEN  byte = byte + 64  */ /*bit used???*/
   if ( 'LEFT'( ('RIGHT'( byte1 , 3 )) , 1) ) = 1 THEN  byte = byte + 32
   if ( 'LEFT'( ('RIGHT'( byte1 , 2 )) , 1) ) = 1 THEN  byte = byte + 16
   if ( 'RIGHT'( byte1 , 1 ) ) = 1 THEN  byte = byte + 8
   if byte = 0 THEN byte = 128

   address 'OCTAMED_REXX'
    'wi_showstring Octamed Sysex Pull (c) 1997 D. Krupicz ... working......'
    'ed_setdata cmdnum 5 qual 7'
    'ed_advanceline down'
    'ed_setdata qual 'byte' '
    'ed_advanceline down'
   address 'REXX'

/* Osc 1 Vibrato   48 ....defg  49 ....h...  51 ......bc  0bcdefgh                  */
   byte = 0                                  /* initialize data byte                */
   'SEEK'( 'file' , 48 + offset, 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )               /* read character                      */
   byte1 = convert( hex )                    /* convert to xxxxxxx byte string      */
   if ( 'LEFT'( ('RIGHT'( byte1 , 4 )) , 1) ) = 1 THEN  byte = byte + 16
   if ( 'LEFT'( ('RIGHT'( byte1 , 3 )) , 1) ) = 1 THEN  byte = byte + 8
   if ( 'LEFT'( ('RIGHT'( byte1 , 2 )) , 1) ) = 1 THEN  byte = byte + 4
   if ( 'RIGHT'( byte1 , 1 ) ) = 1 THEN  byte = byte + 2

   'SEEK'( 'file' , 49 + offset, 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )               /* read character                      */
   byte1 = convert( hex )                    /* convert to xxxxxxx byte string      */
   if ( 'LEFT'( ('RIGHT'( byte1 , 4 )) , 1) ) = 1 THEN  byte = byte + 1
 
   'SEEK'( 'file' , 51 + offset, 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )               /* read character                      */
   byte1 = convert( hex )                    /* convert to xxxxxxx byte string      */
   if ( 'LEFT'( ('RIGHT'( byte1 , 2 )) , 1) ) = 1 THEN  byte = byte + 64
   if ( 'RIGHT'( byte1 , 1 ) ) = 1 THEN  byte = byte + 32
   if byte = 0 THEN byte = 128

   address 'OCTAMED_REXX'
    'ed_setdata cmdnum 5 qual 24'
    'ed_advanceline down'
    'ed_setdata qual 'byte' '
    'ed_advanceline down'
   address 'REXX'

/* Osc 2 Vibrato   50 ....cdef  51 ....gh..  53 .......b  0bcdefgh                  */
   byte = 0                                  /* initialize data byte                */
   'SEEK'( 'file' , 50 + offset, 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )               /* read character                      */
   byte1 = convert( hex )                    /* convert to xxxxxxx byte string      */
   if ( 'LEFT'( ('RIGHT'( byte1 , 4 )) , 1) ) = 1 THEN  byte = byte + 32
   if ( 'LEFT'( ('RIGHT'( byte1 , 3 )) , 1) ) = 1 THEN  byte = byte + 16
   if ( 'LEFT'( ('RIGHT'( byte1 , 2 )) , 1) ) = 1 THEN  byte = byte + 8
   if ( 'RIGHT'( byte1 , 1 ) ) = 1 THEN  byte = byte + 4

   'SEEK'( 'file' , 53 + offset, 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )               /* read character                      */
   byte1 = convert( hex )                    /* convert to xxxxxxx byte string      */
   if ( 'RIGHT'( byte1 , 1 ) ) = 1 THEN  byte = byte + 64
 
   'SEEK'( 'file' , 51 + offset, 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )               /* read character                      */
   byte1 = convert( hex )                    /* convert to xxxxxxx byte string      */
   if ( 'LEFT'( ('RIGHT'( byte1 , 4 )) , 1) ) = 1 THEN  byte = byte + 2
    if ( 'LEFT'( ('RIGHT'( byte1 ,32 )) , 1) ) = 1 THEN  byte = byte +14
   if byte = 0 THEN byte = 128

   address 'OCTAMED_REXX'
    'ed_setdata cmdnum 5 qual 25'
    'ed_advanceline down'
    'ed_setdata qual 'byte' '
    'ed_advanceline down'
   address 'REXX'

/* Osc 2 Env Pitch  52 ....bcde  53 ....fgh.  0bcdefgh                              */
   byte = 0                                  /* initialize data byte                */
   'SEEK'( 'file' , 52 + offset, 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )               /* read character                      */
   byte1 = convert( hex )                    /* convert to xxxxxxx byte string      */
   if ( 'LEFT'( ('RIGHT'( byte1 , 4 )) , 1) ) = 1 THEN  byte = byte + 64
   if ( 'LEFT'( ('RIGHT'( byte1 , 3 )) , 1) ) = 1 THEN  byte = byte + 32
   if ( 'LEFT'( ('RIGHT'( byte1 , 2 )) , 1) ) = 1 THEN  byte = byte + 16
   if ( 'RIGHT'( byte1 , 1 ) ) = 1 THEN  byte = byte + 8

   'SEEK'( 'file' , 53 + offset, 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )               /* read character                      */
   byte1 = convert( hex )                    /* convert to xxxxxxx byte string      */
   if ( 'LEFT'( ('RIGHT'( byte1 , 4 )) , 1) ) = 1 THEN  byte = byte + 4
   if ( 'LEFT'( ('RIGHT'( byte1 , 3 )) , 1) ) = 1 THEN  byte = byte + 2
   if ( 'LEFT'( ('RIGHT'( byte1 , 2 )) , 1) ) = 1 THEN  byte = byte + 1
   if byte = 0 THEN byte = 128

   address 'OCTAMED_REXX'
    'ed_setdata cmdnum 5 qual 26'
    'ed_advanceline down'
    'ed_setdata qual 'byte' '
    'ed_advanceline down'
   address 'REXX'

/* Detune   55 ....efgh  54 .....bcd  0bcdefgh                              */
   byte = 0                                  /* initialize data byte                */
   'SEEK'( 'file' , 55 + offset, 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )               /* read character                      */
   byte1 = convert( hex )                    /* convert to xxxxxxx byte string      */
   if ( 'LEFT'( ('RIGHT'( byte1 , 4 )) , 1) ) = 1 THEN  byte = byte + 8
   if ( 'LEFT'( ('RIGHT'( byte1 , 3 )) , 1) ) = 1 THEN  byte = byte + 4
   if ( 'LEFT'( ('RIGHT'( byte1 , 2 )) , 1) ) = 1 THEN  byte = byte + 2
   if ( 'RIGHT'( byte1 , 1 ) ) = 1 THEN  byte = byte + 1

   'SEEK'( 'file' , 54 + offset, 'b' )               /* seek file position                  */
   hex = 'READCH'( 'file', 1 )               /* read character                      */
   byte1 = convert( hex )                    /* convert to xxxxxxx byte string      */
   if ( 'LEFT'( ('RIGHT'( byte1 , 3 )) , 1) ) = 1 THEN  byte = byte + 64
   if ( 'LEFT'( ('RIGHT'( byte1 , 2 )) , 1) ) = 1 THEN  byte = byte + 32
   if ( 'RIGHT'( byte1 , 1 ) ) = 1 THEN  byte = byte + 16
   if byte = 0 THEN byte = 128

   address 'OCTAMED_REXX'
    wi_showstring  'Sysex Pull Done.'
    'ed_setdata cmdnum 5 qual 27'
    'ed_advanceline down'
    'ed_setdata qual 'byte' '
    'ed_advanceline down'
   address 'REXX'


'CLOSE'('file')

address 'OCTAMED_REXX'
'op_update on'
address 'REXX'


EXIT

convert:                                     /* define function convert             */
   ARG conv_in                               /* input is a HEX character            */
   conv_str = 'C2X'(conv_in)                 /* convert HEX to STRING equivalent    */

   if 'LEFT'(conv_str,1) = '3' THEN DO       /* if it's a 3x hex humber...          */
      conv_out = 'C2B'( conv_in )
      END
   else DO
      if 'LEFT'(conv_str,1) = '4' THEN DO    /* else if it's a 4x hex humber...     */
         conv_out = 'C2B'('X2C'( 'D2X'( 'X2D'( 'RIGHT'(conv_str,1) ) + 1 + 8 + 48 )))
         END
      else DO
         conv_out = 'C2B'( conv_in )        /* else else if it's a Xx hex humber...*/
         END
      END

   RETURN conv_out                           /* return the xxxxxxxx binary string   */
