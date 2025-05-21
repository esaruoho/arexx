/****h* SoundFX/FromOctaMed.rexx [1.10] *
*
*  NAME
*    FromOctaMed.rexx
*  COPYRIGHT
*    $VER: FromOctaMed.rexx 1.10 (23.09.98) � by David O'Reilly & Stefan Kost 1998-1998
*  FUNCTION
*    imports the current sample from OctaMed Sound Studio
*  AUTHOR
*    David O'Reilly			dr
*    Stefan Kost			sk
*  CREATION DATE
*    17.Jun.1998
*  MODIFICATION HISTORY
*    23.Sep.1998	V 1.10	adapted to SoundFX (sk)
*                           better type detection (sk)
*    17.Jun.1998	V 1.00	initial version (dr)
*  NOTES
*
*******
*/

OPTIONS RESULTS
ADDRESS 'OCTAMED_REXX'

IN_GETTYPE
smp_type=RESULT

IF smp_type=EMPTY THEN DO
	ADDRESS 'REXX_SFX' SFX_Message '"Current Octamed instrument is empty !"'
	EXIT
END
ELSE IF smp_type=SYNTH THEN DO
	ADDRESS 'REXX_SFX' SFX_Message '"Current Octamed instrument is a synth sound !"'
	EXIT
END
ELSE IF smp_type=UNKNOWN THEN DO
	ADDRESS 'REXX_SFX' SFX_Message '"Current Octamed instrument is of unknown type !"'
	EXIT
END

IN_SAVE 't:tmp_om2sfx.aiff aiff'
IN_GETNAME
smp_name=RESULT

ADDRESS 'REXX_SFX'

SFX_SelLoader 'IFF-AIFF'
SFX_LoadSample 't:tmp_om2sfx.aiff'
buf1=RESULT
SFX_RenameBuffer buf1 smp_name
SFX_Activate

ADDRESS COMMAND 'delete >nil: t:tmp_om2sfx.aiff'
EXIT
