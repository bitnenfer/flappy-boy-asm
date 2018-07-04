	lib Registers

	isdmg
	offbankgroup
	puball
	
title 	group 	$00
	; Interrupts and Catridge Header
	org $0000
	
	; Interrupts
	ret
	org *+$08
	ret
	org *+$10
	ret
	org *+$18
	ret
	org *+$20
	ret
	org *+$28
	ret
	org *+$30
	ret
	org *+$38
	ret
	org *+$40
	ret
	org *+$48
	ret
	org *+$50
	ret
	org *+$58
	ret
	org *+$60
	ret
		
	org $0100
	nop
	jp EntryPoint
	
	;; NINTENDO LOGO
	db $CE,$ED,$66,$66		
	db $CC,$0D,$00,$0B
	db $03,$73,$00,$83
	db $00,$0C,$00,$0D
	db $00,$08,$11,$1F
	db $88,$89,$00,$0E
	db $DC,$CC,$6E,$E6
	db $DD,$DD,$D9,$99
	db $BB,$BB,$67,$63
	db $6E,$0E,$EC,$CC
	db $DD,$DC,$99,$9F
	db $BB,$B9,$33,$3E

	;; TITLE
	db "F","L","A","P"		
	db "P","Y"," ","B"
	db "O","Y",$00,$00
	db $00,$00,$00

	;; GAMEBOY COLOR
	db $00			
	;; MAKER
	db $00,$00			
	;; MACHINE
	db $00			
	;; CASSETTE TYPE
	db $00			
	;; ROM SIZE
	db $00			
	;; RAM SIZE
	db $00			
	;; COUNTRY
	db $01			
	;; GAMEBOY
	db $00			
	;; ROM VERSION
	db $00			
	;; NEGATIVE CHECK
	db $67			
	;; CHECK SUM
	db $00,$00			
	
	
; Constants
StartDMA equ $FF80

Main	group $00
		org $0150
	
	; Code
EntryPoint:
	
	; Turn off LCD
	ld hl,LCDC
	res $07,(hl)
	
	; Enable Sprites
	set $01,(hl)
	
	; Clear OAM RAM
	ld hl,OAM0
	ld de,OAM39_ATTRIB
	ld b,$00
	call MemSet
	
	; Init Shadow OAM
	call InitShadowOAM
	
	; Clear Screen
	ld hl,VRAM_BGMAP0_START
	ld de,VRAM_BGMAP0_END
	ld b,$01
	call MemSet
	
	; Turn on LCD
	ld hl,LCDC
	set $07,(hl)
	
MainLoop:
	; First Wait for V-Blank
	call WaitVBlank

	; After Sprite Update
	; push to OAM RAM
	call StartDMA
	jp MainLoop

	; Static Data
	

	lib Utils
	lib ShadowOAM
	lib Variables
	