; Utility Functions
WaitVBlank:
	ld hl,LYC
	ld (hl),$90
_Wait:
	ld a,(LCDS)
	bit $02,a
	jr z,_Wait
	ret

MemCpy:
	; BC = Source
	; HL = Dest
	; DE = Block Size
	dec de
_MemCpyLoop:
	ld a,(bc)
	ld (hl),a
	inc bc
	inc hl
	dec de
_MemCpyChkLimit:
	ld a,e
	cp $00
	jr nz,_MemCpyLoop
	ld a,d
	cp $00
	jr nz,_MemCpyLoop
	ret
	
MemSet:
	; HL = Start
	; DE = End
	; B = Value
_MemSetLoop:
	ld (hl),b
	inc hl
	ld a,h
	cp d
	jr nz,_MemSetLoop
	ld a,l
	cp e
	jr nz,_MemSetLoop
	ld h,d
	ld l,e
	ld (hl),b
	ret
