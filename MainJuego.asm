;/*** TP Organización del computador 2019 1CUATRIM ***/3
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

handler1 dw ?
preguntas db 560 dup(' ') ;aprox cantidad de lugares para las preguntas
archivo_pre db "Preguntas.txt",0   
   

handler2 dw ?
archivo_res db "Respuestas.txt",0 
respuestas db 50 dup(' ') 
   
jugador db 6 dup(' ')
        
respuesta_correcta db ? 
       
new_line        db 10,13,'$';salto de linea


ancho      db 15
alto       db 20

msj_espera db "El tablero se ",'#' 
           db "esta armando...",'$'

msj_nombre db "Ingrese su nombre (5 letras): ",'$'

msj_siguiente db "Presione F para continuar: ",'$'
  
msj_GameOver db "FIN DEL JUEGO!",1,3,'$'
msj_puntaje db "TU PUNTAJE FINAL ES: ",'$'

msj_PressAnyKey db "PRESIONE CUALQUIER TECLA PARA FINALIZAR: ","$"  

titulo_preguntas db "PREGUNTAS: ",'$'

titulo_creditos db "CREADORES:",'$'
integrantes db "- Camila Sanchez",'#',"- Kevin Ruiz",'#',"- Salvador Yagusz",'$'
agradecimiento db "Gracias por jugar: ","$"

pos_inicial_X db 0; Posicion inicial en X del cursor
pos_inicial_Y db 3; Posicion inicial en Y del cursor 


flechita db 26,"$"
fila_pregunta db 4

cant_respuestas_correctas db 0

diez db "10",'$'
 
respuesta_jugador db ?

titulo_respuesta db "RESPUESTA: ",'$'

columna_respuesta db 27

columna_correcta db 27

correcta db "RESPUESTA ES CORRECTA",0,0,"$"
incorrecta db "RESPUESTA ES INCORRECTA$"
num_pregunta db 30h, ") ","$"
final db "                           ","$"


;/***********************************************************************************************************/
;/*
msjPresentacion     db "TABLERO DE JUEGO", '$'


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
            
     

            
inicio:
  call abrir_preguntas
  call abrir_respuestas
  call ubicar_respuestas
  call imprimir_consigna
  call pedir_nombre_jugador
  call detectar_nueva_ventana
  call msj_esperar_armado
  call imprimir_preguntas
  call ARMAR_TABLERO   
  call print_tablero
  
  
  ;Se lleva el cursor a la posicion inicial
  mov dh, pos_inicial_Y
  mov dl, pos_inicial_X           
  mov bh, 0
  mov ah, 02h      
  int 10h
  
  mov cx,0
  ciclo_de_juego:
  cmp cx, 10
  
  je fin_del_juego
  push cx
  call indicar_pregunta
  
  call DETECTAR_TECLA
  pop cx
  
  call extraer_una_respuesta
  
  push cx
  call chequear_respuesta ;input:respuesta_correcta y respuesta_jugador 
  pop cx
                            ;return: en cant_respuestas_correctas suma si es correcta
  inc cx
  jmp ciclo_de_juego
 
 
  
  fin_del_juego:
  call imprimir_msj_GameOver
  call finalizar
  call pasar_creditos
  call agradecer_jugador
  
  mov ah,4Ch
  int 21h     
     
     
     
;************************************************************************************************      
;*                              PROCEDIMIENTOS                                                  *
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
    cmp al, 0Dh
    je selecciono_una_letra 
    
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
    
    selecciono_una_letra:
    call armar_palabra_usuario
    
    finDetectarTecla:
    ret
endp DETECTAR_TECLA


;************************************************************************************************
;*                                 ARMADO DEL TABLERO                                           *
;************************************************************************************************
    
proc ARMAR_TABLERO
    
    
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
    
    cmp tablero[bx],"*"
    je poner_letra_random
    inc bx 
    jmp llenarVector
    
    poner_letra_random:
    add dl, 41h
    mov tablero[bx], dl
    inc bx
    jmp llenarVector
    
    
    fin:
    endp ARMAR_TABLERO
    ret    

;************************************************************************************************
;*                     IMPRIMIENDO EL TABLERO DE JUEGO                                          *
;************************************************************************************************
print_tablero proc 
    
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
;*                                UBICAR CONSIGNA                                               *
;************************************************************************************************
proc imprimir_consigna
    mov al, 03h
    mov ah, 0
    int 10h
    
    ubicar_titulo:
    mov al,1
    mov bh,0
    mov bl,1110b  ;color amarillo
    mov cx,44
    mov dl,20
    mov dh,0
    mov bp,offset titulo
    mov ah,13h
    int 10h
 
    
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
endp imprimir_consigna  

;************************************************************************************************
;*                      Proc para detectar siguiente ventana                                    *
;************************************************************************************************

proc detectar_nueva_ventana 
    mov dh,14
    mov dl,20
    mov bh,0
    mov ah,2
    int 10h
    
    imprimir msj_siguiente
    
    pedir_F:
    mov ah,7
    int 21h 
    
    cmp al,'f'
    je fin_detec
    
    jmp pedir_F
    
    fin_detec:
    ret
endp detectar_nueva_ventana

;************************************************************************************************
;*        Procedimiento para imprimir mensaje de espera mientras se arma el tablero             *
;************************************************************************************************

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
;*                               IMPRIMIR PREGUNTAS                                             *
;************************************************************************************************
proc imprimir_preguntas
    ubicar_titulo_preguntas:
    mov dh,3
    mov dl,17
    mov bh,0
    mov ah,2
    int 10h
    imprimir titulo_preguntas 
    
    mov dl,17
    mov dh,15
    mov bh,0
    mov ah,02h
    int 10h
    
    imprimir titulo_respuesta
    
    mov si,offset preguntas
    xor bl,bl
    mov bl,3
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
    

;************************************************************************************************
;*                    PROCEDIMIENTOS DE MOVIMIENTO CON DETECCION DE BORDES                      *
;************************************************************************************************
 
proc mover_derecha
    mov bh,0
    mov ah,3 ;subfuncion de 10h que me permite obtener la pos del cursor 
    int 10h
    
    cmp dl,14   ;ancho del tablero (15-1) 
    je borde_derecha
    
    add dl,1
    mov ah,02h     
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
    
    cmp dh,22    
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
    mov dh, 3
    mov ah, 02h
    int 10h
    
    ret 
    
endp mover_abajo
      
      
proc mover_arriba
    mov bh,0
    mov ah,3 
    int 10h
    
    cmp dh,3   
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
    mov dh, 22
    mov ah, 02h
    int 10h
   
    ret  
    
endp mover_arriba

;************************************************************************************************                                                                                                                                          
;*                       ABRIR ARCHIVOS CON LAS PREGUNTAS Y RESPUESTAS                          *
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

;************************************************************************************************                                                                                                                                          
;*                              REGISTRO DE JUGADOR                                             *
;************************************************************************************************

proc pedir_nombre_jugador
    
    xor bx, bx
    mov cx, 0
    
    mov dl, 5
    mov dh, 10
    mov ah, 02h
    int 10h
    
    mov ah, 09h
    mov dx, offset msj_nombre 
    int 21h
    
    pedir_tecla:
    cmp cx,5
    je fin4 
    
    mov ah, 01h
    int 21h   
    mov jugador[bx], al
    
    inc bx
    inc cx
    
    jmp pedir_tecla
    
    fin4:
    mov jugador[bx], "$" 
    ret
endp pedir_nombre_jugador

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

;************************************************************************************************
;*                                  CHEQUEAR PALABRA                                            *
;************************************************************************************************
 
 proc chequear_respuesta
    xor bx,bx
    xor si,si
    xor ax,ax 
    mov bx, offset respuesta_correcta
    mov si, offset respuesta_jugador
    inc num_pregunta[0] 
    
    comparacion:
    cmp [bx], "$"
    je ver_si_ambas_terminaron 
    mov al, [bx]
    cmp [si],al
    jne es_incorrecta
     
    inc si
    inc bx
    jmp comparacion
    
    ver_si_ambas_terminaron:
    cmp [si], "$"
    je es_correcta 
    
    es_incorrecta:
    call mostrar_incorrecta
    jmp fin6
    
    es_correcta:
    call mostrar_correcta
    add cant_respuestas_correctas[0],1  
    
    fin6:
    ret
 endp chequear_respuesta
 
;************************************************************************************************
;*                          ARMAR LA RESPUESTA DEL USUARIO                                      *
;************************************************************************************************   

proc armar_palabra_usuario
    xor si, si
    mov si, offset respuesta_jugador
    mov ah, 08h
    int 10h 
    mov [si],al   
    call mostrar_respuesta
    
    pedir_siguiente_movimiento:
    mov ah,00h
    int 16h
    
    cmp al,"d"
    je letra_siguiente_horizontal
    cmp al,"s"
    je letra_siguiente_vertical
    
    jmp pedir_siguiente_movimiento
     

;---------SI PRESIONO 'D'...---------      
      
    letra_siguiente_horizontal:
    ;comparo_extremo_derecho
    mov bh,0
    mov ah,3  
    int 10h
    cmp dl,14 
    je pedir_space_por_borde
    
    ;si no estoy en borde sigo de largo
    add dl, 1
    mov ah, 02h
    int 10h
    inc si  
    
    pedir_enter_o_space:   
    mov ah, 00h
    int 16h
    cmp al, 0Dh
    je meter_letra_en_respuesta 
    cmp al, 20h
    je terminar_palabra
    jmp pedir_enter_o_space 
    
    meter_letra_en_respuesta:
    mov ah,08h
    mov bh,0
    int 10h
    mov [si], al
    call mostrar_respuesta
    jmp letra_siguiente_horizontal
    
    
;---------SI PRESIONO 'S'...--------- 
    
    letra_siguiente_vertical:
    comparo_extremo_inferior:
    mov bh,0
    mov ah,3 
    int 10h     
    cmp dh,22    
    je pedir_space_por_borde
    
    inc si
    add dh, 1                     
    mov ah, 02h
    int 10h
    
    pedir_enter_o_space1:   
    mov ah, 00h
    int 16h
    cmp al, 0Dh                     
    je meter_letra_en_respuesta1 
    cmp al, 20h                  
    je terminar_palabra
    jmp pedir_enter_o_space1 
    
    meter_letra_en_respuesta1:
    mov ah,08h
    mov bh,0
    int 10h
    mov [si], al
    call mostrar_respuesta
    
    jmp letra_siguiente_vertical
              
              
    pedir_space_por_borde:
    mov ah,00h
    int 16h
    cmp al,20h                     ;space
    je terminar_palabra_por_borde
    jmp pedir_space_por_borde
    
    terminar_palabra_por_borde:
    mov [si+1], "$" 
    call limpiar_respuesta
    jmp fin7
     
    terminar_palabra:
    mov [si], "$"
    call limpiar_respuesta
    
    fin7:
    ret    
endp armar_palabra_usuario

;************************************************************************************************
;*                         EXTRAER RESPUESTA DE .TXT                                            *
;************************************************************************************************
    
proc extraer_una_respuesta
    xor bx,bx
    xor si,si
    mov bx, offset respuestas
    mov si, offset respuesta_correcta
    mov ax,0
    
    chequear_numero_respuesta:
    cmp ax,cx           
    je copiar_respuesta  
     
    buscar_respuesta:
    cmp [bx],"$"
    je sumar_apariciones
    inc bx
    jmp buscar_respuesta 
    
    sumar_apariciones:
    inc ax
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

;************************************************************************************************
;*                          IMPRIME FLECHITA                                                    *
;************************************************************************************************

proc indicar_pregunta
    mov bh,0
    mov ah,03h
    int 10h
    
    mov pos_inicial_X,dl
    mov pos_inicial_Y,dh
    
    mov bl,fila_pregunta
    
    mov dl,16
    mov dh,bl 
    mov bh,0
    mov ah,02h
    int 10h
    
    mov dx, offset flechita
    mov ah,09h
    int 21h
    
    inc bl
    mov fila_pregunta,bl
    
    mov dl,pos_inicial_X
    mov dh,pos_inicial_Y
    mov bh,0
    mov ah,02h
    int 10h
    
    ret
endp indicar_pregunta
;*********************************************************************************************
;                                 MOSTRAR RESPUESTA QUE ESCRIBE USUARIO                      *
;*********************************************************************************************
proc mostrar_respuesta
    mov bh,0
    mov ah,03h
    int 10h
    
    mov pos_inicial_X,dl
    mov pos_inicial_Y,dh
    
    mov bl,columna_respuesta
    
    mov dl,columna_respuesta
    mov dh,15
    mov bh,0
    mov ah,02h
    int 10h
    
    mov ah,2
    mov dl,al
    int 21h
    
    inc bl
    mov columna_respuesta,bl
    
    reacomodamos_cursor:
    mov dl,pos_inicial_X
    mov dh,pos_inicial_Y
    mov bh,0
    mov ah,02h
    int 10h
    ret
endp mostrar_respuesta

;**********************************************************************************************
;*                                LIMPIAR ZONA DE RESPUESTA                                   *
;**********************************************************************************************

proc limpiar_respuesta
    ;guardamos la posicion anterior del cursor
    mov bh,0
    mov ah,03h
    int 10h
    
    mov pos_inicial_X,dl
    mov pos_inicial_Y,dh
     
    mov bl,columna_respuesta
    
    ciclo_limpieza: 
    ;reubicamos
    mov dl,bl
    mov dh,15
    mov bh,0
    mov ah,02h
    int 10h
    
    cmp bl,26
    je fin_limpiar_respuesta_ciclo
    
    ;limpiamos
    mov al,0
    mov bh,0
    mov cx,1
    mov ah,0Ah
    int 10h
    
    dec bl
    jmp ciclo_limpieza
     
    fin_limpiar_respuesta_ciclo:
    inc bl
    mov columna_respuesta ,bl
    
    mov dl,pos_inicial_X
    mov dh,pos_inicial_Y
    mov bh,0
    mov ah,02h
    int 10h
    
    fin_limpieza_res:
    ret
endp limpiar_respuesta

;************************************************************************************************
;*                          PROCEDIMIENTOS DE FIN DEL JUEGO                                     *
;************************************************************************************************

proc imprimir_msj_GameOver
    mov ah,02h
    mov dl,17
    mov bh,0
    mov dh,17
    int 10h
    mov dx, offset msj_GameOver
    mov ah,09h
    int 21h
    
    mov ah,02h
    mov dl,17
    mov dh,19
    mov bh,0
    int 10h
    mov dx, offset msj_puntaje
    mov ah,09h
    int 21h
    
    mov ah,02h
    add cant_respuestas_correctas[0],48   ;asi obtiene ascii de los nums
    cmp cant_respuestas_correctas[0],58 ;no hay ascii del 10 xdd
    je imprimir_10
    mov dl,cant_respuestas_correctas[0] 
    int 21h
    jmp fin10
    
    imprimir_10:
    mov ah,09h
    mov dx,offset diez
    int 21h
    
    fin10:
    ret
endp imprimir_msj_GameOver

proc finalizar
    pedir_cualquier_tecla:
    mov ah,02h
    mov dl,17
    mov bh,0
    mov dh,22
    int 10h
    mov dx, offset msj_PressAnyKey
    mov ah,09h
    int 21h
    
    mov ah,07h
    int 21h
    
    ret
endp finalizar 
    
proc pasar_creditos
    limpiar_pantalla:
    mov al, 03h
    mov ah, 0
    int 10h
    
    imprimir_titulo_creditos:
    mov dl,25
    mov dh,1
    mov bh,0
    mov ah,02h
    int 10h
    
    mov dx, offset titulo_creditos
    mov ah,09h
    int 21h  
    
    imprimir_integrantes:
    mov si,offset integrantes
    xor bl,bl
    mov bl,3
    xor al,al  
    
    ubicar:
    add bl,1
    mov dh,bl
    mov dl,25
    mov bh,0
    mov ah,2
    int 10h
    
    
    imprimir_char:
    add al,1
    mov dh,bl
    mov dl,al
    mov ah,2
    mov dl,[si]
    int 21h
    inc si
     
    cmp [si],'$'
    je fin_creditos
    cmp [si],'#'
    jne imprimir_char
    
    inc si
    jmp ubicar
    
    fin_creditos:
    ret
endp pasar_creditos 

proc agradecer_jugador
    ubicar_agradecimiento:
    mov ah,02h
    mov dl,25
    mov dh,12
    mov bh,0
    int 10h
    
    mov dx, offset agradecimiento
    mov ah,09h
    int 21h
    
    mov dx, offset jugador
    mov ah,09h
    int 21h 
     
    ret
endp agradecer_jugador 

;*********************************************************************************************
;*                          MOSTRAR SI LA RESPUESTA ES CORRECTA                              *
;*********************************************************************************************

proc mostrar_correcta
    
    mov bh,0
    mov ah,03h
    int 10h
    
    mov pos_inicial_X,dl
    mov pos_inicial_Y,dh
     
    mov bl,27
    
    mov dl,27
    mov dh,20
    mov bh,0
    mov ah,02h
    int 10h
    
    cmp num_pregunta,3Ah
    je num_10
    
    imprimir num_pregunta
    
    imprimir correcta
    
    reacomodamos_cursor2:
    mov dl,pos_inicial_X
    mov dh,pos_inicial_Y
    mov bh,0
    mov ah,02h
    int 10h
    ret
    num_10:
    
    imprimir final
    ret    
endp mostrar_correcta

proc mostrar_incorrecta
    mov bh,0
    mov ah,03h
    int 10h
    
    mov pos_inicial_X,dl
    mov pos_inicial_Y,dh
    
    mov bl,27
    
    mov dl,27
    mov dh,20
    mov bh,0
    mov ah,02h
    int 10h
    
    cmp num_pregunta,3Ah
    je num_11
    
    imprimir num_pregunta
    
    imprimir incorrecta

    
    reacomodamos_cursor3:
    mov dl,pos_inicial_X
    mov dh,pos_inicial_Y
    mov bh,0
    mov ah,02h
    int 10h
    ret
    num_11:
    
    imprimir final

    ret
endp mostrar_incorrecta