/*************************************************************************/
/* $VER: AutoDrum 5.0                                                    */
/*************************************************************************/
/*
gui_file = arg(1)
*/
gui_file = 'rexx:gui/octamed-d.gui'

say 'Radius OctaMED AutoDRUMS  (c) 1998 1997 D. Krupicz'
say '   OctaMED Drum Machine / Interactive GUI guide. '
say '   CLICK on the gadgets in the AutoDrums window for documentation'
say '   of functions.'
say ' '
say '   OctaMED AutoDRUMS requires OctaMED SoundStudio 1.03c or greater '
say '                              VAREXX gui interface for AREXX '
say '   The included font can be used in octamed if you want AutoDRUMS to display '
say '   the proper graphics for notes ø , play Þ  , and stop Å  '
say '   CycleToMenu 2.1 by F.Giannici makes this program a LOT EASIER to use!!!'
say '   AutoDrums requires the GUI file "octamed-d.gui" to be located in'
say '      the directory rexx:gui '
say ' '

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

OPTIONS RESULTS
OPTIONS FAILAT 10

SIGNAL ON SYNTAX
SIGNAL ON FAILURE 

/* Get the GUI file from the user */
IF gui_file = '' THEN
  DO
    gui_file=rtfilerequest('REXX:gui',,'Varexx Request','_Load','rt_reqpos=reqpos_centerscr rtfi_matchpat=#?.gui rtfi_flags=freqf_patgad')
    IF gui_file = '' THEN EXIT
  END

/* Check Varexx is loaded if not load it */
IF SHOW( 'p', 'VAREXX' ) ~= 1 THEN DO
   say 'OctaMED AutoDrums requires the VAREXX program to run.'
   exit
END
ADDRESS VAREXX

IF OPENPORT("HOLLY") = 0 THEN DO
    CALL rtezrequest "Could not open a port.",, "Varexx Error"
    EXIT
END

/*  'load ' gui_file 'HOLLY'  */ /*normal screen */
'load ' gui_file 'HOLLY '  /*go to octamed screen */

vhost = RESULT
/* say rc externerror */
ADDRESS VALUE vhost

show

/**************************************************************************/
/* MAIN LOOP -- Check for GUI events                                      */
/**************************************************************************/
DO FOREVER
   CALL WAITPKT("HOLLY")
   packet = GETPKT("HOLLY")
   IF packet ~= '00000000'x THEN DO
      class = GETARG(packet)

   IF class = "CLOSEWINDOW" THEN LEAVE

   IF left( class , 7 ) = "_LENGTH" THEN DO
      say 'This sets the length of the beat in multiples of 16'
      say '   it is best to set this to 1/4 of the block length'
      END

   IF left( class , 1 ) = "A" THEN DO
      say 'These gadgets write the corresponding note data into'
      say '   each particular track.  The note pattern entered'
      say '   is shown in the cycle gadget.  For easier use, it'
      say '   is recommended that you install CycleToMenu 2.1'
      say '   which will convert cycle gadgets into popup menus.'
      END

   IF left( class , 1 ) = "B" THEN DO
     say 'These gadgets write the corresponding note data into'
     say '   each particular track.  The note pattern entered'
     say '   is shown in the cycle gadget.  For easier use, it'
     say '   is recommended that you install CycleToMenu 2.1'
     say '   which will convert cycle gadgets into popup menus.'
     END

   IF left( class , 1 ) = "C" THEN DO
      say 'These gadgets write the corresponding note data into'
      say '   each particular track.  The note pattern entered'
      say '   is shown in the cycle gadget.  For easier use, it'
      say '   is recommended that you install CycleToMenu 2.1'
      say '   which will convert cycle gadgets into popup menus.'
       END

   IF left( class , 1 ) = "D" THEN DO
      say 'These gadgets write the corresponding note data into'
      say '   each particular track.  The note pattern entered'
      say '   is shown in the cycle gadget.  For easier use, it'
      say '   is recommended that you install CycleToMenu 2.1'
      say '   which will convert cycle gadgets into popup menus.'
      END

   IF left( class , 1 ) = 'K' THEN DO     /* if aKcenting */
      say 'These gadgets write the corresponding volume accent data into'
      say '   each particular track, using command 0Cxx.  The pattern entered'
      say '   is shown in the cycle gadget.  For easier use, it'
      say '   is recommended that you install CycleToMenu 2.1'
      say '   which will convert cycle gadgets into popup menus.'
      END

/* setting inst_x commands */
      IF left( class , 6 ) = "_SETAL" THEN DO
         say 'This DECREASES the default instrument number for track 0'
         say '   the instrument name will appear in the text gadget.'
         END
     IF left( class , 6 ) = "_SETAG" THEN DO
         IF left( class , 8 ) = "_SETAGET" THEN DO
         say 'This selects the current instr. as the default instrument number for track 0'
         say '   the instrument name will appear in the text gadget.'
         END
         ELSE DO
         say 'This INCREASES the default instrument number for track 0'
         say '   the instrument name will appear in the text gadget.'
         END
         END
   

     IF left( class , 6 ) = "_SETBL" THEN DO
         say 'This DECREASES the default instrument number for track 1'
         say '   the instrument name will appear in the text gadget.'
         END
      IF left( class , 6 ) = "_SETBG" THEN DO
         IF left( class , 8 ) = "_SETBGET" THEN DO
         say 'This selects the current instr. as the default instrument number for track 1'
         say '   the instrument name will appear in the text gadget.'
         END
         ELSE DO
         say 'This INCREASES the default instrument number for track 1'
         say '   the instrument name will appear in the text gadget.'
         END
         END
     IF left( class , 6 ) = "_SETCL" THEN DO
         say 'This DECREASES the default instrument number for track 2'
         say '   the instrument name will appear in the text gadget.'
         END
     IF left( class , 6 ) = "_SETCG" THEN DO
         IF left( class , 8 ) = "_SETCGET" THEN DO
         say 'This selects the current instr. as the default instrument number for track 2'
         say '   the instrument name will appear in the text gadget.'
         END
         ELSE DO
         say 'This INCREASES the default instrument number for track 2'
         say '   the instrument name will appear in the text gadget.'
         END
         END
   
    IF left( class , 6 ) = "_SETDL" THEN DO
         say 'This DECREASES the default instrument number for track 3'
         say '   the instrument name will appear in the text gadget.'
         END
     IF left( class , 6 ) = "_SETDG" THEN DO
         IF left( class , 8 ) = "_SETDGET" THEN DO
         say 'This selects the current instr. as the default instrument number for track 3'
         say '   the instrument name will appear in the text gadget.'
         END
         ELSE DO
         say 'This INCREASES the default instrument number for track 3'
         say '   the instrument name will appear in the text gadget.'
         END
         END
   

/* end of inst select segment */

   IF left( class , 4 ) = "_NEW" THEN DO
      say 'This clears the associated track and resets the cycle gadgets.'
      END

   IF class = "_UPDATE" THEN DO
      say 'This COPIES the first quarter of the block into the rest of the'
      say '   block ASSUMING:                               '
      say '   - that the LENGTH gadget is set to 1/4 of the block length'
      say '   - and that your F6 to F10 keys are set for quarter-block positioning'
      say '     in OctaMED.'
      say '   Playing will stop while this is taking place. '
      END

   IF class = "_APPEND" THEN DO
      say 'This COPIES the entire block to a new block which is APPENDED to the'
      say '   end of the current block list.'
      END

   IF class = "_INSERT" THEN DO
      say 'This COPIES the entire block to a new block which is INSERTED before the'
      say '   current block.'
       END

    IF class = "_PLAY" THEN DO
      say 'This plays the block.'
     END

    IF class = "_STOP" THEN DO
     say 'This stops the block playing.'
       END

    IF class = "_CLEAR" THEN DO
       say 'This clears tracks 0 to 3'
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



