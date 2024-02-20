
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

imprimir macro texto
    mov ah,9
    mov dx,offset texto
    int 21h
endm

jmp inicio

consigna  db 10,13,"En este juego deberas encontrar en la sopa de letras las respuestas"       
          db 10,13,"a las consignas que se mostraran a continuacion y "
          db 10,13,"tendras que responderlas en el orden establecido."
          db 10,13,"Podras moverte con las teclas 'A','S','D' y 'W', "
          db 10,13,"y con la tecla 'ENTER' podras seleccionar las letras.",'$' 

archivo_pre db "Preguntas.txt",0

handler1 dw ?

preguntas db 555 dup(' ') ;aprox cantidad de lugares para las preguntas   
salto db 10,13,'$'



inicio:
call abrir_preguntas 


imprimir consigna
call imprimir_inicio



ret

proc imprimir_inicio 
    xor bx,bx
    mov bx,offset preguntas
    
    ciclo:
    cmp preguntas[bx],'$'
    je final
    
    cmp preguntas[bx],'#'
    jbe salto_linea
    jne continuar
    
    continuar:
    imprimir preguntas[bx]
    inc bx
    jmp ciclo
    
    salto_linea: 
    imprimir salto
    inc bx
    jmp ciclo
    
    final:
    ret
endp imprimir_inicio

    
    



 
;*********************************************************************************************
;                              ABRIR ARCHIVO CON LAS PREGUNTAS
;*********************************************************************************************

proc abrir_preguntas
   
    abrir1:
    mov ah,3dh
    mov al,0
    mov dx,offset archivo_pre
    int 21h
    mov handler1,ax
    
    leer1:
    mov ah,3fh
    mov bx,handler1
    mov dx,offset preguntas
    mov cx,ax 
    int 21h
         
    cerrar1:
    mov ah,3eh
    mov bx,handler1
    int 21h
    
    ret
endp abrir_preguntas


    
 