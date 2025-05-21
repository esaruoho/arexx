/*
	Inverts the notes in the range. If no
	range is specified, the current
	track will be inverted.

	Made by Kjetil S. Matheussen 22.2.99.

	Recommended shortcut: Left Amiga + i

	e-mail: kjetilma@ifi.uio.no

	Address:
	Kjetil S. Matheussen
	5423 Sogn Studentby
	0858 Oslo
	Norway
*/

#include "/nsm.h"
#define TRUE 1
#define FALSE 0

void main(){
	OCTABASE ob;
	BLOCKBASE bb;

	UWORD starttrack,endtrack;
	UWORD	startline,endline;
   UWORD current,post,last;

	UWORD track,line;

	int first;


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

	for(track=starttrack;track<=endtrack;track++){
		first=TRUE;
		for(line=startline;line<=endline;line++){
			current=getnote(bb,track,line);
			if(current){
				if(!first){
					last=last+post-current;
					setnote(bb,track,line,last);
				}else{
					last=current;
					first=FALSE;
				}
				post=current;
			}
		}
	}

	updateeditor(ob);

exit:
}
