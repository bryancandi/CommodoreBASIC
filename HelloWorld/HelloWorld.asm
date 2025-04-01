; C64 Assembly "Hello World" Program
; Prints "hello world" to the screen and returns to BASIC.

; 10 SYS (2304)

*=$0801                 ; Set the starting memory address for the BASIC program

        BYTE    $0E, $08, $0A, $00, $9E, $20, $28,  $32
        BYTE    $33, $30, $34, $29, $00, $00, $00

PRINT_LINE = $AB1E      ; Kernal routine to print a null-terminated string

*=$0900                 ; Set the assembly program's starting address

START
        lda #<HELLOWORLD ; Load the low byte of HELLOWORLD's address into the accumulator
        ldy #>HELLOWORLD ; Load the high byte of HELLOWORLD's address into the Y register
        jsr PRINT_LINE   ; Call the Kernal's PRINT_LINE routine to display the string
        rts              ; Return from subroutine to BASIC

HELLOWORLD
        text "hello world" ; Store the string "hello world" as PETSCII characters
        byte 00            ; Null terminator (00) to end the string.
