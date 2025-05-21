

			NSM - The alternative plug-in system for Octamed.

			Written by Kjetil S. Matheussen 1998-1999.
			Current version: 0.74.


INTRODUCTION:
			Some months ago, I started to look at the arexx-
			system of Octamed Soundstudio for the amiga. I soon
			realised that it was extremely powerfull, and that I
			would use it a lot in the future. But there was one
			major drawback on it, and that was the speed. Even
			if I had bought an 060, the responce-time would be
			awful, so I started peeking and leeking around in the memory
			trying to find out if I in some way could read and
			write the data directly. And the result of that is
			is this new plug-in system. It can not do everything
			that the arexx-system does, but lucky enough, there
			are some functions that let you send octarexx-messages
			to the OCTAREXX-port, and then you can do everything!
			There are around 70 assembler-functions and c-macros
			you can use, so the use of octarexx-commands
			should be very little.

			I have found out that the nsm plug-ins are about
			200.000 (!!!!) times faster than the arexx-scripts
			doing just the same. Plug-ins that only contains
			sendrexx-commands (very rare, I suppose) (the
			commands that sends an octarexx-command to the
			OCTAMED_REXX-port) are about 30% faster than
			an arexx-script doing just the same.


USAGE
			A better description lies in the nsm_short.usage-file,
			but a more detailed usage-description comes here:

			1. Start the nsm-port. Put the following line into
			your user-startup (or startup-sequence) file:
			Run >NIL: (path)/nsm/nsmport/nsmport

			2. Patch Octamed Soundstudio 1.03c. 1.03c is the only
			version that you can use the nsm plug-ins with.
			The patch should be quite safe, but if you don't
			trust me on that; make a copy before you patch!
			run "nsm/patch/octapatch <octamed>"

			3. Make a directory in RAM:, and assign it as NSM:
			After that, copy your plug-ins into that directory.
			This increase the response-time on the plug-ins a lot.
			You could allso make the plug-ins resident, but it
			doesn't seems like the launch-system in octamed support
			resident programs, or something.
			Insert the following lines into your user-startup file
			(or startup-sequence):
			"
			makedir ram:NSM
			assign NSM: "ram:NSM"
			copy dh2:nsm/plug-ins/#?/~(#?.#?|SCOPTIONS) nsm:
			"
			Reset your amiga.

			4. Start octamed (the one you patched). Go to the settings-
			menu, and choose "Keyboard Shortcuts". Add your plug-ins
			the same way as with your old arexx-scripts, except that
			instead of choosing "Execute Arexx-file" in the Action-box,
			choose "Launch Program" instead.


PROBLEMS
			1. When you try to patch, you get the following message:
			"This is not the right version of Octamed Soundstudio 1.03c
			 Excpected 246696 bytes, found 443596."
			This means that you try to patch the uncrunched version of
			Octamed Soundstudio 1.03c. Earlier this version was submitted
			on the homepage of octamed (http://www.octamed.co.uk), but
			now they have changed the archive. It's still the same program,
			but packed to save some bytes. Ok, now do two things. 1. Download
			the packed version from the octamed homepage. 2. (optional, but
			recommended) Mail me your unpacked version of Octamed 1.03c so I
			can make a patch for that version too. I had that version before,
			but I managed to destroy it.

			2. The patched version of octamed crashes!
			Oops! that is not supposed to happen. Please mail me your configuration,
			snoopdos-log, your octamed-file, when it crashes etc. (Note: I have
			never discovered this happening, and don't excpect it to happen for
			you either. But you never know...)

			3. None of the plug-ins are working. 
			If you are shure that you have started the nsmport, and running
			the patched version of octamed (you can check that by looking
			at the size. If octamed is 246856 bytes long, it is patched. If it
			is 246696 bytes long, its not patched.), send me your configuration
			and I will answer you as fast as possible. And if you are a beginner
			to the amiga, it would may be smarter to ask on a newsgroup instead.

BUGS
			1. The isplaying-function doesn't allways work.

TODO
			1. Make a shared library out of the assembler source-code.
			2. Make an amigaguide-file from the "autodoc"-file.
			3. Update the nsm-system to work with OSSV2 when that version
			   comes.
			4. Write a better documentation.
			5. Write an installer-script.
			6. Write some more plug-ins. (thats for shure, I will do, for
			   certain)
			7. Write the gettype-functions for instruments.

			Please feel free to do this things, if you want. And send it
			to me, and I will (ofcourse) credit you. If there are other
			things you think are missing, feel free to do it.



COMPATIBILITY
			Ofcourse, This system will
			only work with the ONE program, and that is
			octamed soundstudio 1.03c (latest version of
			octamed. I guess we won't see a new version of
			octamed on a long time yet.). But, as long
			as you distribute your sources with your
			plug-ins, it will allways be possible to
			use them in the future. Why? Because you
			(or someone else) only have to recompile
			when a new version of octamed comes out.
			I will ofcourse update the archive when
			new versions of octamed comes out. (Whenever
			that happens, I bet we wont see a new version
			of octamed on a very long time yet.)

			But ok. To recompile all the plug-ins for
			each new release of octamed is a little bit stupid.
			Therefore, what really has to be done, is to
			make a shared library out of the assembler-
			source. If anyone does this, the
			compatibility with future versions should
			be very safe. I am not very capable of doing
			those library-stuff things, and as long as I
			am the only one supporting this system right
			now, I have no motivation for doing it. But
			if people start sending me plug-ins, I will
			absolutely consider making a shared library
			for it. Should not be too hard...

			But; you may think that "updating for new
			versions" is not necesarry that easy. And yes,
			you are right. We now know very little about
			how OSS V2 will look. But it should be safe
			to presume that all the old REXX-commands
			will still work on the new versions. And then,
			if it seems to be extremely difficult to find
			out how to make that and that command for
			the new versions in the library-file, its just
			replacing them with the rexx-commando
			doing just the same until someone
			finds out how to implement the
			function directly. Allso, if this system gets
			popular, I really hope that the
			new developers of octamed will support
			it in some way. (but, well, we will have to
			see about that one. :)


CHANGES
			Changes from V0.73b:
			1. Included the following functions:
			   - Setlinehiglight
			   - Unsetlinehighlight

			Changes from V0.73:
			1. Updated the manual.

			Changes from V0.72:
			1. Added the following functions:
			getcurroctave(OCTABASE octabase)

			2. Fixed a bug in the following functions:
			getfinetune
			gethold
			getdecay
			getdefaultpitch
			getextendedpreset
			getmidichannel
			getmidipreset
			getcurrinstrument
			getsuppressnoteonof
			gettranspose
			getvolume
			getloopstart
			getlooplength
			getloopstate
			getlooppingpong
			getdisable


			Changes from V0.71:
			1. Added the following functions:
			getnumblocks(OCTABASE octabase). This function did
			actually exsist in the octacontrol.a-file allready,
			but not in the header-file and in the autodoc-file.

			istrackon(OCTABASE octabase,WORD track). Does the
			same as the octarexx-function.

			isplaying(OCTABASE octabase). Returns 1 if octamed
			is playing, 0 if not. (beware that this doesn't
			allways work, so if you want to be absolutely shure,
			use the octarexx-isplaying function instead.)

			2. Fixed the getinname-function.


			Changes from V0.70:
			1. Added 22 new functions:

			getsamplebase
			getcurrsamplebase
			getsamplelength
			getsample
			setsample

			getfinetune
			gethold
			getdecay
			getdefaultpitch
			getextendedpreset
			getmidichannel
			getmidipreset
			getcurrinstrument
			getsuppressnoteonof
			getinname
			gettranspose
			getvolume
			getloopstart
			getlooplength
			getloopstate
			getlooppingpong
			getdisable


			2. Removed the "memory-loss"-problem in the BUGS-section of
			this manual. The "bug" was in the port-program, and I had allready
			fixed it before I released V0.70.


DEVELOPMENT
			To make your own plug-ins, you should know a little c, and a tiny bit
			arexx. Look at the example-plug ins included in this package, and
			read the "autodoc"-file. (it's not really an autodoc-file, but
			that doesn't matter, you can read it anyway.)
			It's allso possible to use other languages than c (even arexx),
			but I haven't customized anything for other languages. If you do,
			please send it to me, so I can include it in the next release.
			Allso; If you make a plug-in you think other people should know
			about, send it to me, and I will put it on the nsm-homepage.
			(remember to include the source). It's allso smart to put it
			on the aminet, I suppose.


DISCLAIMER
			Well, do what you want. But don't rerelease this package
			under your own name without crediting me for what I have done.
			Allso, when making plug-ins, please include the source-file.
			Thats a very good habit, and I don't see why you shouldn't.
			Well, if you are making some sort of commersial plug-in
			or something, I suppose I can't expect deny you not
			releasing the source-code too. But if you make a commersial
			program, using the nsm-system (or parts of the source-code), and
			not incudes the source-code of the commercial program, I (or someone else)
			will crack your program (if it has some kind of copy-protection),
			and put the program (or a crack-patch) on the homepage of nsm.
			(http://www.stud.ifi.uio.no/~kjetilma/nsm/).
			(Yes, I am allowed to do that since I write that I will do that here.)
			(well, its not very likely that anyone wants to make a commersial
			plug-in, but... :) )


COPYING
			Yes, you can.


FINAL NOTES
			1. The plug-ins should be very safe if programmed correctly. (by
			using the included assembler-functions, not by poking directly).
			That means there should be a very small risk crashing octamed when using
			the plug-ins, as long as the plug-ins itself doesn't crash the amiga
			ofcourse.
			2. And, (very important); Excuse my lousy english! I am a muscician,
			not a professor in the english language. ;)


CONTACT
			Kjetil S. Matheussen
			5423 Sogn Studentby
			0858 Oslo
			Norway

			e-mail: kjetilma@ifi.uio.no

			nsm-homepage: http://www.stud.ifi.uio.no/~kjetilma/nsm/
			octamed-homepage: http://www.octamed.co.uk/

