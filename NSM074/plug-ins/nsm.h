/* nsm.h V0.74
	Written by Kjetil S. Matheussen 19.2.99
*/


#include <stdio.h>
#include <exec/types.h>

typedef UWORD *OCTABASE;
typedef WORD *BLOCKBASE;
typedef char *SAMPLEBASE;		/* This three are defined different, so that the programmer
											gets a warning when he/she/it has used the wrong
											variable-type. */

#define NOTE 0
#define INUM 1
#define CMDNUM 2
#define CMDLVL 3					/* For the getmed and setmed functions. */

#define updateeditor(a) if(getlinehighlight(getcurrblockbase(a),0)){sendrexx("ED_HIGHLIGHTLINE 0 ON");}else{sendrexx("ED_HIGHLIGHTLINE 0 OFF");}

#define getcurrblockbase(a) getblockbase(a,getcurrblock(a))

#define SRT sprintf
#define TRS );result=sendrexx(send
#define VAR_UWORD );sscanf(sendrexx(send),"%d",& /*This are quite old,
																   but can still be useful. */

#define WORDLENGTHSTRING "      "
#define wordintostring(a,b,c) \
	 wordintostring_noconst(a##WORDLENGTHSTRING##c,sizeof(a),b)

#define wordintostring2(a,b,c,d,e)\
	wordintostring_noconst( \
		wordintostring_noconst( \
			a##WORDLENGTHSTRING##c##WORDLENGTHSTRING##e,sizeof(a),b \
		) \
		,sizeof(a##WORDLENGTHSTRING##c),d \
	)

#define wordintostring3(a,b,c,d,e,f,g)\
	wordintostring_noconst( \
		wordintostring_noconst( \
			wordintostring_noconst( \
				a##WORDLENGTHSTRING##c##WORDLENGTHSTRING##e##WORDLENGTHSTRING##g,sizeof(a),b \
			) \
			,sizeof(a##WORDLENGTHSTRING##c),d \
		) \
		,sizeof(a##WORDLENGTHSTRING##c##WORDLENGTHSTRING##e),f \
	)

#define wordintostring4(a,b,c,d,e,f,g,h,i)\
	wordintostring_noconst( \
		wordintostring_noconst( \
			wordintostring_noconst( \
				wordintostring_noconst( \
					a##WORDLENGTHSTRING##c##WORDLENGTHSTRING \
					##e##WORDLENGTHSTRING##g##WORDLENGTHSTRING##i,sizeof(a),b \
				) \
				,sizeof(a##WORDLENGTHSTRING##c),d \
			) \
			,sizeof(a##WORDLENGTHSTRING##c##WORDLENGTHSTRING##e),f \
		) \
		,sizeof(a##WORDLENGTHSTRING##c##WORDLENGTHSTRING##e##WORDLENGTHSTRING##g),h \
	)

#define wordintostring5(a,b,c,d,e,f,g,h,i,j,k)\
	wordintostring_noconst( \
		wordintostring_noconst( \
			wordintostring_noconst( \
				wordintostring_noconst( \
					wordintostring_noconst( \
						a##WORDLENGTHSTRING##c##WORDLENGTHSTRING \
						##e##WORDLENGTHSTRING##g##WORDLENGTHSTRING \
						##i##WORDLENGTHSTRING##k,sizeof(a),b \
					) \
					,sizeof(a##WORDLENGTHSTRING##c),d \
				) \
				,sizeof(a##WORDLENGTHSTRING##c##WORDLENGTHSTRING##e),f \
			) \
			,sizeof(a##WORDLENGTHSTRING##c##WORDLENGTHSTRING##e##WORDLENGTHSTRING##g),h \
		) \
		,sizeof(a##WORDLENGTHSTRING##c##WORDLENGTHSTRING \
		##e##WORDLENGTHSTRING##g##WORDLENGTHSTRING##i),j \
	)

#define sendrexxword(a,b,c) sendrexx(wordintostring(a,b,c))
#define sendrexxword2(a,b,c,d,e) sendrexx(wordintostring2(a,b,c,d,e))
#define sendrexxword3(a,b,c,d,e,f,g) sendrexx(wordintostring3(a,b,c,d,e,f,g))
#define sendrexxword4(a,b,c,d,e,f,g,h,i) sendrexx(wordintostring4(a,b,c,d,e,f,g,h,i))
#define sendrexxword_noconst(a,b,c) sendrexx(wordintostring_noconst(a,b,c))
#define sendrexxRI(a) stringtoint(sendrexx(a))
#define resultstringfalse(a) (a[0]=='0' && a[1]==0)
#define resultstringtrue(a) (a[0]!='0' || a[1]!=0)

extern BLOCKBASE __asm getblockbase(register __a0 OCTABASE octabase,register __d6 int block);
extern char __asm *sendrexx(register __d6 char *rexxcommand);
extern int __asm freeresult(void);
extern OCTABASE __asm getoctabase(void);
extern int __asm setnote(register __a0 BLOCKBASE blockbase,register __d1 UWORD track, register __d2 UWORD line, register __d0 UWORD note);
extern UWORD __asm getnote(register __a0 BLOCKBASE blockbase,register __d1 UWORD track, register __d2 UWORD line);
extern int __asm setinum(register __a0 BLOCKBASE blockbase,register __d1 UWORD track, register __d2 UWORD line, register __d0 UWORD note);
extern UWORD __asm getinum(register __a0 BLOCKBASE blockbase,register __d1 UWORD track, register __d2 UWORD line);
extern int __asm setcmdnum(register __a0 BLOCKBASE blockbase,register __d1 UWORD track, register __d2 UWORD line, register __d3 UWORD page, register __d0 UWORD note);
extern UWORD __asm getcmdnum(register __a0 BLOCKBASE blockbase,register __d1 WORD track, register __d2 UWORD line, register __d3 UWORD page);
extern int __asm setcmdlvl(register __a0 BLOCKBASE blockbase,register __d1 UWORD track, register __d2 UWORD line, register __d3 UWORD page, register __d0 UWORD note);
extern UWORD __asm getcmdlvl(register __a0 BLOCKBASE blockbase,register __d1 UWORD track, register __d2 UWORD line, register __d3 UWORD page);
extern int __asm getmed(register __d4 int edpart,register __a0 BLOCKBASE blockbase,register __d1 UWORD track, register __d2 UWORD line, register __d3 UWORD page);
extern int __asm setmed(register __d4 int edpart,register __a0 BLOCKBASE blockbase, register __d1 UWORD track, register __d2 UWORD line, register __d3 UWORD page, register __d0 UWORD data);

extern char  __asm *getblockname(register __a0 BLOCKBASE blockbase);
extern UWORD __asm getnumlines(register __a0 BLOCKBASE blockbase);
extern UWORD __asm getnumtracks(register __a0 BLOCKBASE blockbase);
extern UWORD __asm getnumpages(register __a0 BLOCKBASE blockbase);
extern UWORD __asm getlinehighlight(register __a0 BLOCKBASE blockbase,register __d1 UWORD line);
extern __asm setlinehighlight(register __a0 BLOCKBASE blockbase,register __d0 UWORD line);
extern __asm unsetlinehighlight(register __a0 BLOCKBASE blockbase,register __d0 UWORD line);

extern UWORD __asm isranged(register __a0 OCTABASE octabase);
extern UWORD __asm getrangeendline(register __a0 OCTABASE octabase);
extern UWORD __asm getrangeendtrack(register __a0 OCTABASE octabase);
extern UWORD __asm getrangestartline(register __a0 OCTABASE octabase);
extern UWORD __asm getrangestarttrack(register __a0 OCTABASE octabase);
extern UWORD __asm getcurrtrack(register __a0 OCTABASE octabase);
extern UWORD __asm getcurrline(register __a0 OCTABASE octabase);
extern UWORD __asm getcurrblock(register __a0 OCTABASE octabase);
extern UWORD __asm getcurrpage(register __a0 OCTABASE octabase);
extern UWORD __asm getsubpos(register __a0 OCTABASE octabase);
extern UWORD __asm getnumblocks(register __a0 OCTABASE octabase);
extern int __asm istrackon(register __a0 OCTABASE octabase,register __d1 UWORD track);
extern int __asm isplaying(register __a0 OCTABASE octabase);
extern UWORD __asm getcurroctave(register __a0 OCTABASE);

extern SAMPLEBASE __asm getsamplebase(register __a0 OCTABASE octabase,register __d1 UWORD sample);
extern SAMPLEBASE __asm getcurrsamplebase(register __a0 OCTABASE octabase);

extern LONG __asm getsamplelength(register __a0 SAMPLEBASE samplebase);
extern UWORD __asm getsample(register __a0 SAMPLEBASE samplebase,register __d1 ULONG offset);
extern void __asm setsample(register __a0 SAMPLEBASE samplebase,register __d6 ULONG offset,register __d0 WORD value);

extern BYTE __asm getfinetune(register __a0 OCTABASE octabase,register __d1 UWORD samplenumber);
extern UBYTE __asm gethold(register __a0 OCTABASE octabase,register __d1 UWORD samplenumber);

extern UBYTE __asm getdecay(register __a0 OCTABASE octabase,register __d1 UWORD samplenumber);
extern BYTE __asm getdefaultpitch(register __a0 OCTABASE octabase,register __d1 UWORD samplenumber);
extern int __asm getextendedpreset(register __a0 OCTABASE octabase,register __d1 UWORD samplenumber);
extern UBYTE __asm getmidichannel(register __a0 OCTABASE octabase,register __d1 UWORD samplenumber);
extern UWORD __asm getmidipreset(register __a0 OCTABASE octabase,register __d1 UWORD samplenumber);
extern UWORD __asm getcurrinstrument(register __a0 OCTABASE octabase);
extern char __asm *getinname(register __a0 OCTABASE octabase,register __d1 UWORD samplenumber);
extern int __asm getsuppressnoteonoff(register __a0 OCTABASE octabase,register __d1 UWORD samplenumber);
extern BYTE __asm gettranspose(register __a0 OCTABASE octabase,register __d1 UWORD samplenumber);
extern BYTE __asm getvolume(register __a0 OCTABASE octabase,register __d1 UWORD samplenumber);
extern ULONG __asm getloopstart(register __a0 OCTABASE octabase,register __d1 UWORD samplenumber);
extern ULONG __asm getlooplength(register __a0 OCTABASE octabase,register __d1 UWORD samplenumber);
extern int __asm getloopstate(register __a0 OCTABASE octabase,register __d1 UWORD samplenumber);
extern int __asm getlooppingpong(register __a0 OCTABASE octabase,register __d1 UWORD samplenumber);
extern int __asm getdisable(register __a0 OCTABASE octabase,register __d1 UWORD samplenumber);

extern char __asm *wordintostring_noconst(register __a0 char *inputstring,register __d1 int pos,register __d6 WORD number);
extern int __asm stringtoint(register __d6 char *string);



