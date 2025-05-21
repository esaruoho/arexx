/*************************************************************************/
/* $VER: AutoDrum 5.0                                                    */
/*************************************************************************/
/*
gui_file = arg(1)
*/
/* gui_file = 'ram:rexx/gui/octamed-d.gui' */
gui_file = 'rexx:gui/octamed-d.gui'

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
inst_a = 1   /* set instrument numbers */
inst_b = 1
inst_c = 1
inst_d = 1
cluster_a = 0    /* set note clusters */
cluster_b = 0
cluster_c = 0
cluster_d = 0
blocksp = 1        /* set default spacing  mode    1= 16 lines 2 =32 line etc.. */
a = 0             /* set note defaults */
b = 0
c = 0
d = 0
noteon = 25       /* set note on */
track = 0      /* set default track */
insttrack = 0   /* set def trk for inst selection */
instsel = 1    /* set def instr for inst selection */
instmsb = 0
instlsb = 0
bias = 0
bias_add = 0

DO FOREVER
   setnotes = 0
   drop group cluster instname

   CALL WAITPKT("HOLLY")
   packet = GETPKT("HOLLY")
   IF packet ~= '00000000'x THEN DO
      class = GETARG(packet)

   say class

   IF class = "CLOSEWINDOW" THEN LEAVE

   IF left( class , 7 ) = "_LENGTH" THEN DO
      blocksp = right( class , 1 ) + 1    /*set block spacing mode */
      if blocksp = 9 then blocksp = 16
      if blocksp = 10 then blocksp = 32
      END

   IF left( class , 1 ) = "A" THEN DO
      group = 4 * ( right( left( class , 4 ) , 2 ) - 1 )          /* extract group id from xxNN x */
      say group 'group'
      cluster = right( class , 2 )                   /* extract note cluster identity */
      track = 0
      inst_x = inst_a
      setnotes = 1                                   /* YES! lets write notes... */
      END

   IF left( class , 1 ) = "B" THEN DO
      group = 4 * ( right( left( class , 4 ) , 2 ) - 1 )          /* extract group id from xxNN x */
      cluster = right( class , 2 )                   /* extract note cluster identity */
      track = 1
      inst_x = inst_b
      setnotes = 1                                   /* YES! lets write notes... */
      END

   IF left( class , 1 ) = "C" THEN DO
      group = 4 * ( right( left( class , 4 ) , 2 ) - 1 )          /* extract group id from xxNN x */
      cluster = right( class , 2 )                   /* extract note cluster identity */
      track = 2
      inst_x = inst_c
       setnotes = 1                                   /* YES! lets write notes... */
      END

   IF left( class , 1 ) = "D" THEN DO
      group = 4 * ( right( left( class , 4 ) , 2 ) - 1 )          /* extract group id from xxNN x */
      cluster = right( class , 2 )                   /* extract note cluster identity */
      track = 3
      inst_x = inst_d
      setnotes = 1                                   /* YES! lets write notes... */
      END

   IF left( class , 5 ) = "_BIAS" THEN DO   /* set sector to work on */
      bias = right( class , 2)       /* set bias 0 1 2 3 */
      bias_add = ( blocksp * 16 ) * bias
      END

   IF setnotes = 1 THEN DO    /* set edit mode when setting notes */
      setnotes = 0
      SELECT
         WHEN cluster = 0 THEN DO                         /* noteoff = 0 noteon = 25 */
            a = 0
            b = 0
            c = 0
            d = 0
            END
         WHEN cluster = 1 THEN DO
            a = 0
            b = 0
            c = 0
            d = noteon
            END
         WHEN cluster = 2 THEN DO
            a = 0
            b = 0
            c = noteon
            d = 0
            END
         WHEN cluster = 3 THEN DO
            a = 0
            b = 0
            c = noteon
            d = noteon
            END
         WHEN cluster = 4 THEN DO
            a = 0
            b = noteon
            c = 0
            d = 0
            END
         WHEN cluster = 5 THEN DO
            a = 0
            b = noteon
            c = 0
            d = noteon
            END
         WHEN cluster = 6 THEN DO
            a = 0
            b = noteon
            c = noteon
            d = 0
            END
         WHEN cluster = 7 THEN DO
            a = 0
            b = noteon
            c = noteon
            d = noteon
            END
         WHEN cluster = 8 THEN DO
            a = noteon
            b = 0
            c = 0
            d = 0
            END
         WHEN cluster = 9 THEN DO
            a = noteon
            b = 0
            c = 0
            d = noteon
            END
         WHEN cluster = 10 THEN DO
            a = noteon
            b = 0
            c = noteon
            d = 0
            END
         WHEN cluster = 11 THEN DO
            a = noteon
            b = 0
            c = noteon
            d = noteon
            END
         WHEN cluster = 12 THEN DO
            a = noteon
            b = noteon
            c = 0
            d = 0
            END
         WHEN cluster = 13 THEN DO
            a = noteon
            b = noteon
            c = 0
            d = noteon
            END
         WHEN cluster = 14 THEN DO
            a = noteon
            b = noteon
            c = noteon
            d = 0
            END
         WHEN cluster = 15 THEN DO
            a = noteon
            b = noteon
            c = noteon
            d = noteon
            END
         OTHERWISE DO
            END
         END                   /* end select  */

         ADDRESS OCTAMED_REXX
         'op_update off'
         IF a ~= 0 THEN 'ed_setdata l ' bias_add + ( 0 + group ) * blocksp 't' track 'inum ' inst_x ' note ' a
         IF b ~= 0 THEN 'ed_setdata l ' bias_add + ( 1 + group ) * blocksp 't' track 'inum ' inst_x ' note ' b
         IF c ~= 0 THEN 'ed_setdata l ' bias_add + ( 2 + group ) * blocksp 't' track 'inum ' inst_x ' note ' c
         IF d ~= 0 THEN 'ed_setdata l ' bias_add + ( 3 + group ) * blocksp 't' track 'inum ' inst_x ' note ' d

         IF a  = 0 THEN 'ed_setdata l ' bias_add + ( 0 + group ) * blocksp 't' track 'inum 0 note 0'
         IF b  = 0 THEN 'ed_setdata l ' bias_add + ( 1 + group ) * blocksp 't' track 'inum 0 note 0'
         IF c  = 0 THEN 'ed_setdata l ' bias_add + ( 2 + group ) * blocksp 't' track 'inum 0 note 0'
         IF d  = 0 THEN 'ed_setdata l ' bias_add + ( 3 + group ) * blocksp 't' track 'inum 0 note 0'

         'op_update on'

         ADDRESS VALUE vhost

      END     /* end IF setdata loop */

/* ACCENT SETTING LOOP */
   IF left( class , 1 ) = 'K' THEN DO     /* if aKcenting */
      IF right( left( class , 2 ) , 1 ) = "A" THEN DO
         group = 4 * ( right( left( class , 4 ) , 2 ) - 1 )
         cluster = right( class , 2 )
         track = 0
         END
      IF right( left( class , 2 ) , 1 ) = "B" THEN DO
         group = 4 * ( right( left( class , 4 ) , 2 ) - 1 )
         cluster = right( class , 2 )
        track = 1
         END
      IF right( left( class , 2 ) , 1 ) = "C" THEN DO
         group = 4 * ( right( left( class , 4 ) , 2 ) - 1 )
         cluster = right( class , 2 )
         track = 2
         END
      IF right( left( class , 2 ) , 1 ) = "D" THEN DO
         group = 4 * ( right( left( class , 4 ) , 2 ) - 1 )
         cluster = right( class , 2 )
         track = 3
         END

      say 'accent gp' group 'cl' cluster

      SELECT
         WHEN cluster = 0 THEN DO
            acc1 = 99
            acc2 = 99
            acc3 = 99
            acc4 = 99
            END
         WHEN cluster = 1 THEN DO
            acc1 = 99
            acc2 = 50
            acc3 = 99
            acc4 = 50
            END
         WHEN cluster = 2 THEN DO
            acc1 = 99
            acc2 = 50
            acc3 = 25
            acc4 = 50
             END
         WHEN cluster = 3 THEN DO
            acc1 = 99
            acc2 = 25
            acc3 = 50
            acc4 = 25
             END
         WHEN cluster = 4 THEN DO
            acc1 = 99
            acc2 = 1
            acc3 = 99
            acc4 = 1
             END
         WHEN cluster = 5 THEN DO
            acc1 = 99
            acc2 = 1
            acc3 = 50
            acc4 = 1
             END
         WHEN cluster = 6 THEN DO
            acc1 = 25
            acc2 = 50
            acc3 = 99
            acc4 = 99
             END
         WHEN cluster = 7 THEN DO
            acc1 = 25
            acc2 = 99
            acc3 = 50
            acc4 = 99
             END
         OTHERWISE DO
            END
         END

         ADDRESS OCTAMED_REXX   /* set accent data */
         'op_update off'
         'ed_setdata l '  bias_add + ( 0 + group ) * blocksp 't' track 'cmdnum 12 qual' acc1
         'ed_setdata l '  bias_add + ( 1 + group ) * blocksp 't' track 'cmdnum 12 qual' acc2
         'ed_setdata l '  bias_add + ( 2 + group ) * blocksp 't' track 'cmdnum 12 qual' acc3
         'ed_setdata l '  bias_add + ( 3 + group ) * blocksp 't' track 'cmdnum 12 qual' acc4
         'op_update on'
         ADDRESS VALUE vhost
      END

/* END OF ACCENT SET LOOP */


/* setting inst_x commands */
   drop instname
   IF left( class , 5 ) = "_SETA" THEN DO
      IF left( class , 6 ) = "_SETAL" THEN DO
         IF inst_a > 1 THEN inst_a = inst_a - 1
         END
      IF left( class , 6 ) = "_SETAG" THEN DO
         IF inst_a < 64 THEN inst_a = inst_a + 1
         END
      IF left( class , 8 ) = "_SETAGET" THEN DO
         drop inst_a
         ADDRESS OCTAMED_REXX
         in_getnumber var inst_a
         END
      ADDRESS OCTAMED_REXX
      'in_select' inst_a
      'in_getname' VAR instname
      ADDRESS VALUE vhost
      'settext trk1 ' left( instname, 14 )
      END
   IF left( class , 5 ) = "_SETB" THEN DO
      IF left( class , 6 ) = "_SETBL" THEN DO
         IF inst_b > 1 THEN inst_b = inst_b - 1
         END
      IF left( class , 6 ) = "_SETBG" THEN DO
         IF inst_b < 64 THEN inst_b = inst_b + 1
         END
      IF left( class , 8 ) = "_SETBGET" THEN DO
         drop inst_b
         ADDRESS OCTAMED_REXX
         in_getnumber var inst_b
         END
      ADDRESS OCTAMED_REXX
      'in_select' inst_b
      'in_getname' VAR instname
      ADDRESS VALUE vhost
      'settext trk2 ' left( instname, 14 )
      END
   IF left( class , 5 ) = "_SETC" THEN DO
      IF left( class , 6 ) = "_SETCL" THEN DO
         IF inst_c > 1 THEN inst_c = inst_c - 1
         END
      IF left( class , 6 ) = "_SETCG" THEN DO
         IF inst_c < 64 THEN inst_c = inst_c + 1
         END
      IF left( class , 8 ) = "_SETCGET" THEN DO
         drop inst_c
         ADDRESS OCTAMED_REXX
         in_getnumber var inst_c
         END
      ADDRESS OCTAMED_REXX
      'in_select' inst_c
      'in_getname' VAR instname
      ADDRESS VALUE vhost
      'settext trk3 ' left( instname, 14 )
      END
   IF left( class , 5 ) = "_SETD" THEN DO
      IF left( class , 6 ) = "_SETDL" THEN DO
         IF inst_d > 1 THEN inst_d = inst_d - 1
         END
      IF left( class , 6 ) = "_SETDG" THEN DO
         IF inst_d < 64 THEN inst_d = inst_d + 1
         END
      IF left( class , 8 ) = "_SETDGET" THEN DO
         drop inst_d
         ADDRESS OCTAMED_REXX
         in_getnumber var inst_d
         END
      ADDRESS OCTAMED_REXX
      'in_select' inst_d
      'in_getname' VAR instname
      ADDRESS VALUE vhost
      'settext trk4 ' left( instname, 14 )
      END

/* end of inst select segment */

   IF left( class , 4 ) = "_NEW" THEN DO
      say 'clearing...'
      say right( left( class , 6 ) , 2 )
      IF right( left( class , 6 ) , 2 ) = "A1" THEN DO
         ADDRESS OCTAMED_REXX
         'ed_goto track 0'
         'rn_erase track'
         ADDRESS VALUE vhost
         setnum A101 0
         setnum A102 0
         setnum A103 0
         setnum A104 0
         setnum KA01 0
         setnum KA02 0
         setnum KA03 0
         setnum KA04 0
           END
      IF right( left( class , 6 ) , 2 ) = "AA" THEN DO
         END
      IF right( left( class , 6 ) , 2 ) = "B1" THEN DO
         ADDRESS OCTAMED_REXX
         'ed_goto track 1'
         'rn_erase track'
         ADDRESS VALUE vhost
         setnum B101 0
         setnum B102 0
         setnum B103 0
         setnum B104 0
         setnum KB01 0
         setnum KB02 0
         setnum KB03 0
         setnum KB04 0
         END
      IF right( left( class , 6 ) , 2 ) = "BA" THEN DO
         /* clear track 0 COMMANDS */
         END
      IF right( left( class , 6 ) , 2 ) = "C1" THEN DO
         ADDRESS OCTAMED_REXX
         'ed_goto track 2'
         'rn_erase track'
         ADDRESS VALUE vhost
         setnum C101 0
         setnum C102 0
         setnum C103 0
         setnum C104 0
         setnum KC01 0
         setnum KC02 0
         setnum KC03 0
         setnum KC04 0
         END
      IF right( left( class , 6 ) , 2 ) = "CA" THEN DO
         /* clear track 0 COMMANDS */
         END
      IF right( left( class , 6 ) , 2 ) = "D1" THEN DO
         ADDRESS OCTAMED_REXX
         'ed_goto track 3'
         'rn_erase track'
         ADDRESS VALUE vhost
         setnum D101 0
         setnum D102 0
         setnum D103 0
         setnum D104 0
         setnum KD01 0
         setnum KD02 0
         setnum KD03 0
         setnum KD04 0
         END
      IF right( left( class , 6 ) , 2 ) = "DA" THEN DO
         /* clear track 0 COMMANDS */
         END
      END

   IF left( class , 3 ) = "_GO" THEN DO
      ADDRESS OCTAMED_REXX
      IF class = "_GO6" THEN DO
         ed_advanceline fkey 6
         END
      IF class = "_GO7" THEN DO
         ed_advanceline fkey 7
         END
      IF class = "_GO8" THEN DO
         ed_advanceline fkey 8
         END
      IF class = "_GO9" THEN DO
         ed_advanceline fkey 9
         END
      ADDRESS VALUE vhost
      END

   IF class = "_UPDATE" THEN DO
      ADDRESS OCTAMED_REXX
      op_update off
      pl_stop
      ed_goto l 0 t 0
      rn_setrange 0 0 3 (blocksp * 16)
      rn_copy range
      ed_advanceline fkey 7
      rn_paste range
      ed_advanceline fkey 8
      rn_paste range
      ed_advanceline fkey 9
      rn_paste range
      op_update on
      pl_playblock
      ADDRESS VALUE vhost
      END

   IF class = "_APPEND" THEN DO
      ADDRESS OCTAMED_REXX
      pl_stop
      ed_newblock append clonecurr            /* add new block to end */
      rn_copy block                           /* copy current block into block buffer */
      ed_gotoblock last firstline             /* move to last block */
      rn_paste block                          /* paste block buffer to the NEW block  */
      pl_playblock
      ADDRESS VALUE vhost
      END

   IF class = "_INSERT" THEN DO
      ADDRESS OCTAMED_REXX
      pl_stop
      rn_copy block                           /* copy current block into block buffer */
      ed_newblock insert clonecurr            /* insert new block to end */
      rn_paste block                          /* paste block buffer to the NEW block  */
      pl_playblock
      ADDRESS VALUE vhost
      END

    IF class = "_PLAY" THEN DO
       ADDRESS OCTAMED_REXX
       pl_playblock
       ADDRESS VALUE vhost
       END

    IF class = "_STOP" THEN DO
       ADDRESS OCTAMED_REXX
       pl_stop
       ADDRESS VALUE vhost
       END

    IF class = "_CLEAR" THEN DO
       ADDRESS OCTAMED_REXX
       'ed_goto track 0'
       'rn_erase track'
       'ed_goto track 1'
       'rn_erase track'
       'ed_goto track 2'
       'rn_erase track'
       'ed_goto track 3'
       'rn_erase track'
       ADDRESS VALUE vhost
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



