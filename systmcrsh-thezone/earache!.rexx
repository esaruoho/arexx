/*
  $VER: EARACHE! 0.1c BETA 2
  DATE: 06-DEC-2011
  COMPLAINTS: systmcrsh@gmail.com
  NET: http://www.dirtybomb.tk
  PERVERTS CALL: 917-***-****
*/

/* data dir */
dir = 'REXX:data/'

/* gui */
gui_file = dir'earache!.gui'
CALL ADDLIB 'rexxmathlib.library',-20,-30,0
/* CALL ADDLIB 'rexxreqtools.library',-20,-30,0 */

IF EXISTS("libs:rexxsupport.library") THEN DO
	IF ~SHOW("L","rexxsupport.library") THEN
		IF ~ADDLIB("rexxsupport.library",0,-30,0) THEN EXIT
END
ELSE EXIT
/*
IF EXISTS("libs:rexxtricks.library") THEN DO
	IF ~SHOW("L","rexxtricks.library") THEN
		IF ~ADDLIB("rexxtricks.library",0,-30) THEN EXIT
END
ELSE EXIT
*/
OPTIONS RESULTS
OPTIONS FAILAT 10
SIGNAL on syntax
SIGNAL on failure

/*
IF gui_file = '' THEN DO
	gui_file = RTFILEREQUEST('REXX:',,'Varexx Request','_Load','rt_reqpos=reqpos_centerscr rtfi_matchpat=#?.gui rtfi_flags=freqf_patgad')
	IF gui_file = '' THEN EXIT
END
*/

IF SHOW( 'p', 'VAREXX' ) ~= 1 THEN DO
	ADDRESS COMMAND "RUN >NIL: varexx"
	ADDRESS COMMAND "WaitForPort VAREXX"
END
ADDRESS VAREXX

IF OPENPORT("EARACHE!") = 0 THEN DO
	SAY "Could not open a port. Varexx Error."
	EXIT
END

'load ' gui_file 'EARACHE! PS=OCTAMED'

host = RESULT
ADDRESS VALUE host

SHOW

SIGNAL on error

/* defaults */
defaults:
	CALL p_rd
	do_echo = 0; num = 00; rate = 00; vol = 00; do_vol = 0; volume = 100; endvol = 100; noclip = 'CLIP'; do_filter = 0; filter_type = 'SA_BOOST'; avg = 00; dist = 00
/*
; do_noise = 0; noise = 0
*/
	option = 0
	do_error = 0
	do_undo = 0
	SETNUM _opt 0
	SET _filter DISABLE
	ADDRESS OCTAMED_REXX
	OPTIONS RESULTS
	'OP_GET OverwriteReq var overwrite'
;;

calc:
	ADDRESS OCTAMED_REXX
	OPTIONS RESULTS
	'IN_GETNUMBER var inst'
	'IN_GETNAME var inst_name'
	'IN_GETTYPE var type'
	IF type ~= 'SAMPLE' THEN SIGNAL no_sample
	'SA_GETRANGESTART var start'
	'SA_GETRANGEEND var end'
	IF start = end THEN DO
		'SA_GETSAMPLELENGTH var length'
		SA_RANGE 0 length
		start = 0
		end = length
	END
	ns = 0
	ADDRESS VALUE host
	SETTEXT _out 'RN:' start'-'end
	IF return = 1 THEN DO
		return = 0
		RETURN
	END
;;

/* main */
main:
	ADDRESS VALUE host
	SETTEXT _ins inst
	DO FOREVER
		CALL WAITPKT("EARACHE!")
		packet = GETPKT("EARACHE!")

		IF packet ~= '00000000'x THEN DO
			class = GETARG(packet)

			IF class = "CLOSEWINDOW" THEN LEAVE

			IF class = '_SHOW' THEN DO
				CALL REPLY(packet,rc)
				ADDRESS VALUE host
				WINDOW FRONT
				WINDOW ACTIVATE
				class = "ACTIVEWINDOW"
			END

			IF class = "ACTIVEWINDOW" THEN DO
				return = 1
				CALL calc
				ADDRESS VALUE host
				SETTEXT _out 'RN:' start'-'end
				SIGNAL main
			END

			IF class = "INACTIVEWINDOW" THEN DO
				ADDRESS VALUE host
				SETTEXT _out "www.dirtybomb.tk"
			END

	 		IF LEFT( class , 5 ) = '_ECHO' THEN DO
				PARSE VAR class null echo
				echo = STRIP(echo)
				IF echo > 0 THEN echo = LEFT(echo, 6, 0)
				IF echo < 1 THEN echo = 'NNRRVV'
				SETTEXT _echo echo
				IF DATATYPE(echo) ~= 'NUM' THEN DO
					error = "ECHO = ######!"
					do_echo = 0
					SETTEXT _echo COMPRESS(NN RR VV)
					num = '00'
					rate = '00'
					vol = '00'
					do_error = 1
					SIGNAL error
				END
				PARSE VAR echo 1 num 3 rate 5 vol
				ADDRESS VALUE host
				do_echo = 1
				SETTEXT _out 'E:'num 'R:'rate 'V:'vol
	 		END
/*
			IF LEFT( class , 6 ) = '_NOISE' THEN DO
				PARSE VAR class null noise
				noise = STRIP(noise)
				IF DATATYPE(noise) = 'CHAR' THEN DO
					noise = 0
					SETTEXT _noise 0
				END
				IF noise = 0 THEN do_noise = 0
				IF noise > 0 THEN do_noise = 1
				SETTEXT _out 'N:'noise
			END
*/
			IF LEFT( class , 7 ) = '_NOCLIP' THEN DO
				PARSE VAR class null noclip
				noclip = STRIP(noclip)
				IF noclip = 'FALSE' THEN noclip = 'CLIP'
				IF noclip = 'TRUE' THEN noclip = 'NOCLIP'
			END

			IF LEFT( class , 4 ) = '_VOL' THEN DO
				PARSE VAR class null volume '/' endvol
				volume = STRIP(volume)
				endvol = STRIP(endvol)
				IF DATATYPE(volume) ~= 'NUM' THEN DO
					volume = 100
					endvol = 100
					error = "VOL = ###/###!"
					SETTEXT _vol volume'/'endvol
					do_error = 1
					do_vol = 0
					SIGNAL error
				END
				IF DATATYPE(endvol) ~= 'NUM' THEN DO
					endvol = volume
					SETTEXT _vol volume'/'endvol
				END
				do_vol = 1
				SET _noclip ENABLE
				SETTEXT _out 'V:'volume endvol
			END

			IF LEFT( class , 4 ) = '_OPT' THEN DO
				PARSE VAR class null option
				IF option = 0 THEN DO
					filter_type = 'NONE'
					do_filter = 0
					SET _filter DISABLE
					SETTEXT _out filter_type
				END
				IF option = 1 THEN DO
					filter_type = 'SA_BOOST'
					do_filter = 1
					SET _filter ENABLE
					SETTEXT _out filter_type 'A:'avg 'D:'dist
				END
				IF option = 2 THEN DO
					filter_type = 'SA_FILTER'
					do_filter = 1
					SET _filter ENABLE
					SETTEXT _out filter_type 'A:'avg 'D:'dist
				END
			END

			IF LEFT( class , 7 ) = '_FILTER' THEN DO
				PARSE VAR class null filter
				filter = STRIP(filter)
				filter = LEFT(filter, 4, 0)
				SETTEXT _filter filter
				IF DATATYPE(filter) ~= 'NUM' THEN DO
					SETNUM _opt 0
					SET _filter DISABLE
					SETTEXT _filter COMPRESS(AA DD)
					filter_type = 'SA_BOOST'
					avg = '00'
					dist = '00'
					error = "FILTER = ####!"
					do_error = 1
					SIGNAL error
				END
	 			PARSE VAR filter 1 avg 3 dist
				do_filter = 1
				SETTEXT _out filter_type 'A:'avg 'D:'dist
			END

			IF class = "_NEXT" THEN DO
				ADDRESS OCTAMED_REXX
				IN_SELECT NEXT
				return = 1
				CALL calc
				'IN_GETNUMBER var inst'
				'IN_GETTYPE var type'
				IF type ~= 'SAMPLE' THEN SIGNAL no_sample
				'SA_GETRANGESTART var start'
				'SA_GETRANGEEND var end'
				ADDRESS VALUE host
				SETTEXT _out 'RN:' start'-'end
				SETTEXT _ins inst
			END

			IF class = "_PREV" THEN DO
				ADDRESS OCTAMED_REXX
				IN_SELECT PREV
				return = 1
				CALL calc
				'IN_GETNUMBER var inst'
				'IN_GETTYPE var type'
				IF type ~= 'SAMPLE' THEN SIGNAL no_sample
				'SA_GETRANGESTART var start'
				'SA_GETRANGEEND var end'
				ADDRESS VALUE host
				SETTEXT _out 'RN:' start'-'end
				SETTEXT _ins inst
			END

			IF class = "_PLAY" THEN DO
				ADDRESS OCTAMED_REXX
				SA_PLAY DISPLAY
				ADDRESS VALUE host
			END

			IF class = "_LOAD" THEN DO
				SETTEXT _out "Load Inst."
				ADDRESS OCTAMED_REXX
				IN_LOADREQ
				ADDRESS VALUE host
			END

	 		IF LEFT( class , 8 ) = 'KEYBOARD' THEN DO
				PARSE VAR class null kb
				kb = UPPER(STRIP(kb))
				IF kb = 'F1' THEN DO
					CALL destroy
				END
				IF kb = 'F2' THEN DO
					ADDRESS VALUE host
					WINDOW FRONT
				END
				IF kb = 'F3' THEN DO
					CALL timebomb
				END
				IF kb = 'F4' THEN DO
					CALL teeth_s
				END
				IF kb = 'HELP' THEN DO
					cmd = dir'help!'
					ADDRESS COMMAND cmd
					ADDRESS OCTAMED_REXX
					WI_OCTAMEDTOFRONT
					ADDRESS VALUE host
					WINDOW ACTIVATE
				END
				IF INDEX('0123456789', kb) > 0 THEN DO
					CALL p_ld
				END
				IF INDEX('!@#$%^&*()', kb) > 0 THEN DO
					CALL p_sv
				END
				IF kb = '+' && kb = '=' THEN DO
					IF ns = 1 THEN CALL calc
					ADDRESS OCTAMED_REXX
					'SA_ADJUSTYRANGE S=10'
					ADDRESS VALUE host
					SETTEXT _out "+10"
				END
				IF kb = '-' && kb = '_' THEN DO
					IF ns = 1 THEN CALL calc
					ADDRESS OCTAMED_REXX
					'SA_ADJUSTYRANGE S=-10'
					ADDRESS VALUE host
					SETTEXT _out "-10"
				END
				IF kb = 'A' THEN DO
					IF ns = 1 THEN CALL calc
					ADDRESS OCTAMED_REXX
					'SA_GETSAMPLELENGTH var length'
					SA_RANGE 0 length
					'SA_GETRANGESTART var start'
					'SA_GETRANGEEND var end'
					ADDRESS VALUE host
					SETTEXT _out 'RN:' start'-'end
				END
				IF kb = 'C' THEN DO
					IF ns = 1 THEN CALL calc
					ADDRESS OCTAMED_REXX
					SA_CENTRALIZESAMPLE
					ADDRESS VALUE host
					SETTEXT _out "CENTER"
				END
				IF kb = 'E' THEN DO
					ADDRESS OCTAMED_REXX
					'WI_ISOPEN SAMPLEEDITOR var smp_ed'
					IF smp_ed = 0 THEN DO
						WI_OPEN SAMPLEEDITOR
						ADDRESS VALUE host
						WINDOW FRONT
						WINDOW ACTIVATE
						class = "ACTIVEWINDOW"
					END
					IF smp_ed = 1 THEN DO
						WI_CLOSE SAMPLEEDITOR
						ADDRESS VALUE host
						WINDOW FRONT
						WINDOW ACTIVATE
						class = "ACTIVEWINDOW"
					END
				END
				/* save inst */
				IF kb = 'S' THEN DO
					SETTEXT _out "Save Inst."
					ADDRESS OCTAMED_REXX
					IN_SAVEREQ WAVE
					ADDRESS VALUE host
				END
				IF kb = 'U' THEN DO
					IF do_undo = 0 THEN DO
						SETTEXT _out "Nothing!"
					END
					IF do_undo = 1 THEN DO
						ADDRESS OCTAMED_REXX
						IN_SELECT undo_inst
						IN_LOAD 'RAM:e_temp.wav'
						ADDRESS COMMAND 'DELETE RAM:e_temp.wav >NIL:'
						IN_SETTRANSPOSE undo_tr
						IN_SETFINETUNE undo_ft
						IN_SETNAME undo_name
						IN_SETDEFAULTPITCH undo_pitch
						'IN_GETNUMBER var inst'
						ADDRESS VALUE host
						SETTEXT _ins inst
						SETTEXT _out "Undone!"
						do_undo = 0
					END
				END
			END

			/* do operation */
			IF class = "_GO" THEN DO
				IF ns = 1 THEN SIGNAL no_sample
				BUSY SET
				CALL TIME(R)
				CALL undo
				SETTEXT _out "BUSY!"
				ADDRESS OCTAMED_REXX
				OPTIONS RESULTS
				'SA_GETSAMPLELENGTH var length'
				'SA_GETRANGESTART var start'
				'SA_GETRANGEEND var end'
				IF start = end THEN DO
					start = 0
					end = length
				END
				SA_RANGE start end
				IF do_noise = 1 THEN DO
					SA_CREATENOISE noise
				END
				IF do_echo = 1 THEN DO
					SA_ECHO num rate vol
				END
				IF do_vol = 1 THEN DO
					SA_CHANGEVOL volume endvol noclip
				END
				IF do_filter = 1 THEN DO
					filter_type avg dist
				END
				SA_REFRESH
				SIGNAL done
			END

		END
	END
;;

	'hide unload'
	CALL CLOSEPORT("EARACHE!")
EXIT


/* errors */
failure:
	SAY "Error code" rc "-- Line" SIGL
	SAY EXTERNERROR
	'hide unload'
	CALL CLOSEPORT("EARACHE!")
EXIT
;;

syntax:
	SAY "Error" rc  "-- Line" SIGL
	SAY ERRORTEXT( rc )
	'hide unload'
	CALL CLOSEPORT("EARACHE!")
EXIT
;;

error:
	IF do_error = 1 THEN DO
		ADDRESS VALUE host
		BUSY
		SETTEXT _out "Error! "error
		do_error = 0
		SIGNAL main
	END
	SAY "Error! "rc SIGL
	'hide unload'
	CALL CLOSEPORT("EARACHE!")
EXIT
;;

/* functions */
done:
	ADDRESS VALUE host
	SETTEXT _out "Done. "TIME(E)"s"
	IF overwrite = 1 THEN DO
		ADDRESS OCTAMED_REXX
		OP_SET OverwriteReq ON
	END
	ADDRESS VALUE host
	BUSY
	SIGNAL main
;;

no_sample:
	ADDRESS OCTAMED_REXX
	'IN_GETNUMBER VAR inst'
	ADDRESS VALUE host
	BUSY
	SETTEXT _out "No Sample!"
	ns = 1
	SIGNAL main
;;

undo:
	ADDRESS OCTAMED_REXX
	OPTIONS RESULTS
	OP_SET OverwriteReq OFF
	'IN_GETTRANSPOSE var undo_tr'
	'IN_GETFINETUNE var undo_ft'
	'IN_GETDEFAULTPITCH var undo_pitch'
	'IN_GETNUMBER var inst'
	'IN_GETNAME var inst_name'
	undo_inst = inst
	undo_name = inst_name
	IN_SAVE 'RAM:'e_temp.wav'' WAVE
	do_undo = 1
	IF overwrite = 1 THEN DO
		ADDRESS OCTAMED_REXX
		OP_SET OverwriteReq ON
	END
	RETURN RESULT
;;

preset:
	IF do_echo = 1 THEN DO
		ADDRESS VALUE host
		SETTEXT _echo COMPRESS(num rate vol)
	END
	IF do_echo = 0 THEN DO
		ADDRESS VALUE host
		SETTEXT _echo COMPRESS(NN RR VV)
		num = '00'
		rate = '00'
		vol = '00'
	END
	IF do_vol = 1 THEN DO
		ADDRESS VALUE host
		SET _noclip ENABLE
		IF noclip = 'NOCLIP' THEN SETCHECK _noclip CHECK
		IF noclip = 'CLIP' THEN SETCHECK _noclip
		SETTEXT _vol COMPRESS(volume'/'endvol)
	END
	IF do_vol = 0 THEN DO
		ADDRESS VALUE host
		SET _noclip DISABLE
		IF noclip = 'NOCLIP' THEN SETCHECK _noclip CHECK
		IF noclip = 'CLIP' THEN SETCHECK _noclip
		volume = 100
		endvol = 100
		SETTEXT _vol volume'/'endvol
		SET _endvol DISABLE
	END
	IF do_filter = 1 THEN DO
		ADDRESS VALUE host
		IF filter_type = 'SA_BOOST' THEN SETNUM _opt 1
		IF filter_type = 'SA_FILTER' THEN SETNUM _opt 2
		SET _filter ENABLE
		SETTEXT _filter COMPRESS(avg dist)
	END
	IF do_filter = 0 THEN DO
		ADDRESS VALUE host
		SETNUM _opt 0
		SET _filter DISABLE
		SETTEXT _filter COMPRESS(AA DD)
		filter_type = 'SA_BOOST'
		avg = '00'
		dist = '00'
	END
/*
	IF do_noise = 1 THEN DO
		noise = STRIP(noise)
		ADDRESS VALUE host
		SETTEXT _noise noise
	END
	IF do_noise = 0 THEN DO
		noise = STRIP(noise)
		ADDRESS VALUE host
		SETTEXT _noise noise
	END
*/
	RETURN
;;

timebomb: PROCEDURE
	IF SHOW(p, "TIMEBOMB!") = 1 THEN DO
		ADDRESS "TIMEBOMB!" '_SHOW'
	END
	IF SHOW(p, "TIMEBOMB!") = 0 THEN DO
		ADDRESS COMMAND "RUN >NIL: rx rexx:timebomb!.rexx"
	END
	RETURN
;;

teeth_s: PROCEDURE
	IF SHOW(p, "TEETH!.S") = 1 THEN DO
		ADDRESS "TEETH!.S" '_SHOW'
	END
	IF SHOW(p, "TEETH!.S") = 0 THEN DO
		ADDRESS COMMAND "RUN >NIL: rx rexx:teeth!_s.rexx"
	END
	RETURN
;;

destroy: PROCEDURE
	IF SHOW(p, "DESTR6Y!") = 1 THEN DO
		ADDRESS "DESTR6Y!" '_SHOW'
	END
	IF SHOW(p, "DESTR6Y!") = 0 THEN DO
		ADDRESS COMMAND "RUN >NIL: rx rexx:destr6y!.rexx"
	END
	RETURN
;;

/* load preset */
p_ld:
	CALL p_rd
	preset = p.kb
	PARSE VAR preset do_echo num rate vol do_vol volume endvol noclip do_filter filter_type avg dist
	do_echo = STRIP(do_echo)
	num = STRIP(num)
	rate = STRIP(rate)
	vol = STRIP(vol)
	do_vol = STRIP(do_vol)
	volume = STRIP(volume)
	endvol = STRIP(endvol)
	noclip = STRIP(noclip)
	do_filter = STRIP(do_filter)
	filter_type = STRIP(filter_type)
	avg = STRIP(avg)
	dist = STRIP(dist)
	CALL preset
	RETURN
;;

/* read preset */
p_rd:
	y = OPEN('in', dir'earache!.preset', 'R')
	IF y = 0 THEN DO
		BUSY SET
		y = OPEN('out', dir'earache!.preset', 'W')
		DO x = 0 TO 9
			CALL WRITELN('out' , '0 00 00 00 0 100 100 CLIP 0 SA_BOOST 00 00')
		END
		CALL CLOSE('out')
		BUSY
		y = OPEN('in', dir'earache!.preset', 'R')
	END
	DO x = 0 TO 9
		p.x = READLN('in')
	END
	CALL CLOSE('in')
	RETURN
;;

/* save preset */
p_sv:
	preset = do_echo num rate vol do_vol volume endvol noclip do_filter filter_type avg dist
	kb = TRANSLATE(kb, '1234567890', '!@#$%^&*()')
	p.kb = preset
	BUSY SET
	y = OPEN('out', dir'earache!.preset', 'W')
	CALL SEEK('out', 0, 'B')
	DO x = 0 TO 9
		z = p.x
		CALL WRITELN('out' , z)
	END
	CALL CLOSE('out')
	BUSY
	SETTEXT _out "OK."
	SIGNAL main
;;

quit:
	'hide unload'
	CALL CLOSEPORT("EARACHE!")
EXIT
;;