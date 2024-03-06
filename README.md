# Sopa de Letras ASM

## Introducción
En este trabajo, se tiene como objetivo realizar un juego, el cual consiste en mostrar diez preguntas en pantalla y una sopa de letras, en la cual se encontran las respuestas. 
El usuario debe moverse a lo largo y a lo ancho del trablero de juego y seleccionar la respuesta en caso de encontrarla. Las preguntas deben ser respondidas en orden. Además, al principio se muestra una
consigna que explica el objetivo del juego, y se pide al jugador ingresar su nombre.

## Para jugar
Lo ideal es tener descargado el EMU8086 para ejecutar los archivos necesarios.
En particular, para jugar debe compilar y emular el archivo que posee los nombres de los miembros. 

### Instrucciones
En resumen, se debe cargar el nombre del usuario. Luego comenzará a cargar las preguntas y a cargar el tablero con las letras (el cual puede tardar un poco bastante ;) ). Luego, se puede utilizar con las letras
**A, W , D y S** para mover el curso, con la tecla **ENTER** selecciona la primera letra de la palabra y luego con las letras para mover, debe seleccionar la dirección por la cual continua la palabra (derecha, izquierda, arriba o
abajo). Tenga en cuenta que una vez que selecciona la dirrecion **NO PUEDE CAMBIAR LA DIRECCION**.
Luego, siga presionando ENTER por cada letra que corresponda a su palabra seleccionada. Para finalizar, presione **SPACE** y la palabra se guardará para determinar si respondió de manera correcta o incorrecta.

Las preguntas van en orden, asi que no puede saltearlas y volver a alguna anterior. Debe responder en orden ;)

## Errores posibles
Es posible que ocurra un error al no encontrar los archivos de preguntas y respuestas.
Para solucionar esto, debe ir a la ubicación donde haya establecido la carpeta de emu8086. Al compilar los archivos, el programa crea una carpeta _My Build_ donde va guardando todos los archivos compilados.
Copie y pegue los archivos txt de preguntas y respuestas y proporcioneles los permisos tanto de lectura como de escritura. 

Otro error posible es que directamente no compile el archivo asm del juego.
Para solucionar esto, vaya al archivo asm y proporcionele permisos para todo. Si es necesario, también al archivo compilado.

También, al principio, cuando indique su nombre, presione ENTER 2 veces y cuando presione _"F"_ para continuar tenga en cuenta de no tener activado el Bloq Mayus.

## Para más información
Se deja el link a un informe realizado en ese momento para la entrega [aquí](https://drive.google.com/file/d/141LoRniy6R5gSztsjEHf_SHs6JXYIC0D/view?usp=drive_link).
