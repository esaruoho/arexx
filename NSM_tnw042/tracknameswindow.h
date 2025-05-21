

/* Main header-file for tracknameswindow V0.3.
	Made by Kjetil S. Matheussen 1998.
*/




#include <exec/types.h>
#include <dos/dos.h>
#include <clib/exec_protos.h>
#include <clib/alib_protos.h>
#include <stdio.h>

#include <clib/graphics_protos.h>
#include <clib/dos_protos.h>

extern struct GfxBase *GfxBase;


#ifdef LATTICE
int CXBRK(void) { return(0); }  /* Disable Lattice CTRL-C handling */
int chkabort(void) {return(0);}
#endif


#include <string.h>
#include "/nsm.h"

extern UWORD __asm getcurroctave(register __a0 OCTABASE);
extern UWORD __asm geteditorwindowtopleft(register __a0 OCTABASE octabase);
extern UWORD __asm geteditorwindowwidth(register __a0 OCTABASE octabase);
extern int __asm getnumvisibletracks(register __a0 OCTABASE octabase);
extern UWORD __asm getscreenfontsize(register __a0 OCTABASE octabase);
extern char __asm *geteditorTextAttrstruct(register __a0 OCTABASE octabase);
extern int __asm getleftmostvisibletrack(register __a0 OCTABASE octabase);
extern int __asm gettracknamedata(register __a0 OCTABASE octabase);
extern void __asm settracknamedata(register __a0 OCTABASE octabase,register __d2 UBYTE data);
extern void __asm settrackname(register __a0 OCTABASE octabase,register __a1 char *string,register __d1 UWORD track,register __d2 int placement);
extern char __asm *gettrackname(register __a0 OCTABASE octabase,register __d1 UWORD track);
extern void __asm updatetrackwindow(void);

extern void inserttext(char *trackname,int pos,int pen);
extern void drawvisibletrack(int pos,int pen);
extern void movecursorright(void);
extern void movecursorleft(void);
extern void scrollleft(void);
extern void scrollright(void);
extern void showinumname(char *name);
extern void initwindow(
	char *editfontTextAttrstruct,
	UWORD edittopleft,
	UWORD editwidth,
	int numvisibletracks,
	UWORD screenfontYsize
);
extern void shutdownwindow(void);

