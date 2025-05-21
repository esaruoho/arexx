/*

	Stin - Shift Track INstruments.
	This shifts the instruments on the
	current track one instrument to the
	right (current instrument will be changed
	to the next instrument).
	If there are multiple instruments
	prestent on the current track, the instrument
	number that is closest to the cursor will
	be shiftet.

	Made by Kjetil S. Matheussen 6.8.99.

	Recomended shortcut: Shift+Ctrl+Right arror.

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

	UWORD track;
	UWORD line,num_lines;
	UWORD inum,inum_curr,inum_change;
	UWORD lineoffset=0;

	if((ob=getoctabase())==0) goto exit;			/* Allways include this line first in
																	your plug-ins. */
	bb=getcurrblockbase(ob);
	track=getcurrtrack(ob);
	line=getcurrline(ob);
	num_lines=getnumlines(bb);

	/* find the instrument to switch. */
	while(1){
		inum=getinum(bb,track,line-lineoffset);
		if(inum!=0) break;
		inum=getinum(bb,track,line+lineoffset);
		if(inum!=0) break;
		lineoffset++;
		if(line-lineoffset<0 && line+lineoffset>num_lines) goto exit;
	}
	inum_change=inum+1;
	if(inum_change==64) inum_change=1;

	for(line=0;line<=num_lines;line++){
		inum_curr=getinum(bb,track,line);
		if(inum_curr==inum) setinum(bb,track,line,inum_change);
	}

	updateeditor(ob);

exit:
}
