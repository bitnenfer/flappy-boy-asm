SECTION "rom", ROM0

; HEADER
; $0104 - $0133: The Nintendo Logo.
DB $CE, $ED, $66, $66, $CC, $0D, $00, $0B
DB $03, $73, $00, $83, $00, $0C, $00, $0D
DB $00, $08, $11, $1F, $88, $89, $00, $0E
DB $DC, $CC, $6E, $E6, $DD, $DD, $D9, $99
DB $BB, $BB, $67, $63, $6E, $0E, $EC, $CC
DB $DD, $DC, $99, $9F, $BB, $B9, $33, $3E

; $0134 - $013E: The title, in upper-case letters, followed by zeroes.
DB "BITNENFER "
DS 7 ; padding
; $013F - $0142: The manufacturer code.
DS 4
; $0143: Gameboy Color compatibility flag.    
DB $00
; $0144 - $0145: "New" Licensee Code, a two character name.
DB "OK"
; $0146: Super Gameboy compatibility flag.
DB $00
; $0147: Cartridge type. Either no ROM or MBC5 is recommended.
DB $00
; $0148: Rom size.
DB $00
; $0149: Ram size.
DB $00
; $014A: Destination code.
DB $01
; $014B: Old licensee code.
DB $33
; $014C: ROM version number
DB $00
; $014D: Header checksum.
DB $FF
; $014E- $014F: Global checksum.
DW $FACE