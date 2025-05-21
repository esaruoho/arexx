/*
	Copies the current trackname to the tracknamebuffer.

	Link with annomanno.o and /octacontrol.o

	Recommended shortcut: Alt+c

	Made by Kjetil S. Matheussen 9.3.99.

	e-mail: kjetilma@ifi.uio.no

	Address:
	Kjetil S. Matheussen
	5423 Sogn Studentby
	0858 Oslo
	Norway
*/



#include "tracknameswindow.h"

void main(void){
	OCTABASE ob;

	UWORD currtrack;

	if((ob=getoctabase())==0) goto exit;

	currtrack=getcurrtrack(ob);

	settracknamedata2(ob,currtrack);
	settracknamedata(ob,GETBUF);


exit:
}


