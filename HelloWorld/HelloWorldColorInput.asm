; C64 Assembly "Hello World" Program with Multi-Color and Black Background
; Resets colors to C64 defaults after key press

; 10 SYS (2304)

*=$0801         ; BASIC stub starting address
        BYTE    $0E, $08, $0A, $00, $9E, $20, $28, $32
        BYTE    $33, $30, $34, $29, $00, $00, $00

*=$0900         ; Assembly program starting address
        lda #$93                ; Load PETSCII code for clear screen into the accumulator
        jsr $FFD2               ; Output via CHROUT with the PETSCII clear code to clear the screen
        lda #$08                ; Set uppercase/graphics mode (optional)
        jsr $FFD2               ; Output via CHROUT
        ldx #$00                ; Initialize X register as index (starts at 0)

        ; Set background and border colors to black
        lda #$00                ; Load black color code into the accumulator
        sta $D020               ; Write (store) frame color to memory
        sta $D021               ; Write (store) background color to memory               

HELLOWORLD_LOOP
        lda HELLOWORLD,x        ; Load screen code from string at index X
        beq NEXT_STRING         ; If null, move to next string
        sta $0400,x             ; Write screen code to screen memory
        lda HELLOWORLD_COLORS,x ; Load color code from color table at index X
        sta $D800,x             ; Write color to color memory
        inx                     ; Increment index (next character)
        jmp HELLOWORLD_LOOP     ; Repeat for next character

NEXT_STRING
        ldx #$00                ; Reset index for next string

PRESSKEY_LOOP
        lda PRESSKEY,x          ; Load screen code from string at index X
        beq WAIT_KEY            ; This is the last string, so if null, wait for key
        sta $0450,x             ; Write to third line (second=428) (80 bytes offset down)
        lda #$01                ; Load white color code
        sta $D850,x             ; Write color to color memory (80 bytes offset)
        inx                     ; Increment index (next character)
        jmp PRESSKEY_LOOP       ; Repeat for next character

WAIT_KEY
        jsr GETIN               ; Call GETIN subroutine

        ; Add line break before returning to BASIC
        lda #$0D                ; Load carriage return code (moves cursor to next line)
        jsr $FFD2               ; Output via CHROUT with carriage return (cursor to line 3)
        jsr $FFD2               ; Output via CHROUT again (cursor to line 4)
        jsr $FFD2               ; Output via CHROUT again (cursor to line 5)

        ; Reset to C64 default colors (load to accumulator and store)
        lda #$0E                ; Load light blue border
        sta $D020               ; Write color to memory
        lda #$06                ; Load blue background
        sta $D021               ; Write color to memory
        rts                     ; Return to BASIC

HELLOWORLD
        byte 8, 5, 12, 12, 15   ; Screen codes: H=8, E=5, L=12, L=12, O=15
        byte 44                 ; Screen code for comma=44
        byte 32                 ; Screen code for space=32
        byte 23, 15, 18, 12, 4  ; Screen codes: W=23, O=15, R=18, L=12, D=4
        byte 33                 ; Screen code for exclamation point=33
        byte 0                  ; Null terminator

HELLOWORLD_COLORS
        byte 2, 5, 3, 4, 7      ; Red, Green, Cyan, Purple, Yellow for "HELLO"
        byte 1, 1               ; White for comma and space
        byte 15, 8, 10, 13, 14  ; Lt Gray, Orange, Lt Red, Lt Green, Lt Blue for "WORLD"
        byte 1                  ; White for exclamation point
        byte 0                  ; Null terminator

PRESSKEY
        byte 16, 18, 5, 19, 19  ; Screen codes for "PRESS"        
        byte 32                 ; Screen code for space
        byte 1, 14, 25          ; Screen code for "ANY"
        byte 32                 ; Screen code for space
        byte 11, 5, 25          ; Screen codes for "KEY"
        byte 0                  ; Null terminator

GETIN           ; GETIN subroutine: Waits for a key press
        jsr $FFE4               ; Call Kernal GETIN routine
        cmp #$00                ; Check if a key was pressed
        beq GETIN               ; If no key, loop back and check again
        rts                     ; Return to BASIC when a key is pressed