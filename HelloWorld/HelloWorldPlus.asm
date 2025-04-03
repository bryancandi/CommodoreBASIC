; C64 Assembly "Hello World" Program with Multi-Color and Black Background
; Resets colors to C64 defaults and exits after key press

; 10 SYS (2304)

; BASIC stub starting address
*=$0801
        BYTE    $0E, $08, $0A, $00, $9E, $20, $28, $32
        BYTE    $33, $30, $34, $29, $00, $00, $00

; Assembly program starting address
*=$0900
        lda #$93                ; Load PETSCII code for clear screen into the accumulator
        jsr $FFD2               ; Output via CHROUT with the PETSCII clear code to clear the screen
        lda #$08                ; Set uppercase/graphics mode (optional)
        jsr $FFD2               ; Output via CHROUT
        ldx #$00                ; Initialize X register as index (starts at 0)

        ; Set background and border colors to black
        lda #$00                ; Load black color code into the accumulator
        sta $D020               ; Write (store) border color to memory (53280)
        sta $D021               ; Write (store) background color to memory (53281)

HELLOWORLD_LOOP
        lda HELLOWORLD,x        ; Load screen code from string at index X
        beq NEXTSTRING_0        ; If null, move to next string
        sta $0400,x             ; Write screen code to screen memory
        lda HELLOWORLD_COLORS,x ; Load color code from color table at index X
        sta $D800,x             ; Write color to color memory
        inx                     ; Increment index (next character)
        jmp HELLOWORLD_LOOP     ; Repeat for next character

NEXTSTRING_0
        ldx #$00                ; Reset index X to 0 for next string loop

HELLOASSY_LOOP
        lda HELLOASSY,x         ; Load screen code from string at index X
        beq NEXTSTRING_1        ; If null, move to next string
        sta $0428,x             ; Write to second line (40 bytes offset down)
        lda HELLOASSY_COLORS,x  ; Load color code from color table at index X
        sta $D828,x             ; Write color to color memory (40 bytes offset)
        inx                     ; Increment index (next character)
        jmp HELLOASSY_LOOP      ; Repeat for next character

NEXTSTRING_1
        ldx #$00                ; Reset index X to 0 for next string loop

PRESSKEY_LOOP
        lda PRESSKEY,x          ; Load screen code from string at index X
        beq WAIT_KEY            ; This is the last string, so if null, wait for key
        sta $0478,x             ; Write to fourth line (120 bytes offset down)
        lda #$01                ; Load white color code
        sta $D878,x             ; Write color to color memory (120 bytes offset)
        inx                     ; Increment index (next character)
        jmp PRESSKEY_LOOP       ; Repeat for next character

WAIT_KEY
        jsr GETIN               ; Call GETIN subroutine

        ; Add line breaks before returning to BASIC to not overwrite printed text
        lda #$0D                ; Load carriage return code (moves cursor to next line)
        jsr $FFD2               ; Output via CHROUT with carriage return (cursor to next line)
        jsr $FFD2               ; Output via CHROUT again (cursor to next line)
        jsr $FFD2               ; Output via CHROUT again (cursor to next line)

        ; Reset to C64 default colors (load to accumulator and store)
        lda #$0E                ; Load light blue border
        sta $D020               ; Write color to memory
        lda #$06                ; Load blue background
        sta $D021               ; Write color to memory
        rts                     ; Return to BASIC

; Data for "HELLOWORLD" (Line 1)
HELLOWORLD
        byte 8, 5, 12, 12, 15   ; Screen codes for "HELLO"
        byte 44, 32             ; Screen codes for ", "        
        byte 23, 15, 18, 12, 4  ; Screen codes for "WORLD"
        byte 33                 ; Screen code for "!"
        byte 0                  ; Null terminator

HELLOWORLD_COLORS
        byte 2, 5, 3, 4, 7      ; Red, Green, Cyan, Purple, Yellow for "HELLO"
        byte 1, 1               ; White for ", "
        byte 15, 8, 10, 13, 14  ; Lt Gray, Orange, Lt Red, Lt Green, Lt Blue for "WORLD"
        byte 1                  ; White for "!"
        byte 0                  ; Null terminator

; Data for "HELLOASSY" (Line 2)
HELLOASSY
        byte 8, 5, 12, 12, 15   ; Screen codes for "HELLO"
        byte 44, 32             ; Screen codes for ", " 
        byte 1, 19, 19, 5, 13   ; Screen codes for "ASSEM"
        byte 2, 12, 25          ; Screen codes for "BLY"
        byte 33                 ; Screen code for "!"
        byte 0                  ; Null terminator

HELLOASSY_COLORS
        byte 2, 5, 3, 4, 7      ; Red, Green, Cyan, Purple, Yellow for "HELLO"
        byte 1, 1               ; White for ", "
        byte 15, 8, 10, 13, 14  ; Lt Gray, Orange, Lt Red, Lt Green, Lt Blue for "ASSEM"
        byte 15, 9, 12          ; Lt Gray, Brown, Gray for "BLY"
        byte 1                  ; White for "!"
        byte 0                  ; Null terminator

; Data for "PRESS KEY" (Line 4)
PRESSKEY
        byte 16, 18, 5, 19, 19  ; Screen codes for "PRESS"        
        byte 32                 ; Screen code for space
        byte 1, 14, 25          ; Screen code for "ANY"
        byte 32                 ; Screen code for space
        byte 11, 5, 25          ; Screen codes for "KEY"
        byte 0                  ; Null terminator

; GETIN subroutine: Waits for a key press
GETIN
        jsr $FFE4               ; Call Kernal GETIN routine
        cmp #$00                ; Check if a key was pressed
        beq GETIN               ; If no key, loop back and check again
        rts                     ; Return to BASIC when a key is pressed

; End of HelloWorldPlus.asm