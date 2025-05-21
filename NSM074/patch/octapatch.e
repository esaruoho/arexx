/* 
	Octapatch V0.70 made by Kjetil S Matheussen

	Patches Octamed1.03c to send an address of
	the variablespace in Octamed to the nsmport.

   Written for E 2.21b by Wouter van Oortmerssen.

	This Patch seems to work very fine. But Please
	report to me if there are any problems.

	e-mail: kjetilma@ifi.uio.no

	Address:
	Kjetil S. Matheussen
	5423 Sogn Studentby
	0858 Oslo
	Norway
*/


CONST MEMF_CHIP=2,
		MEMF_ANY=0,
      MEMF_LARGEST=$20000,
      MODE_OLDFILE=$3ED,
		MODE_NEWFILE=$3EE

DEF space,octahandle,patchhandle,result

PROC main()
	VOID '$VER: Octapatch 0.70 (09.12.99) by Kjetil S. Matheussen'

	WriteF('Octapatch 0.70 (09.12.99) by Kjetil S. Matheussen...\n')

	IF FileLength(arg)<>$3c3a8
		IF FileLength(arg)=-1
			WriteF('\nCould not find "\s".\n',arg)
		ELSE
			WriteF('\nThis is not the right version of Octamed Soundstudio 1.03c.\n')
			WriteF('Excpected 246696 bytes, found \d.\n',FileLength(arg))
			WriteF('\nIf you are shure that its OSS1.03c you are trying to patch,\n')
			WriteF('please mail your octamed to: kjetilma@ifi.uio.no. Thanks. \n')
			WriteF('\nOctamed1.03c with the length 246696 can be obtained from\n')
			WriteF('http://www.octamed.co.uk.\n\n')
		ENDIF
		CleanUp(0)
	ENDIF

	IF AvailMem(MEMF_ANY)<$40000
		WriteF('Not enough memory!\n')
		endpatch()
	ENDIF
	space:=AllocMem($3c3a8+$a0,MEMF_ANY)

	octahandle:=Open(arg,MODE_OLDFILE)
	IF octahandle=0
		WriteF('Could not open "\s".\n',arg)
		endpatch()
	ENDIF
	result:=Read(octahandle,space+$a0,$3c3a8)
	IF result<>$3c3a8
		WriteF('Could not read "\s".\n',arg)
		endpatch()
	ENDIF

	CopyMem(space+$a0,space,$70)

	patchhandle:=Open('octapatch12',MODE_OLDFILE)
	IF patchhandle=0
		WriteF('Could not open "octapatch12".\n')
		endpatch()
	ENDIF
	result:=Read(patchhandle,space+$70,$a0)
	Close(patchhandle)


	patchhandle:=Open('octapatch3',MODE_OLDFILE)
	IF patchhandle=0
		WriteF('Could not open "octapatch3".\n')
		endpatch()
	ENDIF
	result:=Read(patchhandle,space+$a0+$7c,$c)
	Close(patchhandle)

	patchhandle:=Open('octapatch4',MODE_OLDFILE)
	IF patchhandle=0
		WriteF('Could not open "octapatch4".\n')
		endpatch()
	ENDIF
	result:=Read(patchhandle,space+$a0+$176,$8)
	Close(patchhandle)


	MOVE.L	space,A2
	MOVE.L	#$3b,$14(A2)	/* Sets the new hunk1-length in the hunkheader. */
	MOVE.L	#$3b,$20(A2)	/* Sets the new hunk1-length in Hunk1. */

	Seek(octahandle,0 ,-1)
	result:=Write(octahandle,space,$3c3a8+$a0)
	IF result=-1
		WriteF('Could not write to file. \n')
		endpatch()
	ENDIF
	WriteF('Octamed Patched successfully! (I hope)\n');

	endpatch()

ENDPROC


PROC endpatch()
	IF space>0 THEN FreeMem(space,$3c3a8+$a0)
	IF octahandle>0 THEN Close(octahandle)
	CleanUp(0)
ENDPROC

