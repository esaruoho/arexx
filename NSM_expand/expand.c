/*
	Expand or Shrink the lines in the range or the current
	block by a faktor/divisor.
	Does allso update highlightened lines to new positions,
	which the built in functions "RN_EXPANDBLOCK" and
	"RN_SHRINKBLOCK" don't do. The source is programmed
	to be fast, not easy to read.

	Recommended shortcut: Alt-Shift-Return.

	Made by Kjetil S. Matheussen.

	First version: 21.2.99.

	Link with /readstr.o and /octacontrol.o. Needs
	at least NSM V074 to compile.

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

	UWORD numlines,numtracks,track,page,numpages,highline;
	UWORD	startline,endline,fromline;
	int faktor,insertlines,line;

	char *dosbase,*filehandle;
	char string[80];

	if((ob=getoctabase())==0) goto exit;			/* Allways include this line first in
																	your plug-ins. */

	dosbase=opendoslibrary();
	filehandle=openoctacon(dosbase,400,60);

	bb=getcurrblockbase(ob);

	writestring(dosbase,filehandle,"(To shrink, use a \"/\" before faktor)\n\n",38);
	writestring(dosbase,filehandle,"Expand faktor: ",16);
	readstring(dosbase,filehandle,string,70);
	if(string[0]!='/'){
		sscanf(string,"%d",&faktor);
	}else{
		sscanf(string,"/%d",&faktor);
	}
	if(faktor<=1 || faktor>3200) goto close;

	numtracks=getnumtracks(bb);
	numpages=getnumpages(bb)+1;
	numlines=getnumlines(bb);

	if(string[0]!='/'){
		if(isranged(ob)){
			startline=getrangestartline(ob);
			endline=getrangeendline(ob);

			insertlines=(endline-startline+1)*(faktor-1);

			numlines=numlines+insertlines;

			if(numlines>3200) goto close;

			sendrexxword("ED_SETBLOCKLINES LINES ",numlines,"");

			bb=getcurrblockbase(ob);		/* Have to update the bb-pointer, because we have
													changed the length of the block, and it has got a new base. */


	/***************** move lines *************/

			for(line=numlines;line>endline+insertlines;line--){
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

	/*************** expand range *************/

			fromline=endline;
			for(line=endline+insertlines;line>startline;line--){
				if((line-startline)%faktor==0){
					for(track=0;track<numtracks;track++){
						setnote(bb,track,line,getnote(bb,track,fromline));
						setinum(bb,track,line,getinum(bb,track,fromline));
						for(page=1;page<=numpages;page++){
							setcmdnum(bb,track,line,page,getcmdnum(bb,track,fromline,page));
							setcmdlvl(bb,track,line,page,getcmdlvl(bb,track,fromline,page));
						}
					}
					highline=getlinehighlight(bb,fromline);
					if (highline!=getlinehighlight(bb,line))
						if (highline==1){
							setlinehighlight(bb,line);
						}else{
							unsetlinehighlight(bb,line);
						}
					fromline--;
				}else{
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
			}

		}else{
			/********** Expand Block. ************/
			sendrexxword("RN_EXPANDBLOCK ",faktor,"");
			bb=getcurrblockbase(ob);
			for(line=numlines;line>0;line--)
				if(getlinehighlight(bb,line)){
					setlinehighlight(bb,line*faktor);
					 unsetlinehighlight(bb,line);
			}
		}
		updateeditor(ob);

	}else{
		if(isranged(ob)){

			/********** Shrink Range. ************/
			startline=getrangestartline(ob);
			endline=getrangeendline(ob);

			if((endline-startline+1)%faktor!=0){
				sendrexx("WI_SHOWSTRING Length of range is not divisable by faktor.");
				goto close;
			}

			insertlines=-((endline-startline+1)*(faktor-1)/(faktor));

			numlines=numlines+insertlines;
			if(numlines<1) goto close;

			fromline=startline;
			for(line=startline+1;line<=endline+insertlines;line++){
				fromline+=faktor;
				for(track=0;track<numtracks;track++){
					setnote(bb,track,line,getnote(bb,track,fromline));
					setinum(bb,track,line,getinum(bb,track,fromline));
					for(page=1;page<=numpages;page++){
						setcmdnum(bb,track,line,page,getcmdnum(bb,track,fromline,page));
						setcmdlvl(bb,track,line,page,getcmdlvl(bb,track,fromline,page));
					}
				}
				highline=getlinehighlight(bb,fromline);
				if (highline!=getlinehighlight(bb,line))
					if (highline==1){
						setlinehighlight(bb,line);
					}else{
						unsetlinehighlight(bb,line);
					}
			}

			/*************** Move lines. ************/
			for(line=endline+insertlines+1;line<numlines;line++){
				fromline=line-insertlines;
				for(track=0;track<numtracks;track++){
					setnote(bb,track,line,getnote(bb,track,fromline));
					setinum(bb,track,line,getinum(bb,track,fromline));
					for(page=1;page<=numpages;page++){
						setcmdnum(bb,track,line,page,getcmdnum(bb,track,fromline,page));
						setcmdlvl(bb,track,line,page,getcmdlvl(bb,track,fromline,page));
					}
				}
				highline=getlinehighlight(bb,fromline);
				if (highline!=getlinehighlight(bb,line))
					if (highline==1){
						setlinehighlight(bb,line);
					}else{
						unsetlinehighlight(bb,line);
					}
			}
			sendrexxword("ED_SETBLOCKLINES LINES ",numlines,"");

		}else{
			if(numlines%faktor!=0){
				sendrexx("WI_SHOWSTRING Length of block is not divisable by faktor.");
				goto close;
			}
			/********** Shrink Block. ************/
			for(line=0;line<numlines/faktor;line++)
				if(getlinehighlight(bb,line*faktor)){
					if(getlinehighlight(bb,line)==0) setlinehighlight(bb,line);
				else{
					if(getlinehighlight(bb,line)==1) unsetlinehighlight(bb,line);
				}
			}
			sendrexxword("RN_SHRINKBLOCK ",faktor,"");
		}
	}


close:
	closefile(dosbase,filehandle);
	closedoslibrary(dosbase);

exit:
}
