/*
	Transpose down the range one octave. If no
	range is specified, the current track
	will be transposed.

	Made by Kjetil S. Matheussen 13.12.98.

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
	BLOCKBASE bb;

	UWORD starttrack,endtrack;
	UWORD	startline,endline;

	UWORD line,track;

	if((ob=getoctabase())==0) goto exit;			/* Allways include this line first in
																	your plug-ins. */
	bb=getcurrblockbase(ob);

	if(isranged(ob)){
		starttrack=getrangestarttrack(ob);
		endtrack=getrangeendtrack(ob);
		startline=getrangestartline(ob);
		endline=getrangeendline(ob);
	}else{
		starttrack=getcurrtrack(ob);
		endtrack=starttrack;
		startline=0;
		endline=getnumlines(bb)-1;
	}

	for(line=startline;line<=endline;line++)
		for(track=starttrack;track<=endtrack;track++)
			if(getnote(bb,track,line)) setnote(bb,track,line,getnote(bb,track,line)-12);

	updateeditor(ob);

exit:
}
