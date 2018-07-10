	lib Registers

	isdmg
	offbankgroup
	puball

title 	group 	$00
	; Interrupts and Catridge Header
	org $0000
	
	lib Vectors
		
	org $0100
	
	nop
	jp EntryPoint
	
	lib Header
	
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
Assets:
	lib Assets

GameCode:
	lib Menu
	lib Game
	lib Utils
	lib ShadowOAM
	lib Variables
	