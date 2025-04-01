; C64 Assembly "Hello World" Program with Multi-Color
; Prints "HELLO WORLD" with a different color for each letter

; 10 SYS (2304)

*=$0801                 ; BASIC stub starting address
        BYTE    $0E, $08, $0A, $00, $9E, $20, $28, $32
        BYTE    $33, $30, $34, $29, $00, $00, $00

*=$0900                 ; Assembly program starting address
        lda #$93        ; Load PETSCII code for clear screen into the accumulator
        jsr $FFD2       ; Call CHROUT with the PETSCII clear code to clear the screen
        lda #$08        ; Set uppercase/graphics mode (optional)
        ldx #$00        ; Initialize X register as index (starts at 0)

NEXT_CHAR
        lda HELLOWORLD,x ; Load screen code from string at index X
        beq END          ; If it’s 0 (null terminator), exit
        sta $0400,x     ; Write screen code to screen memory
        lda COLORS,x    ; Load color code from color table at index X
        sta $D800,x     ; Write color to color memory
        inx             ; Move to next character
        jmp NEXT_CHAR   ; Repeat

END
        rts             ; Return to BASIC

HELLOWORLD
        byte 8, 5, 12, 12, 15    ; Screen codes: H=8, E=5, L=12, L=12, O=15
        byte 32                  ; Screen code for space=32
        byte 23, 15, 18, 12, 4   ; Screen codes: W=23, O=15, R=18, L=12, D=4
        byte 0                   ; Null terminator

COLORS
        byte 2, 5, 3, 4, 7       ; Red, Green, Cyan, Purple, Yellow for "HELLO"
        byte 1                   ; White for space
        byte 15, 8, 10, 13, 14   ; Light Gray, Orange, Light Red, Light Green, Light Blue for "WORLD"        