#define __SFR_OFFSET 0
#include "avr/io.h"

.equ PIN_LENGTH, 4
.equ PIN_START, 0x0100
.equ CORRECT_PIN, 0x0200

.global main
.global PCINT2_vect

;========================= MAIN =============================
main:
    LDI R16, hi8(RAMEND)
    OUT SPH, R16
    LDI R16, lo8(RAMEND)
    OUT SPL, R16

    LDI R16, 0b00001111
    OUT DDRC, R16

    CBI PORTC, 5
    SBI PORTC, 5

    LDI R16, 0xFF
    OUT DDRB, R16

    LDI R16, 0b11110000
    OUT DDRD, R16

    LDI R16, 0b00001111
    OUT PORTD, R16

    RCALL delay_ms
    RCALL LCD_init
    RCALL display_label

    LDI R30, lo8(CORRECT_PIN)
    LDI R31, hi8(CORRECT_PIN)
    LDI R16, '2'
    ST Z+, R16
    LDI R16, '0'
    ST Z+, R16
    LDI R16, '0'
    ST Z+, R16
    LDI R16, '3'
    ST Z+, R16

    LDI R30, hi8(PIN_START)
    LDI R31, lo8(PIN_START)
    LDI R16, 0
    LDI R17, PIN_LENGTH

clear_buffer:
    ST Z+, R16
    DEC R17
    BRNE clear_buffer

    LDI R18, 0
    LDI R19, 0

    LDI R16, 0x0F
    STS PCMSK2, R16
    LDI R16, 0x04
    STS PCICR, R16

    ; === Setup Timer1 for Servo PWM on OC1B (PB2) ===
    ; TCCR1A = COM1B1 | WGM11
    LDI R16, (1 << COM1B1) | (1 << WGM11)
    STS TCCR1A, R16

    ; TCCR1B = WGM13 | WGM12 | CS12 (prescaler 256)
    LDI R16, (1 << WGM13) | (1 << WGM12) | (1 << CS12)
    STS TCCR1B, R16

    ; ICR1 = TOP = 1249 → 20ms period @ 16MHz/256
    LDI R16, lo8(1249)
    STS ICR1L, R16
    LDI R16, hi8(1249)
    STS ICR1H, R16

    SEI

main_loop:
    SLEEP
    ; Default servo angle = 0° → ~0.5ms = OCR1B = 31
    RCALL servo_0deg
    RJMP main_loop

;========================= LCD INIT =============================
LCD_init:
    LDI R16, 51
    RCALL command_wrt
    RCALL delay_ms
    LDI R16, 50
    RCALL command_wrt
    RCALL delay_ms
    LDI R16, 40
    RCALL command_wrt
    RCALL delay_ms
    LDI R16, 12
    RCALL command_wrt
    LDI R16, 1
    RCALL command_wrt
    RCALL delay_ms
    LDI R16, 6
    RCALL command_wrt
    RET

;========================= LCD WRITES =============================
command_wrt:
    MOV R27, R16
    ANDI R27, 0xF0
    LSR R27
    LSR R27
    LSR R27
    LSR R27
    OUT PORTC, R27
    CBI PORTB, 1
    SBI PORTB, 0
    CBI PORTB, 0
    MOV R27, R16
    SWAP R27
    ANDI R27, 0xF0
    LSR R27
    LSR R27
    LSR R27
    LSR R27
    OUT PORTC, R27
    SBI PORTB, 0
    CBI PORTB, 0
    RET

data_wrt:
    MOV R27, R16
    ANDI R27, 0xF0
    LSR R27
    LSR R27
    LSR R27
    LSR R27
    OUT PORTC, R27
    SBI PORTB, 1
    SBI PORTB, 0
    CBI PORTB, 0
    MOV R27, R16
    SWAP R27
    ANDI R27, 0xF0
    LSR R27
    LSR R27
    LSR R27
    LSR R27
    OUT PORTC, R27
    SBI PORTB, 0
    CBI PORTB, 0
    RET

;========================= DISPLAY TEXT =============================
display_label:
    LDI R16, 'P'
    RCALL data_wrt
    LDI R16, 'A'
    RCALL data_wrt
    LDI R16, 'S'
    RCALL data_wrt
    LDI R16, 'S'
    RCALL data_wrt
    LDI R16, 'W'
    RCALL data_wrt
    LDI R16, 'O'
    RCALL data_wrt
    LDI R16, 'R'
    RCALL data_wrt
    LDI R16, 'D'
    RCALL data_wrt
    LDI R16, ':'
    RCALL data_wrt
    RET

access_granted:
    LDI R16, 0xC0
    RCALL command_wrt
    LDI R16, 'A'
    RCALL data_wrt
    LDI R16, 'c'
    RCALL data_wrt
    LDI R16, 'c'
    RCALL data_wrt
    LDI R16, 'e'
    RCALL data_wrt
    LDI R16, 's'
    RCALL data_wrt
    LDI R16, 's'
    RCALL data_wrt
    LDI R16, ' '
    RCALL data_wrt
    LDI R16, 'G'
    RCALL data_wrt
    LDI R16, 'r'
    RCALL data_wrt
    LDI R16, 'a'
    RCALL data_wrt
    LDI R16, 'n'
    RCALL data_wrt
    LDI R16, 't'
    RCALL data_wrt
    LDI R16, 'e'
    RCALL data_wrt
    LDI R16, 'd'
    RCALL data_wrt
    LDI R16, '!'
    RCALL data_wrt
    RET

access_denied:
    LDI R16, 0xC0
    RCALL command_wrt
    LDI R16, 'A'
    RCALL data_wrt
    LDI R16, 'c'
    RCALL data_wrt
    LDI R16, 'c'
    RCALL data_wrt
    LDI R16, 'e'
    RCALL data_wrt
    LDI R16, 's'
    RCALL data_wrt
    LDI R16, 's'
    RCALL data_wrt
    LDI R16, ' '
    RCALL data_wrt
    LDI R16, 'D'
    RCALL data_wrt
    LDI R16, 'e'
    RCALL data_wrt
    LDI R16, 'n'
    RCALL data_wrt
    LDI R16, 'i'
    RCALL data_wrt
    LDI R16, 'e'
    RCALL data_wrt
    LDI R16, 'd'
    RCALL data_wrt
    LDI R16, '!'
    RCALL data_wrt
    RET

restricted:
    LDI R16, 0x80          ; LCD line 1, pos 0
    RCALL command_wrt
    LDI R16, 'R'
    RCALL data_wrt
    LDI R16, 'E'
    RCALL data_wrt
    LDI R16, 'S'
    RCALL data_wrt
    LDI R16, 'T'
    RCALL data_wrt
    LDI R16, 'R'
    RCALL data_wrt
    LDI R16, 'I'
    RCALL data_wrt
    LDI R16, 'C'
    RCALL data_wrt
    LDI R16, 'T'
    RCALL data_wrt
    LDI R16, 'E'
    RCALL data_wrt
    LDI R16, 'D'
    RCALL data_wrt
    LDI R16, '!'
    RCALL data_wrt
    LDI R16, '!'
    RCALL data_wrt
    LDI R16, '!'
    RCALL data_wrt
    RET
;========================= RESETS =============================
blink:
    LDI R28, 12
blink_loop:
    DEC R28
    SBI PINB, 4
    RCALL delay_blink
    CPI R28, 0
    BRNE  blink_loop
    RET
    
reset_input:
;------ RESET LEDS & SERVO --------
    CBI PORTB, 3
    CBI PORTB, 4
    SBI PORTB, 5
    RCALL servo_0deg
;-------- CLEAR LCD ----------
    LDI R16, 0xC0
    RCALL command_wrt
    LDI R17, 16
    LDI R16, ' '
clear_row2_loop:
    RCALL data_wrt
    DEC R17
    BRNE clear_row2_loop
    LDI R16, 0x89
    RCALL command_wrt
    LDI R17, PIN_LENGTH
    LDI R16, ' '
clear_pin_loop:
    RCALL data_wrt
    DEC R17
    BRNE clear_pin_loop
    LDI R16, 0x89
    RCALL command_wrt
    LDI R30, hi8(PIN_START)
    LDI R31, lo8(PIN_START)
    LDI R16, 0
    LDI R17, PIN_LENGTH
clear_sram_loop:
    ST Z+, R16
    DEC R17
    BRNE clear_sram_loop
    LDI R18, 0
    RET
; =================== SERVO CONTROL ===================
servo_0deg:
    LDI R16, lo8(31)
    STS OCR1BL, R16
    LDI R16, hi8(31)
    STS OCR1BH, R16
    RET

servo_90deg:
    LDI R16, lo8(93)
    STS OCR1BL, R16
    LDI R16, hi8(93)
    STS OCR1BH, R16
    RET
;========================= DELAYS =============================
;-------- SHORT DELAY FOR DEBOUNCING AND LCD RESET --------
delay_ms:
    LDI R24, 16
    RCALL delay_timer0
    RET
;--------------- .25s DELAY FOR BLINKING LEDS ------------
delay_blink:
    LDI R30, 15
wait_blink:
    LDI R24, 255
    RCALL delay_timer0
    DEC R30
    CPI R30, 0
    BRNE  wait_blink
    RET    
;-------------- 3 SECOND DELAY ----------------
delay_3s:
    SBI PORTC, 5       ; Enable pull up on PC5
    LDI R30, 183       ; ~3s counter (depends on delay_timer0)
wait_3s:
    LDI R24, 255
    RCALL delay_timer0
    ; Check if button is pressed
    SBIS PINC, 5       ; Skip next if pin is high (not pressed)
    RJMP exit_wait     ; Button pressed -> exit loop
    ; Decrement time
    DEC R30
    CPI R30, 0
    BRNE wait_3s       ; Loop if time not up
exit_wait:
    RET
;---------------- TIMER0 FOR DELAYS ---------------
delay_timer0:             
    CLR   R20
    OUT   TCNT0, R20      ;initialize timer0 with count=0
    OUT   OCR0A, R24      ;OCR0 = R24
    LDI   R20, 0b00001101
    OUT   TCCR0B, R20     ;timer0: CTC mode, prescaler 1024
wait_0: 
    IN    R20, TIFR0      ;get TIFR0 byte & check
    SBRS  R20, OCF0A      ;if OCF0=1, skip next instruction
    RJMP  wait_0          ;else, loop back & check OCF0 flag
    CLR   R20
    OUT   TCCR0B, R20     ;stop timer0
    LDI   R20, (1<<OCF0A)
    OUT   TIFR0, R20      ;clear OCF0 flag
    RET
;========================= KEYPAD SCAN =============================
keypad:
    RCALL delay_ms
    IN R21, PIND
    ANDI R21, 0x0F
    CPI R21, 0x0F
    BREQ keypad

    IN R22, PORTD
    ANDI R22, 0x0F
    ORI R22, 0b01110000
    OUT PORTD, R22
    RCALL ROW1
    CPI R16, 0
    BRNE done

    IN R22, PORTD
    ANDI R22, 0x0F
    ORI R22, 0b10110000
    OUT PORTD, R22
    RCALL ROW2
    CPI R16, 0
    BRNE done

    IN R22, PORTD
    ANDI R22, 0x0F
    ORI R22, 0b11010000
    OUT PORTD, R22
    RCALL ROW3
    CPI R16, 0
    BRNE done

    IN R22, PORTD
    ANDI R22, 0x0F
    ORI R22, 0b11100000
    OUT PORTD, R22
    RCALL ROW4

done:
    LDI R17, 0x0F
    OUT PORTD, R17
    RET

;========================= ROWS =============================
ROW1:
    LDI R16, 0
    SBIS PIND, 3
    RJMP ONE
    SBIS PIND, 2
    RJMP TWO
    SBIS PIND, 1
    RJMP THREE
    SBIS PIND, 0
    RJMP A
    RET

ROW2:
    LDI R16, 0
    SBIS PIND, 3
    RJMP FOUR
    SBIS PIND, 2
    RJMP FIVE
    SBIS PIND, 1
    RJMP SIX
    SBIS PIND, 0
    RJMP B
    RET

ROW3:
    LDI R16, 0
    SBIS PIND, 3
    RJMP SEVEN
    SBIS PIND, 2
    RJMP EIGHT
    SBIS PIND, 1
    RJMP NINE
    SBIS PIND, 0
    RJMP C
    RET

ROW4:
    LDI R16, 0
    SBIS PIND, 3
    RJMP STAR
    SBIS PIND, 2
    RJMP ZERO
    SBIS PIND, 1
    RJMP HASHTAG
    SBIS PIND, 0
    RJMP D
    RET

;========================= CHARACTER MAP =============================
ONE:
    LDI R16, '1'
    RET

TWO:
    LDI R16, '2'
    RET

THREE:
    LDI R16, '3'
    RET

FOUR:
    LDI R16, '4'
    RET

FIVE:
    LDI R16, '5'
    RET

SIX:
    LDI R16, '6'
    RET

SEVEN:
    LDI R16, '7'
    RET

EIGHT:
    LDI R16, '8'
    RET

NINE:
    LDI R16, '9'
    RET

ZERO:
    LDI R16, '0'
    RET

STAR:
    LDI R16, '*'
    RET

HASHTAG:
    LDI R16, '#'
    RET

A:
    LDI R16, 'A'
    RET

B:
    LDI R16, 'B'
    RET

C:
    LDI R16, 'C'
    RET

D:
    LDI R16, 'D'
    RET

;========================= ISR =============================
PCINT2_vect:
    RCALL keypad
    CPI R16, '*'
    BREQ skip_input
    CPI R16, '#'
    BREQ skip_input

    LDI R30, lo8(PIN_START)
    LDI R31, hi8(PIN_START)
    ADD R30, R18
    CLR R25
    ADC R31, R25
    ST Z, R16

    RCALL data_wrt
    INC R18
    CPI R18, PIN_LENGTH
    BRNE release_loop

    LDI R30, lo8(PIN_START)
    LDI R31, hi8(PIN_START)
    LDI R26, lo8(CORRECT_PIN)
    LDI R27, hi8(CORRECT_PIN)
    LDI R20, PIN_LENGTH

compare_loop:
    LD R22, Z+
    LD R23, X+
    CP R22, R23
    BRNE pin_incorrect
    DEC R20
    BRNE compare_loop

pin_correct:
    RCALL access_granted
    CLR   R19 
    RCALL servo_90deg
    SBI   PORTB, 3
    CBI   PORTB, 5
    RCALL delay_3s
    RCALL reset_input
    RJMP  release_loop

pin_incorrect:
    INC R19
    CPI R19, 2
    BRLO not_alarm
    RCALL alarm_state
    RJMP release_loop

not_alarm:
    RCALL access_denied
    RCALL blink
    RCALL reset_input

release_loop:
    IN R21, PIND
    ANDI R21, 0x0F
    CPI R21, 0x0F
    BRNE release_loop
    RCALL delay_ms

skip_input:
    RETI

; ======================= ALARM STATE =========================
alarm_state:
    RCALL restricted

alarm_loop:
    SBI PORTB, 4       ; PB4 HIGH
    CBI PORTB, 5       ; PB5 LOW
    RCALL delay_blink
    CBI PORTB, 4       ; PB4 LOW
    SBI PORTB, 5       ; PB5 HIGH
    RCALL delay_blink
    RJMP alarm_loop    ; Infinite loop