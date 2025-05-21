/*
	Copies the range to another track, with
	the same line-numbers and the instrument
	which is present on the other track.

	Made by Kjetil S. Matheussen January '99.

	This is an example on how to make an
	octamed plug-in with the nsm-system.

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

	UWORD numlines,numpages;

	UWORD starttrack,endtrack;
	UWORD	startline,endline;

	UWORD line=0,page;

	int pastetrack;
	int pasteinum=0;


	APTR dosbase,filehandle;
	char string[80];

	if((ob=getoctabase())==0) goto exit;			/* Allways include this line first in
																	your plug-ins. */
	if(!isranged(ob)) goto exit;

	bb=getcurrblockbase(ob);
 
	starttrack=getrangestarttrack(ob);
	endtrack=getrangeendtrack(ob);
	startline=getrangestartline(ob);
	endline=getrangeendline(ob);

	dosbase=opendoslibrary();
	filehandle=openoctacon(dosbase,350,60);

	writestring(dosbase,filehandle,"To track: ",10);
	readstring(dosbase,filehandle,string,70);
	if(*string==0) goto close;
	sscanf(string,"%d",&pastetrack);
	if(pastetrack<0 || pastetrack>=getnumtracks(bb) || pastetrack==starttrack) goto close;

	numlines=getnumlines(bb);
	while(pasteinum==0){
		pasteinum=getinum(bb,pastetrack,line);
		line++;
		if(line>=numlines){
			writestring(dosbase,filehandle,"Instrument: ",12);
			readstring(dosbase,filehandle,string,70);
			sscanf(string,"%d",&pasteinum);
		}
	}

	numpages=getnumpages(bb);
	for(line=startline;line<=endline;line++){
		setnote(bb,pastetrack,line,getnote(bb,starttrack,line));
		if(getnote(bb,starttrack,line)>0) setinum(bb,pastetrack,line,pasteinum);
		for(page=1;page<=numpages+1;page++){
			setcmdnum(bb,pastetrack,line,page,getcmdnum(bb,starttrack,line,page));
			setcmdlvl(bb,pastetrack,line,page,getcmdlvl(bb,starttrack,line,page));
		}
	}
	updateeditor(ob);

close:
	closefile(dosbase,filehandle);
	closedoslibrary(dosbase);

exit:
}
