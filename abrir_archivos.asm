
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

imprimir macro texto
    mov ah,9
    mov dx,offset texto
    int 21h
endm

jmp inicio

titulo db "TRABAJO PRACTICO ORGANIZACION DEL COMPUTADOR",'$'

consigna  db "En este juego deberas encontrar en la sopa de letras las respuestas a las ",'#',       
          db "consignas que se mostraran a continuacion y tendras que responderlas en el ",'#'
          db "orden establecido. Podras moverte con las teclas 'A','S','D' y 'W'; con la ",'#'
          db "tecla 'ENTER' podras seleccionar las letras y con 'SPACE' podras indicar ",'#'
          db "que terminaste de seleccionar toda la palabra. Good Luck =)",'$'

;*********************************************************************


handler1 dw ?
preguntas db 560 dup(' ') ;aprox cantidad de lugares para las preguntas   
archivo_pre db "Preguntas.txt",0   

archivo_res db "Respuestas.txt",0 
handler2 dw ?
respuestas db 50 dup(' ')


new_line        db 10,13,'$';salto de linea


ancho      db 15
alto       db 20

msj_espera db "El tablero se ",'#' 
           db "esta armando...",'$'


msj_siguiente db "Presione F para continuar: ",'$'


titulo_preguntas db "PREGUNTAS: ",'$'

pos_inicial_X    EQU 0; Posicion inicial en X del cursor
pos_inicial_Y    EQU 2; Posicion inicial en Y del cursor  

tablero  db "***************"
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


;*****************************************************************
inicio:

call abrir_respuestas
call abrir_preguntas
call ubicar_respuestas
call ubicar_consigna
call detectar_nueva_ventana
call msj_esperar_armado
call imprimir_preguntas
call print_tablero

ret 

proc imprimir_preguntas
    ubicar_titulo:
    mov dh,0
    mov dl,16
    mov bh,0
    mov ah,2
    int 10h
    imprimir titulo_preguntas
    
    mov si,offset preguntas
    xor bl,bl
    mov bl,2
    xor al,al  
    
    ubicar_pregunta:
    add bl,1
    mov dh,bl      ;fila
    mov dl,17      ;columna
    mov bh,0
    mov ah,2
    int 10h
    
    
    imprimir_car_pregunta:
    add al,1
    mov dh,bl     ;fila
    mov dl,al     ;columna
    mov ah,2
    mov dl,[si]
    int 21h
    inc si
     
    cmp [si],'$'
    je fin_ubicar_preguntas
    cmp [si],'#'
    jne imprimir_car_pregunta
    
    inc si
    jmp ubicar_pregunta
    
    fin_ubicar_preguntas:
    ret
endp imprimir_preguntas
    
;***********************************************************************************************
;                                UBICAR CONSIGNA                                               *
;***********************************************************************************************
proc ubicar_consigna
    mov al, 03h
    mov ah, 0
    int 10h
    ubicar_titulo:
    mov dh,0
    mov dl,20
    mov bh,0
    mov ah,2
    int 10h
    imprimir titulo 
    
    mov si,offset consigna
    xor bl,bl
    mov bl,2
    xor al,al  
    
    ubicar_linea:
    add bl,1
    mov dh,bl
    mov dl,0
    mov bh,0
    mov ah,2
    int 10h
    
    
    imprimir_car:
    add al,1
    mov dh,bl
    mov dl,al
    mov ah,2
    mov dl,[si]
    int 21h
    inc si
     
    cmp [si],'$'
    je fin_ubicar_consigna
    cmp [si],'#'
    jne imprimir_car
    
    inc si
    jmp ubicar_linea
    
    fin_ubicar_consigna:
    ret
endp ubicar_consigna
;**************************************************************************************
;                    Proc para detectar siguiente ventana                             *
;**************************************************************************************

proc detectar_nueva_ventana 
    mov dh,12
    mov dl,20
    mov bh,0
    mov ah,2
    int 10h
    
    imprimir msj_siguiente
    
    mov ah,7
    int 21h 
    
    cmp al,'F'
    je fin_detec:
    fin_detec:
    ret
endp detectar_nueva_ventana

    
;****************************************************************************************
;         Procedimiento para imprimir mensaje de espera mientras se arma el tablero     *
;****************************************************************************************

proc msj_esperar_armado
    mov al, 03h
    mov ah, 0
    int 10h
    
    ubicar_titulo2:
    mov dh,0
    mov dl,20
    mov bh,0
    mov ah,2
    int 10h
    imprimir titulo 
    
    mov si,offset msj_espera
    xor al,al
    xor bl,bl
    mov bl,6
    
    ubicar_linea_msj:
    add bl,1
    mov dh,bl
    mov dl,0
    mov bh,0
    mov ah,2
    int 10h
    
    imprimir_car_msj:
    add al,1
    mov dh,bl
    mov dl,al
    mov ah,2
    mov dl,[si]
    int 21h
    inc si
     
    cmp [si],'$'
    je fin_msj_espera
    cmp [si],'#'
    jne imprimir_car_msj
    
    inc si
    jmp ubicar_linea_msj
    
    fin_msj_espera:
    ret
endp msj_esperar_armado


;************************************************************************************************
;                                 UBICACION DE RESPUESTAS EN EL TABLERO                         *                                                               
;************************************************************************************************                                                                                                
proc ubicar_respuestas
    mov bx,offset respuestas
    mov si,offset tablero 
    xor cx,cx 
    xor ax,ax
    
    horizontales:   ;primero ubicamos las primeras 5 horizontales
    cmp cx,5
    je comienzo_verticales
    cmp [bx],'$'
    je saltar_horizontales
    
    ubicando_horizontales:
    mov dl,[bx]
    mov [si],dl
    inc bx
    inc si
    jmp horizontales
    
    saltar_horizontales:
    mov ax,64   ;por poner un numero donde queden ubicadas correctamente
    add si,ax
    inc bx 
    inc cx
    jmp horizontales
    
    comienzo_verticales:
    mov si,offset tablero
    add si,13
    
    verticales:   ;luego las ultimas 5 de manera vertical
    cmp cx,10
    je fin_ubicar_respuestas
    cmp [bx],'$'
    je saltar_verticales
    
    ubicando_verticales:
    mov dl,[bx]
    mov [si],dl
    
    add si,15
    inc bx
    jmp verticales
    
    saltar_verticales:
    mov ax,4
    add si,ax
    inc bx
    inc cx
    jmp verticales
    
    fin_ubicar_respuestas:
    ret 
endp ubicar_respuestas

;***********************************************************************************************
;                                   IMPRIMIR TRABLERO
;***********************************************************************************************    
print_tablero proc 
    ;Se establece el uso de la pantalla en modo texto 
    
    
    mov dh, 3
    mov dl, 0
    mov bh, 0
    mov ah, 02h
    int 10h 
    
    xor cx,cx
    mov bx, offset tablero
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
;                        ABRIR ARCHIVOS CON LAS PREGUNTAS Y RESPUESTAS                          *
;************************************************************************************************

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

                         
;**************************************************************************************************************************************
                         
