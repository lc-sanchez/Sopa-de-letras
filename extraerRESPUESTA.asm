org 100h 


jmp inicio

handler2 dw ?
archivo_res db "Respuestas.txt",0 
respuestas db 50 dup(' ')


respuesta_correcta db ? 
numero_de_respuesta dw 0
  



inicio:
call abrir_respuestas
call extraer_una_respuesta
mov ah,4Ch
int 21h  


proc abrir_respuestas
  
    abrir2:
    mov ah,3dh
    mov al,0 ;abrimos en modo lectura
    mov dx,offset archivo_res
    int 21h
    mov handler2,ax    
    
    leer2:
    mov ah,3fh
    mov bx,handler2
    mov dx,offset respuestas
    mov cx,50
    int 21h
                 
    cerrar2:
    mov ah,3eh
    mov bx,handler2
    int 21h
    ret
endp abrir_respuestas 


proc extraer_una_respuesta
    xor bx,bx
    xor si,si
    mov bx, offset respuestas
    mov si, offset respuesta_correcta
    mov ax, 0
    mov cx,0
    
    chequear_numero_respuesta:
    cmp cx,numero_de_respuesta[0]            ;<- estoy en la primera respuesta
    je copiar_respuesta  
     
    buscar_respuesta:
    cmp [bx],"$"
    je sumar_apariciones
    inc bx
    jmp buscar_respuesta 
    
    sumar_apariciones:
    inc cx
    inc bx
    jmp chequear_numero_respuesta
    
     
    copiar_respuesta:
    cmp [bx],"$"
    je fin8
    
    mov al,[bx]
    mov [si],al
    
    inc bx
    inc si
 
    jmp copiar_respuesta   
    
    fin8:
    mov [si],"$" 
    ret
endp extraer_una_respuesta

