Short:        New plug-in system for Octamed. Not arexx
Author:       kjetilma@ifi.uio.no (Kjetil S. Matheussen)
Uploader:     kjetilma ifi uio no (Kjetil S  Matheussen)
Type:         mus/misc
Version:      0.74
Replaces:     mus/misc/NSM073.lha
Architecture: m68k-amigaos

DESCRIPTION
	A new plug-in system for Octamed Soundstudio.
	Lets you read and write to the memory directly
	instead of using the slow arexx-system. Plug-ins
	written with this system are some hundred thousand
	times faster than using arexx. (or something like that. :)
	Around 72 assembler-functions and c-macros are included
	in the package.

	You allso need to install this package if you
	want to use NSM plug-ins, like the tracknameswindow.



CONTENTS

ide: nsm>lha NSM073.lha 
 PERMSSN  UID GID    SIZE  RATIO     STAMP    NAME
----------------- ------- ------ ------------ --------------------
[generic]           10552  40.8% Jan  8 01:25 nsm/nsm.doc
[generic]            6108  65.7% Dec  9 21:52 nsm/nsmport/nsmport
[generic]            2678  44.5% Jan  7 00:08 nsm/nsmport/nsmport.c
[generic]            1708  55.4% Dec 11 06:03 nsm/plug-ins/markrange/markrange
[generic]            1413  50.1% Dec 10 03:56 nsm/plug-ins/markrange/markrange.c
[generic]             118  71.1% Dec 10 03:10 nsm/plug-ins/markrange/SCOPTIONS
[generic]             711  30.0% Jan  6 01:41 nsm/plug-ins/readstr.h
[generic]             532  71.8% Jan  6 04:42 nsm/plug-ins/readstr.o
[generic]           11332  61.6% Dec 11 08:17 nsm/plug-ins/cmdfill/cmdfill
[generic]            4001  35.7% Dec 11 06:16 nsm/plug-ins/cmdfill/cmdfill.c
[generic]            1914  44.6% Dec 11 06:17 nsm/plug-ins/cmdfill/cmdfill.doc
[generic]           20840  17.8% Jan  8 01:17 nsm/plug-ins/nsm.autodoc
[generic]            8326  17.0% Jan  6 04:48 nsm/plug-ins/nsm.h
[generic]           16384  24.7% Jan  7 05:23 nsm/plug-ins/octacontrol.a
[generic]            2702  39.5% Jan  6 04:44 nsm/plug-ins/readstr.a
[generic]             696  66.6% Dec 14 17:19 nsm/plug-ins/highlight/nexthighlight
[generic]             668  66.6% Dec 15 02:21 nsm/plug-ins/highlight/prevhighlight
[generic]             995  57.7% Dec 14 16:51 nsm/plug-ins/highlight/prevhighlight.c
[generic]             120  70.8% Dec  9 14:28 nsm/plug-ins/highlight/SCOPTIONS
[generic]            3044  49.3% Jan  7 05:27 nsm/plug-ins/octacontrol.o
[generic]            1560  44.5% Dec 10 01:53 nsm/plug-ins/flip/flip.c
[generic]            2280  55.8% Dec 11 05:54 nsm/plug-ins/flip/flipblock
[generic]             118  71.1% Dec  9 14:41 nsm/plug-ins/flip/SCOPTIONS
[generic]            1054  55.4% Dec 14 04:30 nsm/plug-ins/highlight/nexthighlight.c
[generic]            5215  37.1% Dec 14 16:49 nsm/plug-ins/highlight/smallocta.a
[generic]             716  64.6% Dec 14 16:49 nsm/plug-ins/highlight/smallocta.o
[generic]            2712  50.9% Dec  9 14:21 nsm/patch/octapatch
[generic]            2677  40.7% Dec  9 14:21 nsm/patch/octapatch.e
[generic]            2840  34.7% Dec 11 06:24 nsm/patch/octapatch.s
[generic]             160  97.5% Dec  9 12:58 nsm/patch/octapatch12
[generic]              12 100.0% Nov 28 03:46 nsm/patch/octapatch3
[generic]               8 100.0% Nov 28 18:46 nsm/patch/octapatch4
[generic]            1996  59.8% Dec 12 14:49 nsm/plug-ins/flip/flip
[generic]            1456  47.3% Dec 11 05:54 nsm/plug-ins/flip/flipblock.c
[generic]            1038  53.8% Dec 11 14:47 nsm/nsm_short.usage
----------------- ------- ------ ------------ --------------------
 Total   35 files  118684  38.4% Jan 13 18:12

-The Patch-directory contains the patch you need to run on
 your octamed-file.
-The nsmport-directory contains a port-program you have to start
 before running octamed.
-The plug-ins directory contains four useful plug-ins.
 1. Flip and flipblock. Turns your block, range or track upside down.
    New melodies to your music.
 2. Nexthighlight and Prevhighlight. Sets the cursor at the next or
    previous highlightened line at hyperspeed. Very usefull.
 3. Markrange. Marks the range in octamed just by using the keyboard.
    A major speed-up.
 4. cmdfill. Fills up the track under the cursor with spesified parameters.
    This one you will use a lot.
-All sources are ofcourse provided.



CONTACT
	Kjetil S. Matheussen
	5423 Sogn Studentby
	0858 Oslo
	Norway

	e-mail: kjetilma@ifi.uio.no

	nsm-homepage: http://www.stud.ifi.uio.no/~kjetilma/nsm/
	octamed-homepage: http://www.octamed.co.uk/
