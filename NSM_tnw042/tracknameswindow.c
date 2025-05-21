/*
   This is the source for the tracknameswindow V0.42.
   See the doc-files for more information.
   Link with windowcontrol.o, annomanno.o and /octacontrol.o.
	You need at least the NSM-package V0.73 to compile.

   Made by Kjetil S. Matheussen.

	This is an example on how to make an
	octamed plug-in with the nsm-system.

	e-mail: kjetilma@ifi.uio.no

	Address:
	Kjetil S. Matheussen
	5423 Sogn Studentby
	0858 Oslo
	Norway



*/
#include "tracknameswindow.h"
#include <stdlib.h>

extern int numvisibletracks;
extern int currvisibletrack;

char tracknamebuf[15]="\3          ";

char windowtitle[50];
int trackstates[63];
int leftvisibletrack;
int cursorpos;
UWORD blockpos;
UWORD numblocks;

UWORD currinum;
UWORD curroctave;

/*
	All argument are optional.

	-stoptaskprior [n]       - n = Is the priority of the task while not plaing. Is set
	                               to 8 by default.
	-playtaskprior [n]       - n = Is the priority of the task while playing. Is set to
	                               -20 by default.
	-ypos [n]                - n = the Y coordinate the window will start at. F. ex: 10

	-editorfontname [n]      - n = the name of the editorfont. F.ex: Topaz.font

	-editorfontsize [n]      - n = size of the editorfont. F. ex: 8. If you specify the
	                               editorfontname, you *must* allso spesify the size.
	-windowheight [n]        - n = the height of the tracknameswindow. F. ex: 30

	-topmarkcursorpos [n]    - n = The top relative Y coordinate of where the top-line
	                               marker will be placed.
	-botmarkcursorpos [n]    - n = The top relative Y coordinate of where the top-line
	                               marker will be placed.
	-fontpos [n]             - n = The Y coordinate of where the text in the tracknames-
	                               window will be placed.
	-whitelinetop [n]        - n = The top Y coordinate of where the white lines will
	                               start.
	-whitelinebot [n]        - n = The bottom Y coordinat of where the white lines will
	                               end.
*/

LONG stoptaskprior=8;
LONG playtaskprior=-20;
int ypos=-1;
char *editorfontname=NULL;
int editorfontsize=-1;
int windowheight=-1;
int topmarkcursorpos=-1,botmarkcursorpos=-1;
int fontpos=-1;
int whitelinetop=-1;whitelinebot=-1;

void initarguments(int argc,char **argv){
	int lokke;
	for(lokke=1;lokke<argc;lokke++){
		next:
		if (!strcmp(argv[lokke],"-stoptaskprior") && lokke+1<argc){
			lokke++;
			sscanf(argv[lokke],"%d",&stoptaskprior);
			goto next;
		}
		if (!strcmp(argv[lokke],"-playtaskprior") && lokke+1<argc){
			lokke++;
			sscanf(argv[lokke],"%d",&playtaskprior);
			goto next;
		}
		if (!strcmp(argv[lokke],"-ypos") && lokke+1<argc){
			lokke++;
			sscanf(argv[lokke],"%d",&ypos);
			goto next;
		}
		if (!strcmp(argv[lokke],"-editorfontname") && lokke+1<argc){
			lokke++;
			editorfontname=argv[lokke];
			goto next;
		}
		if (!strcmp(argv[lokke],"-editorfontsize") && lokke+1<argc){
			lokke++;
			sscanf(argv[lokke],"%d",&editorfontsize);
			goto next;
		}
		if (!strcmp(argv[lokke],"-windowheight") && lokke+1<argc){
			lokke++;
			sscanf(argv[lokke],"%d",&windowheight);
			goto next;
		}
		if (!strcmp(argv[lokke],"-topmarkcursorpos") && lokke+1<argc){
			lokke++;
			sscanf(argv[lokke],"%d",&topmarkcursorpos);
			goto next;
		}
		if (!strcmp(argv[lokke],"-botmarkcursorpos") && lokke+1<argc){
			lokke++;
			sscanf(argv[lokke],"%d",&botmarkcursorpos);
			goto next;
		}
		if (!strcmp(argv[lokke],"-fontpos") && lokke+1<argc){
			lokke++;
			sscanf(argv[lokke],"%d",&fontpos);
			goto next;
		}
		if (!strcmp(argv[lokke],"-whitelinetop") && lokke+1<argc){
			lokke++;
			sscanf(argv[lokke],"%d",&whitelinetop);
			goto next;
		}
		if (!strcmp(argv[lokke],"-whitelinebot") && lokke+1<argc){
			lokke++;
			sscanf(argv[lokke],"%d",&whitelinebot);
			goto next;
		}
		if (!strcmp(argv[lokke],"-fontpos") && lokke+1<argc){
			lokke++;
			sscanf(argv[lokke],"%d",&fontpos);
			goto next;
		}
	}
}

char nametemp[15];
char *gettrackname_n(OCTABASE ob,UWORD track,UWORD block){
	char *ret;

	ret=gettrackname(ob,track,block);
	if(ret[0]==3){
			sprintf(nametemp,"   %d%d    ",track/10,track-((track/10)*10));
			return(nametemp);
	}
	return(ret);
}

void updateallnames(OCTABASE ob){
	int lokke;

	leftvisibletrack=getleftmostvisibletrack(ob);

	for(lokke=leftvisibletrack;lokke<numvisibletracks+leftvisibletrack;lokke++){
		trackstates[lokke]=istrackon(ob,lokke);
		inserttext(
			gettrackname_n(ob,lokke,blockpos),
			lokke-leftvisibletrack,
			trackstates[lokke]*3
		);
	}
	settracknamedata(ob,64);
	
}



void updatewindowtitle(OCTABASE ob){

   curroctave=getcurroctave(ob);
	currinum=getcurrinstrument(ob);
	sprintf(
		windowtitle,

		"Oct:%X%X - Instr:%s - Vol:%2X - %-20.20s - %s",

		curroctave+1,curroctave+2,
		getcurrinstrumentstring(ob),
		getvolume(ob,currinum),
		getinname(ob,currinum),
		getcurrinstrumentinfostring(ob)
	);
	showinumname(windowtitle);

}

void addblockplainnames(OCTABASE ob){
	FILE *plainnamestemp;
	int block,track,track10,track1;

	sprintf(windowtitle,"Please wait. Initializing block #%d for the tracknameswindow.",numblocks);
	showinumname(windowtitle);

	plainnamestemp=fopen("nsm:plainnamestemp","w");

	fprintf(plainnamestemp,"%s\n",gettrackname(ob,(UWORD)-2,0));
	fprintf(plainnamestemp,"%s\n",gettrackname(ob,(UWORD)-1,0));

	for(block=0;block<numblocks;block++)
		for(track=0;track<64;track++)
			fprintf(plainnamestemp,"%s\n",gettrackname(ob,track,block));

	for(track10=0;track10<6;track10++)
		for(track1=0;track1<10;track1++)
			fprintf(plainnamestemp,"\03  %d%d     \n",track10,track1);

	fprintf(plainnamestemp,"\03  60     \n");
	fprintf(plainnamestemp,"\03  61     \n");
	fprintf(plainnamestemp,"\03  62     \n");
	fprintf(plainnamestemp,"\03  63     \n");

	fclose(plainnamestemp);

	sendrexx("SG_LOADANNOTEXT \"nsm:plainnamestemp\"");

	updatewindowtitle(ob);

}

void initializenewsong(OCTABASE ob){
	int block,track10,track1;
	FILE *plainnamestemp;

	sendrexx("SG_LOADANNOTEXT \"nsm:plainnames\"");
	numblocks=getnumblocks(ob);

	showinumname("Please wait. Initializing blocks for the new song");

	plainnamestemp=fopen("nsm:plainnamestemp","w");

	fprintf(plainnamestemp,"%s\n",gettrackname(ob,(UWORD)-2,0));
	fprintf(plainnamestemp,"%s\n",gettrackname(ob,(UWORD)-1,0));

	for(block=0;block<numblocks;block++){
		for(track10=0;track10<6;track10++)
			for(track1=0;track1<10;track1++)
				fprintf(plainnamestemp,"\03  %d%d     \n",track10,track1);

		fprintf(plainnamestemp,"\03  60     \n");
		fprintf(plainnamestemp,"\03  61     \n");
		fprintf(plainnamestemp,"\03  62     \n");
		fprintf(plainnamestemp,"\03  63     \n");
	}

	fclose(plainnamestemp);

	sendrexx("SG_LOADANNOTEXT \"nsm:plainnamestemp\"");

	updatewindowtitle(ob);

}


void gettnwbuf(OCTABASE ob){
	strcpy(
		tracknamebuf,
		gettrackname(
			ob,
			gettracknamedata2(ob),
			getcurrblock(ob)
		)
	);
}

void settnwbuf(OCTABASE ob){
	settrackname(
		ob,
		tracknamebuf,
		gettracknamedata2(ob),
		0,
		getcurrblock(ob)
	);
	updateallnames(ob);
}

void checkdatas(OCTABASE ob){
	int lokke;

	while(leftvisibletrack>getleftmostvisibletrack(ob)){
		scrollright();
		leftvisibletrack--;
		trackstates[leftvisibletrack]=istrackon(ob,leftvisibletrack);
		inserttext(
			gettrackname_n(ob,leftvisibletrack,blockpos),
			0,
			trackstates[leftvisibletrack]*3
		);
	}

	while(leftvisibletrack<getleftmostvisibletrack(ob)){
		trackstates[leftvisibletrack+numvisibletracks]=istrackon(ob,leftvisibletrack+numvisibletracks);
		scrollleft();
		inserttext(
			gettrackname_n(ob,leftvisibletrack+numvisibletracks,blockpos),
			numvisibletracks-1,
			trackstates[leftvisibletrack+numvisibletracks]*3
		);
		leftvisibletrack++;
	}


	if(getcurrtrack(ob)-getleftmostvisibletrack(ob)>currvisibletrack)
		movecursorleft();
	if(getcurrtrack(ob)-getleftmostvisibletrack(ob)<currvisibletrack)
		movecursorright();


	if(currinum!=getcurrinstrument(ob) || curroctave!=getcurroctave(ob))
		updatewindowtitle(ob);

	for(lokke=leftvisibletrack;lokke<numvisibletracks+leftvisibletrack;lokke++)
		if(trackstates[lokke]!=istrackon(ob,lokke)){
			trackstates[lokke]=istrackon(ob,lokke);
			inserttext(
				gettrackname_n(ob,lokke,blockpos),
				lokke-leftvisibletrack,
				trackstates[lokke]*3
			);
		}


	if(getnumblocks(ob)!=numblocks){

		if(getnumblocks(ob)<numblocks) numblocks=getnumblocks(ob);

		if(strcmp(gettrackname(ob,(UWORD)-2,0),"QNM")) initializenewsong(ob);

		while(getnumblocks(ob)>numblocks){
			if(gettrackname(ob,10,numblocks)==0) addblockplainnames(ob);
			numblocks++;
		}
		updateallnames(ob);
	}


	if(blockpos!=getcurrblock(ob)){
		blockpos=getcurrblock(ob);
		updateallnames(ob);
	}
}

void main(int argc, char **argv){
	char *ver="$VER: tracknameswindow 0.42 (7.8.99) by Kjetil S. Matheussen";

	OCTABASE ob;
	struct Task *mytask;
	int tracknamedata;

	char *result;
	UWORD numtracks;

	if(argc>0) initarguments(argc,argv);

	mytask=FindTask(NULL);

	if((ob=getoctabase())==0) goto exit;

	sendrexx("PL_STOP"); /* Hack to make the isplaing-function work properly. */

	result=sendrexx("WI_ISOPEN MAINCONTROL"); /* Hack to make the curroctave-functions work. */
	if(resultstringfalse(result)){
		sendrexx("WI_OPEN MAINCONTROL");
		sendrexx("WI_CLOSE MAINCONTROL");
	}

	numtracks=getnumtracks(getcurrblockbase(ob));
	sendrexx("ED_SETBLOCKTRACKS TRACKS 63");			/* Hack to get the right width of
																		the editor-window. */

	sendrexx("SG_LOADANNOTEXT \"nsm:plainnames\"");	/* Loads in the tracknamesplainfile. */


	initwindow(
		geteditorTextAttrstruct(ob),
		geteditorwindowtopleft(ob),
		geteditorwindowwidth(ob),
		getnumvisibletracks(ob),
		getscreenfontsize(ob)
	);
	currvisibletrack=getcurrtrack(ob)-getleftmostvisibletrack(ob);
	drawvisibletrack(currvisibletrack,1);

	blockpos=getcurrblock(ob);
	numblocks=0;

	updatewindowtitle(ob);

	updateallnames(ob);
	sendrexxword("ED_SETBLOCKTRACKS TRACKS ",numtracks,"");

	do{

		SetTaskPri(mytask,stoptaskprior);					/* While not playing. */
		do{
			checkdatas(ob);
			tracknamedata=gettracknamedata(ob);

			if(tracknamedata!=STABLE){
				if(tracknamedata<64 && tracknamedata>=leftvisibletrack && tracknamedata<leftvisibletrack+numvisibletracks){
					inserttext(
						gettrackname_n(ob,tracknamedata,blockpos),
						tracknamedata-leftvisibletrack,
						trackstates[tracknamedata]*3
					);
					settracknamedata(ob,STABLE);
				}
				if(tracknamedata==UPDATE) updateallnames(ob);
				if(tracknamedata==GETBUF) gettnwbuf(ob);
				if(tracknamedata==SETBUF) settnwbuf(ob);
				if(tracknamedata==QUITTRACKNAMESWINDOW) goto cleanup;
			}

			Delay(1);
		}while(!isplaying(ob));


		SetTaskPri(mytask,playtaskprior);					/* While playing. */
		do{
			checkdatas(ob);
			tracknamedata=gettracknamedata(ob);

			if(tracknamedata!=STABLE){
				if(tracknamedata<64 && tracknamedata>=leftvisibletrack && tracknamedata<leftvisibletrack+numvisibletracks){
					inserttext(
						gettrackname_n(ob,tracknamedata,blockpos),
						tracknamedata-leftvisibletrack,
						trackstates[tracknamedata]*3
					);
					settracknamedata(ob,STABLE);
				}
				if(tracknamedata==UPDATE) updateallnames(ob);
				if(tracknamedata==GETBUF) gettnwbuf(ob);
				if(tracknamedata==SETBUF) settnwbuf(ob);
				if(tracknamedata==QUITTRACKNAMESWINDOW) goto cleanup;
			}

			Delay(1);
		}while(isplaying(ob));


	}while(1);

cleanup:
	settracknamedata(ob,QUITSTABLE);
	shutdownwindow();
exit:
}

