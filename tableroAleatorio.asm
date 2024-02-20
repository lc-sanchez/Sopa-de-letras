org 100h

jmp inicio 
;**************************************************************************
;*                         DEFINICION DE VARIABLES                        *
;**************************************************************************

new_line        db 10,13,'$'; Enter para imprimir el tablero correctamente

ancho db 15
alto db 20 

ini_cursor_x    EQU 0; Posicion inicial en X del cursor
ini_cursor_y    EQU 0; Posicion inicial en Y del cursor 
 
 
tabla   db "***************"
        db "***************"
        db "***************"
        db "***************"
        db "***************"
        db "***************"
        db "***************"
        db "***************"
        db "***************"
        db "***************"
        db "***************"
        db "***************"
        db "***************"
        db "***************"
        db "***************"
        db "***************"
        db "***************"
        db "***************"
        db "***************"
        db "***************",'$'
        
     
;***********************************************************************************************
;*                                AREA DE EJECUCION                                            *
;***********************************************************************************************
inicio:

call generar_letras
call print_tablero          

  ;Se lleva el cursor a la posicion inicial
mov dh, ini_cursor_y
mov dl, ini_cursor_x           
mov bh, 0
  
mov ah, 02h    ;coloco el cursor en la posicion ini_cursor_x  ini_cursor_x   
int 10h    
  
call DETECTAR_TECLA

   
ret
 
 
;***********************************************************************************************
;*                           GENERAR LETRAS ALEATORIAS                                         *
;*********************************************************************************************** 
proc generar_letras
    
    mov bx, 0
    jmp llenarVector
    jmp fin

    llenarVector:

    cmp bx, 301
    jae fin

    mov ah, 2Ch
    int 21h

    cmp dl,25
    ja llenarVector
    
    cmp tabla[bx],"*"
    je poner_letra_random
    inc bx 
    jmp llenarVector
    
    poner_letra_random:
    add dl, 41h
    mov tabla[bx], dl
    inc bx
    jmp llenarVector
    

    fin:
    endp generar_vector_letras
    ret
;************************************************************************************************
;*                                  ARMADO DE TABLA                                             *
;************************************************************************************************ 

print_tablero proc 
    ;Se establece el uso de la pantalla en modo texto
    mov al, 00h
    mov ah, 0
    int 10h 
    
    xor cx,cx
    mov bx, offset tabla
    mov cl, alto
  ptr_cont_fila:  
    push cx
    mov cl, ancho
    mov ah, 02h
  ptr_fila:
    mov dl, [bx]
    inc bx
    int 21h
    loop ptr_fila
    mov dx, offset new_line
    mov ah, 09h
    int 21h
    pop cx
    loop ptr_cont_fila 
ret
print_tablero endp 
;************************************************************************************************
;*                                  DETECTO TECLA PRESIONADA                                    *
;************************************************************************************************ 

DETECTAR_TECLA proc 
          
    tecla: 
    mov ah,0         
    int 16h  
    
    cmp al,"a"
    je izquierda 
    cmp al,"s"
    je abajo
    cmp al,"d"
    je derecha
    cmp al, "w"
    je arriba
    cmp al, 0Dh ;ascii de 'enter'
    je selecion_caracter
    
    jmp tecla
    
    derecha:
    call mover_derecha
    jmp tecla

    izquierda:
    call mover_izquierda    
    jmp tecla
    
    abajo:
    call mover_abajo    
    jmp tecla
    
    arriba:
    call mover_arriba    
    jmp tecla
    
    seleciono_caracter:
    call obtener_caracter    
              
    
;***********************************************************************************************
;*                   PROCEDIMIENTOS DE MOVIMIENTO CON DETECCION DE BORDES                      *
;***********************************************************************************************
 
proc mover_derecha

    mov bh,0
    mov ah,3 ;subfuncion de 10h que me permite obtener la pos del cursor 
    int 10h
    
    cmp dl,14   ;ancho del tablero (15-1) 
    je borde_derecha                      
    
    add dl,1
    mov ah,02h     ;seteo la pos del cursor
    int 10h
    
    ret     
    
    borde_derecha: 
    cmp al, "d"
    je saltar_a_la_izquierda 
    
    ret
    
    saltar_a_la_izquierda:
 
    mov dl, 0
    mov ah, 02h
    int 10h

    ret
    
endp mover_derecha

 
 
proc mover_izquierda
    
    mov bh,0
    mov ah,3 
    int 10h
    
    cmp dl,0   
    
    je borde_izquierdo 
    sub dl,1
    mov ah,02h     
    int 10h
    
    ret 

    borde_izquierdo:
    cmp al, "a"
    je saltar_a_la_derecha 
    
    ret
    
    saltar_a_la_derecha:
    mov dl, 14
    mov ah, 02h
    int 10h
    
    ret
endp mover_izquierda 
                     
    
                     
proc mover_abajo
    
    mov bh,0
    mov ah,3 
    int 10h
    
    cmp dh,19    
    je borde_inferior 
    inc dh
    mov ah,02h     
    int 10h
    
    ret    

    borde_inferior:  
    cmp al, "s"
    je saltar_arriba 
    
    ret
    
    saltar_arriba:
    mov dh, 0
    mov ah, 02h
    int 10h
    
    ret   
endp mover_abajo
      
      
proc mover_arriba
    
    mov bh,0
    mov ah,3 
    int 10h
    
    cmp dh,0   
    
    je borde_superior 
    sub dh,1
    mov ah,02h     
    int 10h
    
    ret   

    borde_superior:    
    cmp al, "w"
    je saltar_abajo 
    
    ret
    
    saltar_abajo:
    mov dh, 19
    mov ah, 02h
    int 10h
   
    ret 
    
endp mover_arriba 


