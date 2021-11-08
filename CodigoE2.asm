#include "p16F887.inc"   ; TODO INSERT CONFIG CODE HERE USING CONFIG BITS GENERATOR
 	__CONFIG	_CONFIG1,	_INTRC_OSC_NOCLKOUT & _WDT_OFF & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOR_OFF & _IESO_ON & _FCMEN_ON & _LVP_OFF 
 	__CONFIG	_CONFIG2,	_BOR40V & _WRT_OFF

RES_VECT  CODE    0x0000            ; processor reset vector
    GOTO    START                   ; go to beginning of program

MAIN_PROG CODE                      ; let linker place main program
i EQU 0x20
j EQU 0x21
k EQU 0x30
m EQU 0x31
q EQU 0x34
r EQU 0x35
s EQU 0x36
o EQU 0x37
p EQU 0x38
x EQU 0x39
y EQU 0x40
aux EQU 0x70
pos1 EQU 0x41	    ;Posicion y almacen de primera palabra
leta1 EQU 0x42
leta2 EQU 0x43
leta3 EQU 0x44
leta4 EQU 0x45
leta5 EQU 0x46
leta6 EQU 0x47
leta7 EQU 0x48
leta8 EQU 0x49
pos2 EQU 0x50	    ;Posicion y almacen de segunda palabra
letb1 EQU 0x51
letb2 EQU 0x52
letb3 EQU 0x53
letb4 EQU 0x54
letb5 EQU 0x55
letb6 EQU 0x56
letb7 EQU 0x57
letb8 EQU 0x58

 
START

    BANKSEL PORTA
    CLRF PORTA
    BANKSEL ANSEL
    CLRF ANSEL
    CLRF ANSELH
    BANKSEL TRISA
    CLRF TRISA
    CLRF TRISB
    CLRF TRISC
    MOVLW b'00000111'
    MOVWF TRISD
    CLRF TRISE
    BCF STATUS,RP1
    BCF STATUS,RP0
    MOVLW b'00101000'
    MOVWF TRISA
    CLRF TRISB
    CLRF TRISC
    CLRF TRISE
    
EMPIEZALCD
    BCF PORTA,0	
    MOVLW 0x01
    MOVWF PORTB
    
    BSF PORTA,1	
    CALL time
    BCF PORTA,1
    CALL time
    
    MOVLW 0x0C	
    MOVWF PORTB
    
    BSF PORTA,1	
    CALL time
    BCF PORTA,1
    CALL time
         
    MOVLW 0x3C	
    MOVWF PORTB
    
    BSF PORTA,1	
    CALL time
    BCF PORTA,1
    CALL time
    
STARTL
    MOVLW d'0'
    MOVWF r
    MOVLW d'0'
    MOVWF s
    MOVLW 0xC2
    MOVWF pos1
    MOVLW 0xD2
    MOVWF pos2
    MOVLW 0x42
    MOVWF FSR
    MOVLW b'00000001'
    MOVWF aux
   
    CALL PEDIR
    
PROG
    BCF STATUS, C
    BTFSC PORTA, 5
    GOTO $+6
    RRF aux
    BTFSS STATUS, C
    GOTO $+3
    MOVLW 0x51
    MOVWF FSR
    MOVLW b'00101000'
    MOVWF PORTA
    MOVLW b'00010000'
    MOVWF PORTD
    CALL BOTON1
    RLF PORTD
    CALL BOTON4
    RLF PORTD
    CALL BOTON7
    RLF PORTD
    CALL BOTONA
    GOTO PROG
    
BOTON1
    BTFSS PORTD, 0
    GOTO BOTON2
    GOTO IMPRIMIR1

BOTON2
    BTFSS PORTD, 1
    GOTO BOTON3
    GOTO IMPRIMIR2
 
BOTON3
    BTFSS PORTD, 2
    RETURN
    GOTO IMPRIMIR3

BOTON4
    BTFSS PORTD, 0
    GOTO BOTON5
    GOTO IMPRIMIR4

BOTON5
    BTFSS PORTD, 1
    GOTO BOTON6
    GOTO IMPRIMIR5
 
BOTON6
    BTFSS PORTD, 2
    RETURN
    GOTO IMPRIMIR6
    
BOTON7
    BTFSS PORTD, 0
    GOTO BOTON8
    GOTO IMPRIMIR7

BOTON8
    BTFSS PORTD, 1
    GOTO BOTON9
    GOTO IMPRIMIR8
 
BOTON9
    BTFSS PORTD, 2
    RETURN
    GOTO IMPRIMIR9
    
BOTONA
    BTFSS PORTD, 0
    GOTO BOTON0
    GOTO NUEVO
    
BOTON0
    BTFSS PORTD, 1
    GOTO BOTONG
    GOTO IMPRIMIR0
    
BOTONG
    BTFSS PORTD, 2
    RETURN
    GOTO COMPROBAR
    
ARRIBA
    BCF PORTA,0	
    CALL time
    
    MOVFW pos1	
    MOVWF PORTB
   
    CALL exec
    
    BSF PORTA,0	
    CALL time
    
    RETURN
    
ABAJO
    BCF PORTA,0	
    CALL time
    
    MOVFW pos2	
    MOVWF PORTB
    
    CALL exec
    
    BSF PORTA,0	
    CALL time
    
    RETURN
    
LUGAR
    BTFSC PORTA, 3
    GOTO $+3
    CALL ARRIBA
    GOTO $+4
    BTFSC PORTA, 5
    GOTO $+2
    CALL ABAJO
    RETURN
    
IMPRIMIR1
    CALL segundo
    CALL GUARDAR1
    BTFSC PORTA, 3
    GOTO $+3
    INCF pos1
    GOTO $+4
    BTFSC PORTA, 5
    GOTO $+2
    INCF pos2
    CALL LUGAR
    MOVLW '1'
    MOVWF PORTB
    CALL exec
    call segundo
    BTFSC PORTA, 3
    GOTO $+2
    CALL OCULTAR
    BTFSC PORTA, 5
    GOTO $+2
    GOTO OCULTAR2
    GOTO PROG
    
IMPRIMIR2
   CALL segundo
   call GUARDAR2
    BTFSC PORTA, 3
    GOTO $+3
    INCF pos1
    GOTO $+4
    BTFSC PORTA, 5
    GOTO $+2
    INCF pos2
    CALL LUGAR
    MOVLW '2'
    MOVWF PORTB
    CALL exec
    call segundo
    BTFSC PORTA, 3
    GOTO $+2
    CALL OCULTAR
    BTFSC PORTA, 5
    GOTO $+2
    GOTO OCULTAR2
    GOTO PROG
    
IMPRIMIR3
    CALL segundo
    CALL GUARDAR3
    BTFSC PORTA, 3
    GOTO $+3
    INCF pos1
    GOTO $+4
    BTFSC PORTA, 5
    GOTO $+2
    INCF pos2
    CALL LUGAR
    MOVLW '3'
    MOVWF PORTB
    CALL exec
    call segundo
    BTFSC PORTA, 3
    GOTO $+2
    CALL OCULTAR
    BTFSC PORTA, 5
    GOTO $+2
    GOTO OCULTAR2
    GOTO PROG
    
IMPRIMIR4
    CALL segundo
    CALL GUARDAR4
    BTFSC PORTA, 3
    GOTO $+3
    INCF pos1
    GOTO $+4
    BTFSC PORTA, 5
    GOTO $+2
    INCF pos2
    CALL LUGAR
    MOVLW '4'
    MOVWF PORTB
    CALL exec
    call segundo
    BTFSC PORTA, 3
    GOTO $+2
    CALL OCULTAR
    BTFSC PORTA, 5
    GOTO $+2
    GOTO OCULTAR2
    GOTO PROG
 
IMPRIMIR5
    CALL segundo
    CALL GUARDAR5
    BTFSC PORTA, 3
    GOTO $+3
    INCF pos1
    GOTO $+4
    BTFSC PORTA, 5
    GOTO $+2
    INCF pos2
    CALL LUGAR
    MOVLW '5'
    MOVWF PORTB
    CALL exec
    call segundo
    BTFSC PORTA, 3
    GOTO $+2
    CALL OCULTAR
    BTFSC PORTA, 5
    GOTO $+2
    GOTO OCULTAR2
    GOTO PROG
    
IMPRIMIR6
    CALL segundo
    CALL GUARDAR6
    BTFSC PORTA, 3
    GOTO $+3
    INCF pos1
    GOTO $+4
    BTFSC PORTA, 5
    GOTO $+2
    INCF pos2
    CALL LUGAR
    MOVLW '6'
    MOVWF PORTB
    CALL exec
    call segundo
    BTFSC PORTA, 3
    GOTO $+2
    CALL OCULTAR
    BTFSC PORTA, 5
    GOTO $+2
    GOTO OCULTAR2
    GOTO PROG
    
IMPRIMIR7
    CALL segundo
    CALL GUARDAR7
    BTFSC PORTA, 3
    GOTO $+3
    INCF pos1
    GOTO $+4
    BTFSC PORTA, 5
    GOTO $+2
    INCF pos2
    CALL LUGAR
    MOVLW '7'
    MOVWF PORTB
    CALL exec
    call segundo
    BTFSC PORTA, 3
    GOTO $+2
    CALL OCULTAR
    BTFSC PORTA, 5
    GOTO $+2
    GOTO OCULTAR2
    GOTO PROG
    
IMPRIMIR8
    CALL segundo
    CALL GUARDAR8
    BTFSC PORTA, 3
    GOTO $+3
    INCF pos1
    GOTO $+4
    BTFSC PORTA, 5
    GOTO $+2
    INCF pos2
    CALL LUGAR
    MOVLW '8'
    MOVWF PORTB
    CALL exec
    call segundo
    BTFSC PORTA, 3
    GOTO $+2
    CALL OCULTAR
    BTFSC PORTA, 5
    GOTO $+2
    GOTO OCULTAR2
    GOTO PROG
    
IMPRIMIR9
    CALL segundo
    CALL GUARDAR9
    BTFSC PORTA, 3
    GOTO $+3
    INCF pos1
    GOTO $+4
    BTFSC PORTA, 5
    GOTO $+2
    INCF pos2
    CALL LUGAR
    MOVLW '9'
    MOVWF PORTB
    CALL exec
    call segundo
    BTFSC PORTA, 3
    GOTO $+2
    CALL OCULTAR
    BTFSC PORTA, 5
    GOTO $+2
    GOTO OCULTAR2
    GOTO PROG
    
IMPRIMIR0
    CALL segundo
    CALL GUARDAR0
    BTFSC PORTA, 3
    GOTO $+3
    INCF pos1
    GOTO $+4
    BTFSC PORTA, 5
    GOTO $+2
    INCF pos2
    CALL LUGAR
    MOVLW '0'
    MOVWF PORTB
    CALL exec
    call segundo
    BTFSC PORTA, 3
    GOTO $+2
    CALL OCULTAR
    BTFSC PORTA, 5
    GOTO $+2
    GOTO OCULTAR2
    GOTO PROG
    
GUARDAR1
    MOVLW d'1'
    MOVWF INDF
    INCF FSR
    RETURN
 
GUARDAR2
    MOVLW d'2'
    MOVWF INDF
    INCF FSR
    RETURN
    
GUARDAR3
    MOVLW d'3'
    MOVWF INDF
    INCF FSR
    RETURN
  
GUARDAR4
    MOVLW d'4'
    MOVWF INDF
    INCF FSR
    RETURN
    
GUARDAR5
    MOVLW d'5'
    MOVWF INDF
    INCF FSR
    RETURN
 
GUARDAR6
    MOVLW d'6'
    MOVWF INDF
    INCF FSR
    RETURN
    
GUARDAR7
    MOVLW d'7'
    MOVWF INDF
    INCF FSR
    RETURN
    
GUARDAR8
    MOVLW d'8'
    MOVWF INDF
    INCF FSR
    RETURN
    
GUARDAR9
    MOVLW d'9'
    MOVWF INDF
    INCF FSR
    RETURN
    
GUARDAR0
    MOVLW d'0'
    MOVWF INDF
    INCF FSR
    RETURN
    
COMPROBAR
    MOVFW leta1
    XORWF letb1
    BTFSS STATUS, Z
    CALL MAL
    MOVFW leta2
    XORWF letb2
    BTFSS STATUS, Z
    CALL MAL
    MOVFW leta3
    XORWF letb3
    BTFSS STATUS, Z
    CALL MAL
    MOVFW leta4
    XORWF letb4
    BTFSS STATUS, Z
    CALL MAL
    MOVFW leta5
    XORWF letb5
    BTFSS STATUS, Z
    CALL MAL
    MOVFW leta6
    XORWF letb6
    BTFSS STATUS, Z
    CALL MAL
    MOVFW leta7
    XORWF letb7
    BTFSS STATUS, Z
    CALL MAL
    MOVFW leta8
    XORWF letb8
    BTFSS STATUS, Z
    CALL MAL
    CALL BIEN
    GOTO PROG
    
BIEN
    MOVLW d'2'
    MOVWF PORTE
    
    CALL segundo
    BCF PORTA,0	
    MOVLW 0x01
    MOVWF PORTB
    
    BSF PORTA,1
    CALL time
    BCF PORTA,1
    CALL time
    
    MOVLW 0x0C	
    MOVWF PORTB
    
    BSF PORTA,1	
    CALL time
    BCF PORTA,1
    CALL time
     
    ACEPTADO
    MOVLW 0x3C	
    MOVWF PORTB
    
    BSF PORTA,1
    CALL time
    BCF PORTA,1
    CALL time
    
    BCF PORTA,0	
    CALL time
    
    MOVLW 0x86	
    MOVWF PORTB
    CALL exec
    
    BSF PORTA,0	
    CALL time
    
    MOVLW 'L'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'A'
    MOVWF PORTB
    CALL exec
    
    ;NUEVO
    BCF PORTA,0	
    CALL time
    
    MOVLW 0xC3
    MOVWF PORTB
    CALL exec
    
    BSF PORTA,0	
    CALL time
    
    MOVLW 'C'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'O'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'N'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'T'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'R'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'A'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'S'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'E'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'N'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'A'
    MOVWF PORTB
    CALL exec
    
    ;NUEVO
    BCF PORTA,0
    CALL time
    
    MOVLW 0x96	
    MOVWF PORTB
    CALL exec
    
    BSF PORTA,0	
    CALL time
    
    MOVLW 'E'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'S'
    MOVWF PORTB
    CALL exec
    
    ;NUEVO
    BCF PORTA,0	
    CALL time
    
    MOVLW 0xD4	
    MOVWF PORTB
    CALL exec
    
    BSF PORTA,0	
    CALL time
    
    MOVLW 'C'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'O'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'R'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'R'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'E'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'C'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'T'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'A'
    MOVWF PORTB
    CALL exec
    
    GOTO PROG
    
    
MAL
    MOVLW d'1'
    MOVWF PORTE
    
    CALL segundo
    BCF PORTA,0
    MOVLW 0x01
    MOVWF PORTB
    
    BSF PORTA,1
    CALL time
    BCF PORTA,1
    CALL time
    
    MOVLW 0x0C	
    MOVWF PORTB
    
    BSF PORTA,1	
    CALL time
    BCF PORTA,1
    CALL time
    
    DECLINADO
    
    MOVLW 0x3C	
    MOVWF PORTB
    
    BSF PORTA,1
    CALL time
    BCF PORTA,1
    CALL time
    
    BCF PORTA,0	
    CALL time
    
    MOVLW 0x86	
    MOVWF PORTB
    CALL exec
    
    BSF PORTA,0
    CALL time
    
    MOVLW 'L'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'A'
    MOVWF PORTB
    CALL exec
    
    ;NUEVO
    BCF PORTA,0	
    CALL time
    
    MOVLW 0xC3	
    MOVWF PORTB
    CALL exec
    
    BSF PORTA,0		;data mode
    CALL time
    
    MOVLW 'C'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'O'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'N'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'T'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'R'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'A'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'S'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'E'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'N'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'A'
    MOVWF PORTB
    CALL exec
    
    ;NUEVO
    BCF PORTA,0	
    CALL time
    
    MOVLW 0x96	
    MOVWF PORTB
    CALL exec
    
    BSF PORTA,0	
    CALL time
    
    MOVLW 'E'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'S'
    MOVWF PORTB
    CALL exec
    
    ;NUEVO
    BCF PORTA,0	
    CALL time
    
    MOVLW 0xD3	
    MOVWF PORTB
    CALL exec
    
    BSF PORTA,0	
    CALL time
    
    MOVLW 'I'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'N'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'C'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'O'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'R'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'R'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'E'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'C'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'T'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'A'
    MOVWF PORTB
    CALL exec
    
    GOTO PROG
    
PEDIR
    BCF PORTA,0	
    CALL time
    
    MOVLW 0x80	
    MOVWF PORTB
    CALL exec
    
    BSF PORTA,0	
    CALL time
    
    MOVLW 'C'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'O'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'N'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'T'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'R'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'A'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'S'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'E'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'N'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'A'
    MOVWF PORTB
    CALL exec
    
    MOVLW ':'
    MOVWF PORTB
    CALL exec
    
    BCF PORTA,0	
    CALL time
    
    MOVLW 0x90	
    MOVWF PORTB
    CALL exec
    
    BSF PORTA,0	
    CALL time
    
    MOVLW 'C'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'O'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'N'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'F'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'I'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'R'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'M'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'E'
    MOVWF PORTB
    CALL exec
    
    MOVLW ':'
    MOVWF PORTB
    CALL exec
   
    GOTO PROG
    
OCULTAR
    BCF PORTA,0	
    CALL time
    
    MOVFW pos1
    MOVWF PORTB
    CALL exec
    
    BSF PORTA,0	
    CALL time
    
    MOVLW '>'
    MOVWF PORTB
    CALL exec
    
    GOTO PROG
    
OCULTAR2
    BCF PORTA,0	
    CALL time
    
    MOVFW pos2
    MOVWF PORTB
    CALL exec
    
    BSF PORTA,0	
    CALL time
    
    MOVLW '>'
    MOVWF PORTB
    CALL exec
    
    GOTO PROG
    
NUEVO
    MOVLW d'0'
    MOVWF PORTE
    GOTO EMPIEZALCD
    
exec

    BSF PORTA,1	
    CALL time
    BCF PORTA,1
    CALL time
    RETURN

time
    CLRF i
    MOVLW d'10'
    MOVWF j
ciclo    
    MOVLW d'80'
    MOVWF i
    DECFSZ i
    GOTO $-1
    DECFSZ j
    GOTO ciclo
    RETURN
    
segundo
nop
nop
movlw d'151'
movwf o
oloop
    decfsz o,f
    goto oloop
    movlw d'43'
    movwf p
ploop
    nop
    movlw d'70' 
    movwf y
yloop

    movlw d'20' 
    movwf x
xloop
    nop
    decfsz x,f
    goto xloop
    decfsz y,f
    goto yloop
    decfsz p,f
    goto ploop
    return
 END