; Menu Module

	; Setup and initialize menu resources
MenuOnEnter:
	ret
	
	; Exit Menu
MenuOnExit:
	ret
	
	; Tick Menu 
MenuOnTick:
	ld a,STATE_GAME
	ld (NextGameState),a
	ret
	