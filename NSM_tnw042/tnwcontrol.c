/*
	Sets the name of the current track and
	a lot of other things.

	Link with annomanno.o, /octacontrol.o
   and /readstr.o to compile.

	Made by Kjetil S. Matheussen 19.12.98.

	Updated: 30.1.99. Changes: Insert track(s) in
	current block didn't work properly. Fixed.

	Updated: 9.3.99. Changes: Option 6 and 7
	read input in hex-notation, now changed to
	read as decimal notation. Possible to copy
	the tracknames of the current block to all
	other blocks.

	Updated: 6.8.99. Changes: Added option 7a,
	"insert a copy of the current block". Rather
	nice function, I think. It does allso set
	the name of the new block automatically.
	If the source-block has the name, "chorus",
	the new block will get the name "chorus part 002".
	And if the source-block has the name, "chorus part 002",
	the new block will get the name "chorus part 003".

	Updated: 7.8.99. Changes: Option 7 and 7a didn't
	copy the tracknames correctly. Should be fixed now,
	I hope.

	e-mail: kjetilma@ifi.uio.no

	Address:
	Kjetil S. Matheussen
	5423 Sogn Studentby
	0858 Oslo
	Norway
*/



#include <string.h>
#include <stdlib.h>
#include "tracknameswindow.h"
#include "/readstr.h"

OCTABASE ob;
char *dosbase,*filehandle;
char string[80];
int stringlen;

UWORD currtrack,currblock,numtracks,numblocks,numlines,numpages;

void setname(void){
	stringlen=strlen(string);
	if(stringlen<10) {
		settrackname(ob,"      ",currtrack,0,currblock);
		settrackname(ob,string,currtrack,4-(stringlen/2),currblock);
	}else{
		settrackname(ob,string,currtrack,0,currblock);
	}
	settracknamedata(ob,currtrack);
}


void setname_1(void){
	writestring(dosbase,filehandle,"New Name will be: ",18);
	readstring(dosbase,filehandle,string,70);
	if(*string!=NULL) setname();
}


char plaintrackname[15];
UWORD block,track;
void inserttrackplain(int trackstoinsert){
	sendrexxword("ED_SETBLOCKTRACKS TRACKS ",trackstoinsert+numtracks,"");

	for(track=63;track>=currtrack+trackstoinsert;track--)
		settrackname(
			ob,
			gettrackname(ob,track-trackstoinsert,block),
			track,
			0,
			block
		);

	for(track=0;track<trackstoinsert;track++){
		sendrexx("RN_INSERTTRACK");
		settrackname(
			ob,
			plaintrackname,
			track+currtrack,
			0,
			block
		);
	}

}


void insert_track_g(void){
	int trackstoinsert=0;

	sprintf(string,"How many tracks (globally from current track): ");
	writestring(dosbase,filehandle,string,strlen(string));
	readstring(dosbase,filehandle,string,70);
	sscanf(string,"%d",&trackstoinsert);
	if(trackstoinsert>0 && trackstoinsert+numtracks<64){

		sprintf(string,"\n\nPlease wait..: %d",trackstoinsert);
		writestring(dosbase,filehandle,string,strlen(string));

		numblocks=getnumblocks(ob);

		for(block=currblock;block<numblocks;block++){
			inserttrackplain(trackstoinsert);
			sendrexx("ED_GOTOBLOCK NEXT");
		}

		sendrexxword("ED_GOTO BLOCK ",currblock,"");

		updatetnw(ob);
	}
}

void insert_track(void){
	int trackstoinsert=0;

	sprintf(string,"How many tracks to insert (in current track): ");
	writestring(dosbase,filehandle,string,strlen(string));
	readstring(dosbase,filehandle,string,70);
	sscanf(string,"%d",&trackstoinsert);
	if(trackstoinsert>0 && trackstoinsert+numtracks<64){

		sprintf(string,"\n\nPlease wait..: %d",trackstoinsert);
		writestring(dosbase,filehandle,string,strlen(string));

		block=currblock;
		inserttrackplain(trackstoinsert);

		updatetnw(ob);
	}
}

void deletetrackname(void){
	for(track=currtrack;track<63;track++)
		settrackname(
			ob,
			gettrackname(ob,track+1,block),
			track,
			0,
			block
		);
	updatetnw(ob);
}

void copytracknamesblockplain(int fromblock,int toblock){
	for(track=0;track<=63;track++)
		settrackname(
			ob,
			gettrackname(ob,track,fromblock),
			track,
			0,
			toblock
		);
}

void copytracknamesblock(void){
	int toblock,lokke;

	sprintf(string,"Which block to copy (\"all\" for all blocks): ");
	writestring(dosbase,filehandle,string,strlen(string));
	readstring(dosbase,filehandle,string,70);
	if(!strcmp("all",string)){
		for(lokke=0;lokke<currblock;lokke++)
			copytracknamesblockplain(currblock,lokke);
		for(lokke=currblock+1;lokke<numblocks;lokke++)
			copytracknamesblockplain(currblock,lokke);
	}else{
		sscanf(string,"%d",&toblock);

		if(toblock>0 && toblock!=currblock && toblock<=numblocks){
			sendrexxword("ED_GOTO BLOCK ",toblock,"");
			copytracknamesblockplain(currblock,toblock);
			updatetnw(ob);
		}
	}
}

void copyblock(void){
	int toblock;

	sprintf(string,"Which block to copy: ");
	writestring(dosbase,filehandle,string,strlen(string));
	readstring(dosbase,filehandle,string,70);
	sscanf(string,"%d",&toblock);

	if(toblock>0 && toblock!=currblock && toblock<=numblocks){
		sendrexx("RN_COPY BLOCK");
		sendrexxword("ED_GOTO BLOCK ",toblock,"");
		sendrexx("RN_PASTE BLOCK");
		copytracknamesblockplain(currblock,toblock);
		updatetnw(ob);
	}
}


void addblockplainnames(void){
	FILE *plainnamestemp;
	int block,track,track10,track1;

	plainnamestemp=fopen("nsm:plainnamestempcontrol","w");

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

	sendrexx("SG_LOADANNOTEXT \"nsm:plainnamestempcontrol\"");

}


void insertblock(void){
	char string2[80]="ED_SETBLOCKNAME \"";

	if(gettrackname(ob,10,numblocks)==0){
		writestring(dosbase,filehandle,"\nPlease wait, initializing new tracknamesblock. ",50);
		addblockplainnames();
		writestring(dosbase,filehandle,"\nFinished! ",11);
	}

	sendrexxword("ED_GOTO BLOCK ",currblock+1,"");

	sendrexxword3(
		"ED_NEWBLOCK INSERT TRACKS ",numtracks,
		" LINES ",numlines,
		" PAGES ",numpages+1,""
	);


	writestring(dosbase,filehandle,"\n\nName of the new block: ",25);
	readstring(dosbase,filehandle,string,50);
	if(*string!=0){
		strcat(string2,string);
		strcat(string2,"\"");
		sendrexx(string2);
	}

	for(block=numblocks;block>currblock;block--)
		copytracknamesblockplain(block-1,block);

	for(track=0;track<64;track++)
		settrackname(
			ob,
			plaintrackname,
			track,
			0,
			currblock+1
		);

	updatetnw(ob);
}

void insertblockandcopy(void){
	char string3[300];
	char *oldname;
	int oldnamelength;
	int part;

	sendrexx("RN_COPY BLOCK");
	sendrexxword("ED_GOTO BLOCK ",currblock+1,"");
	sendrexxword3(
		"ED_NEWBLOCK INSERT TRACKS ",numtracks,
		" LINES ",numlines,
		" PAGES ",numpages+1,""
	);
	sendrexx("RN_PASTE BLOCK");

	for(block=numblocks;block>currblock;block--)
		copytracknamesblockplain(block-1,block);

	copytracknamesblockplain(currblock,currblock+1);
	updatetnw(ob);

	/*name part 000*/
	/*   9876543210*/
	oldname=sendrexxword("ED_GETBLOCKNAME",currblock,"");
	oldnamelength=strlen(oldname);
	if(
		oldname[oldnamelength-8]=='p' &&
		oldname[oldnamelength-7]=='a' &&
		oldname[oldnamelength-6]=='r' &&
		oldname[oldnamelength-5]=='t' &&
		oldname[oldnamelength-4]==' '
	){
		part=atoi(oldname+(oldnamelength-2));
		oldname[oldnamelength-3]=0;
		sprintf(string3,"ED_SETBLOCKNAME \"%s%.3d\"",oldname,part+1);
	}else{
		sprintf(string3,"ED_SETBLOCKNAME \"%s part 002\"",oldname);
	}
	sendrexx(string3);
}

void appendblock(void){
	char string2[80]="ED_SETBLOCKNAME \"";

	sendrexxword3(
		"ED_NEWBLOCK LAST TRACKS ",numtracks,
		" LINES ",numlines,
		" PAGES ",numpages+1,""
	);

	sendrexxword("ED_GOTO BLOCK ",numblocks,"");

	writestring(dosbase,filehandle,"\n\nName of the new block: ",25);
	readstring(dosbase,filehandle,string,50);
	if(*string!=0){
		strcat(string2,string);
		strcat(string2,"\"");
		sendrexx(string2);
	}
}


void resettrackname(void){
	settrackname(
		ob,
		plaintrackname,
		currtrack,
		0,
		currblock
	);
	updatetnw(ob);
}

void deletecurrtracknames(void){
	for(block=currblock+1;block<numblocks;block++)
		copytracknamesblockplain(block,block-1);
	updatetnw(ob);
}

void deleteblock(void){
	sendrexx("ED_DELETEBLOCK");
	deletecurrtracknames();
}

void swaptrack(void){

	if(currtrack<numtracks-1){

		sendrexx("RN_COPY TRACK");

		sendrexx("ED_GOTOTRACK NEXTNOTE");
		sendrexx("RN_SWAP TRACK");

		sendrexx("ED_GOTOTRACK PREVNOTE");
		sendrexx("RN_SWAP TRACK");


		strcpy(string,gettrackname(ob,currtrack,currblock));
		settrackname(
			ob,
			gettrackname(ob,currtrack+1,currblock),
			currtrack,
			0,
			currblock
		);

		settrackname(
			ob,
			string,
			currtrack+1,
			0,
			currblock
		);
		updatetnw(ob);

	}
}

void main(){
	BLOCKBASE bb;

	char *ver="$VER: tnwcontrol 0.42.300199 (7.8.99) by Kjetil S. Matheussen";

	if((ob=getoctabase())==0) goto exit;

	dosbase=opendoslibrary();
	filehandle=openoctacon(dosbase,500,200);

	currtrack=getcurrtrack(ob);
	currblock=getcurrblock(ob);
	numblocks=getnumblocks(ob);
	bb=getblockbase(ob,currblock);
	numtracks=getnumtracks(bb);
	numlines=getnumlines(bb);
	numpages=getnumpages(bb);
	sprintf(plaintrackname,"\03             ");

	if(strcmp(gettrackname(ob,(UWORD)-2,0),"QNM")){
		sendrexx("SG_LOADANNOTEXT \"nsm:plainnames\"");
		updatetnw(ob);
	}

	sprintf(string,"Track %d has the current name: \"%s\"\n\n",currtrack,gettrackname(ob,currtrack,0));
	writestring(dosbase,filehandle,string,strlen(string));

	sprintf(string,"Choose option: (write number and press return)\n\n");
	writestring(dosbase,filehandle,string,strlen(string));

	sprintf(string,"1. Set trackname (default, just write name)\n");
	writestring(dosbase,filehandle,string,strlen(string));

	sprintf(string,"2. Insert track(s) in all blocks from current block\n");
	writestring(dosbase,filehandle,string,strlen(string));

	sprintf(string,"3. Insert track(s) in current block\n");
	writestring(dosbase,filehandle,string,strlen(string));

	sprintf(string,"4. Delete current trackname in current block\n");
	writestring(dosbase,filehandle,string,strlen(string));

	sprintf(string,"5. Copy current block to another block\n");
	writestring(dosbase,filehandle,string,strlen(string));

	sprintf(string,"6. Copy just tracknames of current block to another block\n");
	writestring(dosbase,filehandle,string,strlen(string));

	sprintf(string,"7. Insert New block. \n");
	writestring(dosbase,filehandle,string,strlen(string));

	sprintf(string,"7a. Insert a copy of the current block. \n");
	writestring(dosbase,filehandle,string,strlen(string));

	sprintf(string,"8. Append New block\n");
	writestring(dosbase,filehandle,string,strlen(string));

	sprintf(string,"9. Delete Current block\n");
	writestring(dosbase,filehandle,string,strlen(string));

	sprintf(string,"A. Delete just the tracknames of the current block\n");
	writestring(dosbase,filehandle,string,strlen(string));

	sprintf(string,"B. Delete Last block\n");
	writestring(dosbase,filehandle,string,strlen(string));

	sprintf(string,"C. Swap current track with next\n");
	writestring(dosbase,filehandle,string,strlen(string));

	sprintf(string,"D. Resets the current trackname to default\n");
	writestring(dosbase,filehandle,string,strlen(string));

/*
	sprintf(string,"\n");
	writestring(dosbase,filehandle,string,strlen(string));
	sprintf(string,"\n");
	writestring(dosbase,filehandle,string,strlen(string));
	sprintf(string,"\n");
	writestring(dosbase,filehandle,string,strlen(string));
*/

	sprintf(string,"\n> ");
	writestring(dosbase,filehandle,string,strlen(string));

	readstring(dosbase,filehandle,string,70);


	if(!strcmp(string,"1")){setname_1();goto close;}
	if(!strcmp(string,"2")){insert_track_g();goto close;}
	if(!strcmp(string,"3")){insert_track();goto close;}
	if(!strcmp(string,"4")){block=currblock;deletetrackname();goto close;}
	if(!strcmp(string,"5")){copyblock();goto close;}
	if(!strcmp(string,"6")){copytracknamesblock();goto close;}
	if(!strcmp(string,"7")){insertblock();goto close;}
	if(!strcmp(string,"7a")){insertblockandcopy();goto close;}
	if(!strcmp(string,"8")){appendblock();goto close;}
	if(!strcmp(string,"9")){deleteblock();goto close;}
	if(!strcmp(string,"a") || !strcmp(string,"A") ){deletecurrtracknames();goto close;}
	if(!strcmp(string,"b") || !strcmp(string,"B") ){sendrexx("ED_DELETEBLOCK LAST");goto close;}
	if(!strcmp(string,"c") || !strcmp(string,"C") ){swaptrack();goto close;}
	if(!strcmp(string,"d") || !strcmp(string,"D") ){resettrackname();goto close;}

/*
	if(!strcmp(string,"C")){goto close;}
	if(!strcmp(string,"D")){goto close;}
*/

	if(*string!=NULL) setname();

close:
	closefile(dosbase,filehandle);
	closedoslibrary(dosbase);

exit:
}


