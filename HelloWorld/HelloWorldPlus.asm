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
        sta $D020               ; Store the border color into memory (53280)
        sta $D021               ; Store the background color into memory (53281)

HELLOWORLD_LOOP
        lda HELLOWORLD,x        ; Load screen code from string at index X
        beq NEXTSTRING_0        ; If character is null (0), move to next string
        sta $0400,x             ; Store screen code to screen memory at address + X
        lda HELLOWORLD_COLORS,x ; Load color code from color table at index X
        sta $D800,x             ; Store color code to color memory at address + X
        inx                     ; Increment X index register (next character)
        jmp HELLOWORLD_LOOP     ; Loop to process the next character

NEXTSTRING_0
        ldx #$00                ; Reset index X to 0 for next string loop

HELLOASSY_LOOP
        lda HELLOASSY,x         ; Load screen code from string at index X
        beq NEXTSTRING_1        ; If character is null (0), move to next string
        sta $0428,x             ; Store screen code to screen memory at address + X (40 bytes offset - 2nd line)
        lda HELLOASSY_COLORS,x  ; Load color code from color table at index X
        sta $D828,x             ; Store color code to color memory at address + X (40 bytes offset)
        inx                     ; Increment X index register (next character)
        jmp HELLOASSY_LOOP      ; Loop to process the next character

NEXTSTRING_1
        ldx #$00                ; Reset index X to 0 for next string loop

PRESSKEY_LOOP
        lda PRESSKEY,x          ; Load screen code from string at index X
        beq WAIT_KEY            ; If character is null (0), wait for key
        sta $0478,x             ; Store screen code to screen memory at address + X (120 bytes offset - 4th line)
        lda #$01                ; Load white color code
        sta $D878,x             ; Store color code to color memory at address + X (120 bytes offset)
        inx                     ; Increment X index register (next character)
        jmp PRESSKEY_LOOP       ; Loop to process the next character

WAIT_KEY
        jsr GETIN               ; Call GETIN subroutine

        ; Add line breaks before returning to BASIC to not overwrite printed text
        lda #$0D                ; Load carriage return code (moves cursor to next line)
        jsr $FFD2               ; Output via CHROUT with carriage return (cursor to next line)
        jsr $FFD2               ; Output via CHROUT again (cursor to next line)
        jsr $FFD2               ; Output via CHROUT again (cursor to next line)

        ; Reset to C64 default colors when returning to BASIC
        lda #$0E                ; Load light blue border
        sta $D020               ; Store color to memory
        lda #$06                ; Load blue background
        sta $D021               ; Store color to memory
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

; Data for "PRESSKEY" (Line 4)
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