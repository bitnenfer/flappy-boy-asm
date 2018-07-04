; DMG Display
; -----------

LCD_WIDTH equ $A0
LCD_HEIGHT equ $90

; FF40 - LCDC - LCD Control (R/W)
;  Bit 7 - LCD Display Enable             (0=Off, 1=On)
;  Bit 6 - Window Tile Map Display Select (0=9800-9BFF, 1=9C00-9FFF)
;  Bit 5 - Window Display Enable          (0=Off, 1=On)
;  Bit 4 - BG & Window Tile Data Select   (0=8800-97FF, 1=8000-8FFF)
;  Bit 3 - BG Tile Map Display Select     (0=9800-9BFF, 1=9C00-9FFF)
;  Bit 2 - OBJ (Sprite) Size              (0=8x8, 1=8x16)
;  Bit 1 - OBJ (Sprite) Display Enable    (0=Off, 1=On)
;  Bit 0 - BG Display (for CGB see below) (0=Off, 1=On)
LCDC equ $FF40

; FF41 - STAT - LCDC Status (R/W)
;   Bit 6 - LYC=LY Coincidence Interrupt (1=Enable) (Read/Write)
;   Bit 5 - Mode 2 OAM Interrupt         (1=Enable) (Read/Write)
;   Bit 4 - Mode 1 V-Blank Interrupt     (1=Enable) (Read/Write)
;   Bit 3 - Mode 0 H-Blank Interrupt     (1=Enable) (Read/Write)
;   Bit 2 - Coincidence Flag  (0:LYC<>LY, 1:LYC=LY) (Read Only)
;   Bit 1-0 - Mode Flag       (Mode 0-3, see below) (Read Only)
;             0: During H-Blank
;             1: During V-Blank
;             2: During Searching OAM-RAM
;             3: During Transfering Data to LCD Driver
LCDS equ $FF41

; Scroll Y (R/W)
SCY equ $FF42

; Scroll X (R/W)
SCX equ $FF43

; LCDC Y-Coordinate (R)
LY equ $FF44

; LY Compare (R/W)
LYC equ $FF45

; Window Y Position (R/W)
WY equ $FF4A

; Window X Position minus 7 (R/W)
WX equ $FF4B

; FF47 - BGP - BG Palette Data (R/W) - Non CGB Mode Only
; This register assigns gray shades to the color numbers of the BG and Window tiles.
;   Bit 7-6 - Shade for Color Number 3
;   Bit 5-4 - Shade for Color Number 2
;   Bit 3-2 - Shade for Color Number 1
;   Bit 1-0 - Shade for Color Number 0
; The four possible gray shades are:
;   0  White
;   1  Light gray
;   2  Dark gray
;   3  Black
; In CGB Mode the Color Palettes are taken from CGB Palette Memory instead.
BGP equ $FF47

; FF48 - OBP0 - Object Palette 0 Data (R/W) - Non CGB Mode Only
OBJP0 equ $FF48

; FF49 - OBP1 - Object Palette 1 Data (R/W) - Non CGB Mode Only
OBJP1 equ $FF49

; FF46 - DMA - DMA Transfer and Start Address (W)
; Writing to this register launches a DMA transfer from ROM or RAM 
; to OAM memory (sprite attribute table). The written value specifies
; the transfer source address divided by 100h, ie. source & 
; destination are:
;   Source:      XX00-XX9F   ;XX in range from 00-F1h
;   Destination: FE00-FE9F
; It takes 160 microseconds until the transfer has completed 
; (80 microseconds in CGB Double Speed Mode), during this time the 
; CPU can access only HRAM (memory at FF80-FFFE). For this reason, 
; the programmer must copy a short procedure into HRAM, and use this 
; procedure to start the transfer from inside HRAM, and wait until 
; the transfer has finished:
;    ld  (0FF46h),a ;start DMA transfer, a=start address/100h
;    ld  a,28h      ;delay...
;   wait:           ;total 5x40 cycles, approx 200ms
;    dec a          ;1 cycle
;    jr  nz,wait    ;4 cycles
; Most programs are executing this procedure from inside of their 
; VBlank procedure, but it is possible to execute it during 
; display redraw also, allowing to display more than 40 sprites on 
; the screen (ie. for example 40 sprites in upper half, and other 
; 40 sprites in lower half of the screen).
DMA equ $FF46

VRAM_TILE_START equ $8000
VRAM_TILE_END equ $97FF
VRAM_BGMAP0_START equ $9800
VRAM_BGMAP0_END equ $9BFF
VRAM_BGMAP1_START equ $9C00
VRAM_BGMAP1_END equ $9FFF
VRAM_BGMAP_STRIDE equ $20

; OAM Data
; Byte0 - Y Position
; Specifies the sprites vertical position on the screen (minus 16).
; An offscreen value (for example, Y=0 or Y>=160) hides the sprite.
; 
; Byte1 - X Position
; Specifies the sprites horizontal position on the screen (minus 8).
; An offscreen value (X=0 or X>=168) hides the sprite, but the sprite
; still affects the priority ordering - a better way to hide a sprite is to set its Y-coordinate offscreen.
; 
; Byte2 - Tile/Pattern Number
; Specifies the sprites Tile Number (00-FF). This (unsigned) value selects a tile from memory at 8000h-8FFFh. In CGB Mode this could be either in VRAM Bank 0 or 1, depending on Bit 3 of the following byte.
; In 8x16 mode, the lower bit of the tile number is ignored. Ie. the upper 8x8 tile is "NN AND FEh", and the lower 8x8 tile is "NN OR 01h".
; 
; Byte3 - Attributes/Flags:
;   Bit7   OBJ-to-BG Priority (0=OBJ Above BG, 1=OBJ Behind BG color 1-3)
;          (Used for both BG and Window. BG color 0 is always behind OBJ)
;   Bit6   Y flip          (0=Normal, 1=Vertically mirrored)
;   Bit5   X flip          (0=Normal, 1=Horizontally mirrored)
;   Bit4   Palette number  **Non CGB Mode Only** (0=OBP0, 1=OBP1)
;   Bit3   Tile VRAM-Bank  **CGB Mode Only**     (0=Bank 0, 1=Bank 1)
;   Bit2-0 Palette number  **CGB Mode Only**     (OBP0-7)
OAM0 equ $FE00
OAM0_Y equ $FE00
OAM0_X equ $FE01
OAM0_TILE equ $FE02
OAM0_ATTRIB equ $FE03
OAM1 equ $FE04
OAM1_Y equ $FE04
OAM1_X equ $FE05
OAM1_TILE equ $FE06
OAM1_ATTRIB equ $FE07
OAM2 equ $FE08
OAM2_Y equ $FE08
OAM2_X equ $FE09
OAM2_TILE equ $FE0A
OAM2_ATTRIB equ $FE0B
OAM3 equ $FE0C
OAM3_Y equ $FE0C
OAM3_X equ $FE0D
OAM3_TILE equ $FE0E
OAM3_ATTRIB equ $FE0F
OAM4 equ $FE10
OAM4_Y equ $FE10
OAM4_X equ $FE11
OAM4_TILE equ $FE12
OAM4_ATTRIB equ $FE13
OAM5 equ $FE14
OAM5_Y equ $FE14
OAM5_X equ $FE15
OAM5_TILE equ $FE16
OAM5_ATTRIB equ $FE17
OAM6 equ $FE18
OAM6_Y equ $FE18
OAM6_X equ $FE19
OAM6_TILE equ $FE1A
OAM6_ATTRIB equ $FE1B
OAM7 equ $FE1C
OAM7_Y equ $FE1C
OAM7_X equ $FE1D
OAM7_TILE equ $FE1E
OAM7_ATTRIB equ $FE1F
OAM8 equ $FE20
OAM8_Y equ $FE20
OAM8_X equ $FE21
OAM8_TILE equ $FE22
OAM8_ATTRIB equ $FE23
OAM9 equ $FE24
OAM9_Y equ $FE24
OAM9_X equ $FE25
OAM9_TILE equ $FE26
OAM9_ATTRIB equ $FE27
OAM10 equ $FE28
OAM10_Y equ $FE28
OAM10_X equ $FE29
OAM10_TILE equ $FE2A
OAM10_ATTRIB equ $FE2B
OAM11 equ $FE2C
OAM11_Y equ $FE2C
OAM11_X equ $FE2D
OAM11_TILE equ $FE2E
OAM11_ATTRIB equ $FE2F
OAM12 equ $FE30
OAM12_Y equ $FE30
OAM12_X equ $FE31
OAM12_TILE equ $FE32
OAM12_ATTRIB equ $FE33
OAM13 equ $FE34
OAM13_Y equ $FE34
OAM13_X equ $FE35
OAM13_TILE equ $FE36
OAM13_ATTRIB equ $FE37
OAM14 equ $FE38
OAM14_Y equ $FE38
OAM14_X equ $FE39
OAM14_TILE equ $FE3A
OAM14_ATTRIB equ $FE3B
OAM15 equ $FE3C
OAM15_Y equ $FE3C
OAM15_X equ $FE3D
OAM15_TILE equ $FE3E
OAM15_ATTRIB equ $FE3F
OAM16 equ $FE40
OAM16_Y equ $FE40
OAM16_X equ $FE41
OAM16_TILE equ $FE42
OAM16_ATTRIB equ $FE43
OAM17 equ $FE44
OAM17_Y equ $FE44
OAM17_X equ $FE45
OAM17_TILE equ $FE46
OAM17_ATTRIB equ $FE47
OAM18 equ $FE48
OAM18_Y equ $FE48
OAM18_X equ $FE49
OAM18_TILE equ $FE4A
OAM18_ATTRIB equ $FE4B
OAM19 equ $FE4C
OAM19_Y equ $FE4C
OAM19_X equ $FE4D
OAM19_TILE equ $FE4E
OAM19_ATTRIB equ $FE4F
OAM20 equ $FE50
OAM20_Y equ $FE50
OAM20_X equ $FE51
OAM20_TILE equ $FE52
OAM20_ATTRIB equ $FE53
OAM21 equ $FE54
OAM21_Y equ $FE54
OAM21_X equ $FE55
OAM21_TILE equ $FE56
OAM21_ATTRIB equ $FE57
OAM22 equ $FE58
OAM22_Y equ $FE58
OAM22_X equ $FE59
OAM22_TILE equ $FE5A
OAM22_ATTRIB equ $FE5B
OAM23 equ $FE5C
OAM23_Y equ $FE5C
OAM23_X equ $FE5D
OAM23_TILE equ $FE5E
OAM23_ATTRIB equ $FE5F
OAM24 equ $FE60
OAM24_Y equ $FE60
OAM24_X equ $FE61
OAM24_TILE equ $FE62
OAM24_ATTRIB equ $FE63
OAM25 equ $FE64
OAM25_Y equ $FE64
OAM25_X equ $FE65
OAM25_TILE equ $FE66
OAM25_ATTRIB equ $FE67
OAM26 equ $FE68
OAM26_Y equ $FE68
OAM26_X equ $FE69
OAM26_TILE equ $FE6A
OAM26_ATTRIB equ $FE6B
OAM27 equ $FE6C
OAM27_Y equ $FE6C
OAM27_X equ $FE6D
OAM27_TILE equ $FE6E
OAM27_ATTRIB equ $FE6F
OAM28 equ $FE70
OAM28_Y equ $FE70
OAM28_X equ $FE71
OAM28_TILE equ $FE72
OAM28_ATTRIB equ $FE73
OAM29 equ $FE74
OAM29_Y equ $FE74
OAM29_X equ $FE75
OAM29_TILE equ $FE76
OAM29_ATTRIB equ $FE77
OAM30 equ $FE78
OAM30_Y equ $FE78
OAM30_X equ $FE79
OAM30_TILE equ $FE7A
OAM30_ATTRIB equ $FE7B
OAM31 equ $FE7C
OAM31_Y equ $FE7C
OAM31_X equ $FE7D
OAM31_TILE equ $FE7E
OAM31_ATTRIB equ $FE7F
OAM32 equ $FE80
OAM32_Y equ $FE80
OAM32_X equ $FE81
OAM32_TILE equ $FE82
OAM32_ATTRIB equ $FE83
OAM33 equ $FE84
OAM33_Y equ $FE84
OAM33_X equ $FE85
OAM33_TILE equ $FE86
OAM33_ATTRIB equ $FE87
OAM34 equ $FE88
OAM34_Y equ $FE88
OAM34_X equ $FE89
OAM34_TILE equ $FE8A
OAM34_ATTRIB equ $FE8B
OAM35 equ $FE8C
OAM35_Y equ $FE8C
OAM35_X equ $FE8D
OAM35_TILE equ $FE8E
OAM35_ATTRIB equ $FE8F
OAM36 equ $FE90
OAM36_Y equ $FE90
OAM36_X equ $FE91
OAM36_TILE equ $FE92
OAM36_ATTRIB equ $FE93
OAM37 equ $FE94
OAM37_Y equ $FE94
OAM37_X equ $FE95
OAM37_TILE equ $FE96
OAM37_ATTRIB equ $FE97
OAM38 equ $FE98
OAM38_Y equ $FE98
OAM38_X equ $FE99
OAM38_TILE equ $FE9A
OAM38_ATTRIB equ $FE9B
OAM39 equ $FE9C
OAM39_Y equ $FE9C
OAM39_X equ $FE9D
OAM39_TILE equ $FE9E
OAM39_ATTRIB equ $FE9F

; DMG joypad
; ----------

; FF00 - P1/JOYP - Joypad (R/W)
; The eight gameboy buttons/direction keys are arranged in form of a 2x4 matrix. 
; Select either button or direction keys by writing to this register, 
; then read-out bit 0-3.
;   Bit 7 - Not used
;   Bit 6 - Not used
;   Bit 5 - P15 Select Button Keys      (0=Select)
;   Bit 4 - P14 Select Direction Keys   (0=Select)
;   Bit 3 - P13 Input Down  or Start    (0=Pressed) (Read Only)
;   Bit 2 - P12 Input Up    or Select   (0=Pressed) (Read Only)
;   Bit 1 - P11 Input Left  or Button B (0=Pressed) (Read Only)
;   Bit 0 - P10 Input Right or Button A (0=Pressed) (Read Only)

JOYP equ $FF00

; DMG Sound
; ---------

; Sound Control Registers
; =======================
;
; FF24 - NR50 - Channel control / ON-OFF / Volume (R/W)
; The volume bits specify the "Master Volume" for Left/Right sound output.
;   Bit 7   - Output Vin to SO2 terminal (1=Enable)
;   Bit 6-4 - SO2 output level (volume)  (0-7)
;   Bit 3   - Output Vin to SO1 terminal (1=Enable)
;   Bit 2-0 - SO1 output level (volume)  (0-7)
; The Vin signal is received from the game cartridge bus, allowing external hardware in the cartridge to supply a fifth sound channel, additionally to the gameboys internal four channels. As far as I know this feature isn't used by any existing games.
NR50 equ $FF24

; FF25 - NR51 - Selection of Sound output terminal (R/W)
;   Bit 7 - Output sound 4 to SO2 terminal
;   Bit 6 - Output sound 3 to SO2 terminal
;   Bit 5 - Output sound 2 to SO2 terminal
;   Bit 4 - Output sound 1 to SO2 terminal
;   Bit 3 - Output sound 4 to SO1 terminal
;   Bit 2 - Output sound 3 to SO1 terminal
;   Bit 1 - Output sound 2 to SO1 terminal
;   Bit 0 - Output sound 1 to SO1 terminal
NR51 equ $FF25

; FF26 - NR52 - Sound on/off
; If your GB programs don't use sound then write 00h to this register to save 16% or more on GB power consumption. Disabeling the sound controller by clearing Bit 7 destroys the contents of all sound registers. Also, it is not possible to access any sound registers (execpt FF26) while the sound controller is disabled.
;   Bit 7 - All sound on/off  (0: stop all sound circuits) (Read/Write)
;   Bit 3 - Sound 4 ON flag (Read Only)
;   Bit 2 - Sound 3 ON flag (Read Only)
;   Bit 1 - Sound 2 ON flag (Read Only)
;   Bit 0 - Sound 1 ON flag (Read Only)
NR52 equ $FF26

; Sound Channel 1 - Tone & Sweep
; ===============================
;
; FF10 - NR10 - Channel 1 Sweep register (R/W)
;   Bit 6-4 - Sweep Time
;   Bit 3   - Sweep Increase/Decrease
;              0: Addition    (frequency increases)
;              1: Subtraction (frequency decreases)
;   Bit 2-0 - Number of sweep shift (n: 0-7)
; Sweep Time:
;   000: sweep off - no freq change
;   001: 7.8 ms  (1/128Hz)
;   010: 15.6 ms (2/128Hz)
;   011: 23.4 ms (3/128Hz)
;   100: 31.3 ms (4/128Hz)
;   101: 39.1 ms (5/128Hz)
;   110: 46.9 ms (6/128Hz)
;   111: 54.7 ms (7/128Hz)
; 
; The change of frequency (NR13,NR14) at each shift is calculated by the following formula where X(0) is initial freq & X(t-1) is last freq:
;   X(t) = X(t-1) +/- X(t-1)/2^n
NR10 equ $FF10

; FF11 - NR11 - Channel 1 Sound length/Wave pattern duty (R/W)
;   Bit 7-6 - Wave Pattern Duty (Read/Write)
;   Bit 5-0 - Sound length data (Write Only) (t1: 0-63)
; Wave Duty:
;   00: 12.5% ( _-------_-------_------- )
;   01: 25%   ( __------__------__------ )
;   10: 50%   ( ____----____----____---- ) (normal)
;   11: 75%   ( ______--______--______-- )
; Sound Length = (64-t1)*(1/256) seconds
; The Length value is used only if Bit 6 in NR14 is set.
NR11 equ $FF11

; FF12 - NR12 - Channel 1 Volume Envelope (R/W)
;   Bit 7-4 - Initial Volume of envelope (0-0Fh) (0=No Sound)
;   Bit 3   - Envelope Direction (0=Decrease, 1=Increase)
;   Bit 2-0 - Number of envelope sweep (n: 0-7)
;             (If zero, stop envelope operation.)
; Length of 1 step = n*(1/64) seconds
NR12 equ $FF12

; FF13 - NR13 - Channel 1 Frequency lo (Write Only)
; Lower 8 bits of 11 bit frequency (x).
; Next 3 bit are in NR14 ($FF14)
NR13 equ $FF13

; FF14 - NR14 - Channel 1 Frequency hi (R/W)
;   Bit 7   - Initial (1=Restart Sound)     (Write Only)
;   Bit 6   - Counter/consecutive selection (Read/Write)
;             (1=Stop output when length in NR11 expires)
;   Bit 2-0 - Frequency's higher 3 bits (x) (Write Only)
; Frequency = 131072/(2048-x) Hz
NR14 equ $FF14

; Sound Channel 2 - Tone
; ======================
;
; FF16 - NR21 - Channel 2 Sound Length/Wave Pattern Duty (R/W)
;   Bit 7-6 - Wave Pattern Duty (Read/Write)
;   Bit 5-0 - Sound length data (Write Only) (t1: 0-63)
; Wave Duty:
;   00: 12.5% ( _-------_-------_------- )
;   01: 25%   ( __------__------__------ )
;   10: 50%   ( ____----____----____---- ) (normal)
;   11: 75%   ( ______--______--______-- )
; Sound Length = (64-t1)*(1/256) seconds
; The Length value is used only if Bit 6 in NR24 is set.
NR21 equ $FF16

; FF17 - NR22 - Channel 2 Volume Envelope (R/W)
;   Bit 7-4 - Initial Volume of envelope (0-0Fh) (0=No Sound)
;   Bit 3   - Envelope Direction (0=Decrease, 1=Increase)
;   Bit 2-0 - Number of envelope sweep (n: 0-7)
;             (If zero, stop envelope operation.)
; Length of 1 step = n*(1/64) seconds
NR22 equ $FF17

; FF18 - NR23 - Channel 2 Frequency lo data (W)
; Frequency's lower 8 bits of 11 bit data (x).
; Next 3 bits are in NR24 ($FF19).
NR23 equ $FF18

; FF19 - NR24 - Channel 2 Frequency hi data (R/W)
;   Bit 7   - Initial (1=Restart Sound)     (Write Only)
;   Bit 6   - Counter/consecutive selection (Read/Write)
;             (1=Stop output when length in NR21 expires)
;   Bit 2-0 - Frequency's higher 3 bits (x) (Write Only)
; Frequency = 131072/(2048-x) Hz
NR24 equ $FF19

; Sound Channel 3 - Wave Output
; =============================
;
; FF1A - NR30 - Channel 3 Sound on/off (R/W)
;   Bit 7 - Sound Channel 3 Off  (0=Stop, 1=Playback)  (Read/Write)
NR30 equ $FF1A

; FF1B - NR31 - Channel 3 Sound Length
;   Bit 7-0 - Sound length (t1: 0 - 255)
; Sound Length = (256-t1)*(1/256) seconds
; This value is used only if Bit 6 in NR34 is set.
NR31 equ $FF1B

; FF1C - NR32 - Channel 3 Select output level (R/W)
;   Bit 6-5 - Select output level (Read/Write)
; Possible Output levels are:
;   0: Mute (No sound)
;   1: 100% Volume (Produce Wave Pattern RAM Data as it is)
;   2:  50% Volume (Produce Wave Pattern RAM data shifted once to the right)
;   3:  25% Volume (Produce Wave Pattern RAM data shifted twice to the right)
NR32 equ $FF1C

; FF1D - NR33 - Channel 3 Frequency's lower data (W)
; Lower 8 bits of an 11 bit frequency (x).
NR33 equ $FF1D

; FF1E - NR34 - Channel 3 Frequency's higher data (R/W)
;   Bit 7   - Initial (1=Restart Sound)     (Write Only)
;   Bit 6   - Counter/consecutive selection (Read/Write)
;             (1=Stop output when length in NR31 expires)
;   Bit 2-0 - Frequency's higher 3 bits (x) (Write Only)
; Frequency = 4194304/(64*(2048-x)) Hz = 65536/(2048-x) Hz
NR34 equ $FF1E

; FF30-FF3F - Wave Pattern RAM
; Contents - Waveform storage for arbitrary sound data
WAVE_START equ $FF30
WAVE_END equ $FF3F

; Sound Channel 4 - Noise
; =======================
;
; FF20 - NR41 - Channel 4 Sound Length (R/W)
;   Bit 5-0 - Sound length data (t1: 0-63)
; Sound Length = (64-t1)*(1/256) seconds
; The Length value is used only if Bit 6 in NR44 is set.
NR41 equ $FF20

; FF21 - NR42 - Channel 4 Volume Envelope (R/W)
;   Bit 7-4 - Initial Volume of envelope (0-0Fh) (0=No Sound)
;   Bit 3   - Envelope Direction (0=Decrease, 1=Increase)
;   Bit 2-0 - Number of envelope sweep (n: 0-7)
;             (If zero, stop envelope operation.)
; Length of 1 step = n*(1/64) seconds
NR42 equ $FF21

; FF22 - NR43 - Channel 4 Polynomial Counter (R/W)
; The amplitude is randomly switched between high and low at the given frequency. A higher frequency will make the noise to appear 'softer'.
; When Bit 3 is set, the output will become more regular, and some frequencies will sound more like Tone than Noise.
;   Bit 7-4 - Shift Clock Frequency (s)
;   Bit 3   - Counter Step/Width (0=15 bits, 1=7 bits)
;   Bit 2-0 - Dividing Ratio of Frequencies (r)
; Frequency = 524288 Hz / r / 2^(s+1) ;For r=0 assume r=0.5 instead
NR43 equ $FF22

; FF23 - NR44 - Channel 4 Counter/consecutive; Inital (R/W)
;   Bit 7   - Initial (1=Restart Sound)     (Write Only)
;   Bit 6   - Counter/consecutive selection (Read/Write)
;             (1=Stop output when length in NR41 expires)
NR44 equ $FF23
