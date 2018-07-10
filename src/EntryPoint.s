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

STATE_NONE equ $00
STATE_MENU equ $01
STATE_GAME equ $02

Main	group $00
		org $0150
	
	; Code
EntryPoint:
	
	; Turn off LCD
	ld hl,LCDC
	res $07,(hl)
	
	; Enable Sprites
	set $01,(hl)
	
	; Set palettes
	ld a,%11100100
	ld (BGP),a
	ld (OBJP0),a
	ld (OBJP1),a
	
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
	
	; Set Initial State
	ld a,STATE_NONE
	ld (CurrentGameState),a
	ld a,STATE_MENU
	ld (NextGameState),a
		
MainLoop:	
	; First Wait for V-Blank
	call WaitVBlank
	call SwapGameStates
	
	ld a,(CurrentGameState)
	cp STATE_GAME
	jr z,_GameTick

_MenuTick:
	call MenuOnTick
	jr _UpdateOAM

_GameTick:
	call GameOnTick
	jr _UpdateOAM
	
_UpdateOAM:
	; After Sprite Update
	; push to OAM RAM
	call StartDMA
	jp MainLoop
	
SwapGameStates:
	ld a,(NextGameState)
	ld b,a
	ld a,(CurrentGameState)
	cp b
	jr z, _FinishGameStateChange
	
	cp STATE_NONE
	jr z, _EnterNextState
	cp STATE_MENU
	jr z, _ExitMenu
	cp STATE_GAME
	jr z, _ExitGame

	; On Exit State
_ExitMenu:
	call MenuOnExit
	jr _EnterNextState
	
_ExitGame:
	call GameOnExit
	jr _EnterNextState
	
_EnterNextState:
	ld a,b
	ld (CurrentGameState),a
	cp STATE_MENU
	jr z, _EnterMenu
	cp STATE_GAME
	jr z, _EnterGame
	; Default is Menu
	jr z, _EnterMenu 
	
	; On Enter State
_EnterMenu:
	call MenuOnEnter
	jr _FinishGameStateChange

_EnterGame:
	call GameOnEnter
	jr _FinishGameStateChange
	
_FinishGameStateChange:
	ret
	
	; Static Data
ColorStepData:
	DB %00000000,%01010101,%10101010,%11111111,%10101010,%01010101
	
	lib Menu
	lib Game
	lib Utils
	lib ShadowOAM
	lib Variables
	