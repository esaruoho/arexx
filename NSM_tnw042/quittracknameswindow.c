/* A small plug-in that tells the tracknameswindow
   to quit. Link with annomanno.o and /octacontrol.o.

   Made by Kjetil S. Matheussen 1999.
*/




#include "tracknameswindow.h"

void main(void){
	OCTABASE ob;

	if((ob=getoctabase())==0) goto exit;

	if(strcmp(gettrackname(ob,0,0),"QNM"))
		sendrexx("SG_LOADANNOTEXT \"nsm:plainnames\"");

	settracknamedata(ob,65);

exit:
}


