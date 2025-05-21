/*
  $VER: DESTR6Y! 0.1 BETA 2
  DATE: 06-DEC-2011
  COMPLAINTS: systmcrsh@gmail.com
  NET: http://www.dirtybomb.tk
  PERVERTS CALL: 917-***-****
*/

/* data dir */
dir = 'REXX:data/'

/* gui */
gui_file = dir'destr6y!.gui'
CALL ADDLIB 'rexxmathlib.library',-20,-30,0
/* CALL ADDLIB 'rexxreqtools.library',-20,-30,0 */

IF EXISTS("libs:rexxsupport.library") THEN DO
	IF ~SHOW("L","rexxsupport.library") THEN
		IF ~ADDLIB("rexxsupport.library",0,-30,0) THEN EXIT
END
ELSE EXIT

IF EXISTS("libs:rexxtricks.library") THEN DO
	IF ~SHOW("L","rexxtricks.library") THEN
		IF ~ADDLIB("rexxtricks.library",0,-30) THEN EXIT
END
ELSE EXIT

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

IF OPENPORT("DESTR6Y!") = 0 THEN DO
	SAY "Could not open a port. Varexx Error."
	EXIT
END

'load ' gui_file 'DESTR6Y! PS=OCTAMED'

host = RESULT
ADDRESS VALUE host

SHOW

SIGNAL on error

/* defaults */
panic:
	return = 0
	ADDRESS OCTAMED_REXX
	OPTIONS RESULTS
	'OP_GET OverwriteReq var overwrite'
	'OP_GET SmpEdPitch var rate'
	volume = 100
	highpass = 'F'
	lowpass = 'F'
	comp = 0
	bits = 0
	ds = 0
	vol = ''
	hp = ''
	lp = ''
	bp = ''
	br = ''
	bandp = 'F'
	bandq = 'Q'
	bandr = 'F'
	rejectq = 'Q'
	cmp = ''
	crush = ''
	destroy = ''
	ext = GETCLIP(ds)
	IF ext = '' THEN ext = 0
	ADDRESS VALUE host
	SETTEXT _vol 100
	SETTEXT _hp highpass
	SETTEXT _lp lowpass
	SETTEXT _bp bandp'/'bandq
	SETTEXT _br bandr'/'rejectq
	SETNUM _comp 0
	SETTEXT _out 'Ready. RATE:'rate
	CALL p_rd
;;

calc:
	ADDRESS OCTAMED_REXX
	OPTIONS RESULTS
	'IN_GETNUMBER var inst'
	'IN_GETNAME var inst_name'
	'IN_GETTYPE var type'
	IF type ~= 'SAMPLE' THEN SIGNAL no_sample
	ns = 0
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
		CALL WAITPKT("DESTR6Y!")
		packet = GETPKT("DESTR6Y!")

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
				ADDRESS OCTAMED_REXX
				'OP_GET SmpEdPitch var rate'
				ADDRESS VALUE host
				SETTEXT _out 'Ready. RATE:'rate
				SIGNAL main
			END

			IF class = "INACTIVEWINDOW" THEN DO
				ADDRESS VALUE host
				SETTEXT _out "www.dirtybomb.tk"
			END

			IF LEFT( class , 4 ) = '_VOL' THEN DO
				PARSE VAR class null volume
				volume = STRIP(volume)
				IF DATATYPE(volume) = 'CHAR' THEN DO
					volume = 100
					SETTEXT _vol 100
				END
				SETTEXT _out 'V:'volume
			END

			IF LEFT( class , 3 ) = '_HP' THEN DO
				PARSE VAR class null highpass
				highpass = STRIP(highpass)
				IF DATATYPE(highpass) ~= 'NUM' THEN DO
					highpass = 'F'
					error = "HP = #####!"
					SETTEXT _hp highpass
					do_error = 1
					SIGNAL error
				END
				ADDRESS VALUE host
				SETTEXT _out 'HP:'highpass
	 		END

			IF LEFT( class , 3 ) = '_LP' THEN DO
				PARSE VAR class null lowpass
				lowpass = STRIP(lowpass)
				IF DATATYPE(lowpass) ~= 'NUM' THEN DO
					lowpass = 'F'
					error = "LP = #####!"
					SETTEXT _lp lowpass
					do_error = 1
					SIGNAL error
				END
				ADDRESS VALUE host
				SETTEXT _out 'LP:'lowpass
	 		END

			IF LEFT( class , 3 ) = '_BP' THEN DO
				PARSE VAR class null bandp '/' bandq
				bandp = STRIP(bandp)
				bandq = STRIP(bandq)
				IF DATATYPE(bandp) ~= 'NUM' THEN DO
					bandp = 'F'
					bandq = 'Q'
					error = "BP = #####!"
					SETTEXT _bp bandp'/'bandq
					do_error = 1
					SIGNAL error
				END
				IF DATATYPE(bandq) ~= 'NUM' THEN DO
					bandp = 'F'
					rejectq = 'Q'
					error = "Q = #####!"
					SETTEXT _bp bandr'/'rejectq
					do_error = 1
					SIGNAL error
				END
				ADDRESS VALUE host
				SETTEXT _out 'BP:'bandp 'Q:'bandq
	 		END

			IF LEFT( class , 3 ) = '_BR' THEN DO
				PARSE VAR class null bandr '/' rejectq
				bandr = STRIP(bandr)
				rejectq = STRIP(rejectq)
				IF DATATYPE(bandr) ~= 'NUM' THEN DO
					bandr = 'F'
					rejectq = 'Q'
					error = "BR = #####!"
					SETTEXT _br 'F/Q'
					do_error = 1
					SIGNAL error
				END
				IF DATATYPE(rejectq) ~= 'NUM' THEN DO
					bandr = 'F'
					rejectq = 'Q'
					error = "Q = #####!"
					SETTEXT _br 'F/Q'
					do_error = 1
					SIGNAL error
				END
				ADDRESS VALUE host
				SETTEXT _out 'BR:'bandr 'Q:'rejectq
	 		END

			IF LEFT( class , 5 ) = '_COMP' THEN DO
				PARSE VAR class null comp
				comp = STRIP(comp)
			END

			IF class = "_NEXT" THEN DO
				ADDRESS OCTAMED_REXX
				IN_SELECT NEXT
				return = 1
				CALL calc
				'OP_GET SmpEdPitch var rate'
				ADDRESS VALUE host
				SETTEXT _ins inst
				SETTEXT _out 'Ready. RATE:'rate
			END

			IF class = "_PREV" THEN DO
				ADDRESS OCTAMED_REXX
				IN_SELECT PREV
				return = 1
				CALL calc
				'OP_GET SmpEdPitch var rate'
				ADDRESS VALUE host
				SETTEXT _ins inst
				SETTEXT _out 'Ready. RATE:'rate
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
					ADDRESS VALUE host
					WINDOW FRONT
				END
				IF kb = 'F2' THEN DO
					CALL earache
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
				IF kb = 'B' THEN DO
					CALL bitcrush
				END
				IF kb = 'D' THEN DO
					CALL destroy
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
					IF do_undo ~= 0 THEN DO
						ADDRESS OCTAMED_REXX
						IN_SELECT undo_inst
						IN_LOAD 'RAM:ds_1.wav'
						ADDRESS COMMAND 'DELETE RAM:ds_1.wav >NIL:'
						IN_SETTRANSPOSE undo_tr
						IN_SETFINETUNE undo_ft
						IN_SETNAME undo_name
						IN_SETDEFAULTPITCH undo_pitch
						'IN_GETNUMBER var inst'
						ADDRESS VALUE host
						SETTEXT _ins inst
						SETTEXT _out "Undone!"
						do_undo = 0
						SET _undo DISABLE
					END
				END
			END

			/* do operation */
			IF class = "_GO" THEN DO
				IF ns = 1 THEN SIGNAL calc
				BUSY SET
				CALL TIME(R)
				CALL ext
				CALL undo
				SETTEXT _out "BUSY!"
				ADDRESS OCTAMED_REXX
				'SA_GETSAMPLELENGTH var ln_1'
				speed = 1
				vol = (volume)*.01
				vol = '-v 'vol
				IF DATATYPE(highpass) = 'NUM' THEN hp = 'highpass 'highpass
					ELSE hp = ''
/*
					hp = 'highp 'highpass
*/
				IF DATATYPE(lowpass) = 'NUM' THEN lp = 'lowpass 'lowpass
					ELSE lp = ''
/*
					lp = 'lowp 'lowpass
*/
				IF DATATYPE(bandp) = 'NUM' THEN bp = 'bandpass 'bandp bandq
					ELSE bp = ''
				IF DATATYPE(bandr) = 'NUM' THEN br = 'bandreject 'bandr rejectq
					ELSE br = ''
				IF comp = 0 THEN cmp = ''
				IF comp = 1 THEN cmp = 'compand 0.0105,0.051 -42,-42,-24,-24,-8,-2.666 3 0 0'
				IF comp = 2 THEN cmp = 'compand 0.008,0.015 -42,-42,-36,-36,-9,-3.75 5 0 0'
				IF comp = 3 THEN cmp = 'compand 0.02,0.46 -42,-42,-36,-36,-14,-3.5 8 0 0'
				IF comp = 4 THEN cmp = 'compand 0.035,0.002 -42,-42,-36,-36,-14,-0.466 -8 0 0'
				IF comp = 5 THEN cmp = 'compand 0.00001,0.008 -42,-42,-36,-36,-15,-0.5 -6 0 0'
				IF comp = 6 THEN cmp = 'compand 0.002,0.1 -42,-42,-36,-36,-6,-1.5 0 0 0'
				IF comp = 7 THEN cmp = 'compand 0.002,0.1 -42,-42,-36,-36,-6,-0.75 0 0 0'
				IF comp = 8 THEN cmp = 'compand 0.002,0.1 -42,-42,-36,-36,-6,-1.5 3 0 0'
				IF comp = 9 THEN cmp = 'compand 0.002,0.1 -42,-42,-36,-36,-6,-0.75 3 0 0'
				IF comp = 10 THEN cmp = 'compand 0.002,0.1 -42,-42,-36,-36,-9,-2.25 2 0 0'
				IF comp = 11 THEN cmp = 'compand 0.002,0.1 -42,-42,-36,-36,-9,-1.125 2 0 0'
				IF comp = 12 THEN cmp = 'compand 0.00001,0.33 -42,-42,-36,-36,-0.5,-0.0166 0 0 0'
				IF ds = 0 THEN destroy = '-u'
				IF ds = 1 THEN destroy = '-s'
				IF bits = 0 THEN crush = '-b'
				IF bits = 1 THEN crush = '-w'
				IF bits = 2 THEN crush = '-l'
				IF crush = '-w' THEN speed = speed/2
				IF crush = '-l' THEN speed = speed/4
				IF speed = 1 THEN speed = ''
				ELSE speed = 'speed 'speed
/*				rate = 8363 */
				/* sox cmd */
/*
				cmd = 'sox 'vol' -t wav 'crush destroy' -r 'rate' ram:ds_1.wav -b -t wav -c 1 ram:ds_2.wav' speed highpass lowpass cmp
*/
				cmd = 'sox 'vol' -t wav 'crush destroy' -r 'rate' ram:ds_1.wav -b -t wav -c 1 ram:ds_2.wav' speed bp br hp lp cmp
				cmd = SPACE(cmd, 1)
				ADDRESS COMMAND cmd
				ADDRESS OCTAMED_REXX
				IN_LOAD 'RAM:ds_2.wav'
				IN_SETNAME undo_name
/*
				'SA_GETSAMPLELENGTH var ln_2'
				IF ln_2 ~= ln_1 THEN DO
					SA_RANGE ln_1 ln_2
					SA_DELRANGE
				END
*/
/*
				IF lowpass > 0 THEN DO
					PARSE VAR lp null lowpass
					lowpass = STRIP(lowpass)
				END
				IF highpass > 0 THEN DO
					PARSE VAR hp null highpass
					highpass = STRIP(highpass)
				END
				IF volume ~= 100 THEN DO
					PARSE VAR vol null volume
					volume = STRIP(volume)
					volume = (volume * 100) / 1
				END
*/
/*
				IN_SETDEFAULTPITCH undo_pitch
*/
				SA_REFRESH
				ADDRESS COMMAND 'DELETE RAM:ds_2.wav >NIL:'
				SIGNAL done
			END
		/* end packet */
		END
	/* end main */
	END
;;

	/* clean up */
	CALL SETCLIP(ds)
	/* end gui */
	'hide unload'
	CALL CLOSEPORT("DESTR6Y!")
EXIT

/* errors */
error:
	ADDRESS VALUE host
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
;;

failure:
	SAY "Error code" rc "-- Line" SIGL
	SAY EXTERNERROR
	CALL SETCLIP(ds)
	ADDRESS VALUE host
	'hide unload'
	CALL CLOSEPORT("DESTR6Y!")
EXIT
;;

syntax:
	SAY "Error" rc  "-- Line" SIGL
	SAY ERRORTEXT( rc )
	CALL SETCLIP(ds)
	ADDRESS VALUE host
	'hide unload'
	CALL CLOSEPORT("DESTR6Y!")
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
	'OP_GET SmpEdPitch var rate'
	'IN_GETNAME var inst_name'
	IF inst_name = '' THEN inst_name = 'destroy_'ext'.wav'
	undo_inst = inst
	undo_name = inst_name
	IN_SAVE 'RAM:'ds_1.wav'' WAVE
	do_undo = 1
	IF overwrite = 1 THEN DO
		ADDRESS OCTAMED_REXX
		OP_SET OverwriteReq ON
	END
	RETURN RESULT
;;

ext:
	ext = ext + 1
	CALL SETCLIP(ds, ext)
;;

preset:
	volume = STRIP(volume)
	bits = STRIP(bits)
	highpass = STRIP(highpass)
	lowpass = STRIP(lowpass)
	comp = STRIP(comp)
	bandp = STRIP(bandp)
	bandq = STRIP(bandq)
	bandr = STRIP(bandr)
	rejectq = STRIP(rejectq)
	SETTEXT _vol volume
	SETTEXT _hp highpass
	SETTEXT _lp lowpass
	SETTEXT _bp bandp'/'bandq
	SETTEXT _br bandr'/'rejectq
	SETNUM _comp comp
	RETURN
;;

/* load preset */
p_ld:
	CALL p_rd
	preset = p.kb
	preset = SPACE(preset, 1)
	PARSE VAR preset volume highpass lowpass bandp bandq bandr rejectq comp bits ds
	CALL preset
	RETURN
;;

/* read preset */
p_rd:
	y = OPEN('in', dir'destr6y!.preset', 'R')
	IF y = 0 THEN DO
		BUSY SET
		y = OPEN('out', dir'destr6y!.preset', 'W')
		DO x = 0 TO 9
			CALL WRITELN('out' , '100 F F F Q F Q 0 0 0')
		END
		CALL CLOSE('out')
		BUSY
		y = OPEN('in', dir'destr6y!.preset', 'R')
	END
	DO x = 0 TO 9
		p.x = READLN('in')
	END
	CALL CLOSE('in')
	RETURN
;;

/* save preset */
p_sv:
	preset = SPACE(volume highpass lowpass bandp bandq bandr rejectq comp bits ds, 1)
	kb = TRANSLATE(kb, '1234567890', '!@#$%^&*()')
	p.kb = preset
	BUSY SET
	y = OPEN('out', dir'destr6y!.preset', 'W')
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

bitcrush:
	ADDRESS VALUE host
	IF bits = 0 THEN DO
		bits = 1
		SETTEXT _out 'BITCRUSH 4'
		RETURN
	END
	IF bits = 1 THEN DO
		bits = 2
		SETTEXT _out 'BITCRUSH 2'
		RETURN
	END
	IF bits = 2 THEN DO
		bits = 0
		SETTEXT _out 'BITCRUSH NONE'
		RETURN
	END
	RETURN

destroy:
	ADDRESS VALUE host
	IF ds = 0 THEN DO
		ds = 1
		SETTEXT _out 'DESTROY ON!'
		RETURN
	END
	IF ds = 1 THEN DO
		ds = 0
		SETTEXT _out 'DESTROY OFF!'
		RETURN
	END
	RETURN

timebomb: PROCEDURE
	IF SHOW(p, "TIMEBOMB!") = 1 THEN DO
		ADDRESS "TIMEBOMB!" '_SHOW'
/*		window BACK */
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

earache: PROCEDURE
	IF SHOW(p, "EARACHE!") = 1 THEN DO
		ADDRESS "EARACHE!" '_SHOW'
	END
	IF SHOW(p, "EARACHE!") = 0 THEN DO
		ADDRESS COMMAND "RUN >NIL: rx rexx:earache!.rexx"
	END
	RETURN
;;

quit:
	'hide unload'
	CALL CLOSEPORT("DESTR6Y!")
EXIT
;;