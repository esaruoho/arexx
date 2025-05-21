/*
	Flips all highlighted lines, notes, inum,
	cmdnum and cmdlvl in all the pages at all
	tracks in the current block.

	Made by Kjetil S. Matheussen 9.12.98.

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

	UWORD numtracks;
	UWORD length;
	UWORD pages;
   UWORD data;

	UWORD track,line,page,cmd;

	if((ob=getoctabase())==0) goto exit;			/* Allways include this line first in
																	your plug-ins. */
	bb=getcurrblockbase(ob);

	numtracks=getnumtracks(bb);
	length=getnumlines(bb)-1;
	pages=getnumpages(bb);

	for(line=0;line<length/2;line++){
		if (getlinehighlight(bb,length-line)!=getlinehighlight(bb,line)){
			sendrexxword("ED_HIGHLIGHTLINE ",line," TOGGLE");
			sendrexxword("ED_HIGHLIGHTLINE ",length-line," TOGGLE");
		}
		for(track=0;track<=numtracks;track++){
			for(cmd=NOTE;cmd<=INUM;cmd++){
			   data=getmed(cmd,bb,track,line,1);
				setmed(cmd,bb,track,line,1,getmed(cmd,bb,track,length-line,1));
				setmed(cmd,bb,track,length-line,1,data);
			}
			for(page=1;page<=pages+1;page++)
				for(cmd=CMDNUM;cmd<=CMDLVL;cmd++){
				   data=getmed(cmd,bb,track,line,page);
					setmed(cmd,bb,track,line,page,getmed(cmd,bb,track,length-line,page));
					setmed(cmd,bb,track,length-line,page,data);
				}
		}
	}

	updateeditor(ob);

exit:
}
