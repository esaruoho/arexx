/*
	Marks the range without using the mouse.
	A major speed-up in the composing-process.
	Instrucions:
	1. Run plug-in.
	2. Move the cursor to where you want your
		range to be marked.
	3. Run again.
	4. The range is marked, the mark is ranged, or whatever.

	Do allso remember to define a key to cancel
	your range. The octamed command to cancel a
	range is: "RN_CANCELRANGE". (surprise!)

	Made by Kjetil S. Matheussen 10.12.98.

	This is an example on how to make an
	octamed plug-in with the nsm-system.

	e-mail: kjetilma@ifi.uio.no

	Address:
	Kjetil S. Matheussen
	5423 Sogn Studentby
	0858 Oslo
	Norway
*/

#include "/nsm.h"

void main(){
	OCTABASE ob;

	UWORD starttrack,endtrack;
	UWORD	startline,endline;

	if((ob=getoctabase())==0) goto exit;			/* Allways include this line first in
																	your plug-ins. */
	if(isranged(ob)){
		starttrack=getrangestarttrack(ob);
		endtrack=getcurrtrack(ob);
		if(starttrack>endtrack){
			starttrack=endtrack;
			endtrack=getrangeendtrack(ob);
		}
		startline=getrangestartline(ob);
		endline=getcurrline(ob);
		if(startline>=endline){
			startline=endline;
			endline=getrangeendline(ob);
		}
	}else{
		starttrack=getcurrtrack(ob);
		startline=getcurrline(ob);
		endtrack=starttrack;
		endline=startline;
	}

	sendrexxword4(
		"RN_SETRANGE STARTTRACK ",starttrack,
		" STARTLINE ",startline,
		" ENDTRACK ",endtrack,
		" ENDLINE ",endline,""
	);


exit:
}
