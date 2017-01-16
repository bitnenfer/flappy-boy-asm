SECTION "rom", HOME

; Interrupt handlers
; $0000
ret
DS 7
; $0008
ret
DS 7
; $0010
ret
DS 7
; $0018
ret
DS 7
; $0020
ret
DS 7
; $0028
ret
DS 7
; $0030
ret
DS 7
; $0038
ret
DS 7
; $0040 -- (VBLANK)
ret
DS 7
; $0048 -- (LCD)
ret
DS 7
; $0050 -- (TIMER)
ret
DS 7
; $0058 -- (SERIAL)
ret
DS 7
; $0060 -- (JOYPAD)
ret
DS 7

; $0068 -- Free Space (152 bytes)
DS $98
nop