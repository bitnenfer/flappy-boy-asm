; Menu Module

	; Setup and initialize menu resources
MenuOnEnter:
	ld hl,LCDC
	res $07,(hl)
	
	; Set BGP
	ld a,%11100100
	ld (BGP),a

	; Enable BG
	ld hl,LCDC
	set $03,(hl)

	; Load assets
	ld bc,MenuBackgroundTileData
	ld hl,VRAM_TILE_START
	ld de,MenuBackgroundTileDataSize
	call MemCpy

	call MenuLoadTiles

	ld hl,LCDC
	set $07,(hl)

	ret

MenuLoadTiles:
	; We just load every line by hand.
	ld de,$15
	ld bc,MenuBackgroundMapData + ($14 * $0)
	ld hl,$9c00
	call MemCpy
	ld de,$15
	ld bc,MenuBackgroundMapData + ($14 * $1)
	ld hl,$9c20
	call MemCpy
	ld de,$15
	ld bc,MenuBackgroundMapData + ($14 * $2)
	ld hl,$9c40
	call MemCpy
	ld de,$15
	ld bc,MenuBackgroundMapData + ($14 * $3)
	ld hl,$9c60
	call MemCpy
	ld de,$15
	ld bc,MenuBackgroundMapData + ($14 * $4)
	ld hl,$9c80
	call MemCpy
	ld de,$15
	ld bc,MenuBackgroundMapData + ($14 * $5)
	ld hl,$9ca0
	call MemCpy
	ld de,$15
	ld bc,MenuBackgroundMapData + ($14 * $6)
	ld hl,$9cc0
	call MemCpy
	ld de,$15
	ld bc,MenuBackgroundMapData + ($14 * $7)
	ld hl,$9ce0
	call MemCpy
	ld de,$15
	ld bc,MenuBackgroundMapData + ($14 * $8)
	ld hl,$9d00
	call MemCpy
	ld de,$15
	ld bc,MenuBackgroundMapData + ($14 * $9)
	ld hl,$9d20
	call MemCpy
	ld de,$15
	ld bc,MenuBackgroundMapData + ($14 * $a)
	ld hl,$9d40
	call MemCpy
	ld de,$15
	ld bc,MenuBackgroundMapData + ($14 * $b)
	ld hl,$9d60
	call MemCpy
	ld de,$15
	ld bc,MenuBackgroundMapData + ($14 * $c)
	ld hl,$9d80
	call MemCpy
	ld de,$15
	ld bc,MenuBackgroundMapData + ($14 * $d)
	ld hl,$9da0
	call MemCpy
	ld de,$15
	ld bc,MenuBackgroundMapData + ($14 * $e)
	ld hl,$9dc0
	call MemCpy
	ld de,$15
	ld bc,MenuBackgroundMapData + ($14 * $f)
	ld hl,$9de0
	call MemCpy
	ld de,$15
	ld bc,MenuBackgroundMapData + ($14 * $10)
	ld hl,$9e00
	call MemCpy
	ld de,$15
	ld bc,MenuBackgroundMapData + ($14 * $11)
	ld hl,$9e20
	call MemCpy
	ret
	
	; Exit Menu
MenuOnExit:
	ret
	
	; Tick Menu 
MenuOnTick:
	; ld a,STATE_GAME
	; ld (NextGameState),a
	ret
	