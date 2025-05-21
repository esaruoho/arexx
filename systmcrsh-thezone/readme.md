from https://eab.abime.net/showthread.php?t=58409#google_vignette

"
teeth!: is a sample chopper. it has a randomize function for randomly rearranging a sample. it also has a lock feature for locking areas you don't want rearranged. you can also manually rearrange a sample using the lock feature, or you can manually edit + chop a sample using the select/copy/paste tools. they automatically adjust to select/copy/paste convenient areas (1/8 1/16 1/32, etc). you can also rearrange/chop/paste multiple samples together. theres also a random retrigger feature that will randomly retrigger areas of the audio... eventually i'll make this like the lock feature so you can force retrigger (or not).

timebomb!: will automatically resample a sample to match the bpm of a project. it supports any range of both bpm and spd. i spent a lot of time coming up with the equations that actually calculate this... it was a bitch because there is no documentation anywhere about it + it was fairly complicated math. timebomb can also automatically transpose a sample using octamed's instrument settings rather than resample.

earache!: is basically a frontend for some of octamed's built in effects. handy to have everything conveniently located. (inspired by anakirob)

destroy!: not pictured, is basically a frontend for sox with a few features of timebomb! supports high pass, low pass, bandpass filters, compression, timestretching (instead of resampling), a bitcrusher (2bit 4bit), and a destroy option that will insanely distort the audio.

everything runs fast on an emulated amiga 4000. i've run them all on my real amiga 600 + they are pretty slow... ~ 1minute for resampling with sox, ~15 secs to resample with octamed's internal resampler, ~10 secs to chop a breakbeat. although slow on a 600, they are all %100 compatible with a 68000 cpu as well as workbench 2.1. sorry for the lame video, i hate making videos. will try to post some vids of the others later."

i apologize for the lack of updates... between work, social life, music production, + some laziness, have had an absurd lack of time. i'm currently rewriting parts of teeth and adding some new stuff... an offset calculator, pattern operations + some other things: [ Show youtube player ]

its still small and simple to use, but packs a lot more power. i cant make any promises when it will be finished, but i think its pretty close. if you're interested, the best bet is to drop me an email at systmcrsh[at]gmail[dot]com + i'll send an email. you can also sometimes find me on irc.esper.net #tds.

earache + timebomb are finished as far as im concerned and are available here: http://www.dirtybomb.tk/destr6y!/

install:
c.lha
-> copy varexx and VXC to your SYSTEM:C directory
libs.lha
-> copy *.lib to your SYSTEM:LIBS directory
rexx.lha
-> copy *.rexx and *.gui to your REXX: directory

if you don't have a rexx: directory you will need to assign one, or change the line of the scripts that call the gui (ie line 10: gui_file = 'REXX:earache!.gui'). you can then either select 'run rexx script' in octamed, or assign a keyboard shortcut to 'run arexx script': rexx:[script!].rexx

earache!: basically a frontend for some of octamed's effects.
Echo: octamed's echo effect. NN = number of echoes, RR = echo rate, VV = volume decrease. numbers must be entered in pairs, ie 01 = 1
Vol: volume increase or decrease (in percent). range = 0-999
F/B: filter/boost/none. AA = averaging, DD = distance. numbers must be entered in pairs, ie 01 = 1
NC: don't clip the sample (when vol > 100)
L: load a new sample in the selected instrument
P: play the selected instrument
< and >: scroll forward/backward through instruments
Go!: do operation
U: undo last operation.
Keyboard CMD:
F1: load preset. useful if you use the same settings a lot. to create your own preset you will need to edit lines 292-309 in earache!.rexx
F2: toggle undo enable/disable. enabling undos adds approx 8s of execution time on an a600.

timebomb!: resamples or transposes an instrument to match tempo.
Pitch: the default pitch of your sample (C-1, C#1, D-1, etc). must be entered as a number. its the most efficient way i knew off for entering it. 1 = C-1, 2= C#-1, 3 = D-1, 13 = C-2, 25 = C-3, etc. when you enter this data it will also set the default pitch in the sample editor. watch vid if you get confused.
Beats: the # of beats your sample is, ie 2 beats, 4 beats, 8, etc
-AA: resample with no anti-aliasing
+AA: resample with anti-aliasing
TSP: don't resample, transpose using instrument transposition settings instead. this gets flaky when you try to transposition further than 1 or 2 octaves. in that case you should resample. there is a technical reason for this...
L P < > Go!: same as above

other stuff:
the guis require varexx (partially included above): http://aminet.net/util/rexx/varexx.lha
the guis were created using gadtoolsbox (not included): http://aminet.net/dev/gui/gadtoolsbox20c.lha

koney: i see you have a release on industrial strength and hkv. thats awesome... isr is just a block away from my apartment. a friend of mine does a bunch of stuff for them. i plan to press a 7" myself next month.
"

as far as teeth!... theres a big problem with the random generator in teeth... its basically pseudo-random. this means that users could potentially generate the same content. i think thats unacceptable and decided not to release it until i fix it. i wrote down some ideas for fixing it, but havent tried it out yet. what i may do is remove the random code until then... i think it will still be valuable without it (esp w/ pattern ops + offset pasting). anyways this is my tentative timeline for teeth:

1. finish adding some new stuff
2. remove random code + upload
3. rewrite better random code + upload


if someone with more programming knowledge can suggest a better random routine, i'd love to hear about it. basically my idea for fixing it is to obfuscate it with more math...


anyways, should be finished soon i hope.

