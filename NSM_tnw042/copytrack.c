/*
	Copies the current track and trackname.

	Link with annomanno.o, /octacontrol.o
   and /readstr.o.

	Recommended shortcut: Alt+c

	Made by Kjetil S. Matheussen 9.1.99.

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

	sendrexx("RN_COPY TRACK");
	settracknamedata2(ob,currtrack);
	settracknamedata(ob,GETBUF);


exit:
}


