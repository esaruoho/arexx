/*
	Jumps to the previous highlightened line
	in the current block. If no more
	highlightened lines, it	will jump to the first line.
	This is a highlightening fast function
	too, by the way!

	Made by Kjetil S. Matheussen 14.12.98.

	Update: 14.12.90: Replaced ED_GOTO with
	ED_ADVANCELINE which is much faster.

	This is an example on how to make an
	octamed plug-in with the nsm-system.

	e-mail: kjetilma@ifi.uio.no

	Address:
	Kjetil S. Matheussen
	5423 Sogn Studentby
	0858 Oslo
	Norway
*/

#include "/nsm.h"

void main(){
	OCTABASE ob;
	BLOCKBASE bb;

	UWORD mline,start;

	ob=getoctabase();

	bb=getcurrblockbase(ob);
	mline=getcurrline(ob);
	if (mline==0) goto exit;								/* arexx: if mline=numlines-1 then exit */
	start=mline;

	do{
		mline--;																/* arexx: mline=mline+1 */
	}while(!getlinehighlight(bb,mline) && mline>0);	/* arexx: do until (result | mline=numlines-1 */

	sendrexxword("ED_ADVANCELINE UP ",start-mline,"");						/* arexx: ED_GOTO LINE mline */
exit:

}
