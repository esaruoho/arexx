/*
	Lets you specify the name, midichannel,
	midipreset and volume on the current
	instrument without using the mouse.
	If you don't want to change the variable,
	just press return.

	Made by Kjetil S. Matheussen 26.2.99.
	Updated 1.3.99. Changes: Set name too.

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

	UWORD instrument;
	int channel,preset,volume;

	char *dosbase,*filehandle;
	char string[160];
	char sendstring[50];

	if((ob=getoctabase())==0) goto exit;			/* Allways include this line first in
																	your plug-ins. */

	dosbase=opendoslibrary();
	filehandle=openoctacon(dosbase,450,70);

	instrument=getcurrinstrument(ob);

	sprintf(
		string,
		"Name: %s\nChannel: %d - Preset: %d - Volume: $%x\n",
		getinname(ob,instrument),
		getmidichannel(ob,instrument),
		getmidipreset(ob,instrument),
		getvolume(ob,instrument)
	);
	writestring(dosbase,filehandle,string,strlen(string));

	writestring(dosbase,filehandle,"New Name: ",10);
	readstring(dosbase,filehandle,string,70);
	if(*string!=0 && strlen(string)<38){
		sprintf(sendstring,"IN_SETNAME %s",string);
		sendrexx(sendstring);
	}

	writestring(dosbase,filehandle,"New Channel: ",14);
	readstring(dosbase,filehandle,string,70);
	if(*string!=0){
		sscanf(string,"%d",&channel);
		if(channel>=0 && channel<17)
			sendrexxword("IN_SETMIDICHANNEL ",channel,"");
	}

	writestring(dosbase,filehandle,"New Preset: ",12);
	readstring(dosbase,filehandle,string,70);
	if(*string!=0){
		sscanf(string,"%d",&preset);
		if(preset>=0 && preset<=2800)
			sendrexxword("IN_SETMIDIPRESET ",preset,"");
	}

	writestring(dosbase,filehandle,"New Volume: $",14);
	readstring(dosbase,filehandle,string,70);
	if(*string!=0){
		sscanf(string,"%x",&volume);
		if(volume>=0 && volume<=0x40)
			sendrexxword("IN_SETVOLUME ",volume,"");
	}


close:
	closefile(dosbase,filehandle);
	closedoslibrary(dosbase);

exit:
}
