/*
	Inserts or deletes <n> number of lines on all the tracks
	at the current cursorline-position. Does allso
	update the length of the block to <oldlength>+<n>
	and update the highlightened lines to the new
	positions.

	If you are just going to insert or delete one line, the
	"RN_INSERTLINE" and "RN_DELETELINE" commands are about
	just as fast as the plug-in. But with more lines to
	delete/insert, the plug-ins gets exponential faster.

	Recommended shortcut: Shift-return.

	Made by Kjetil S. Matheussen.

	Updated: 19.2.99. Changes: Uses the new functions in
	NSM; "sethighlightline" and "unsethighlightline", rewritten
	the delete-rutine, and fixed a bug. The plug-in is now many
	thousands times faster than previous versions.

	Updated: 8.1.99. Changes: Can delete lines too, and
	Con-window allways opens at the octamed-screen.

	First version: 15.12.98.

	Link with /readstr.o and /octacontrol.o to compile. Needs
	at least NSM V074.

	e-mail: kjetilma@ifi.uio.no

	Address:
	Kjetil S. Matheussen
	5423 Sogn Studentby
	0858 Oslo
	Norway
*/

#include <string.h>
#include "/nsm.h"
#include "/readstr.h"

void main(){
	OCTABASE ob;
	BLOCKBASE bb;

	UWORD numlines,numtracks,currline,track,page,numpages,highline;
	int insertlines,line;

	char *dosbase,*filehandle;
	char string[80];

	if((ob=getoctabase())==0) goto exit;			/* Allways include this line first in
																	your plug-ins. */

	dosbase=opendoslibrary();
	filehandle=openoctacon(dosbase,350,60);

	bb=getcurrblockbase(ob);

	writestring(dosbase,filehandle,"(To delete lines, use a \"-\")\n\n",30);
	writestring(dosbase,filehandle,"Number of lines to insert: ",27);
	readstring(dosbase,filehandle,string,70);
	numlines=getnumlines(bb);							/* Has to be put here. */
	sscanf(string,"%d",&insertlines);
	if(insertlines+numlines<=0 || insertlines+numlines>3200) goto close;

	numtracks=getnumtracks(bb);
	currline=getcurrline(ob);
	numpages=getnumpages(bb)+1;

	if(insertlines>0){
		sendrexxword("ED_SETBLOCKLINES LINES ",numlines+insertlines,"");
		bb=getcurrblockbase(ob);		/* Have to update the bb-pointer, because we have
												changed the length of the block, and it has got a new base. */
		numlines=numlines+insertlines;

		for(line=numlines;line>=currline+insertlines;line--){
			for(track=0;track<numtracks;track++){
				setnote(bb,track,line,getnote(bb,track,line-insertlines));
				setinum(bb,track,line,getinum(bb,track,line-insertlines));
				for(page=1;page<=numpages;page++){
					setcmdnum(bb,track,line,page,getcmdnum(bb,track,line-insertlines,page));
					setcmdlvl(bb,track,line,page,getcmdlvl(bb,track,line-insertlines,page));
				}
			}
			highline=getlinehighlight(bb,line-insertlines);
			if (highline!=getlinehighlight(bb,line))
				if (highline==1){
					setlinehighlight(bb,line);
				}else{
					unsetlinehighlight(bb,line);
				}
		}

		for(line=currline;line<currline+insertlines;line++){
			for(track=0;track<numtracks;track++){
				setnote(bb,track,line,0);
				setinum(bb,track,line,0);
				for(page=1;page<=numpages;page++){
					setcmdnum(bb,track,line,page,0);
					setcmdlvl(bb,track,line,page,0);
				}
			}
			if (getlinehighlight(bb,line)==1) unsetlinehighlight(bb,line);
		}
		updateeditor(ob);


	}else{

		for(line=currline;line<numlines+insertlines;line++){
			for(track=0;track<numtracks;track++){
				setnote(bb,track,line,getnote(bb,track,line-insertlines));
				setinum(bb,track,line,getinum(bb,track,line-insertlines));
				for(page=1;page<=numpages;page++){
					setcmdnum(bb,track,line,page,getcmdnum(bb,track,line-insertlines,page));
					setcmdlvl(bb,track,line,page,getcmdlvl(bb,track,line-insertlines,page));
				}
			}
			highline=getlinehighlight(bb,line-insertlines);
			if (highline!=getlinehighlight(bb,line))
				if (highline==1){
					setlinehighlight(bb,line);
				}else{
					unsetlinehighlight(bb,line);
				}
		}
		sendrexxword("ED_SETBLOCKLINES LINES ",numlines+insertlines,"");
	}


close:
	closefile(dosbase,filehandle);
	closedoslibrary(dosbase);

exit:
}
