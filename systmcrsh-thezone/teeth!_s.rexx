/*
  $VER: TEETH! 0.1 [SAMPL] BETA 3
  DATE: 08-DEC-2011
  COMPLAINTS: systmcrsh@gmail.com
  NET: http://www.dirtybomb.tk
  PERVERTS CALL: 917-***-****
*/

/* data dir */
dir = 'REXX:data/'

/* gui */
gui_file = dir'teeth!_s.gui'

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

IF OPENPORT("TEETH!.S") = 0 THEN DO
	SAY "Could not open a port. Varexx Error."
	EXIT
END

'load' gui_file 'TEETH!.S PS=OCTAMED'

host = RESULT
ADDRESS VALUE host

SHOW

SIGNAL on error

/* pal/ntsc */
PARSE VERSION CPU VAR cpu MPU VIDEO FREQ VAR video
init = 1

/* defaults */
defaults:
	beats = 4
	res = 8
	div = 1 / res
	start = GETCLIP(rn1)
	end = GETCLIP(rn2)
	IF start = '' THEN start = 0
	IF end = '' THEN end = div
	seq_1 = 12345678
	seq_2 = 12345678
	PARSE VAR seq_1 1 s0 2 s1 3 s2 4 s3 5 s4 6 s5 7 s6 8 s7
	PARSE VAR seq_2 1 s8 2 s9 3 s10 4 s11 5 s12 6 s13 7 s14 8 s15
	seq.0 = s0 -1; seq.1 = s1 -1; seq.2 = s2 -1; seq.3 = s3 -1; seq.4 = s4 -1; seq.5 = s5 -1; seq.6 = s6 -1; seq.7 = s7 -1; seq.8  = s8 -1; seq.9  = s9 -1; seq.10 = s10 -1; seq.11 = s11 -1; seq.12 = s12 -1; seq.13 = s13 -1; seq.14 = s14 -1; seq.15 = s15 -1
	sampl_1 = 01; sampl_2 = 02; sampl_3 = ''; sampl_4 = ''; sampl_5 = 03
	s.1 = 1; s.2 = 2; s.3 = 3; s.4 = 4; s.5 = 5; 
	r_rd = 0
	do_play = 0
	rp_div = 5
	repeat = 0
	line = 0
	file = 'teeth'
	last_1 = seq_1
	last_2 = seq_2
	last.0 = ''; last.1 = ''; last.2 = ''; last.3 = ''; last.4 = ''; last.5 = ''; last.6 = ''; last.7 = ''; last.8 = ''; last.9 = ''; last.10 = ''; last.11 = ''; last.12 = ''; last.13 = ''; last.14 = ''; last.15 = '';
	ext = GETCLIP(num)
	IF ext = '' THEN ext = 0
	/* seq divider (1/2 beats) */
	s_div = 4
	div_3 = 0
	sticky = 0
	quant = 0
	text_1 = ''
	text_2 = ''
	paste = 0
	copy = 0
;;

/* do calculations */
calc:
	ADDRESS OCTAMED_REXX
	OPTIONS RESULTS
	'IN_GETNUMBER VAR inst'
	'IN_GETTYPE VAR type'
	IF type ~= 'SAMPLE' THEN SIGNAL no_sample
	'SA_GETSAMPLELENGTH VAR length'
	ns = 0
	/* init */
	IF init = 1 THEN DO
		CALL rn
		init = 0
	END
	IF return = 1 THEN DO
		return = 0
		RETURN
	END
	SIGNAL main
;;

/* main */
main:
	ADDRESS VALUE host
	SETTEXT _ins inst
	DO FOREVER
		CALL WAITPKT("TEETH!.S")
		packet = GETPKT("TEETH!.S")

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
				start = GETCLIP(rn1)
				end = GETCLIP(rn2)
				IF start = '' THEN start = 0
				IF end = '' THEN end = div
				CALL rn
				SIGNAL main
			END
			IF class = "INACTIVEWINDOW" THEN DO
				ADDRESS VALUE host
				SETTEXT _out "www.dirtybomb.tk"
			END
			/* sequence */
	 		IF LEFT( class , 4 ) = '_SEQ' THEN DO
				PARSE VAR class null sequence
				sequence = STRIP(sequence)
				IF DATATYPE(sequence) ~= 'NUM' THEN sequence = '12345678'
				PARSE VAR sequence 1 seq_1 9 seq_2
				seq_1 = LEFT(seq_1, 8, 0)
				IF seq_2 = '' THEN seq_2 = seq_1
				seq_2 = LEFT(seq_2, 8, 0)
				IF seq_2 = seq_1 THEN SETTEXT _seq COMPRESS(seq_1)
				ELSE SETTEXT _seq COMPRESS(seq_1 seq_2)
				SETTEXT _out seq_1 seq_2
				PARSE VAR seq_1 1 s0 2 s1 3 s2 4 s3 5 s4 6 s5 7 s6 8 s7
				PARSE VAR seq_2 1 s8 2 s9 3 s10 4 s11 5 s12 6 s13 7 s14 8 s15
				seq.0 = s0 -1; seq.1 = s1 -1; seq.2 = s2 -1; seq.3 = s3 -1; seq.4 = s4 -1; seq.5 = s5 -1; seq.6 = s6 -1; seq.7 = s7 -1; seq.8  = s8 -1; seq.9  = s9 -1; seq.10 = s10 -1; seq.11 = s11 -1; seq.12 = s12 -1; seq.13 = s13 -1; seq.14 = s14 -1; seq.15 = s15 -1
	 		END
			/* repeat */
	 		IF LEFT( class , 7 ) = '_REPEAT' THEN DO
				PARSE VAR class null repeat
				repeat = UPPER(STRIP(repeat))
/*
				IF INDEX('0123456789ABCDEFabcdef0A0B0C0D0E0F0a0b0c0d0e0f1A1B1C1D1E1F1a1b1c1d1e1f', repeat) = 0 THEN repeat = 0
*/
				IF INDEX(C2X(XRANGE('01'x,'1F'x)), repeat) = 0 THEN repeat = 0
				SETTEXT _repeat UPPER(COMPRESS(repeat))
				repeat = X2D(repeat)
			END
			/* source */
			IF LEFT( class , 4 ) = '_SRC' THEN DO
				PARSE VAR class null src
				src = STRIP(src)
				IF DATATYPE(src) ~= 'NUM' THEN DO
					src = 'FFFF'
					SETTEXT _src src
					do_error = 1
					error = "INST ERROR!"
					s_error = 1
				END
				null = LENGTH(src) - 2
				PARSE VALUE src WITH +null sampl_5
				src = LEFT(src, null)
				PARSE VAR src 1 sampl_1 3 sampl_2 5 sampl_3 7 sampl_4
/* 0 error */
				IF sampl_1 = 0 && sampl_2 = 0 && sampl_3 = 0 && sampl_4 = 0 && sampl_5 = 0 THEN DO
					src = 'FFFF'
					SETTEXT _src src
					do_error = 1
					error = "INST ERROR!"
					s_error = 1
				END
/* end 0 error */
				IF sampl_2 = '' THEN sampl_2 = sampl_1
				IF sampl_3 = '' THEN sampl_3 = sampl_2
				IF sampl_4 = sampl_5 THEN sampl_4 = ''
/*			CALL src_check */
				return = 1
				CALL calc
				IF sampl_4 = '' THEN SETTEXT _out COMPRESS(sampl_1 sampl_2 sampl_3) sampl_5
				ELSE SETTEXT _out COMPRESS(sampl_1 sampl_2 sampl_3 '['sampl_4']') sampl_5
				IF do_error = 1 THEN SIGNAL error
				s_error = 0
			END
			/* beats */
			IF LEFT( class , 6 ) = '_BEATS' THEN DO
				PARSE VAR class null beats
				beats = STRIP(beats)
				IF DATATYPE(beats) ~= 'NUM' THEN beats = 4
				SETTEXT _beats COMPRESS(beats)
				IF ns = 1 THEN CALL calc
				CALL rn
			END
			/* play range */
			IF class = "_PRNG" THEN DO
				ADDRESS OCTAMED_REXX
				SA_PLAY RANGE
			END
			/* range next */
			IF class = "_RNEXT" THEN DO
				IF ns = 1 THEN CALL calc
				IF end < .9999 THEN DO
					start = start + div
					end = end + div
				END
				CALL rn
			END
			/* range previous */
			IF class = "_RPREV" THEN DO
				IF ns = 1 THEN CALL calc
				IF start > 0.0078125 THEN DO
					start = start - div
					end = end - div
				END
				CALL rn
			END
			/* range minus */
			IF class = "_RMINUS" THEN DO
				IF ns = 1 THEN CALL calc
				/* ugly fix */
				IF end - start > (div + 0.005) THEN end = end - div
				CALL rn
			END
			/* range plus */
			IF class = "_RPLUS" THEN DO
				IF ns = 1 THEN CALL calc
				IF end < .999 THEN end = end + div
				CALL rn
			END
			/* copy */
			IF class = "_COPY" THEN DO
				CALL copy
			END
			/* paste */
			IF class = "_PASTE" THEN DO
				CALL paste
			END
			/* load */
			IF class = "_LOAD" THEN DO
				SETTEXT _out "Load Inst."
				ADDRESS OCTAMED_REXX
				IN_LOADREQ
				ADDRESS VALUE host
			END
			/* play */
			IF class = "_PLAY" THEN DO
				IF ns = 1 THEN CALL calc
				ADDRESS OCTAMED_REXX
				SA_PLAY DISPLAY
				ADDRESS VALUE host
			END
			/* prev */
			IF class = "_PREV" THEN DO
				ADDRESS OCTAMED_REXX
				IN_SELECT PREV
				return = 1
				CALL calc
				ADDRESS VALUE host
				SETTEXT _ins inst
				CALL rn
				ADDRESS VALUE host
			END
			/* next */
			IF class = "_NEXT" THEN DO
				ADDRESS OCTAMED_REXX
				IN_SELECT NEXT
				return = 1
				CALL calc
				ADDRESS VALUE host
				SETTEXT _ins inst
				CALL rn
			END
			/* keyboard */
	 		IF LEFT( class , 8 ) = 'KEYBOARD' THEN DO
				PARSE VAR class null kb
				kb = UPPER(STRIP(kb))
				IF kb = 'F1' THEN DO
					CALL destroy
				END
				IF kb = 'F2' THEN DO
					CALL earache
				END
				IF kb = 'F3' THEN DO
					CALL timebomb
				END
				IF kb = 'F4' THEN DO
					ADDRESS VALUE host
					WINDOW FRONT
				END
				IF kb = 'HELP' THEN DO
					cmd = dir'help!'
					ADDRESS COMMAND cmd
					ADDRESS OCTAMED_REXX
					WI_OCTAMEDTOFRONT
					ADDRESS VALUE host
					WINDOW ACTIVATE
				END
				/* autoplay */
				IF kb = ' ' THEN DO
					CALL autoplay
				END
				/* play range */
				IF kb = 'TAB' THEN DO
					ADDRESS OCTAMED_REXX
					SA_PLAY RANGE
					ADDRESS VALUE host
				END
				/* res - */
				IF kb = '-' && kb = '_' THEN DO
					CALL r_minus
				END
				/* res + */
				IF kb = '+' && kb = '=' THEN DO
					CALL r_plus
				END
				/* 3/4 */
				IF kb = '\' THEN DO
					CALL r_slash
				END
				/* rp_div - */
				IF kb = ':' THEN DO
					CALL rp_minus
				END
				/* rp_div + */
				IF kb = '"' THEN DO
					CALL rp_plus
				END
				/* rep - */
				IF kb = ';' THEN DO
					IF repeat > 0 THEN repeat = (repeat - 1)
					SETTEXT _repeat D2X(repeat)
				END
				/* rep + */
				IF kb = "'" THEN DO
					IF repeat < 31 THEN repeat = (repeat + 1)
					SETTEXT _repeat D2X(repeat)
				END
				/* seq. div - */
				IF kb = '.' THEN DO
					IF s_div > 4 THEN s_div = (s_div / 2)
					CALL rn
				END
				/* seq. div + */
				IF kb = '/' THEN DO
					IF s_div < 64 THEN s_div = (s_div * 2)
					CALL rn
				END
				/* start - */
				IF kb = '[' THEN DO
					IF ns = 1 THEN CALL calc
					IF start > 0.0078125 THEN DO
						start = start - div
					END
					CALL rn
				END
				/* end + */
				IF kb = ']' THEN DO
					IF ns = 1 THEN CALL calc
					IF end < .999 THEN end = end + div
					CALL rn
				END
				/* start + */
				IF kb = '{' THEN DO
					IF ns = 1 THEN CALL calc
					IF (end - start) > div THEN DO
						start = start + div
					END
					CALL rn
				END
				/* end - */
				IF kb = '}' THEN DO
					IF ns = 1 THEN CALL calc
					IF (end - start) > div THEN DO
						end = end - div
					END
					CALL rn
				END
				IF INDEX('!@#$%', kb) > 0 THEN DO
					kb = TRANSLATE(kb, '12345', '!@#$%')
					ADDRESS OCTAMED_REXX
					OPTIONS RESULTS
					'IN_GETNUMBER VAR ins'
					s.kb = ins
					ADDRESS VALUE host
					SETTEXT _out 'OK.'
					SIGNAL main
				END
				IF INDEX('12345', kb) > 0 THEN DO
					ADDRESS OCTAMED_REXX
					IN_SELECT s.kb
					return = 1
					CALL calc
					ADDRESS VALUE host
					SETTEXT _ins inst
					CALL rn
					ADDRESS VALUE host
				END
				IF INDEX('^&*()', kb) > 0 THEN DO
					CALL p_sv
				END
				IF INDEX('67890', kb) > 0 THEN DO
					CALL p_ld
				END
				/* range next */
				IF kb = "RIGHT" THEN DO
					IF ns = 1 THEN CALL calc
					IF end < .9999 THEN DO
						start = start + div
						end = end + div
					END
					CALL rn
					ADDRESS VALUE host
				END
				/* range previous */
				IF kb = "LEFT" THEN DO
					IF ns = 1 THEN CALL calc
					IF start > 0.0078125 THEN DO
						start = start - div
						end = end - div
					END
					CALL rn
					ADDRESS VALUE host
				END
				/* range minus */
				IF kb = "DOWN" THEN DO
					IF ns = 1 THEN CALL calc
					/* ugly fix */
					IF end - start > (div + 0.005) THEN end = end - div
					CALL rn
				END
				/* range plus */
				IF kb = "UP" THEN DO
					IF ns = 1 THEN CALL calc
					IF end < .999 THEN end = end + div
					CALL rn
				END
				/* range all */
				IF kb = 'A' THEN DO
					IF ns = 1 THEN CALL calc
					ADDRESS OCTAMED_REXX
					start = 0; end = 1; CALL rn
					ADDRESS VALUE host
				END
				/* clear */
				IF kb = 'BS' THEN DO
					ADDRESS OCTAMED_REXX
					SA_CLEARRANGE
					ADDRESS VALUE host
					SETTEXT _out 'Cleared.'
				END
				/* copy option */
				IF kb = 'C' THEN DO
					CALL copy
				END
				/* erase */
				IF kb = 'DELETE' THEN DO
					IF ns = 1 THEN CALL calc
					ADDRESS OCTAMED_REXX
					SA_DELRANGE
					CALL rn
					ADDRESS VALUE host
					SETTEXT _out 'Erased.'
				END
				/* smpl editor */
				IF kb = 'E' THEN DO
					ADDRESS OCTAMED_REXX
					'WI_ISOPEN SAMPLEEDITOR VAR smp_ed'
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
/*						WINDOW FRONT */
						WINDOW ACTIVATE
						class = "ACTIVEWINDOW"
					END
				END
				/* help */
/*
				IF kb = 'HELP' THEN DO
					ADDRESS COMMAND
					con = "CON:0/10/640/256/"UPPER(file'_'ext)"/CLOSE/SCREENOCTAMED"
					CALL OPEN OUT,'RAM:temp',WRITE
					CALL WRITELN OUT,'more 'dir''help.txt
					CALL WRITELN OUT,'Endcli'
					CALL CLOSE OUT
					'Newcli' con 'RAM:temp'
					ADDRESS VALUE host
				END
*/
				/* invert */
				IF kb = 'I' THEN DO
					ADDRESS OCTAMED_REXX
					SA_INVERTRANGE
					ADDRESS VALUE host
					SETTEXT _out 'Inverted.'
				END
				/* sticky rep */
				IF kb = 'K' THEN DO
					CALL sticky
				END
				/* last seq. */
				IF kb = 'L' THEN DO
					SETTEXT _out last_1 last_2
				END
/*
				IF kb = 'L' THEN DO
					CALL last
				END
*/
				/* more */
				IF kb = 'M' THEN DO
					ADDRESS COMMAND
					con = "CON:0/10/640/256/"UPPER(file'_'ext)"/CLOSE/SCREENOCTAMED"
					CALL OPEN OUT,'RAM:temp',WRITE
					CALL WRITELN OUT,'more 'dir''file'_'ext'.txt'
					CALL WRITELN OUT,'Endcli'
					CALL CLOSE OUT
					'Newcli' con 'RAM:temp'
					ADDRESS VALUE host
				END
				/* new rnd */
				IF kb = 'N' THEN DO
					BUSY SET
					r_rd = 0
					CALL r_gen
					r_rd = 1
					BUSY
					SETTEXT _out "OK."
				END
				/* paste option */
				IF kb = 'P' THEN DO
					CALL p_opt
				END
				/* quantize */
				IF kb = 'Q' THEN DO
					CALL quant
				END
				/* reverse */
				IF kb = 'R' THEN DO
					ADDRESS OCTAMED_REXX
					SA_REVERSERANGE
					ADDRESS VALUE host
					SETTEXT _out 'Reversed.'
				END
				/* save inst */
				IF kb = 'S' THEN DO
					SETTEXT _out "Save Inst."
					ADDRESS OCTAMED_REXX
/*					IN_SELECT sampl_5 */
					IN_SAVEREQ WAVE
					ADDRESS VALUE host
				END
				/* save text */
				IF kb = 'T' THEN DO
					BUSY SET
					CALL write
					BUSY
					SETTEXT _out "Saved:" file'_'ext'.txt'
				END
				/* paste option */
				IF kb = 'V' THEN DO
					CALL paste
				END
				/* write rnd */
				IF kb = 'W' THEN DO
					BUSY SET
					CALL r_wt
					BUSY
					SETTEXT _out "OK."
				END
				/* copy option */
				IF kb = 'Y' THEN DO
					CALL c_opt
				END
			/* end kb */
			END
			/* do operation */
			IF class = "_GO" THEN DO
				IF s_error = 1 THEN DO
					src = 'FFFF'
					SETTEXT _src src
					do_error = 1
					error = "INST ERROR!"
					SIGNAL error
				END
/* host */
				ADDRESS VALUE host
				BUSY SET
				SETTEXT _out 'BUSY!'
/*
				SETLABEL Project0 '"' || 'TEETH!.S V0.1' || '"' screen
*/
				ADDRESS OCTAMED_REXX
				OPTIONS RESULTS
				PL_STOP
				SIGNAL go_sample
			END
		/* end packet */
		END
	/* end main */
	END
;;

	/* clean up */
	CALL SETCLIP(rn1)
	CALL SETCLIP(rn2)
	CALL DELETE('RAM:temp')

	/* end gui */
	'hide unload'
	CALL CLOSEPORT("TEETH!.S")
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
/* clean up */
	CALL SETCLIP(rn1)
	CALL SETCLIP(rn2)
	CALL DELETE('RAM:temp')
	ADDRESS VALUE host
	'hide unload'
	CALL CLOSEPORT("TEETH!.S")
EXIT
;;

syntax:
	SAY "Error" rc  "-- Line" SIGL
	SAY ERRORTEXT( rc )
/* clean up */
	CALL SETCLIP(rn1)
	CALL SETCLIP(rn2)
	CALL DELETE('RAM:temp')
	ADDRESS VALUE host
	'hide unload'
	CALL CLOSEPORT("TEETH!.S")
EXIT
;;

/* random 0-15 (16) */
rnd_16: PROCEDURE EXPOSE rnd r_rd r. dir
	IF r_rd = 0 THEN DO
		CALL r_rd
		r_rd = 1
	END
/* call time? testing? */
	CALL TIME("R")
	x = RAND(0, 64)
	y = RAND(0, 64)
	z = r.x
	IF x = 64 THEN y = 64
	PARSE VALUE z WITH +y rnd +1
	rnd = X2D(rnd)
	RETURN
;;

/* do sample */
go_sample:
	CALL TIME("R")
	ADDRESS OCTAMED_REXX
	'IN_GETNUMBER VAR sampl'
	file = 'teeth'
	DO x = 0 TO 15
		ptn.x = ''
	END
	y = -1
	x = 0
	z = -1
	CALL new_sample
	c = 0
	line = 0
	/* sampl_4 check */
	IF sampl_4 ~= '' THEN DO
		IN_SELECT sampl_4
		'IN_GETTYPE VAR type'
		IF type ~= 'SAMPLE' THEN DO
			error = "No Sample!"
			do_error = 1
			SIGNAL error
		END
	END
	DO UNTIL x = beats / (s_div / (8 / lpb))
		y = y + 1
		IF y >= 16 THEN y = 0
		a = 0
		src = rand(1, 99999)
		IF src // 2 = 0 THEN src = sampl_1
		ELSE src = sampl_2
		IF src = sampl_2 & sampl_3 ~= '' THEN DO
			src = rand(1, 99999)
			IF src // 2 = 0 THEN src = sampl_2
			ELSE src = sampl_3
		END
		IN_SELECT src
		'IN_GETTYPE VAR type'
		IF type ~= 'SAMPLE' THEN DO
			error = "No Sample!"
			do_error = 1
			SIGNAL error
		END
		IF seq.y < 0 THEN DO
			CALL rnd_16
			IF rnd > 7 THEN rnd = rnd - 8
			start = (rnd * div) / 1
		END
		IF seq.y >= 0 THEN start = (seq.y * div)
		ptn.y = ((start * res) + 1) / 1
		last.y = TRUNC(ptn.y)
		/* 16ths snap to 8ths */
		start = start * (res / 8)
		'SA_GETSAMPLELENGTH VAR length'
		end = start + div
		IF repeat = 29 THEN DO
			CALL rnd_16
			IF rnd > 7 THEN rnd = rnd - 8
			repeat = rnd
			z = 0
		END
		IF repeat = 30 THEN DO
			CALL rnd_16
			repeat = rnd
			z = 1
		END
		IF repeat = 31 THEN DO
			CALL rnd_16
			repeat = rnd
			CALL rnd_16
			repeat = repeat + rnd
			IF repeat > 28 THEN repeat = 28
			z = 2
		END
		IF repeat = 1 THEN CALL r1
		IF repeat = 2 THEN CALL r1
		IF repeat = 3 THEN CALL r2
		IF repeat = 4 THEN CALL r2
		IF repeat = 5 THEN CALL r3
		IF repeat = 6 THEN CALL r3
		IF repeat = 7 THEN CALL r4
		IF repeat = 8 THEN CALL r4
		IF repeat = 9 THEN CALL r5
		IF repeat = 10 THEN CALL r6
		IF repeat = 11 THEN CALL r7
		IF repeat = 12 THEN CALL r8
		IF repeat = 13 THEN CALL r5
		IF repeat = 14 THEN CALL r6
		IF repeat = 15 THEN CALL r7
		IF repeat = 16 THEN CALL r8
		IF repeat = 17 THEN CALL r16
		IF repeat = 18 THEN CALL r16
		IF repeat = 19 THEN CALL r32
		IF repeat = 20 THEN CALL r32
		IF repeat = 21 THEN CALL r8
		IF repeat = 22 THEN CALL r16
		IF repeat = 23 THEN CALL r32
		IF repeat = 24 THEN CALL r16
		IF repeat = 25 THEN CALL r32
		IF repeat = 26 THEN CALL r64
		IF repeat = 27 THEN CALL r8
		IF repeat = 28 THEN CALL r8
		IF a = 0 THEN CALL set_sample
		IF z = 0 THEN repeat = 29
		IF z = 1 THEN repeat = 30
		IF z = 2 THEN repeat = 31
	END
	IN_SELECT sampl_1
	'SA_GETSAMPLELENGTH VAR length'
	IN_SELECT sampl_5
	CALL ext
	/* name */
	IN_SETNAME file'_'ext'.wav'
	return = 1
	CALL calc
	SIGNAL done
;;

/* sample data */
set_sample:
	b = end - start
	x = x + b
	ln_1 = (b / div) / 1
	ln_2 = 1 / div
	IF ln_1 // 1 ~= 0 THEN DO
		DO UNTIL ln_1 // 1 = 0
			ln_1 = (ln_1 * 2) / 1
			ln_2 = (ln_2 * 2) / 1
		END
	END
	text.line = left(y + 1 , 5)  left(ptn.y , 5) left(ln_1'/'ln_2 , 5) left(src , 5) left(TRUNC((start * length) + 0.5 , 0) , 8) left(TRUNC((end * length) + 0.5 , 0) , 8) left(sampl_5 , 5) left(c , 8) left(TRUNC(c + (b * length)) , 9)
	line = line + 1
	IF x > beats / (s_div / (8 / lpb)) THEN DO
		file = 'panic'
		IN_SELECT sampl_5
		CALL ext
		IN_SETNAME file'_'ext'.wav'
		SIGNAL panic
	END
	SA_RANGE TRUNC((start * length) + 0.5 , 0) TRUNC((end * length) + 0.5 , 0)
	SA_COPYRANGE
	IN_SELECT sampl_5
/* c or c + 1? */
	SA_RANGE c TRUNC(c + (b * length))
	SA_PASTE OW
	'SA_GETRANGEEND VAR c'
	c = c + 1
	RETURN
;;

/* finish */
done:
/*	CALL CLOSE('out') */
/*
	text_1 = COMPRESS(ptn.0 ptn.1 ptn.2 ptn.3 ptn.4 ptn.5 ptn.6 ptn.7)
	text_2 = COMPRESS(ptn.8 ptn.9 ptn.10 ptn.11 ptn.12 ptn.13 ptn.14 ptn.15)
*/

	last_1 = COMPRESS(last.0 last.1 last.2 last.3 last.4 last.5 last.6 last.7)
	last_2 = COMPRESS(last.8 last.9 last.10 last.11 last.12 last.13 last.14 last.15)

	IF do_play = 1 THEN PL_PLAYBLOCK
/* return sampl */
	IN_SELECT sampl
	inst = sampl
	return = 1
	CALL calc
	CALL rf
	CALL rn
	ADDRESS VALUE host
	SETTEXT _ins inst
/*
	SETTEXT _out "Done." TIME(E) TRANSLATE(last_1 , R, 0) TRANSLATE(last_2 , R, 0)
*/
/*
	SETLABEL Project0 '"Done. ' || TIME(E) || 's ' || text_1 text_2 || '"' screen
*/
	SETTEXT _out "Done." TIME(E)
	BUSY
	SIGNAL main
;;

/* res + */
r_plus:
	IF div_3 = 1 THEN DO
		IF res = 96 THEN RETURN
		res = res * 2
		div = 1 / res
		CALL rn
		RETURN
	END
	IF res = 128 THEN RETURN
	res = res * 2
	div = 1 / res
	CALL rn
	RETURN
;;

/* res - */
r_minus:
	IF res = 3 THEN RETURN
	IF res = 8 THEN RETURN
	res = res / 2
	div = 1 / res
	CALL rm_1
	CALL rn
	RETURN
;;

rm_1: PROCEDURE EXPOSE start end div
	x = start / div
	y = end / div
	x = TRUNC(x + .000001, 5) / 1
	y = TRUNC(y + .000001, 5) / 1
	IF x // 1 ~= 0 THEN DO
		IF y // 1 = 0 THEN start = start - (div / 2)
		IF y // 1 ~= 0 THEN DO
			start = start - (div / 2)
			end = end - (div / 2)
		END
		RETURN
	END
	IF y // 1 ~= 0 THEN end = end + (div / 2)
	RETURN
;;

/* no sample */
no_sample:
	'IN_GETNUMBER VAR inst'
	ADDRESS VALUE host
	BUSY
	SETTEXT _out "No Sample!"
	ns = 1
	SIGNAL main
;;

r_rd: PROCEDURE EXPOSE r. dir
	y = OPEN('in', dir'teeth!_s.random', 'R')
	IF y = 0 THEN DO
		CALL r_gen
		RETURN
	END
	CALL TIME("R")
	DO x = 0 TO 63
		r.x = READLN('in')
	END
	CALL CLOSE('in')
	RETURN
;;

r_gen: PROCEDURE EXPOSE r.
	CALL TIME("R")
	DO a = 0 TO 63
		z = ''
		DO b = 0 TO 8
			x.b = RAND(0, 999999999)
			y = D2X(x.b)
			z = COMPRESS(z y)
		END
		z = LEFT(z,64,0)
		r.a = z
	END
	RETURN
;;

r_wt: PROCEDURE EXPOSE r. dir
	CALL OPEN('out', dir'teeth!_s.random', 'W')
	CALL TIME("R")
	DO x = 0 TO 63
		CALL WRITELN('out' , r.x)
	END
	CALL CLOSE('out')
	RETURN
;;

/* repeat 1-2 1/16 1/16 */
r1:
	CALL rnd_16
	IF rnd // rp_div = 0 THEN DO
		DO a = 0 TO 1
			IF repeat = 2 THEN DO
				CALL rnd_16
				IF quant = 1 THEN DO
					IF rnd > 7 THEN rnd = rnd - 8
					start = (rnd * div) / 1
				END
				IF quant = 0 THEN start = rnd * (div / 2)
			END
			IF sticky = 1 THEN DO
				IF y > 15 THEN y = 0
				IF seq.y >= 0 THEN start = (seq.y * div)
			END
			IF sticky = 0 THEN DO
				IF y = 0 THEN start = 0
			END
			end = start + (div / 2)
			IN_SELECT src
			'SA_GETSAMPLELENGTH VAR length'
			ptn.y = (TRUNC(start / div, 2) / 1) + 1
			last.y = TRUNC(ptn.y)
			ptn.y = '['ptn.y']'
			CALL set_sample
		END
		RETURN
	END
	a = 0
	RETURN
;;

/* repeat 3-4 3/8 3/8 */
r2:
	IF x <= ((beats / 4) - (div * 6)) THEN DO
		CALL rnd_16
		IF rnd // rp_div = 0 THEN DO
			DO a = 0 TO 1
				IF a = 1 THEN y = y + 1
	 			IF repeat = 4 THEN DO
					CALL rnd_16
					IF quant = 1 THEN DO
						IF rnd > 7 THEN rnd = rnd - 8
						start = (rnd * div) / 1
					END
					IF quant = 0 THEN start = rnd * (div / 2)
				END
				IF sticky = 1 THEN DO
					IF y > 15 THEN y = 0
					IF seq.y >= 0 THEN start = (seq.y * div)
				END
				IF sticky = 0 THEN DO
					IF y = 0 THEN start = 0
				END
				IF start > (1 - (div * 3)) THEN DO
					DO UNTIL start <= (1 - (div * 3))
/*
						start = start - div
*/
						start = start - (div / 2)
					END
				END
				end = start + (div * 3)
				IN_SELECT src
				'SA_GETSAMPLELENGTH VAR length'
				ptn.y = (TRUNC(start / div, 2) / 1) + 1
				last.y = TRUNC(ptn.y)
				ptn.y = '['ptn.y']'
				y = y + 1
				ptn.y = (TRUNC(start / div, 2) / 1) + 1
				last.y = TRUNC(ptn.y)
				ptn.y = '['ptn.y']'
				y = y + 1
				ptn.y = (TRUNC(start / div, 2) / 1) + 1
				last.y = TRUNC(ptn.y)
				ptn.y = '['ptn.y']'
				CALL set_sample
			END
		END
		RETURN
	END
	a = 0
	RETURN
;;

/* repeat 5-6 3/8 1/8 */
r3:
	IF x <= ((beats / 4) - (div * 4)) THEN DO
		CALL rnd_16
		IF rnd // rp_div = 0 THEN DO
			DO a = 0 TO 1
				IF a = 1 THEN y = y + 1
				IF repeat = 6 THEN DO
					CALL rnd_16
					IF quant = 1 THEN DO
						IF rnd > 7 THEN rnd = rnd - 8
						start = (rnd * div) / 1
					END
					IF quant = 0 THEN start = rnd * (div / 2)
				END
				IF sticky = 1 THEN DO
					IF y > 15 THEN y = 0
					IF seq.y >= 0 THEN start = (seq.y * div)
				END
				IF sticky = 0 THEN DO
					IF y = 0 THEN start = 0
				END
				IF a = 0 THEN DO
					IF start > (1 - (div * 3)) THEN DO
						DO UNTIL start <= (1 - (div * 3))
/*
							start = start - div
*/
							start = start - (div / 2)
						END
					END
				END
				IF a = 1 THEN DO
					IF start > (1 - div) THEN DO
						DO UNTIL start <= (1 - div)
/*
							start = start - div
*/
							start = start - (div / 2)
						END
					END
				END
				IF a = 0 THEN end = start + (div * 3)
				IF a = 1 THEN end = start + div
				IN_SELECT src
				'SA_GETSAMPLELENGTH VAR length'
				IF a = 0 THEN DO
					ptn.y = (TRUNC(start / div, 2) / 1) + 1
					last.y = TRUNC(ptn.y)
					ptn.y = '['ptn.y']'
					y = y + 1
					ptn.y = (TRUNC(start / div, 2) / 1) + 1
					last.y = TRUNC(ptn.y)
					ptn.y = '['ptn.y']'
					y = y + 1
					ptn.y = (TRUNC(start / div, 2) / 1) + 1
					last.y = TRUNC(ptn.y)
					ptn.y = '['ptn.y']'
				END
				IF a = 1 THEN DO
					ptn.y = (TRUNC(start / div, 2) / 1) + 1
					last.y = TRUNC(ptn.y)
					ptn.y = '['ptn.y']'
				END
				CALL set_sample
			END
		END
		RETURN
	END
	a = 0
	RETURN
;;

/* repeat 7-8 1/8 3/8 */
r4:
	IF x <= ((beats / 4) - (div * 4)) THEN DO
		CALL rnd_16
		IF rnd // rp_div = 0 THEN DO
			DO a = 0 TO 1
				IF a = 1 THEN y = y + 1
				IF repeat = 8 THEN DO
					CALL rnd_16
					IF quant = 1 THEN DO
						IF rnd > 7 THEN rnd = rnd - 8
						start = (rnd * div) / 1
					END
					IF quant = 0 THEN start = rnd * (div / 2)
				END
				IF sticky = 1 THEN DO
					IF y > 15 THEN y = 0
					IF seq.y >= 0 THEN start = (seq.y * div)
				END
				IF sticky = 0 THEN DO
					IF y = 0 THEN start = 0
				END
				IF a = 1 THEN DO
					IF start > (1 - (div * 3)) THEN DO
						DO UNTIL start <= (1 - (div * 3))
/*						start = start - div */
							start = start - (div / 2)
						END
					END
				END
				IF a = 0 THEN DO
					IF start > (1 - div) THEN DO
						DO UNTIL start <= (1 - div)
/*						start = start - div */
							start = start - (div / 2)
						END
					END
				END
				IF a = 0 THEN end = start + div
				IF a = 1 THEN end = start + (div * 3)
				IN_SELECT src
				'SA_GETSAMPLELENGTH VAR length'
				IF a = 1 THEN DO
					ptn.y = (TRUNC(start / div, 2) / 1) + 1
					last.y = TRUNC(ptn.y)
					ptn.y = '['ptn.y']'
					y = y + 1
					ptn.y = (TRUNC(start / div, 2) / 1) + 1
					last.y = TRUNC(ptn.y)
					ptn.y = '['ptn.y']'
					y = y + 1
					ptn.y = (TRUNC(start / div, 2) / 1) + 1
					last.y = TRUNC(ptn.y)
					ptn.y = '['ptn.y']'
				END
				IF a = 0 THEN DO
					ptn.y = (TRUNC(start / div, 2) / 1) + 1
					last.y = TRUNC(ptn.y)
					ptn.y = '['ptn.y']'
				END
				CALL set_sample
			END
		END
		RETURN
	END
	a = 0
	RETURN
;;

/* repeat 9 3/16 1/16 */
r5:
	IF x <= ((beats / 4) - (div * 2)) THEN DO
		CALL rnd_16
		IF rnd // rp_div = 0 THEN DO
			CALL rnd_16
			IF quant = 1 THEN DO
				IF rnd > 7 THEN rnd = rnd - 8
				start = (rnd * div) / 1
			END
			IF quant = 0 THEN start = rnd * (div / 2)
			DO a = 0 TO 1
				IF sticky = 1 THEN DO
					IF y > 15 THEN y = 0
					IF seq.y >= 0 THEN start = (seq.y * div)
				END
				IF sticky = 0 THEN DO
					IF y = 0 THEN start = 0
				END
				IF a = 0 THEN DO
					IF start > (1 - ((div / 2) * 3)) THEN DO
						DO UNTIL start <= (1 - ((div / 2) * 3))
/*
							start = start - div
*/
							start = start - (div / 4)
						END
					END
				END
				IF a = 1 THEN DO
					IF start > (1 - (div / 2)) THEN DO
						DO UNTIL start <= (1 - (div / 2))
/*
							start = start - div
*/
							start = start - (div / 4)
						END
					END
				END
				IF a = 0 THEN end = start + ((div / 2) * 3)
				IF a = 1 THEN end = start + div / 2
				IN_SELECT src
				'SA_GETSAMPLELENGTH VAR length'
				IF a = 0 THEN DO
					y = y + 1
					ptn.y = (TRUNC(start / div, 2) / 1) + 1
					last.y = TRUNC(ptn.y)
					ptn.y = '['ptn.y']'
				END
				IF a = 1 THEN DO
					ptn.y = (TRUNC(start / div, 2) / 1) + 1
					last.y = TRUNC(ptn.y)
					ptn.y = '['ptn.y']'
				END
				CALL set_sample
			END
		END
		RETURN
	END
	a = 0
	RETURN
;;

/* repeat A 1/16 3/16 */
r6:
	IF x <= ((beats / 4) - (div * 2)) THEN DO
		CALL rnd_16
		IF rnd // rp_div = 0 THEN DO
			CALL rnd_16
			IF quant = 1 THEN DO
				IF rnd > 7 THEN rnd = rnd - 8
				start = (rnd * div) / 1
			END
			IF quant = 0 THEN start = rnd * (div / 2)
			DO a = 0 TO 1
				IF sticky = 1 THEN DO
					IF y > 15 THEN y = 0
					IF seq.y >= 0 THEN start = (seq.y * div)
				END
				IF sticky = 0 THEN DO
					IF y = 0 THEN start = 0
				END
				IF a = 0 THEN DO
					IF start > (1 - (div / 2)) THEN DO
						DO UNTIL start <= (1 - (div / 2))
/*
							start = start - div
*/
							start = start - (div / 4)
						END
					END
				END
				IF a = 1 THEN DO
					IF start > (1 - ((div / 2) * 3)) THEN DO
						DO UNTIL start <= (1 - ((div / 2) * 3))
/*
							start = start - div
*/
							start = start - (div / 4)
						END
					END
				END
				IF a = 0 THEN end = start + div / 2
				IF a = 1 THEN end = start + ((div / 2) * 3)
				IN_SELECT src
				'SA_GETSAMPLELENGTH VAR length'
				IF a = 0 THEN DO
					y = y + 1
					ptn.y = (TRUNC(start / div, 2) / 1) + 1
					last.y = TRUNC(ptn.y)
					ptn.y = '['ptn.y']'
				END
				IF a = 1 THEN DO
					ptn.y = (TRUNC(start / div, 2) / 1) + 1
					last.y = TRUNC(ptn.y)
					ptn.y = '['ptn.y']'
				END
				CALL set_sample
			END
		END
		RETURN
	END
	a = 0
	RETURN
;;

/* repeat B 3/16 3/16 */
r7:
	IF x <= ((beats / 4) - ((div / 2) * 6)) THEN DO
		CALL rnd_16
		IF rnd // rp_div = 0 THEN DO
			DO a = 0 TO 1
	 			IF repeat = 4 THEN DO
					CALL rnd_16
					IF quant = 1 THEN DO
						IF rnd > 7 THEN rnd = rnd - 8
						start = (rnd * div) / 1
					END
					IF quant = 0 THEN start = rnd * (div / 2)
				END
				IF sticky = 1 THEN DO
					IF y > 15 THEN y = 0
					IF seq.y >= 0 THEN start = (seq.y * div)
				END
				IF sticky = 0 THEN DO
					IF y = 0 THEN start = 0
				END
				IF start > (1 - ((div / 2) * 3)) THEN DO
					DO UNTIL start <= (1 - ((div / 2) * 3))
/*
							start = start - div
*/
						start = start - (div / 2)
					END
				END
				end = start + ((div / 2) * 3)
				IN_SELECT src
				'SA_GETSAMPLELENGTH VAR length'
				y = y + 1
				ptn.y = (TRUNC(start / div, 2) / 1) + 1
				last.y = TRUNC(ptn.y)
				ptn.y = '['ptn.y']'
				CALL set_sample
			END
		END
		RETURN
	END
	a = 0
	RETURN
;;

/* static rep 1/8 */
r8:
	IF x > ((beats / 4) - (div * 2)) THEN RETURN
	IF repeat = 28 THEN DO
		IF x > ((beats / 4) - (div * 4)) THEN RETURN
	END
	CALL rnd_16
	IF rnd // rp_div = 0 THEN DO
		IF repeat = 27 THEN DO
			IF x > ((beats / 4) - (div * 4)) THEN RETURN
			CALL r32
			CALL rnd_16
			IF rnd > 7 THEN rnd = rnd - 8
			start = (rnd * div) / 1
			IF sampl_4 ~= '' THEN src = sampl_4
			DO a = 0 TO 1
				IF sticky = 1 THEN DO
					IF y > 15 THEN y = 0
					IF seq.y >= 0 THEN start = (seq.y * div)
				END
				IF sticky = 0 THEN DO
					IF y = 0 THEN start = 0
				END
				end = start + div
				IN_SELECT src
				'SA_GETSAMPLELENGTH VAR length'
				IF a = 1 THEN DO
					y = y + 1
					ptn.y = (TRUNC(start / div, 2) / 1) + 1
					last.y = TRUNC(ptn.y)
					ptn.y = '['ptn.y']'
				END
				CALL set_sample
			END
		END
		IF repeat = 28 THEN DO
			CALL rnd_16
			IF rnd > 7 THEN rnd = rnd - 8
			start = (rnd * div) / 1
			IF sticky = 1 THEN DO
				IF y > 15 THEN y = 0
				IF seq.y >= 0 THEN start = (seq.y * div)
			END
			IF sticky = 0 THEN DO
				IF y = 0 THEN start = 0
			END
			IF a = 1 THEN a = 0
			y = y + 1
			ptn.y = (TRUNC(start / div, 2) / 1) + 1
			last.y = TRUNC(ptn.y)
			ptn.y = '['ptn.y']'
			CALL r16
			IF a = 0 then a = 1
		END
		RETURN
	END
	a = 0
	RETURN
;;

/* static rep 1/16 */
r16:
	CALL rnd_16
	IF repeat = 28 THEN rnd = rp_div
	IF repeat = 27 THEN rnd = rp_div
	IF rnd // rp_div = 0 THEN DO
/*
		CALL rnd_16
 		start = rnd * (div / 2)
*/
		IF sampl_4 ~= '' THEN src = sampl_4
		DO a = 0 TO 1
			IF sticky = 1 THEN DO
				IF y > 15 THEN y = 0
				IF seq.y >= 0 THEN start = (seq.y * div)
			END
			IF sticky = 0 THEN DO
				IF y = 0 THEN start = 0
			END
			end = start + (div / 2)
			IN_SELECT src
			'SA_GETSAMPLELENGTH VAR length'
			CALL set_sample
		END
/* experimental */
		IF repeat = 12 THEN DO
			IF x >= ((4 * beats) * res) THEN RETURN
			repeat = 8
			a = 0
			y = y + 1
			CALL r4
			IF a = 0 THEN y = y - 1
			IF a = 0 THEN a = 1
			repeat = 12
		END
/* experimental */
		IF repeat = 14 THEN DO
			IF x >= ((4 * beats) * res) THEN RETURN
			repeat = 2
			a = 0
			y = y + 1
			CALL r1
			IF a = 0 THEN y = y - 1
			IF a = 0 THEN a = 1
			repeat = 14
		END
		IF a = 0 THEN a = 1
		IF repeat = 28 THEN DO
			IF a = 1 THEN a = 0
			y = y + 1
			ptn.y = (TRUNC(start / div, 2) / 1) + 1
			last.y = TRUNC(ptn.y)
			ptn.y = '['ptn.y']'
			CALL r32
			IF a = 0 THEN a = 1
		END
		IF repeat = 27 THEN DO
			IF a = 1 THEN a = 0
			y = y + 1
			ptn.y = (TRUNC(start / div, 2) / 1) + 1
			last.y = TRUNC(ptn.y)
			ptn.y = '['ptn.y']'
			RETURN
			IF a = 0 THEN a = 1
		END
		RETURN
	END
	a = 0
	RETURN
;;

/* static rep 1/32 */
r32:
	CALL rnd_16
	IF repeat = 27 THEN rnd = rp_div
	IF rnd // rp_div = 0 THEN DO
/*
		CALL rnd_16
 		start = rnd * (div / 2)
*/
		IF sampl_4 ~= '' THEN src = sampl_4
		DO a = 0 TO 3
			IF sticky = 1 THEN DO
				IF y > 15 THEN y = 0
				IF seq.y >= 0 THEN start = (seq.y * div)
			END
			IF sticky = 0 THEN DO
				IF y = 0 THEN start = 0
			END
			end = start + (div / 4)
			IN_SELECT src
			'SA_GETSAMPLELENGTH VAR length'
			CALL set_sample
		END
/* experimental */
		IF repeat = 10 THEN DO
			IF x >= ((4 * beats) * res) THEN RETURN
/*
			CALL rnd_16
			start = rnd * (div / 2)
*/
			y = y + 1
			CALL r16
			IF a = 0 THEN y = y - 1
		END
/* experimental */
		IF repeat = 26 THEN DO
			IF x >= ((4 * beats) * res) THEN RETURN
			repeat = 2
			y = y + 1
			CALL r16
			IF a = 0 THEN y = y - 1
			repeat = 26
		END
		IF a = 0 THEN a = 1
		IF repeat = 27 THEN DO
			IF a = 1 THEN a = 0
			y = y + 1
			ptn.y = (TRUNC(start / div, 2) / 1) + 1
			last.y = TRUNC(ptn.y)
			ptn.y = '['ptn.y']'
			CALL r16
			IF a = 0 THEN a = 1
		END
		RETURN
	END
	a = 0
	RETURN
;;

/* static rep 1/64 */
r64:
	CALL rnd_16
	IF rnd // rp_div = 0 THEN DO
		IF sampl_4 ~= '' THEN src = sampl_4
		DO a = 0 TO 7
			IF sticky = 1 THEN DO
				IF y > 15 THEN y = 0
				IF seq.y >= 0 THEN start = (seq.y * div)
			END
			IF sticky = 0 THEN DO
				IF y = 0 THEN start = 0
			END
			end = start + (div / 8)
			IN_SELECT src
			'SA_GETSAMPLELENGTH VAR length'
			CALL set_sample
		END
		RETURN
	END
	a = 0
	RETURN
;;

/* static rep 1/128 */
r128:
	CALL rnd_16
	IF rnd // rp_div = 0 THEN DO
		IF sampl_4 ~= '' THEN src = sampl_4
		DO a = 0 TO 15
			IF sticky = 1 THEN DO
				IF y > 15 THEN y = 0
				IF seq.y >= 0 THEN start = (seq.y * div)
			END
			IF sticky = 0 THEN DO
				IF y = 0 THEN start = 0
			END
			end = start + (div / 16)
			IN_SELECT src
			'SA_GETSAMPLELENGTH VAR length'
			CALL set_sample
		END
		RETURN
	END
	a = 0
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

earache: PROCEDURE
	IF SHOW(p, "EARACHE!") = 1 THEN DO
		ADDRESS "EARACHE!" '_SHOW'
	END
	IF SHOW(p, "EARACHE!") = 0 THEN DO
		ADDRESS COMMAND "RUN >NIL: rx rexx:earache!.rexx"
	END
	RETURN
;;

destroy: PROCEDURE
	IF SHOW(p, "DESTR6Y!") = 1 THEN DO
		ADDRESS "DESTR6Y!" '_SHOW'
/*
		window BACK
*/
	END
	IF SHOW(p, "DESTR6Y!") = 0 THEN DO
		ADDRESS COMMAND "RUN >NIL: rx rexx:destr6y!.rexx"
/*
		window BACK
*/
	END
	RETURN
;;

panic:
	panic = 1
/*
	CALL write
*/
	IF do_play = 1 THEN PL_PLAYBLOCK
	ADDRESS VALUE host
	SETTEXT _out "PANIC!" repeat
	BUSY
		IF z = 0 THEN repeat = 29
		IF z = 1 THEN repeat = 30
		IF z = 2 THEN repeat = 31
	start = 0; end = div
  panic = 0
	SIGNAL calc
;;

write: PROCEDURE EXPOSE dir line panic file repeat ext text.
	/* date/time */
	date = DATE(U)
	time = TIME()
/*
	PARSE VALUE date WITH mm '/' dd '/' yy
	PARSE VALUE time WITH hr ':' min ':' sec
	date = COMPRESS(mm dd yy)
	time = COMPRESS(hr min sec)
*/
/*
	CALL DELETE(dir'panic.txt')
*/
	text = left("STEP" , 5) left("SEQ" , 5) left("LEN" , 5) left("SRC" , 5) left("START" , 8) left("END" , 8) left("DEST" , 5) left("START" , 8) left("END" , 9)
	CALL OPEN('out', dir''file'_'ext'.txt', 'W')
	CALL WRITELN('out' , text)
	text = left('' , 66)
	CALL WRITELN('out' , text)
	DO x = 0 TO (line - 1)
		CALL WRITELN('out' , text.x)
	END
	IF panic = 1 THEN DO
		CALL WRITELN('out' , left('' , 66))
		CALL WRITELN('out' , 'panic:' repeat)
		panic = 0
	END
	CALL WRITELN('out' , left('' , 66))
	CALL WRITELN('out' , date time)
	CALL CLOSE('out')
	ADDRESS VALUE host
	RETURN
;;

/* refresh display */
rn:
	CALL SETCLIP(rn1, start)
	CALL SETCLIP(rn2, end)
	ADDRESS OCTAMED_REXX
	SA_RANGE TRUNC((start * length) + 0.5 , 0) TRUNC((end * length) + 0.5 , 0)
  b_start = (start * beats) + 1
  b_end = (end * beats) + 1
	/* fix disp. decimals */
/*
	b_start = b_start / 1
	b_end = b_end / 1
*/
	b_start = TRUNC((b_start + .000001), 5) / 1
	b_end = TRUNC((b_end + .000001), 5) / 1
	IF b_end >= (beats + 1) THEN b_end = 'E'
	'IN_GETNUMBER VAR inst'
	ADDRESS VALUE host
	SETTEXT _ins inst
/*
	SETTEXT _out (s_div/4)':1 'end/div - start/div'/'res ''b_start b_end
*/
	SETTEXT _out (s_div / 4)':1 'COMPRESS((((end / div) - (start / div)) + 0.5) % 1 '/' res) ''b_start b_end
	RETURN
;;

ext:
	/* date/time ext. */
/*
	date = DATE(U)
	time = TIME()
	PARSE VALUE date WITH mm '/' dd '/' yy
	PARSE VALUE time WITH hr ':' min ':' sec
	date = COMPRESS(mm dd yy)
	time = COMPRESS(hr min sec)
	ext = date''time
*/
	ext = ext + 1
	CALL SETCLIP(num, ext)
	RETURN
;;
/*
last:
	PARSE VAR class null sequence
	sequence = COMPRESS(last_1 last_2)
	IF sequence = '' THEN sequence = '12345678'
	PARSE VAR sequence 1 seq_1 9 seq_2
	seq_1 = LEFT(seq_1, 8, 0)
	IF seq_2 = '' THEN seq_2 = seq_1
	seq_2 = LEFT(seq_2, 8, 0)
	IF seq_2 = seq_1 THEN SETTEXT _seq COMPRESS(seq_1)
	ELSE SETTEXT _seq COMPRESS(seq_1 seq_2)
	SETTEXT _out seq_1 seq_2
	PARSE VAR seq_1 1 s0 2 s1 3 s2 4 s3 5 s4 6 s5 7 s6 8 s7
	PARSE VAR seq_2 1 s8 2 s9 3 s10 4 s11 5 s12 6 s13 7 s14 8 s15
	seq.0 = s0 -1; seq.1 = s1 -1; seq.2 = s2 -1; seq.3 = s3 -1; seq.4 = s4 -1; seq.5 = s5 -1; seq.6 = s6 -1; seq.7 = s7 -1; seq.8  = s8 -1; seq.9  = s9 -1; seq.10 = s10 -1; seq.11 = s11 -1; seq.12 = s12 -1; seq.13 = s13 -1; seq.14 = s14 -1; seq.15 = s15 -1
	RETURN
;;
*/

/* fix res */
rf:
	null = res
	IF ((end - start) / 1) < (div / 1) THEN DO
		x = 0
		DO UNTIL res = null
			div = ((div / (div / (end - start))) / 1)
			res = 1 / div
			CALL r_minus
			x = x + 1
			IF x > 8 THEN SIGNAL panic
		END
		res = null * (div / (end - start))
	END
	RETURN
;;

new_sample:
	ADDRESS OCTAMED_REXX
	OPTIONS RESULTS
	'SG_GETTEMPOMODE VAR mode'
	'SG_GETTEMPOLPB VAR lpb'
	'SG_GETTEMPOTPL VAR tpl'
	'SG_GETTEMPO VAR tempo'
	IN_SELECT sampl_1
	'IN_GETTYPE VAR type'
	IF type ~= 'SAMPLE' THEN DO
		error = "No Sample!"
		do_error = 1
		SIGNAL error
	END
	'OP_GET SmpEdPitch VAR freq'
	IF mode = 'BPM' THEN tempo = ((tempo * .75 * lpb) / tpl)
	IF mode = 'SPD' THEN tempo = ((tempo / tpl) / .088)
	length = ((beats * freq) * 60) / tempo
	length = length / (s_div / 4)
	IN_SELECT sampl_5
	IN_FLUSH
	SA_CHANGESIZE TRUNC(length + 0.5 , 0) CLEAR
	'OP_SET SmpEdPitch VAR freq'
	RETURN
;;

r_slash:
	IF div_3 = 0 THEN DO
		res = (res * .75) / 1
		beats = (beats * .75) / 1
		div = 1 / res
		start = 0; end = div
		div_3 = 1
		SETTEXT _beats beats
		IF ns = 1 THEN CALL calc
		CALL rn
		RETURN
	END
	IF div_3 = 1 THEN DO
		res = res / .75
		beats = beats / .75
		IF res < 8 THEN res = 8
		div = 1 / res
		start = 0; end = div
		div_3 = 0
		SETTEXT _beats beats
		IF ns = 1 THEN CALL calc
		CALL rn
	END
	RETURN
;;

/* load preset */
p_ld:
	CALL p_rd
	kb = INDEX('67890', kb)
	preset = p.kb
	PARSE VAR preset seq_1 seq_2 repeat src beats
	seq_1 = STRIP(seq_1)
	seq_2 = STRIP(seq_2)
	repeat = STRIP(repeat)
	src = STRIP(src)
	beats = STRIP(beats)
	PARSE VAR seq_1 1 s0 2 s1 3 s2 4 s3 5 s4 6 s5 7 s6 8 s7
	PARSE VAR seq_2 1 s8 2 s9 3 s10 4 s11 5 s12 6 s13 7 s14 8 s15
	seq.0 = s0 -1; seq.1 = s1 -1; seq.2 = s2 -1; seq.3 = s3 -1; seq.4 = s4 -1; seq.5 = s5 -1; seq.6 = s6 -1; seq.7 = s7 -1; seq.8  = s8 -1; seq.9  = s9 -1; seq.10 = s10 -1; seq.11 = s11 -1; seq.12 = s12 -1; seq.13 = s13 -1; seq.14 = s14 -1; seq.15 = s15 -1
	null = LENGTH(src) - 2
	PARSE VALUE src WITH +null sampl_5
	src = LEFT(src, null)
	PARSE VAR src 1 sampl_1 3 sampl_2 5 sampl_3 7 sampl_4
	IF sampl_2 = '' THEN sampl_2 = sampl_1
	IF sampl_3 = '' THEN sampl_3 = sampl_2
	IF sampl_4 = sampl_5 THEN sampl_4 = ''
/* src check */
	ADDRESS VALUE host
	SETTEXT _seq COMPRESS(seq_1 seq_2)
	SETTEXT _repeat D2X(repeat)
	SETTEXT _beats COMPRESS(beats)
	SETTEXT _src COMPRESS(sampl_1 sampl_2 sampl_3 sampl_4 sampl_5)
	RETURN
;;

/* read preset */
p_rd:
	y = OPEN('in', dir'teeth!_s.preset', 'R')
	IF y = 0 THEN DO
		BUSY SET
		y = OPEN('out', dir'teeth!_s.preset', 'W')
		DO x = 1 TO 10
			CALL WRITELN('out' , '12345678 12345678 0 010203 4')
		END
		CALL CLOSE('out')
		BUSY
		y = OPEN('in', dir'teeth!_s.preset', 'R')
	END
	DO x = 1 TO 10
		p.x = READLN('in')
	END
	CALL CLOSE('in')
	RETURN
;;

/* save preset */
p_sv:
	preset = seq_1 seq_2 repeat COMPRESS(sampl_1 sampl_2 sampl_3 sampl_4 sampl_5) beats
	kb = TRANSLATE(kb, '12345', '^&*()')
	p.kb = preset
	BUSY SET
	y = OPEN('out', dir'teeth!_s.preset', 'W')
	CALL SEEK('out', 0, 'B')
	DO x = 1 TO 5
		z = p.x
		CALL WRITELN('out' , z)
	END
	CALL CLOSE('out')
	BUSY
	SETTEXT _out "OK."
	SIGNAL main
;;

sticky:
	IF sticky = 0 THEN DO
		sticky = 1
		SETTEXT _out "STICKY ON!"
		RETURN
	END
	IF sticky = 1 THEN DO
		sticky = 0
		SETTEXT _out "STICKY OFF!"
		RETURN
	END
	RETURN
;;

quant:
	IF quant = 0 THEN DO
		quant = 1
		SETTEXT _out "QUANTIZE ON!"
		RETURN
	END
	IF quant = 1 THEN DO
		quant = 0
		SETTEXT _out "QUANTIZE OFF!"
		RETURN
	END
	RETURN
;;

p_opt:
	ADDRESS VALUE host
	IF paste = 0 THEN DO
		paste = 1
		SETTEXT _out 'PA = RN START'
		RETURN
	END
	IF paste = 1 THEN DO
		paste = 2
		SETTEXT _out 'PA = RN END'
		RETURN
	END
	IF paste = 2 THEN DO
		paste = 3
		SETTEXT _out 'PA = SMPL START'
		RETURN
	END
	IF paste = 3 THEN DO
		paste = 4
		SETTEXT _out 'PA = SMPL END'
		RETURN
	END
	IF paste = 4 THEN DO
		paste = 5
		SETTEXT _out 'PA = MIX 50/50'
		RETURN
	END
	IF paste = 5 THEN DO
		paste = 6
		SETTEXT _out 'PA = NEW SMPL'
		RETURN
	END
	IF paste = 6 THEN DO
		paste = 0
		SETTEXT _out 'PA = PASTE INTO'
		RETURN
	END
	RETURN
;;

c_opt:
	ADDRESS VALUE host
	IF copy = 0 THEN DO
		copy = 1
		SETTEXT _out 'CP = CUT'
		RETURN
	END
	IF copy = 1 THEN DO
		copy = 2
		SETTEXT _out 'CP = CHOP'
		RETURN
	END
	IF copy = 2 THEN DO
		copy = 0
		SETTEXT _out 'CP = COPY'
		RETURN
	END
;;

/* rp_div + */
rp_plus:
	IF rp_div = 1 THEN DO
		SETTEXT _out "REP 100"
		RETURN
	END
	IF rp_div = 8 THEN DO
		rp_div = 7
		SETTEXT _out "REP 13.3"
		RETURN
	END
	IF rp_div = 7 THEN DO
		rp_div = 5
		SETTEXT _out "REP 20"
		RETURN
	END
	IF rp_div = 5 THEN DO
		rp_div = 3
		SETTEXT _out "REP 33.3"
		RETURN
	END
	IF rp_div = 3 THEN DO
		rp_div = 2
		SETTEXT _out "REP 53.3"
		RETURN
	END
	IF rp_div = 2 THEN DO
		rp_div = 1
		SETTEXT _out "REP 100"
		RETURN
	END
	RETURN
;;

/* rp_div - */
rp_minus:
	IF rp_div = 8 THEN DO
		SETTEXT _out "REP 6.6"
		RETURN
	END
	IF rp_div = 1 THEN DO
		rp_div = 2
		SETTEXT _out "REP 53.3"
		RETURN
	END
	IF rp_div = 2 THEN DO
		rp_div = 3
		SETTEXT _out "REP 33.3"
		RETURN
	END
	IF rp_div = 3 THEN DO
		rp_div = 5
		SETTEXT _out "REP 20"
		RETURN
	END
	IF rp_div = 5 THEN DO
		rp_div = 7
		SETTEXT _out "REP 13.3"
		RETURN
	END
	IF rp_div = 7 THEN DO
		rp_div = 8
		SETTEXT _out "REP 6.6"
		RETURN
	END
	RETURN
;;

/* autoplay */
autoplay:
	IF do_play = 1 THEN DO
		do_play = 0
		SETTEXT _out "AUTOPLAY OFF!"
		RETURN
	END
	IF do_play = 0 THEN DO
		do_play = 1
		SETTEXT _out "AUTOPLAY ON!"
		RETURN
	END
	RETURN
;;

/* paste */
paste:
	ADDRESS OCTAMED_REXX
	IF type = 'SAMPLE' THEN DO
		/* paste into */
		IF paste = 0 THEN SA_PASTE OW
		/* paste at rn start */
		IF paste = 1 THEN DO
			SA_RANGE TRUNC((start * length) + 0.5 , 0) TRUNC((start * length) + 0.5 , 0)
			SA_PASTE
		END
		/* paste at rn end */
		IF paste = 2 THEN DO
		SA_RANGE TRUNC((end * length) + 0.5 , 0) TRUNC((end * length) + 0.5 , 0)
		SA_PASTE
		END
		/* paste at smpl start */
		IF paste = 3 THEN DO
		SA_RANGE 0 0
		SA_PASTE
		END
		/* paste at smpl end */
		IF paste = 4 THEN DO
		SA_RANGE length length
		SA_PASTE
		END
		/* paste mix */
		IF paste = 5 THEN SA_MIX 50 50
		/* paste new */
		IF paste = 6 THEN DO
			SA_BUFFERTOSAMPLE
			CALL ext
			IN_SETNAME file'_'ext'.wav'
		END
	END
	ELSE DO
		SA_BUFFERTOSAMPLE
		CALL ext
		IN_SETNAME file'_'ext'.wav'
	END
	SA_SHOW ALL
	return = 1
	CALL calc
	CALL rn
	ADDRESS VALUE host
	SETTEXT _out "Pasted."
	SIGNAL main
;;

/* copy */
copy:
	IF ns = 1 THEN CALL calc
	ADDRESS OCTAMED_REXX
	IF copy = 0 THEN DO
		SA_COPYRANGE
		ADDRESS VALUE host
		SETTEXT _out 'Copied.'
	END
	IF copy = 1 THEN DO
		SA_CUTRANGE
		SA_SHOW ALL
		CALL rn
		ADDRESS VALUE host
		SETTEXT _out 'Cut.'
	END
	IF copy = 2 THEN DO
		SA_CHOPRANGE
		SA_SHOW ALL
		return = 1
		CALL calc
		CALL rn
		ADDRESS VALUE host
		SETTEXT _out 'Chopped.'
	END  
	SIGNAL main
;;

quit:
	'hide unload'
	CALL CLOSEPORT("TEETH!.S")
	EXIT
;;