/* flip_track.rexx */
/* flips a track or selected range (1 track) */
/* $VER: FlipTracks_v1.00 */

ADDRESS OCTAMED_REXX
OPTIONS RESULTS

rn_isranged VAR isranged            /* is there a range? */

IF isranged THEN DO
   rn_getrangestartline VAR rn_st
   rn_getrangeendline VAR rn_end
   END
ELSE DO
   rn_st = 0
   ed_getnumlines VAR rn_end
   END

length = rn_end - rn_st + 1
op_update off

DO i = 0 to length % 2             /* do inversion for half of range length */

   drop top_note top_inum top_cmdnum top_qual bot_note bot_inum bot_cmdnum bot_qual

   ed_getdata 'l' rn_st + i 'note' VAR top_note          /* get top note data */
   ed_getdata 'l' rn_st + i 'inum' VAR top_inum
   ed_getdata 'l' rn_st + i 'cmdnum' VAR top_cmdnum
   ed_getdata 'l' rn_st + i 'qual' VAR top_qual

   ed_getdata 'l' rn_end - i 'note' VAR bot_note          /* get BOTtom note data */
   ed_getdata 'l' rn_end - i 'inum' VAR bot_inum
   ed_getdata 'l' rn_end - i 'cmdnum' VAR bot_cmdnum
   ed_getdata 'l' rn_end - i 'qual' VAR bot_qual

   ed_setdata 'l' rn_st + i 'note' bot_note          /* set top note data */
   ed_setdata 'l' rn_st + i 'inum' bot_inum
   ed_setdata 'l' rn_st + i 'cmdnum' bot_cmdnum
   ed_setdata 'l' rn_st + i 'qual' bot_qual

   ed_setdata 'l' rn_end - i 'note' top_note          /* set BOTtom note data */
   ed_setdata 'l' rn_end - i 'inum' top_inum
   ed_setdata 'l' rn_end - i 'cmdnum' top_cmdnum
   ed_setdata 'l' rn_end - i 'qual' top_qual

   END

op_update on
