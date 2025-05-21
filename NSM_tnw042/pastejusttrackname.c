/*
	Pastes the trackname in the tracknamebuffer
	to the current track.

	Link with annomanno.o and /octacontrol.o

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

	UWORD currtrack,currblock;

	if((ob=getoctabase())==0) goto exit;

	currtrack=getcurrtrack(ob);

	settracknamedata2(ob,currtrack);
	settracknamedata(ob,SETBUF);


exit:
}


