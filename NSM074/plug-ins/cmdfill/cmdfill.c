/*
	An octamed plug-in that fills cmdnum and
	cmdlvl from spesified parameters. Read
	the doc-file for more information.

	Last updated: 20.2.99. Changes: Window
	opens allways at Octamed screen.

	Made by Kjetil S. Matheussen 10.12.98.
	Idea: Ash Atkins

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

void main(int argc,char *argv[]){
	OCTABASE ob;
	BLOCKBASE bb;

	UWORD track,line,page,uwordnote,uwordnotelast=0;

	int prefix=-1,rangestart,rangeend;
	int rangestartset=FALSE,rangeendset=FALSE;
	int firsttime=TRUE;
	int onecmdnum=TRUE;
	int lokke;
	float incdec=-1,note;
	int post=TRUE;
	char *dosbase,*filehandle;
	char string[80];


	if((ob=getoctabase())==0) goto exit;			/* Allways include this line first in
																	your plug-ins. */
	bb=getcurrblockbase(ob);

/*
	-p
	-rs
	-re
	-id
	POST
	FILLCMDNUM
*/

	if(argc>0)
		for(lokke=1;lokke<argc;lokke++){
			next:
			if (!strcmp(argv[lokke],"-p") && lokke+1<argc){
				lokke++;
				sscanf(argv[lokke],"%x",&prefix);
				goto next;
			}
			if (!strcmp(argv[lokke],"-rs") && lokke+1<argc){
				lokke++;
				sscanf(argv[lokke],"%x",&rangestart);
				rangestartset=TRUE;
				goto next;
			}
			if (!strcmp(argv[lokke],"-re") && lokke+1<argc){
				lokke++;
				sscanf(argv[lokke],"%x",&rangeend);
				rangeendset=TRUE;
				goto next;
			}
			if (!strcmp(argv[lokke],"-id") && lokke+1<argc){
				lokke++;
				sscanf(argv[lokke],"%f",&incdec);
				if(incdec<=0) goto exit;					/* If incdec is zero, the program
																		will end in a loop it can't get out of.
																		I allso check for less than zero, since thats
																		easy. */
				goto next;
			}
			if (!strcmp(argv[lokke],"PRE")) post=FALSE;
			if (!strcmp(argv[lokke],"FILLCMDNUM")) onecmdnum=FALSE;
		}

	dosbase=opendoslibrary();
	filehandle=openoctacon(dosbase,200,80);

	if(prefix<0){	/* if not initialized with an argument. */
		writestring(dosbase,filehandle,"Prefix: ",8);
		readstring(dosbase,filehandle,string,70);
		sscanf(string,"%x",&prefix);
		if(*string==0) prefix=0;
		if(prefix<0 || prefix>127) goto close;
	}

	if(!rangestartset){
		writestring(dosbase,filehandle,"Rangestart: ",12);
		readstring(dosbase,filehandle,string,70);
		sscanf(string,"%x",&rangestart);
		if(*string==0) rangestart=0;
	}

	if(!rangeendset){
		writestring(dosbase,filehandle,"Rangeend: ",10);
		readstring(dosbase,filehandle,string,70);
		sscanf(string,"%x",&rangeend);
		if(*string==0) rangeend=0;
	}

	if(incdec<0){
		writestring(dosbase,filehandle,"Inc/Dec: ",9);
		readstring(dosbase,filehandle,string,70);
		if(*string==0) goto close;
		sscanf(string,"%f",&incdec);
		if(incdec<=0) goto close;
	}

	track=getcurrtrack(ob);
	line=getcurrline(ob);

	page=getcurrpage(ob);

	if(rangeend<rangestart) incdec=-incdec;

	note=rangestart-(post*incdec);
	do{
		note+=incdec;
		uwordnote=note;
		if(uwordnote!=uwordnotelast || firsttime){
			if (!onecmdnum || firsttime) setcmdnum(bb,track,line,page,prefix);
			setcmdlvl(bb,track,line,page,uwordnote);
			uwordnotelast=uwordnote;
			firsttime=FALSE;
		}
		line++;
	}while(!((incdec<0 && note<rangeend) || (incdec>0 && note>=rangeend)));

	updateeditor(ob);

/*	printf("her: %d,%d,%d,%f\n",prefix,rangestart,rangeend,incdec);
*/
close:
	closefile(dosbase,filehandle);
	closedoslibrary(dosbase);

exit:
}
