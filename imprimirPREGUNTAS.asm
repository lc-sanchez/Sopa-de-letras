org 100h
  
  
jmp inicio

archivo_pre db "Preguntas.txt",0
handler1 dw ?
preguntas db 555 dup(' ') ;aprox cantidad de lugares para las preguntas   
        ;con 551 funca, pero con 550 NO!
        
new_line        db 10,13,'$'

 
inicio:
call abrir_preguntas 
call pantalla_modo_texto
call imprimir_preguntas

fin:
mov ah,4Ch
int 21h






proc abrir_preguntas
;-------------------   
    abrir1:
    mov ah,3Dh
    mov al,0  ;abrimos en modo lectura
    mov dx,offset archivo_pre 
    int 21h
    mov handler1,ax
    
    leer1:
    mov ah,3Fh
    mov bx,handler1
    mov dx,offset preguntas
    mov cx,ax 
    int 21h
         
    cerrar1:
    mov ah,3Eh
    mov bx,handler1
    int 21h
    
    ret
endp abrir_preguntas
        


proc pantalla_modo_texto  
;-----------------------    
    mov al, 03h   ;80x25
    mov ah, 0
    int 10h
    
    ret
endp pantalla_modo_texto

     


proc imprimir_preguntas
;----------------------   
    mov cx, 1                  ;arranco por la primera pregunta
    mov bx, offset preguntas  
      
    pregunta:
    cmp [bx], "$"
    jne ciclo_por_pregunta
    cmp cx,10                      ;10 --> cant preguntas
    jne siguiente_pregunta

    jmp fin1
    
    ciclo_por_pregunta:
    mov ah, 02h            ;imprime char
    mov dl, [bx]
    inc bx
    int 21h
    jmp pregunta
    
    siguiente_pregunta:
    inc bx 
    mov dx, offset new_line
    mov ah, 09h
    int 21h 
    inc cx
    jmp pregunta
    
    fin1: 
    ret
endp imprimir_preguntas 
    
     