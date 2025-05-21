/*
	Flips all lines, notes, inum,
	cmdnum and cmdlvl in all the pages in the
	range. If no range is specified, the current
	track will be flipped.

	Made by Kjetil S. Matheussen 9.12.98.
	Last updated: 14.1.98. Changes: Range didn't
	work when rangestart>0.

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
	UWORD pages;
   UWORD data;

	UWORD track,line,page,cmd;

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

	pages=getnumpages(bb);

	for(line=0;line<(endline-startline+1)/2;line++)
		for(track=starttrack;track<=endtrack;track++){
			for(cmd=NOTE;cmd<=INUM;cmd++){
			   data=getmed(cmd,bb,track,line+startline,1);
				setmed(cmd,bb,track,line+startline,1,getmed(cmd,bb,track,endline-line,1));
				setmed(cmd,bb,track,endline-line,1,data);
			}
			for(page=1;page<=pages+1;page++)
				for(cmd=CMDNUM;cmd<=CMDLVL;cmd++){
				   data=getmed(cmd,bb,track,line+startline,page);
					setmed(cmd,bb,track,line+startline,page,getmed(cmd,bb,track,endline-line,page));
					setmed(cmd,bb,track,endline-line,page,data);
				}
		}

	updateeditor(ob);

exit:
}
