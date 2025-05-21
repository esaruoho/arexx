Short:        Inserts or deletes lines fast in Octamed.
Author:       kjetilma@ifi.uio.no (Kjetil S. Matheussen)
Uploader:     kjetilma ifi uio no (Kjetil S  Matheussen)
Type:         mus/misc
Version:      0.74.190299
Replaces:     mus/misc/NSM_ins*
Requires:     The NSM-package
Architecture: m68k-amigaos

DESCRIPTION

        Inserts or deletes <n> number of lines on all the tracks
        at the current cursorline-position. Does allso
        update the length of the block to <oldlength>+<n>
        and update the highlightened lines to the new
        positions.
 
        If you are just going to insert or delete one line, the
        "RN_INSERTLINE" and "RN_DELETELINE" commands are about
        just as fast as the plug-in. But with more lines to
        delete/insert, the plug-ins gets exponential faster.
 
        Recommended shortcut: Shift-return.
 
        Made by Kjetil S. Matheussen.


        Updated: 19.2.99. Changes: Uses the new functions in
        NSM; "sethighlightline" and "unsethighlightline", rewritten
        the delete-rutine, and fixed a bug. The plug-in is now many
        thousands times faster than previous versions.
 
        Updated: 8.1.99. Changes: Can delete lines too, and
        Con-window allways opens at the octamed-screen.
 
        First version: 15.12.98.



CONTACT
	e-mail: kjetilma@ifi.uio.no

	Address:
	Kjetil S. Matheussen
	5423 Sogn Studentby
	0858 Oslo
	Norway

	nsm-homepage: http://www.stud.ifi.uio.no/~kjetilma/nsm/
