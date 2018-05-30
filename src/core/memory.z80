SECTION "memory", ROMX
; memcpy implementation for Z80
memcpy::
    ; DE = block size
    ; BC = source address
    ; HL = destination address
    dec DE

.memcpy_loop:
    ld A, [BC]
    ld [HLI], A
    inc BC
    dec DE

.memcpy_check_limit:
    ld A, E
    cp $00
    jr nz, .memcpy_loop
    ld A, D
    cp $00
    jr nz, .memcpy_loop
    ret