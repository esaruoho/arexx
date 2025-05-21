/*************************************************************************/
/* $VER: resonance 1.0                                                   */
/*                                                                       */
/* Resonance  (c) 1998 D. Krupicz                                        */
/* Octamed Sound Studio analog resonance plug-in                         */
/* Slow Slow Slow :(                                                     */
/*************************************************************************/
/*
gui_file = arg(1)
*/
gui_file = 'ram:rexx/gui/resonance.gui'

IF EXISTS("libs:rexxsupport.library") THEN DO
    IF ~SHOW("L","rexxsupport.library") THEN
        IF ~ADDLIB("rexxsupport.library",0,-30,0) THEN EXIT
END
ELSE EXIT

IF EXISTS("libs:rexxreqtools.library") THEN DO
    IF ~SHOW("L","rexxreqtools.library") THEN
        IF ~ADDLIB("rexxreqtools.library",0,-30) THEN EXIT
END
ELSE EXIT

if ~ 'SHOW'('L',"rexxmathlib.library") then DO
   'ADDLIB'('rexxmathlib.library',0,-30,0)
   END


OPTIONS RESULTS
OPTIONS FAILAT 10

SIGNAL ON SYNTAX
SIGNAL ON FAILURE 

ADDRESS OCTAMED_REXX
ed_setblocklines 16       /* 16 lines per block, pal */
ADDRESS REXX

/* Get the GUI file from the user */
IF gui_file = '' THEN
  DO
    gui_file=rtfilerequest('REXX:gui',,'Varexx Request','_Load','rt_reqpos=reqpos_centerscr rtfi_matchpat=#?.gui rtfi_flags=freqf_patgad')
    IF gui_file = '' THEN EXIT
  END

/* Check Varexx is loaded if not load it */

IF SHOW( 'p', 'VAREXX' ) ~= 1 THEN DO
    ADDRESS COMMAND "run >NIL: varexx"
    ADDRESS COMMAND "WaitForPort VAREXX"
END
ADDRESS VAREXX

IF OPENPORT("HOLLY") = 0 THEN DO
    CALL rtezrequest "Could not open a port.",, "Varexx Error"
    EXIT
END

/*  'load ' gui_file 'HOLLY'  */ /*normal screen */
  'load ' gui_file 'HOLLY PS=OCTAMED'  /*go to octamed screen */

vhost = RESULT
/* say rc externerror */
ADDRESS VALUE vhost

show

/**************************************************************************/
/* MAIN LOOP -- Check for GUI events                                      */
/**************************************************************************/

/* set defaults */

amp = 31000            /* initial amplitude */
decay = 1.075              /* decay rate   long = 1.015  short = 2 */
fmult = 1             /* frequency */
fmod = 1  /*  1.0005  */             /* frequency mod over time */

threshold = 256        /* effect threshold */
look_offs = 5         /* difference offset */


DO FOREVER
   CALL WAITPKT("HOLLY")
   packet = GETPKT("HOLLY")
   IF packet ~= '00000000'x THEN DO
      drop pos vol
      class = GETARG(packet)
/*      say class  */
      IF class = "CLOSEWINDOW" THEN LEAVE

      IF left( class , 4 ) = '_MIX' THEN DO
         mix = right( class , 3 ) / 100
         'settext textmix' mix
         'settext info mix_set'
         END

      IF left( class , 6 ) = '_FMULT' THEN DO
         fmult = right( class , 3 ) / 50
         'settext textfmult' 'sin * 'fmult
         'settext info freq_set'
         END

      IF left( class , 5 ) = '_FMOD' THEN DO
         fmod = ( right( class , 3 ) - 10 ) / 100000 + 1
         'settext textfmod' fmod
         'settext info freq.mod_set'
         END

      IF left( class , 6 ) = '_DECAY' THEN DO
/*         decay = ( right( class , 3 ) / 100 ) + 1  */
         decay =   ((( right( class , 3 ) - 10 ) * 10 ) / 800 ) + 1
         'settext textdecay' decay
         'settext info decay_set'
         END

     IF left( class , 10 ) = '_THRESHOLD' THEN DO
         threshold = right( class , 3 )
         'settext textthreshold' threshold
         'settext info threshold_set'
         END

     IF left( class , 10 ) = '_LOOK_OFFS' THEN DO
         look_offs = right( class , 3 )
         'settext textlook_offs' look_offs 
         'settext info look_set'
         END

      IF class = "GO" THEN DO      /* actually do resonance */
         'settext info working...'
         address 'OCTAMED_REXX'
         drop s_type begin end
         'in_gettype' var s_type
         IF s_type ~= 'EMPTY' THEN DO
            'sa_getrangestart' var begin
            'sa_getrangeend' var end

            DO i= begin TO end BY 1
               drop smpl_a smpl_b amp_b
               sa_getsample i var smpl_a
               sa_getsample i + look_offs var smpl_b

               amp_b = abs( smpl_b - smpl_a )

               IF amp_b > threshold THEN amp = amp_b / 2
/*
               say 'mix' mix 'amp' amp 'fmult' fmult 'fmod' fmod 'decay' decay
*/
               y = smpl_a / 2 + trunc( mix * ( sin( i * fmult ) * amp ))   /* calculate resonance */
               amp = amp / decay
               IF amp < 1 THEN amp = 1
               fmult = fmult / fmod
               IF fmult < 0.00001 THEN fmult = 0.00001
               sa_setsample i y
               END
            END

         sa_refresh

         ADDRESS VALUE vhost
         'settext info done.'
         IF s_type = 'EMPTY' THEN DO
            'settext info no_sample'
            END
         END
      END
   END

    'hide unload'    

    CALL CLOSEPORT( "HOLLY" )
EXIT

/* Error messages */
failure:
    SAY "Error code" rc "-- Line" SIGL
    SAY EXTERNERROR
    'hide unload'
    CALL CLOSEPORT ("HOLLY")

EXIT

syntax:
    SAY "Error" rc  "-- Line" SIGL
    SAY ERRORTEXT( rc )
    'hide unload'
    CALL CLOSEPORT ("HOLLY")
EXIT



