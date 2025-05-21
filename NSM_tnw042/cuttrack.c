/*
	Cuts the current track, and copies
	the current trackname.

	To cut the current trackname, press
	'd'+return in the tnwcontrol plug-in.

	(Can not be done in this plug-in because
	there isn't any handshake-function yet.)

	Recommended shortcut: Alt+x

	Link with annomanno.o, /octacontrol.o
   and /readstr.o.

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

	sendrexx("RN_CUT TRACK");
	settracknamedata2(ob,currtrack);
	settracknamedata(ob,GETBUF);

exit:
}


