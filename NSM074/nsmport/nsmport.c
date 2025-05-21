/*
					nsmport
				by Kjetil S. Matheussen.

This is the official port-example from commodore
with a few changes.

	e-mail: kjetilma@ifi.uio.no

	Address:
	Kjetil S. Matheussen
	5423 Sogn Studentby
	0858 Oslo
	Norway


Commodore-comments:
port1.c - Execute me to compile with SAS C 5.10
LC -b1 -cfistq -v -y -j73 port1.c
Blink FROM LIB:c.o,port1.o TO port1 LIBRARY LIB:LC.lib,LIB:Amiga.lib
quit

*/

#include <exec/types.h>
#include <exec/ports.h>
#include <dos/dos.h>
#include <clib/exec_protos.h>
#include <clib/alib_protos.h>
#include <stdio.h>

#ifdef LATTICE
int CXBRK(void) { return(0); }  /* Disable Lattice CTRL-C handling */
int chkabort(void) {return(0);}
#endif

struct NSMMessage {
    struct Message nsm_Msg;
    WORD           *Octa_address;
};

void main(int argc, char **argv)
{
	 char *ver="$VER: nsmport 0.70 (09.12.99) by Kjetil S. Matheussen";

    struct MsgPort *nsmport;
    struct NSMMessage *nsmmsg;
    ULONG portsig, usersig, signal;
    BOOL ABORT = FALSE;

		WORD		*Octa_address_local=0;			/* This is the address in Octamed that NSM use. */

    if (nsmport = CreatePort("nsmport", 0))
    {
        portsig = 1 << nsmport->mp_SigBit;       /* Give user a `break' signal. */
        usersig = SIGBREAKF_CTRL_C;

        printf("nsmport successfully started. Now execute octamed1.03c.\n");
        do
        {                                                 /* port1 will wait forever and reply   */
            signal = Wait(portsig | usersig);             /* to messages, until the user breaks. */

                                   /* Since we only have one port that might get messages we     */
            if (signal & portsig)  /* have to reply to, it is not really necessary to test for   */
            {                      /* the portsignal. If there is not message at the port, nsmmsg */

               while(nsmmsg = (struct NSMMessage *)GetMsg(nsmport))        /* simply will be NULL. */
               {

							if(nsmmsg->Octa_address==0){
										nsmmsg->Octa_address=Octa_address_local;
							}else{
      			              	Octa_address_local=nsmmsg->Octa_address;       /* Since we have not replied yet to the owner of    */
							}

      		         ReplyMsg((struct Message *)nsmmsg);
         		}
        		}

		     	if (signal & usersig)                                    /* The user wants to abort. */
   			{
         		while(nsmmsg = (struct NSMMessage *)GetMsg(nsmport))    /* Make sure port is empty. */
               	ReplyMsg((struct Message *)nsmmsg);
          		ABORT = TRUE;
     			}
			}
		  while (ABORT == FALSE);
 		    DeletePort(nsmport);
	  }
  else printf("Couldn't create 'nsmport'\n");
}
