


	Ok. This file is for you that don't bother to read
	thru the whole doc-file before you start. To use
	plug-ins do the following:


1.	Unpack the whole archive. You don't need to make a
	directory first. Just unpack it to your music-directory,
	or something. (Well, I suppose you have allready done
	this since you are reading this.)

2. Insert the following lines into your user-startup file:

"
;NSM-stuff
makedir ram:NSM
assign NSM: "ram:NSM"
Run >NIL: dh2:nsm/nsmport/nsmport
copy dh2:nsm/plug-ins/#?/~(#?.#?|SCOPTIONS) nsm:
"

Change "dh2:" to the path you unpacked the archive.


3. Run the following program:
dh2:nsm/patch/octapatch dh2:octany/octamed

Change "dh2:" to the path you unpacked the archive.
Change "dh2:octany/octamed" to the path where the octamed
soundstudio 1.03c binary-file is placed on your hd. (or disc.)
(This should be a safe patch, but please do take a copy of
your old binary if you feel for it.)

4. Reset your amiga.

5. Start octamed. Go to the settings-menu, and choose
"Keyboard Shortcuts". Add your plug-ins the same way
as with your old arexx-scripts, except that instead of
choosing "Execute Arexx-file" in the Action-box, choose
"Launch Program" instead. To find out which plug-ins
you have; start shell and write "list nsm:".


That should be it. If you have problems, read the
doc-file.


