/*
  $VER: TIMEBOMB! 0.1d BETA 3
  DATE: 08-DEC-2011
  COMPLAINTS: systmcrsh@gmail.com
  NET: http://www.dirtybomb.tk
  PERVERTS CALL: 917-***-****
*/

/* data dir */
dir = 'REXX:data/'

/* gui */
gui_file = dir'timebomb!.gui'
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

IF OPENPORT("TIMEBOMB!") = 0 THEN DO
	SAY "Could not open a port. Varexx Error."
	EXIT
END

'load ' gui_file 'TIMEBOMB! PS=OCTAMED'

host = RESULT
ADDRESS VALUE host

SHOW

SIGNAL on error

/* get pal/ntsc */
PARSE VERSION CPU MPU VIDEO FREQ var video
video:
	IF video = '50HZ' THEN DO
		video = 'PAL'
		freq.0 = 8287
		freq.1 = 4143
		freq.2 = 4389
		freq.3 = 4654
		freq.4 = 4926
		freq.5 = 5231
		freq.6 = 5542
		freq.7 = 5872
		freq.8 = 6222
		freq.9 = 6592
		freq.10	= 6982
		freq.11	= 7389
		freq.12	= 7829
		freq.13	= 8287
		freq.14	= 8779
		freq.15	= 9309
		freq.16	= 9852
		freq.17	= 10462
		freq.18	= 11084
		freq.19	= 11744
		freq.20	= 12445
		freq.21	= 13185
		freq.22	= 13964
		freq.23	= 14778
		freq.24	= 15694
		freq.25	= 16574
		freq.26	= 17558
		freq.27	= 18667
		freq.28	= 19704
		freq.29	= 20864
		freq.30	= 22168
		freq.31	= 23489
		freq.32	= 24803
		freq.33	= 26273
		freq.34	= 27928
		freq.35	= 29557
		freq.36	= 31388
		note.0 = "Not Set"
		note.1 = "C-1"
		note.2 = "C#1"
		note.3 = "D-1"
		note.4 = "D#1"
		note.5 = "E-1"
		note.6 = "F-1"
		note.7 = "F#1"
		note.8 = "G-1"
		note.9 = "G#1"
		note.10 = "A-1"
		note.11 = "A#1"
		note.12 = "B-1"
		note.13 = "C-2"
		note.14 = "C#2"
		note.15 = "D-2"
		note.16 = "D#2"
		note.17 = "E-2"
		note.18 = "F-2"
		note.19 = "F#2"
		note.20 = "G-2"
		note.21 = "G#2"
		note.22 = "A-2"
		note.23 = "A#2"
		note.24 = "B-2"
		note.25 = "C-3"
		note.26 = "C#3"
		note.27 = "D-3"
		note.28 = "D#3"
		note.29 = "E-3"
		note.30 = "F-3"
		note.31 = "F#3"
		note.32 = "G-3"
		note.33 = "G#3"
		note.34 = "A-3"
		note.35 = "A#3"
		note.36 = "B-3"
	END
	IF video = '60HZ' THEN DO
		video = 'NTSC'
		freq.0 = 8363
		freq.1 = 4181
		freq.2 = 4430
		freq.3 = 4697
		freq.4 = 4971
		freq.5 = 5279
		freq.6 = 5593
		freq.7 = 5926
		freq.8 = 6279
		freq.9 = 6653
		freq.10	= 7046
		freq.11	= 7457
		freq.12	= 7901
		freq.13	= 8363
		freq.14	= 8860
		freq.15	= 9395
		freq.16	= 9943
		freq.17	= 10559
		freq.18	= 11186
		freq.19	= 11852
		freq.20	= 12559
		freq.21	= 13306
		freq.22	= 14092
		freq.23	= 14914
		freq.24	= 15838
		freq.25	= 16726
		freq.26	= 17720
		freq.27	= 18839
		freq.28	= 19886
		freq.29	= 21056
		freq.30	= 22372
		freq.31	= 23705
		freq.32	= 25031
		freq.33	= 26515
		freq.34	= 28185
		freq.35	= 29829
		freq.36	= 31677
		note.0 = "Not Set"
		note.1 = "C-1"
		note.2 = "C#1"
		note.3 = "D-1"
		note.4 = "D#1"
		note.5 = "E-1"
		note.6 = "F-1"
		note.7 = "F#1"
		note.8 = "G-1"
		note.9 = "G#1"
		note.10 = "A-1"
		note.11 = "A#1"
		note.12 = "B-1"
		note.13 = "C-2"
		note.14 = "C#2"
		note.15 = "D-2"
		note.16 = "D#2"
		note.17 = "E-2"
		note.18 = "F-2"
		note.19 = "F#2"
		note.20 = "G-2"
		note.21 = "G#2"
		note.22 = "A-2"
		note.23 = "A#2"
		note.24 = "B-2"
		note.25 = "C-3"
		note.26 = "C#3"
		note.27 = "D-3"
		note.28 = "D#3"
		note.29 = "E-3"
		note.30 = "F-3"
		note.31 = "F#3"
		note.32 = "G-3"
		note.33 = "G#3"
		note.34 = "A-3"
		note.35 = "A#3"
		note.36 = "B-3"
	END
;;

/* defaults */
defaults:
/* pal clock 3546895 7.09379 */
/* ntsc clock 3579545 7.15909 */
	pitch = 0
	beats = 4
	speed = ''
	option = 0
	do_error = 0
	do_update = 1
	return = 0
	SETNUM _opt 0
	SETNUM _pitch pitch
	SETNUM _beats beats
	SETTEXT _bpm 0
	SETTEXT _note 0
	SETTEXT _out 'Ready.'
	ADDRESS OCTAMED_REXX
	OPTIONS RESULTS
	'OP_GET OverwriteReq var overwrite'
	CALL setpitch
;;

/* do calculations */
calc:
	ADDRESS OCTAMED_REXX
	OPTIONS RESULTS
	'IN_GETNUMBER var inst'
	'IN_GETNAME var inst_name'
	'IN_GETTYPE var type'
	IF type ~= 'SAMPLE' THEN SIGNAL no_sample
	'SG_GETTEMPOMODE var mode'
	IF mode ='SPD' THEN do_update = 1
	'SG_GETTEMPOLPB var lpb'
	'SG_GETTEMPOTPL var tpl'
	'SA_GETSAMPLELENGTH var length'
	ADDRESS VALUE host
	IF beats = 0 THEN DO
		error = "Beats = 0!"
		do_error = 1
		SIGNAL error
	END
	IF do_update = 1 THEN DO
		ADDRESS OCTAMED_REXX
		'SG_GETTEMPO var tempo'
		ADDRESS VALUE host
		IF mode = 'BPM' THEN tempo = ((tempo * .75 * lpb) / tpl)
		IF mode = 'SPD' THEN tempo = ((tempo / tpl) / .088)
		do_update = 0
	END
/*
	length = ((beats * freq.pitch) * 60) / tempo
*/
	bpm = ((beats * freq.pitch) * 60) / length
	speed = tempo/bpm
	bpm_1 = TRUNC(bpm + 0.005, 2)
	SETTEXT _out "SNG: "tempo video
	SETTEXT _bpm bpm_1
	SETTEXT _note note.pitch
	SETTEXT _ins inst
	SETNUM _pitch pitch
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
		ADDRESS VALUE host
		CALL WAITPKT("TIMEBOMB!")
		packet = GETPKT("TIMEBOMB!")

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
				do_update = 1
				return = 0
				CALL calc
				SIGNAL main
			END

			IF class = "INACTIVEWINDOW" THEN DO
				ADDRESS VALUE host
				SETTEXT _out "www.dirtybomb.tk"
			END

	 		IF LEFT( class , 6 ) = '_PITCH' THEN DO
	 			pitch = RIGHT( class , 2 )
	 			IF pitch > 36 THEN pitch = 36
	 			ADDRESS OCTAMED_REXX
	 			IN_SETDEFAULTPITCH pitch
				ADDRESS VALUE host
				return = 1
	 			CALL setpitch
				return = 1
	 			CALL calc
	 		END

			IF LEFT( class , 6 ) = '_BEATS' THEN DO
				beats = RIGHT( class , 2 )
				return = 1
	 			CALL calc
				SETTEXT _bpm bpm_1
				SETTEXT _note note.pitch
			END

			IF LEFT( class , 4 ) = '_OPT' THEN DO
				option = RIGHT( class , 1 )
			END

			IF class = "_NEXT" THEN DO
				ADDRESS OCTAMED_REXX
				IN_SELECT NEXT
				'IN_GETTYPE var type'
				IF type ~= 'SAMPLE' THEN SIGNAL no_sample
				return = 1
				CALL setpitch
				return = 1
	 			CALL calc
				ADDRESS VALUE host
				SETTEXT _ins inst
				SETNUM _pitch pitch
				SETTEXT _bpm bpm_1
				SETTEXT _note note.pitch
			END

			IF class = "_PREV" THEN DO
				ADDRESS OCTAMED_REXX
				IN_SELECT PREV
				'IN_GETTYPE var type'
				IF type ~= 'SAMPLE' THEN SIGNAL no_sample
				return = 1
				CALL setpitch
				return = 1
				CALL calc
				ADDRESS VALUE host
				SETTEXT _ins inst
				SETNUM _pitch pitch
				SETTEXT _bpm bpm_1
				SETTEXT _note note.pitch
			END

			IF class = "_PLAY" THEN DO
				ADDRESS OCTAMED_REXX
				SA_PLAY DISPLAY
			END

			IF class = "_LOAD" THEN DO
				SETTEXT _out "Load Inst."
				ADDRESS OCTAMED_REXX
				IN_LOADREQ
				ADDRESS VALUE host
			END

	 		IF LEFT( class , 8 ) = 'KEYBOARD' THEN DO
				PARSE var class null kb
				kb = STRIP(kb)
				IF INDEX('abcdefgABCDEFG', kb) = 0 THEN kb = UPPER(kb)
				IF kb = 'F1' THEN CALL destroy
				IF kb = 'F2' THEN CALL earache
				IF kb = 'F3' THEN DO
					ADDRESS VALUE host
					WINDOW FRONT
				END
				IF kb = 'F4' THEN CALL teeth_s
				IF kb = 'HELP' THEN DO
					cmd = dir'help!'
					ADDRESS COMMAND cmd
					ADDRESS OCTAMED_REXX
					WI_OCTAMEDTOFRONT
					ADDRESS VALUE host
					WINDOW ACTIVATE
				END
				IF kb = 'P' THEN DO
					video = '50HZ'
					SETTEXT _out "PAL!"
					SIGNAL video
				END
				IF kb = 'N' THEN DO
					video = '60HZ'
					SETTEXT _out "NTSC!"
					SIGNAL video
				END
				/* save inst */
				IF kb = 'S' THEN DO
					SETTEXT _out "Save Inst."
					ADDRESS OCTAMED_REXX
					IN_SAVEREQ WAVE
					ADDRESS VALUE host
				END
				IF kb = '+' && kb = '=' THEN DO
					ADDRESS OCTAMED_REXX
					OPTIONS RESULTS
					'IN_GETDEFAULTPITCH var pitch'
					IF pitch < 36 THEN pitch = pitch + 1
	 				IN_SETDEFAULTPITCH pitch
					return = 1
	 				CALL setpitch
					return = 1
	 				CALL calc
					SIGNAL main
	 			END
				IF kb = '-' && kb = '_' THEN DO
					ADDRESS OCTAMED_REXX
					OPTIONS RESULTS
					'IN_GETDEFAULTPITCH var pitch'
					IF pitch > 0 THEN pitch = pitch - 1
	 				IN_SETDEFAULTPITCH pitch
					return = 1
	 				CALL setpitch
					return = 1
	 				CALL calc
					SIGNAL main
	 			END
				IF kb = ']' THEN DO
					ADDRESS OCTAMED_REXX
					OPTIONS RESULTS
					'IN_GETDEFAULTPITCH var pitch'
					IF (pitch + 12) <= 36 THEN pitch = pitch + 12
	 				IN_SETDEFAULTPITCH pitch
					return = 1
	 				CALL setpitch
					return = 1
	 				CALL calc
					SIGNAL main
	 			END
				IF kb = '[' THEN DO
					ADDRESS OCTAMED_REXX
					OPTIONS RESULTS
					'IN_GETDEFAULTPITCH var pitch'
					IF (pitch - 12) >= 0 THEN pitch = pitch - 12
	 				IN_SETDEFAULTPITCH pitch
					return = 1
	 				CALL setpitch
					return = 1
	 				CALL calc
					SIGNAL main
	 			END
				IF INDEX('0123456789', kb) > 0 THEN DO
					beats = kb
					IF beats = 0 THEN beats = 16
					SETNUM _beats beats
					return = 1
	 				CALL calc
					SETTEXT _bpm bpm_1
					SETTEXT _note note.pitch
					SIGNAL main
				END
				IF INDEX('abcdefgABCDEFG', kb) > 0 THEN DO
					ADDRESS OCTAMED_REXX
					OPTIONS RESULTS
	 				IF kb = 'c' THEN IN_SETDEFAULTPITCH 25
	 				IF kb = 'd' THEN IN_SETDEFAULTPITCH 27
	 				IF kb = 'e' THEN IN_SETDEFAULTPITCH 29
	 				IF kb = 'f' THEN IN_SETDEFAULTPITCH 30
	 				IF kb = 'g' THEN IN_SETDEFAULTPITCH 32
	 				IF kb = 'a' THEN IN_SETDEFAULTPITCH 34
	 				IF kb = 'b' THEN IN_SETDEFAULTPITCH 36
	 				IF kb = 'C' THEN IN_SETDEFAULTPITCH 13
	 				IF kb = 'D' THEN IN_SETDEFAULTPITCH 15
	 				IF kb = 'E' THEN IN_SETDEFAULTPITCH 17
	 				IF kb = 'F' THEN IN_SETDEFAULTPITCH 18
	 				IF kb = 'G' THEN IN_SETDEFAULTPITCH 20
	 				IF kb = 'A' THEN IN_SETDEFAULTPITCH 22
	 				IF kb = 'B' THEN IN_SETDEFAULTPITCH 24
					return = 1
	 				CALL setpitch
					return = 1
	 				CALL calc
					SIGNAL main
	 			END
			END

			/* do operation */
			IF class = "_GO" THEN DO
				IF type ~= 'SAMPLE' THEN SIGNAL no_sample
				ADDRESS VALUE host
				BUSY SET
				CALL TIME(R)
				return = 1
				do_update = 1
				CALL calc
				SETTEXT _out "BUSY!"
				ADDRESS OCTAMED_REXX
	 			IN_SETDEFAULTPITCH pitch
				OP_SET SmpEdPitch freq.pitch
				/* internal no anti-aliasing */
				IF option = 0 THEN DO
					dest = freq.pitch*speed
					dest = TRUNC(dest + 0.5,0)
					SA_CHANGEPITCH freq.pitch dest
					IN_SETTRANSPOSE 0
					IN_SETFINETUNE 0
					SIGNAL done
				END
				/* internal w/ anti-aliasing */
				IF option = 1 THEN DO
					dest = freq.pitch*speed
					dest = TRUNC(dest + 0.5,0)
					SA_CHANGEPITCH freq.pitch dest ANTIALIAS
					IN_SETTRANSPOSE 0
					IN_SETFINETUNE 0
					SIGNAL done
				END
				/* transpose */
				IF option = 2 THEN DO
					speed = 12 * (ln(tempo/bpm) / ln(2))
					speed = TRUNC(speed, 2)
					PARSE VAR speed transpose "." finetune
					IF finetune ~= 0 THEN DO
						finetune = 100/finetune
						IF speed < 0 THEN finetune = (8/finetune) * -1
						IF speed > 0 THEN finetune = 7/finetune
					END
					finetune = TRUNC(finetune + 0.5,0)
					IF finetune = 8 THEN finetune = -7 & transpose = transpose + 1
					IF finetune = 9 THEN finetune = -8 & transpose = transpose + 1
					IF finetune = -9 THEN finetune = 7 & transpose = transpose -1
					IN_SETTRANSPOSE transpose
					IN_SETFINETUNE finetune
					SIGNAL done
				END
				/* sox */
				IF option = 3 THEN DO
					/* acc. */
					IF TRUNC(speed, 4) = 1.000 THEN SIGNAL done
					ADDRESS OCTAMED_REXX
					OPTIONS RESULTS
					'IN_GETDEFAULTPITCH var pitch'
					OP_SET OverwriteReq OFF
					'IN_GETNAME var iname'
					IN_SAVE 'RAM:'tb_1.wav'' WAVE
					cmd = 'sox -t wav -r 'freq.pitch' ram:tb_1.wav -t wav ram:tb_2.wav speed 'speed
					ADDRESS COMMAND cmd
					ADDRESS OCTAMED_REXX
					IN_LOAD 'RAM:tb_2.wav'
					IN_SETNAME iname
					SA_REFRESH
					IN_SETTRANSPOSE 0
					IN_SETFINETUNE 0
					ADDRESS OCTAMED_REXX
					OPTIONS RESULTS
	 				IN_SETDEFAULTPITCH pitch
					return = 1
	 				CALL setpitch
					IF overwrite = 1 THEN DO
						ADDRESS OCTAMED_REXX
						OP_SET OverwriteReq ON
					END
					CALL DELETE('RAM:tb_1.wav')
					CALL DELETE('RAM:tb_2.wav')
					SIGNAL done
				END
				/* sox timestretch */
				IF option = 4 THEN DO
					ADDRESS OCTAMED_REXX
					/* acc. */
					IF TRUNC(speed, 4) = 1.000 THEN SIGNAL done
					OPTIONS RESULTS
					'IN_GETDEFAULTPITCH var pitch'
					OP_SET OverwriteReq OFF
					'IN_GETNAME var iname'
					IN_SAVE 'RAM:'tb_1.wav'' WAVE
					cmd = 'sox -t wav -r 'freq.pitch' ram:tb_1.wav -t wav ram:tb_2.wav stretch 'bpm/tempo
					ADDRESS COMMAND cmd
					ADDRESS OCTAMED_REXX
					IN_LOAD 'RAM:tb_2.wav'
					IN_SETNAME iname
					SA_REFRESH
					IN_SETTRANSPOSE 0
					IN_SETFINETUNE 0
	 				IN_SETDEFAULTPITCH pitch
					return = 1
	 				CALL setpitch
					IF overwrite = 1 THEN DO
						ADDRESS OCTAMED_REXX
						OP_SET OverwriteReq ON
					END
					CALL DELETE('RAM:tb_1.wav')
					CALL DELETE('RAM:tb_2.wav')
					SIGNAL done
				END
			END
		/* end packet */
		END
	/* end main */
	END
;;

	'hide unload'
	CALL CLOSEPORT("TIMEBOMB!")
EXIT

/* errors */
failure:
	SAY "Error code" rc "-- Line" SIGL
	SAY EXTERNERROR
	'hide unload'
	CALL CLOSEPORT("TIMEBOMB!")
EXIT
;;

syntax:
	SAY "Error" rc  "-- Line" SIGL
	SAY ERRORTEXT( rc )
	'hide unload'
	CALL CLOSEPORT("TIMEBOMB!")
EXIT
;;

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

/* functions */
done:
	return = 1
	CALL calc
	ADDRESS VALUE host
	SETTEXT _out "Done. "TIME(E)"s"
	ADDRESS VALUE host
	BUSY
	SIGNAL main
;;

no_sample:
	ADDRESS OCTAMED_REXX
	'IN_GETNUMBER var inst'
	ADDRESS VALUE host
	SETTEXT _out "No Sample!"
	pitch = 0
	SETTEXT _bpm 0
	SETTEXT _note note.pitch
	SETNUM _pitch pitch
	SIGNAL main
;;

setpitch:
	ADDRESS OCTAMED_REXX
	OPTIONS RESULTS
	'IN_GETDEFAULTPITCH var pitch'
	/* experimental */
/*
	IF pitch = 0 THEN DO
		'OP_GET SmpEdPitch var freq'
		DO x = 0 TO 36
			IF freq = freq.x THEN pitch = x
		END
	END
*/
	OP_SET SmpEdPitch freq.pitch
	SA_REFRESH
	ADDRESS VALUE host
	SETTEXT _bpm bpm_1
	SETTEXT _note note.pitch
	SETNUM _pitch pitch
	IF return = 1 THEN DO
		return = 0
		RETURN
	END
	SIGNAL calc
/* 50Hz .2 60Hz .167 */
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

quit:
	'hide unload'
	CALL CLOSEPORT("TIMEBOMB!")
EXIT
;;