

;			This is the sources for the code that is put into
;			the patced version of octamed soundstudio 1.03c.




*******                 Start of patch1.                  **********
******* Is to be loaded in at offset $50 in octamed1.03c. **********
patch1start:
	move.l	(a2),d0
	lea	4(a2),a1
	add.l	(a1)+,a2
	lea	4(a1),a0
	rts
	nop
*******                 Start of patch2.                   **********
patch2start:
	move.l	d0,d3
	move.l	4.w,a6
	jsr	-198(a6)
	move.l	d0,d1
	cmp	#$cf48,d3
	bne	return

	move.l	d0,a6


;	Used registers:
;	A6 - exec.library
;	A5 - My message-port
;	A3 - NSM-message
;	A1 - NSM-port
;	D4 - Address to send

	movem.l	d0/d1/d4/a0/a1/a3/a5,-(sp)	;Jupp, need to do this.


	move.l	a6,d4

	move.l	4.w,a6
	jsr	-$29a(a6)		;Creates a message-port
	tst.l	d0
	beq	exit
	move.l	d0,a5


	moveq	#24,d0			;Allocates the memory for the NSM-message
	move.l	#$10001,d1		;MEMF_PUBLIC | MEMF_CLEAR
	jsr	-198(a6)
	tst.l	d0
	beq	close_port
	move.l	d0,a3


	move.l	a5,14(a3)		;Set the replyport for the message
	move.l	d4,20(a3)		;Address to send


	jsr	-120(a6)		;Disable interrupts


	lea	nsmportname(pc),a1	;Finds the NSM-port
	jsr	-390(a6)
	tst	d0
	beq	could_not_find_port


	move.l	d0,a0			;Sends the message
	move.l	a3,a1
	jsr	-366(a6)


	jsr	-126(a6)		;Enable interrupts


	move.l	a5,a0			;Waits for reply
	jsr	-$180(a6)


free_message:
	move.l	a3,a1
	moveq	#24,d0
	jsr	-210(a6)


close_port:
	move.l	a5,a0
	jsr	-$2a0(a6)


exit:

	movem.l	(sp)+,d0/d1/d4/a0/a1/a3/a5	;Sets back registers

return:
	rts				;Returns back to the 4th. patch.


could_not_find_port:
	jsr	-126(a6)		;Enable interrupts
	bra.s	free_message


nsmportname:
	dc.b	"nsmport",0

	nop

******** End of patch1 and patch2. **********
********        Length: $a0        **********






hunk1startaddress:
	lea	downsomewhere(pc),a2


********                 Start of Patch3                  **********
******** Is to be loaded in at offset $7c in Octamed1.03c **********
patch3start:
	lea	hunk1startaddress(pc),a1
	move.l	a4,(a1)											;Jupp, self-modifying! :)
	jsr	$50(a4)												;Jumps to patch1start
	nop
********                  End of patch3                    *********
******** 			         Length: $b     				     **********



hunk2start:
	dc.l	0,0,0,0,0
	dc.l	0,0,0,0,0
	dc.l	0,0,0,0,0
	dc.l	0,0,0,0,0
	dc.l	0,0,0,0,0

	dc.l	0,0,0,0,0
	dc.l	0,0,0,0,0
	dc.l	0,0,0,0,0
	dc.l	0,0,0,0,0
	dc.l	0,0,0,0,0

	dc.l	0,0,0,0,0
	dc.l	0,0,0,0,0

	dc.w	0,0,0,0,0


	dc.b	0,0
	nop

;length: 254

********                 Start of Patch4                   **********
******** Is to be loaded in at offset $176 in Octamed1.03c **********
	move.l	hunk2start(pc),a6
	jsr	$60(a6)												;Jumps to Patch2start
********                  End of patch4                    *********
********   				      Length: $8	 				        **********



downsomewhere:


