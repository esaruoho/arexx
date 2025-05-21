#include <exec/types.h>

extern APTR __asm opendoslibrary(void);
extern APTR __asm openfile(register __a6 char *dosbase,register __d1 char *filestring,register __d2 LONG accessMode);
extern APTR __asm openoctacon(register __a5 char *dosbase,register __d3 UWORD width,register __d2 UWORD height);
extern void __asm closefile(register __a6 char *dosbase,register __d1 char *filehandle);
extern void __asm readstring(register __a6 char *dosbase,register __d1 char *filehandle,register __d2 char *buffer,register __d3 int length);
extern void __asm writestring(register __a6 char *dosbase,register __d1 char *filehande,register __d2 char *string,register __d3 int length);
extern void	__asm closedoslibrary(register __a1 char *dosbase);
