/*
  $VER: EARACHE! 0.1b
  DATE: 24-APR-2011
  COMPLAINTS: systmcrsh@gmail.com
  NET: http://www.dirtybomb.tk
  PERVERTS CALL: 917-***-****
*/

/* gui */
gui_file = 'REXX:earache!.gui'
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

IF gui_file = '' THEN DO
	gui_file=rtfilerequest('REXX:gui',,'Varexx Request','_Load','rt_reqpos=reqpos_centerscr rtfi_matchpat=#?.gui rtfi_flags=freqf_patgad')
	IF gui_file = '' THEN EXIT
END

IF SHOW( 'p', 'VAREXX' ) ~= 1 THEN DO
	ADDRESS COMMAND "run >NIL: varexx"
	ADDRESS COMMAND "WaitForPort VAREXX"
END
ADDRESS VAREXX

IF OPENPORT("EARACHE!") = 0 THEN DO
	SAY "Could not open a port.  Varexx Error."
	EXIT
END

'load ' gui_file 'EARACHE! PS=OCTAMED'

e_host = RESULT
ADDRESS VALUE e_host

SHOW

SIGNAL on error

/* set defaults */
	opt = 0
	noclip = 'ALSE'
	do_echo = 0
	do_vol = 0
	do_error = 0
	do_undo = 0
	undo_en = 0
	do_filter = 0
	SETNUM _opt 0
	SET _filter DISABLE
	SETCHECK _noclip
	SET _noclip DISABLE
	SET _undo DISABLE
	SETTEXT _out 'Ready.'
	ADDRESS OCTAMED_REXX
	OPTIONS RESULTS
	'OP_GET OverwriteReq var overwrite'
	IF overwrite = 1 THEN CALL SETCLIP("overwrite", "1")
	'IN_GETNUMBER var inst'
	'IN_GETNAME var inst_name'
	'IN_GETTYPE var type'
	IF type ~= 'SAMPLE' THEN CALL nosample

/* main */
main:
	DO FOREVER
		ADDRESS VALUE e_host
		IF do_undo = 1 THEN SET _undo ENABLE
		SETTEXT _ins inst
		CALL WAITPKT("EARACHE!")
		packet = GETPKT("EARACHE!")
	
		IF packet ~= '00000000'x THEN DO
			e_class = GETARG(packet)

			IF e_class = "CLOSEWINDOW" THEN LEAVE
	
			IF e_class = "ACTIVEWINDOW" THEN DO
				ADDRESS OCTAMED_REXX
				'IN_GETNUMBER var inst'
				'IN_GETTYPE var type'
				IF type ~= 'SAMPLE' THEN CALL nosample
				ADDRESS VALUE e_host
				SETTEXT _ins inst
			END

	 		IF LEFT( e_class , 5 ) = '_ECHO' THEN DO
	 			echo = RIGHT( e_class , 6 )
				IF DATATYPE(echo) ~= 'NUM' THEN DO
					error = "ECHO = ######!"
					do_error = 1
					SIGNAL error
				END
				PARSE VAR echo 1 num 3 rate 5 vol
				ADDRESS VALUE e_host
				do_echo = 1
				SETTEXT _out ECHO
	 		END

			IF LEFT( e_class , 4 ) = '_VOL' THEN DO
	 			volume = RIGHT( e_class , 3 )
				IF DATATYPE(volume) = 'CHAR' THEN DO
					PARSE VAR volume null " " volume
					DROP null
				END
				IF volume = 0 THEN DO
					SET _noclip DISABLE
					do_vol = 0
				END
				IF volume > 0 THEN DO
					SET _noclip ENABLE
					do_vol = 1
				END
				SETTEXT _out volume
			END

			IF LEFT( e_class , 7 ) = '_NOCLIP' THEN DO
				noclip = RIGHT( e_class , 4 )
				IF noclip = 'ALSE' THEN noclip = 'CLIP'
				IF noclip = 'TRUE' THEN noclip = 'NOCLIP'
			END

			IF LEFT( e_class , 4 ) = '_OPT' THEN DO
				opt = RIGHT( e_class , 1 )
				IF opt = 0 THEN DO
					filter_type = ''
					do_filter = 0
					SET _filter DISABLE
				END
				IF opt = 1 THEN DO
					filter_type = 'SA_BOOST'
					do_filter = 1
					SET _filter ENABLE
				END
				IF opt = 2 THEN DO
					filter_type = 'SA_FILTER'
					do_filter = 1
					SET _filter ENABLE
				END
				SETTEXT _out filter_type
			END

			IF LEFT( e_class , 7 ) = '_FILTER' THEN DO
				filter = RIGHT( e_class , 4 )
				IF DATATYPE(filter) ~= 'NUM' THEN DO
					error = "FILTER = ####!"
					do_error = 1
					SIGNAL error
				END
	 			PARSE VAR filter 1 avg 3 dist
				do_filter = 1
				SETTEXT _out avg dist
			END

			IF e_class = "_NEXT" THEN DO
				ADDRESS OCTAMED_REXX
				IN_SELECT NEXT
				'IN_GETNUMBER var inst'
				'IN_GETTYPE var type'
				IF type ~= 'SAMPLE' THEN CALL nosample
				ADDRESS VALUE e_host
				SETTEXT _ins inst
			END

			IF e_class = "_PREV" THEN DO
				ADDRESS OCTAMED_REXX
				IN_SELECT PREV
				'IN_GETNUMBER var inst'
				'IN_GETTYPE var type'
				IF type ~= 'SAMPLE' THEN CALL nosample
				ADDRESS VALUE e_host
				SETTEXT _ins inst
			END

			IF e_class = "_PLAY" THEN DO
				ADDRESS OCTAMED_REXX		
				SA_PLAY DISPLAY	
			END

			IF e_class = "_LOAD" THEN DO
				SETTEXT _out "Load Inst."
				ADDRESS OCTAMED_REXX
				IN_LOADREQ
				ADDRESS VALUE e_host
			END

	 		IF LEFT( e_class , 8 ) = 'KEYBOARD' THEN DO
	 			k_cmd = RIGHT( e_class , 2 )
				IF k_cmd = 'F1' THEN CALL preset
				IF k_cmd = 'F2' THEN CALL u_toggle
			END

			IF e_class = "_UNDO" THEN DO
				IF do_undo = 0 THEN DO
					SETTEXT _out "Nothing!"
				END
				IF do_undo ~= 0 THEN DO
					ADDRESS OCTAMED_REXX
					IN_SELECT undo_inst
					IN_LOAD 'T:temp1.ds'
					ADDRESS COMMAND 'DELETE T:temp1.ds >NIL:'
					IN_SETTRANSPOSE undo_tr
					IN_SETFINETUNE undo_ft
					IN_SETNAME undo_name
					IN_SETDEFAULTPITCH undo_pitch
					ADDRESS VALUE e_host
					SETTEXT _out "Undone!"
					do_undo = 0
					SET _undo DISABLE
				END
			END

/* do operation */
			IF e_class = "_GO" THEN DO
				IF type ~= 'SAMPLE' THEN CALL nosample
				BUSY SET
				CALL TIME(R)
				IF undo_en = 1 THEN CALL undo
				SETTEXT _out "Earbleed!"
				ADDRESS OCTAMED_REXX
				OPTIONS RESULTS
				'SA_GETSAMPLELENGTH var length'
				SA_RANGE 0 length
				IF do_echo = 1 THEN DO
					SA_ECHO num rate vol
				END
				IF do_vol = 1 THEN DO
					SA_CHANGEVOL volume volume noclip
				END
				IF do_filter = 1 THEN DO
					filter_type avg dist
				END
				SA_REFRESH
				SIGNAL done
			END
		END
	END
	'hide unload'
	CALL CLOSEPORT("EARACHE!")
EXIT

done:
	ADDRESS VALUE e_host
	SETTEXT _out "Done. "TIME(E)"s"
	IF GETCLIP("overwrite") = 1 THEN DO
		ADDRESS OCTAMED_REXX
		OP_SET OverwriteReq ON
	END
	ADDRESS VALUE e_host
	BUSY
	SIGNAL main

nosample:
	ADDRESS VALUE e_host
	SETTEXT _ins inst
	SETTEXT _out "No Sample!"
	SIGNAL main
END

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
	IN_SAVE 'T:'temp1.ds'' WAVE
	do_undo = 1
	RETURN RESULT

preset:
/* echo */
	do_echo = 1
	num = 01
	rate = 01
	vol = 01
	
/* vol */
	do_vol = 1
	volume = 01
/* CLIP NOCLIP */
	noclip = 'CLIP'
	
/* filter */
	do_filter = 1
/* SA_BOOST SA_FILTER */
	filter_type = 'SA_BOOST'
	avg = 01
	dist = 01

/* end preset */	
	IF do_echo = 1 THEN DO
		ADDRESS VALUE e_host
		SETTEXT _echo COMPRESS(num rate vol)
	END
	IF do_echo = 0 THEN DO
		ADDRESS VALUE e_host
		SETTEXT _echo COMPRESS(NN RR VV)
		num = ''
		rate = ''
		vol = ''
	END
	IF do_vol = 1 THEN DO
		ADDRESS VALUE e_host
		SET _noclip ENABLE
		SETNUM _vol volume
		SET _noclip ENABLE
		IF noclip = 'NOCLIP' THEN SETCHECK _noclip CHECK
		IF noclip = 'CLIP' THEN SETCHECK _noclip
	END
	IF do_vol = 0 THEN DO
		ADDRESS VALUE e_host
		SET _noclip DISABLE
		SETNUM _vol 0
		SET _noclip DISABLE
		SETCHECK _noclip
		volume = 0
		noclip = 'CLIP'
	END
	IF do_filter = 1 THEN DO
		ADDRESS VALUE e_host
		IF filter_type = 'SA_BOOST' THEN SETNUM _opt 1
		IF filter_type = 'SA_FILTER' THEN SETNUM _opt 2
		SET _filter ENABLE
		SETTEXT _filter COMPRESS(avg dist)
	END
	IF do_filter = 0 THEN DO
		ADDRESS VALUE e_host
		SETNUM _opt 0
		SET _filter DISABLE
		SETTEXT _filter COMPRESS(AA DD)
		filter_type = ''
		avg = ''
		dist = ''
	END
	RETURN

u_toggle:
	IF undo_en = 0 THEN DO
		undo_en = 1
		If do_undo = 1 THEN SET _undo ENABLE
		SETTEXT _out "UNDO ENABLED!"
		SIGNAL main
	END
	IF undo_en = 1 THEN DO
		undo_en = 0
		do_undo = 0
		SET _undo DISABLE
		SETTEXT _out "UNDO DISABLED!"
		SIGNAL main
	END

/* error messages */
failure:
	SAY "Error code" rc "-- Line" SIGL
	SAY EXTERNERROR
	'hide unload'
	CALL CLOSEPORT("EARACHE!")
EXIT

syntax:
	SAY "Error" rc  "-- Line" SIGL
	SAY ERRORTEXT( rc )
	'hide unload'
	CALL CLOSEPORT("EARACHE!")
EXIT

error:
	ADDRESS VALUE e_host
	BUSY
	IF do_error = 1 THEN DO
		SETTEXT _out "Error! "error
		do_error = 0
		SIGNAL main
	END
	SETTEXT _out "Error! "rc SIGL
	error = ''
	SIGNAL main
EXIT