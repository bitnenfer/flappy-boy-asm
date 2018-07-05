; Game Module

	; Setup and initialize game resources
GameOnEnter:
	ret
	
	; Exit game
GameOnExit:
	ret
	
	; Tick Game 
GameOnTick:
	ld a,STATE_MENU
	ld (NextGameState),a
	ret
	