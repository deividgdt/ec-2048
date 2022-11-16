section .data               
;Cambiar Nombre y Apellido por vuestros datos.
developer db "_David_ _Cucalon_Moreno_",0

;Constantes que también están definidas en C.
DimMatrix    equ 4      
SizeMatrix   equ DimMatrix*DimMatrix ;=16

section .text            
;Variables definidas en Ensamblador.
global developer                        

;Subrutinas de ensamblador que se llaman des de C.
global showNumberP1, updateBoardP1, copyMatrixP1
global rotateMatrixRP1, shiftNumbersRP1, addPairsRP1
global readKeyP1, playP1

;Variables definidas en C.
extern rowScreen, colScreen, charac, number
extern m, mRotated, score, state

;Funciones de C que se llaman desde ensamblador
extern clearScreen_C, printBoardP1_C, gotoxyP1_C, getchP1_C, printchP1_C
extern insertTileP1_C, printMessageP1_C 


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ATENCIÓN: Recordad que en ensamblador las variables y los parámetros 
;;   de tipo 'char' se tienen que asignar a registros de tipo
;;   BYTE (1 byte): al, ah, bl, bh, cl, ch, dl, dh, sil, dil, ..., r15b
;;   las de tipo 'short' se tiene que assignar a registros de tipo 
;;   WORD (2 bytes): ax, bx, cx, dx, si, di, ...., r15w
;;   las de tipo 'int' se tiene que assignar a registros de tipo  
;;   DWORD (4 bytes): eax, ebx, ecx, edx, esi, edi, ...., r15d
;;   las de tipo 'long' se tiene que assignar a registros de tipo 
;;   QWORD (8 bytes): rax, rbx, rcx, rdx, rsi, rdi, ...., r15
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Las subrutinas en ensamblador que tenéis que implementar son:
;;   showNumberP1, updateBoardP1, copyMatrixP1,  
;;   rotateMatrixRP1, shiftNumbersRP1, addPairsRP1.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Esta subrutina se da hecha. NO LA PODÉIS MODIFICAR.
; Situar el cursor en una fila indicada por la variable (rowScreen) y en 
; una columna indicada por la variable (colScreen) de pantalla 
; llamando a la función gotoxyP1_C.
; 
; Variables globales utilizadas:	
; (rowScreen): Fila de la pantalla donde posicionamos el cursor.
; (colScreen): Columna de la pantalla donde posicionamos el cursor.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
gotoxyP1:
   push rbp
   mov  rbp, rsp
   ;guardamos el estado de los registros del procesador porque
   ;las funciones de C no mantienen el estado de los registros.
   push rax
   push rbx
   push rcx
   push rdx
   push rsi
   push rdi
   push r8
   push r9
   push r10
   push r11
   push r12
   push r13
   push r14
   push r15

   call gotoxyP1_C
 
   pop r15
   pop r14
   pop r13
   pop r12
   pop r11
   pop r10
   pop r9
   pop r8
   pop rdi
   pop rsi
   pop rdx
   pop rcx
   pop rbx
   pop rax

   mov rsp, rbp
   pop rbp
   ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Esta subrutina se da hecha. NO LA PODÉIS MODIFICAR.
; Mostrar un carácter guradado en la varaile (charac) en pantalla, en
; la posición donde está el cursor llamando a la función printchP1_C.
; 
; Variables globales utilizadas:	
; (charac):  Carácter que queremos mostrar.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
printchP1:
   push rbp
   mov  rbp, rsp
   ;guardamos el estado de los registros del procesador porque
   ;las funciones de C no mantienen el estado de los registros.
   push rax
   push rbx
   push rcx
   push rdx
   push rsi
   push rdi
   push r8
   push r9
   push r10
   push r11
   push r12
   push r13
   push r14
   push r15

   call printchP1_C
 
   pop r15
   pop r14
   pop r13
   pop r12
   pop r11
   pop r10
   pop r9
   pop r8
   pop rdi
   pop rsi
   pop rdx
   pop rcx
   pop rbx
   pop rax

   mov rsp, rbp
   pop rbp
   ret
   

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Esta subrutina se da hecha. NO LA PODÉIS MODIFICAR.
; Leer una tecla y guardar el carácter asociado en la varaible (charac) 
; sin mostrarlo en pantalla, llamando a la función getchP1_C
; 
; Variables globales utilizadas:	
; (charac): Carácter que leemos e teclado
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
getchP1:
   push rbp
   mov  rbp, rsp
   ;guardamos el estado de los registros del procesador porque
   ;las funciones de C no mantienen el estado de los registros.
   push rax
   push rbx
   push rcx
   push rdx
   push rsi
   push rdi
   push r8
   push r9
   push r10
   push r11
   push r12
   push r13
   push r14
   push r15
   push rbp

   call getchP1_C
 
   pop rbp
   pop r15
   pop r14
   pop r13
   pop r12
   pop r11
   pop r10
   pop r9
   pop r8
   pop rdi
   pop rsi
   pop rdx
   pop rcx
   pop rbx
   pop rax
   
   mov rsp, rbp
   pop rbp
   ret 
   

;;;;;
; Convierte el número de la variable (number) de tipo int (DWORD) de 6
; dígitos (number <= 999999) a caracteres ASCII que representen su valor.
; Si (number) es más grande de 999999 cambiaremos el valor a 999999.
; Se tien que dividir el valor entre 10, de forma iterativa, hasta 
; obtener los 6 dígitos. 
; A cada iteración, el residuo de la división que es un valor
; entre (0-9) indica el valor del dígito que tenemos que convertir
; a ASCII ('0' - '9') sumando '0' (48 decimal) para poderlo mostrar.
; Cuando el cociente sea 0 mostraremos espacios en la parte no significativa.
; Por ejemplo, si number=103 mostraremos "   103" y no "000103".
; Se tienen que mostrar los dígitos (carácter ASCII) desde la posición 
; indicada por las variables (rowScreen) y (colScreen), posición de les 
; unidades, hacia la izquierda.
; Como el primer dígito que obtenemos son las unidades, después las decenas,
; ..., para mostrar el valor se tiene que desplazar el cursor una posición
; a la izquierda en cada iteración.
; Para posicionar el cursor se llamada a la subrutina gotoxyP1 y para 
; mostrar los caracteres a la subrutina printchP1.
;
; Variables globales utilizadas:    
; (number)   : Número que queremos mostrar.
; (rowScreen): Fila de la pantalla donde posicionamos el cursor.
; (colScreen): Columna de la pantalla donde posicionamos el cursor.
; (charac)   : Carácter a escribir en pantalla.
;;;;;
showNumberP1:
   push rbp
   mov  rbp, rsp

   ; mantenemos integridad de registros almacenandolos en la pila
   push r8
   push r9

   mov r8d, DWORD[number]; r8d = n
   cmp r8d, 999999
   jle for_sn_i
   
   ; Si n es mayor que 999999, entonces
   mov r8d, 999999
   
   ; Si n es menor o igual que 999999
   for_sn_i: 
      mov r9d, 0; r9b = i
   for_sn_s:
      cmp r9d, 6; i <= 6
      jge for_sn_e

      mov BYTE[charac], " "
      
      if_sn_2_s: 
         cmp r8d, 0
         jle if_sn_2_e
         
         ;EDX:EAX
         mov eax, r8d; dividendo
         xor edx, edx; limpiamos edx, el xor usando como fuente y destino el mismo registro deja todo a 0
         mov ecx, 10; divisor
         div ecx; se realiza la division 32bits - EDX:EAX / ECX 
         
         ; Resultado: EAX / Residuo: EDX
         add edx, 30h; para mostrar el valor en ASCII sumamos 30h
         mov [charac], edx; guardamos el valor hex en [charac]
         mov r8d, eax; n = resultado

      if_sn_2_e:

      call gotoxyP1
      call printchP1
      dec DWORD[colScreen]
   
      inc r9d; i++
      jmp for_sn_s
   
   for_sn_e:

   ; sacamos de la pila el contenido que habiamos guardado de los registros
   pop r9
   pop r8

   mov rsp, rbp
   pop rbp
   ret


;;;;;
; Actualizar el contenido del Tablero de Juego con los datos de 
; la matriz (m) de 4x4 de tipo short y los puntos del marcador (score) 
; que se han hecho.  
; Se tiene que recorrer toda la matriz (m), y para cada elemento de 
; la matriz posicionar el cursor en pantalla y mostrar el número de 
; esa posición de la matriz.
; Recorrer toda la matriz por filas de izquierda a derecha y de arriba a abajo.
; Para recorrer la matriz en ensamblador el índice va de 0 (posición [0][0])
; a 30 (posición [3][3]) con incrementos de 2 porquè los datos son de
; tipo short(WORD) 2 bytes.
; Después, mostrar el marcador (score) en la parte inferior del tablero,
; fila 18, columna 26 llamando a la subrutina showNumberP1.
; Finalmente posicionar el cursor en la fila 18, columna 28 llamando a la 
; subrutina gotoxyP1().
;
; Variables globales utilizadas:    
; (rowScreen): Fila de la pantalla donde posicionamos el cursor.
; (colScreen): Columna de la pantalla donde posicionamos el cursor.
; (m)        : Matriz donde guardamos los números del juego.
; (score)    : Puntos acumulados en el marcador.
; (number)   : Número que queremos mostrar.
;;;;;  
updateBoardP1:
   push rbp
   mov  rbp, rsp

   ; guardamos el contenido de los registros
   push r8
   push r9
   push r10
   push r11
   push r12
   push r13
   push r14

   mov r14d, DWORD[score]; guardamos el score temporalmente
   mov DWORD[number], 0h; inicializamos la variable
  
   mov r8d, 10; rowScreenAux = 10
   mov r10d, 0; row selector rango = {0 ... 30}
   for_ub_1_s:
      cmp r10d, 30; por cada fila {0,8,16,24}
      jg for_ub_1_e
      mov r9d, 17; colScreenAux = 17

      mov r11d, 0; column selector {0 ... 6}
      for_ub_2_s:
         cmp r11d, 6; por cada columna {0,2,4,6}
         jg for_ub_2_e
         
         mov r13d, r10d; guardamos el valor de la fila {0,8,16,24} 
         add r13d, r11d; le sumamos la columna {0,2,4,6}

         mov r12w, [m+r13d]; r12w = m[0 ... 30]
         mov WORD[number], r12w

         mov DWORD[rowScreen], r8d
         mov DWORD[colScreen], r9d
         
         call showNumberP1
         
         add r9d, 9; aumentar columnScreenAux
         add r11d, 2; column selector

         jmp for_ub_2_s
      
      for_ub_2_e:

      add r8d, 2; aumentar rowScreenAux
      add r10d, r11d; row selector {0,8,16,24} + 8

      jmp for_ub_1_s

   for_ub_1_e:   

   mov DWORD[number], r14d; cargamos el score en number
   mov DWORD[rowScreen], 18
   mov DWORD[colScreen], 26
   call showNumberP1
   mov DWORD[rowScreen], 18
   mov DWORD[colScreen], 28
   call gotoxyP1

   ; sacamos de la pila el contenido que habiamos guardado de los registros
   pop r14
   pop r13
   pop r12
   pop r11
   pop r10
   pop r9
   pop r8
   
   mov rsp, rbp
   pop rbp
   ret


;;;;;  
; Copiar los valores de la matriz (mRotated) a la matriz (m).
; La matriz (mRotated) no se tiene que modificar, 
; los cambios se tienen que hacer en la matriz (m).
; Recorrer toda la matriz por filas de izquierda a derecha y de arriba a abajo.
; Para recorrer la matriz en ensamblador el índice va de 0 (posición [0][0])
; a 30 (posición [3][3]) con incrementos de 2 porque los datos son de 
; tipo short(WORD) 2 bytes.
; No se muestra la matriz. 
;
; Variables globales utilizadas:    
; (m)       : Matriz donde guardamos los números del juego.
; (mRotated): Matriz con los números rotados a la derecha
;;;;;  
copyMatrixP1:
   push rbp
   mov  rbp, rsp

   ; guardamos el contenido de los registros
   push r8
   push r9
   push r10
   push r11
   
   mov r8d, 0; row selector  {0 ... 30}
   for_cm_1_s:
      cmp r8d, 30; por cada fila {0,8,16,24}
      jg for_cm_1_e

      mov r9d, 0; column selector {0 ... 6}
      for_cm_2_s:
         cmp r9d, 6; por cada columna {0,2,4,6}
         jg for_cm_2_e

         mov r10d, r8d; almacenamos el valor de fila {0,8,16,24}
         add r10d, r9d; sumamos el valor de la columna {0,2,4,6}

         mov r11w, [mRotated+r10d]; guardamos el valor de la matriz a copia temporalmente
         mov [m+r10d], r11w; lo asignamos a la matriz original

         add r9d, 2; column selector {n+2}
         jmp for_cm_2_s

      for_cm_2_e:

      add r8d, r9d; row selector {0,8,16,24} + 8
      jmp for_cm_1_s

   for_cm_1_e:

   ; sacamos de la pila el contenido que habiamos guardado de los registros
   pop r11
   pop r10
   pop r9
   pop r8
   
   mov rsp, rbp
   pop rbp
   ret


;;;;;      
; Rotar a la derecha la matriz (m), sobre la matriz (mRotated). 
; La primera fila pasa a ser la cuarta columna, la segunda fila pasa 
; a ser la segunda columna, la tercera fila pasa a ser la tercera columna 
; y la cuarta fila pasa a ser la primer columna. 
; En el enunciado se explica con más detalle como hacer la rotación.
; NOTA: NO es lo mismo que hacer la matriz traspuesta.
; La matriz (m) no se tiene que modificar, 
; los cambios se tiene que hacer en la matriz (mRotated).
; Para recorrer la matriz en ensamblador el índice va de 0 (posición [0][0])
; a 30 (posiciones [3][3]) con decrementos de 2 porquè los datos son de
; tipo short(WORD) 2 bytes.
; Para acceder a una posición concreta de la matriz desde ensamblador 
; hay que tener en cuenta que el índice es:(index=(fila*DimMatrix+columna)*2),
; multiplicamos por 2 perque los datos son de tipo short(WORD) 2 bytes.
; No se tiene que mostrar la matriz.
; Una vez se ha hecho la rotación, copiar la matriz (mRotated) en la 
; matriz (m) llamando la subrutina copyMatrixP1_C().
;
; Variables globales utilizadas:    
; (m)        : Matriz donde guardamos los números del juego.
; (mRotated) : Matriz con los números rotados a la derecha.
;;;;;  
rotateMatrixRP1:
   push rbp
   mov  rbp, rsp
   
   ; guardamos el contenido de los registros
   push r8
   push r9
   push r10
   push r11
   push r12
   push r13

   mov r8d, 6; mRotated = empieza en 6 y decrementa -2 cada vuelta
   mov r9d, 0; m = empieza en 0 y aumenta 8 cada vuelta
   for_rm_1_s:
      cmp r8d, 0; 
      jl for_rm_1_e

      mov r10d, r8d; mRotated = empieza en r8d, aumenta 8 cada vuelta
      mov r11d, r9d; m = empieza en en r9d, aumenta 2 cada vuelta
      mov r12w, 4; indice del for, max 4 min 0
      for_rm_2_s:
         cmp r12w, 0
         je for_rm_2_e

         mov r13w, WORD[m+r11d]
         mov WORD[mRotated+r10d], r13w

         add r10d, 8; mRotated+(r10d+8)
         add r11d, 2; m+(r11d+2)

         sub r12w, 1; decrementamos el indice del for en 1
         jmp for_rm_2_s
      
      for_rm_2_e:

      sub r8d, 2
      add r9d, 8
       
      jmp for_rm_1_s

   for_rm_1_e:

   call copyMatrixP1

   ; sacamos de la pila el contenido que habiamos guardado de los registros
   pop r13
   pop r12
   pop r11
   pop r10
   pop r9
   pop r8
      
   mov rsp, rbp
   pop rbp
   ret


;;;;;  
; Desplazar a la derecha los números de cada fila de la matriz (m), 
; manteniendo el orden de los números y poniendo los ceros a la izquierda.
; Recorrer la matriz por filas de derecha a izquierda de abajo hacia arriba.
; Para recorrer la matriz en ensamblador, en este caso, el índice va de la
; posición 30 (posición [3][3]) a la 0 (posición [0][0]) con decrementos de 
; 2 porquè los datos son de tipo short(WORD) 2 bytes.
; Para acceder a una posición concreta de la matriz desde ensamblador 
; hay que tener en cuenta que el índice es:(index=(fila*DimMatrix+columna)*2),
; multiplicamos por 2 perque los datos son de tipo short(WORD) 2 bytes.
; Si se desplaza un número (NO LOS CEROS) pondremos la variable 
; (state) a '2'.
; En cada fila, si encuentra un 0, mira si hay un número defierente 
; de cero, en la misma fila para ponerlo en aquella posición.
; Si una fila de la matriz es: [0,2,0,4] y state = '1', quedará [0,0,2,4] 
; y state = '2'.
; Los cambios se tienen que hacer sobre la misma  matriz.
; No se tiene que mostrar la matriz.
; 
; Variables globales utilizadas:     
; (m)    : Matriz donde guardamos los números del juego.
; (state): Estado del juego. ('2': Se han hecho movimientos).
;;;;;  
shiftNumbersRP1:
   push rbp
   mov  rbp, rsp

   push r8
   push r9
   push r10
   push r11
   push r12
   push r13
   
   mov r8d, 30
   for_snum_1_s:
      cmp r8d, 0
      jle for_snum_1_e; si es menor que 0, hemos terminado de recorrer la matriz
      
      mov r9d, 0; por cada vuelta {r8d=30,22,14,6}, inicializamos a 0 r9d
      for_snum_2_s:
         cmp r9d, 6
         je for_snum_2_e; si r9d es igual a 6, hemos terminado de recorrer la fila
         
         mov r10d, r8d
         sub r10d, r9d; guardamos m[i][j] en r10d, restando r8d{30,22,14,6}-r9d{0,2,4}
         
         if_snum_1_s:
            cmp WORD[m+r10d], 0
            jne if_snum_1_e; si m[i][j] no es igual a 0 terminamos esta vuelta

            mov r11d, r10d
            sub r11d, 2; r11d = r10d-2 -> m[i][k] 

            mov r12d, r8d
            sub r12d, 6; limite del while, van de {30-24;22-16;14-8;6-0}

            while_snum_1_s:
               cmp r11d, r12d
               jl while_snum_1_e1; si m[i][k] es menor que el limite del while, terminamos en while_snum_1_e1
               cmp WORD[m+r11d], 0
               jne while_snum_1_e2; si m[i][k] NO es igual a 0, terminamos el while en while_snum_1_e2
               sub r11d, 2
               jmp while_snum_1_s

            while_snum_1_e1:
            mov r9d, 6; transferimos el valor 6 al registro provocando que finalce una vuelta de for_snum_2
            jmp for_snum_2_s
            while_snum_1_e2:
            mov r13w, WORD[m+r11d]; almacenamos el valor de m[i][k] en r13w
            mov WORD[m+r10d], r13w; almacenamos el valor de m[i][k] en m[i][j]
            mov WORD[m+r11d], 0; borramos el contenido de m[i][k] igualando a 0
            mov BYTE[state], 32h; establecemos la variable state a '2'
            jmp if_snum_1_e
         
         if_snum_1_e:
         add r9d, 2; aumentamos en 2 r9d {0,2,4}
         jmp for_snum_2_s
         
      for_snum_2_e:
      sub r8d, 8; reducimos en 8 r8d={30,22,16,6}
      jmp for_snum_1_s
   for_snum_1_e:
   
   ; sacamos de la pila el contenido que habiamos guardado de los registros
   pop r13
   pop r12
   pop r11
   pop r10
   pop r9
   pop r8
   
   mov rsp, rbp
   pop rbp
   ret
      

;;;;;  
; Emparejar números iguales des la derecha de la matriz (m) y acumular 
; los puntos en el marcador sumando los puntos de las parejas que se 
; hayan hecho.
; Recorrer la matriz por filas de derecha a izquierda y de abajo hacia arriba. 
; Cuando se encuentre una pareja, dos casillas consecutivas con el mismo 
; número, juntamos la pareja poniendo la suma de los números de la 
; pareja en la casilla de la derecha, un 0 en la casilla de la izquierda
; y acumularemos esta suma en la variable (p) (puntos ganados).
; Si una fila de la matriz es: [8,4,4,2] y state = '1', quedará [8,0,8,2], 
; p = p + (4+4) y state = '2'.
; Si al final se ha juntado alguna pareja (p>0), pondremos la variable 
; (state) a '2' para indicar que se ha movido algún número y actualizaremos
; la variable (score) con los puntos obtenidos de hacer las parejas.
; Para recorrer la matriz en ensamblador, en este caso, el índice va de la
; posición 30 (posición [3][3]) a la 0 (posición [0][0]) con incrementos de 
; 2 porquè los datos son de tipo short(WORD) 2 bytes.
; Los cambios se tienen que hacer sobre la misma matriz.
; No se tiene que mostrar la matriz.
; 
; Variables globales utilizadas:   
; (m)    : Matriz donde guardamos los números del juego.
; (score): Puntos acumulados en el marcador.
; (state): Estado del juego. ('2': Se han hecho movimientos).
;;;;;  
addPairsRP1:
   push rbp
   mov  rbp, rsp

   ; guardamos el contenido de los registros
   push r8
   push r9
   push r10
   push r11
   push r12
   push r13
   push r14

   mov r8d, 30; r8w elemento a_ij 
   mov r12w, 0; inicializamos a 0 el valor de los puntos ganados
   
   for_ap_1_s:
      cmp r8d, 0; si el valor de a_ij es 0, hemos terminado de recorrer la matriz
      jle for_ap_1_e

      mov r13d, 0; el valor que restamos al indice de la matriz en cada vuelta   
      for_ap_2_s:
         cmp r13d, 6
         je for_ap_2_e

         mov r14d, r8d; almacenamos temporalmente el indice de la matriz
         sub r14d, r13d; restamos el valor de la fila actual
         
         mov r9d, r14d
         sub r9d, 2; r9w elemento a_ij-1 a comparar

         if_ap_1_s:
            cmp WORD[m+r14d], 0
            je if_ap_1_e
            mov r10w, WORD[m+r9d]; r10w almacenamos el valor de a_ij-1
            cmp WORD[m+r14d], r10w
            jne if_ap_1_e

            mov r11w, WORD[m+r14d]
            imul r11w, 2; r11w guardamos el valor de a_ij*2

            mov WORD[m+r14d], r11w; m+r8w guardamos a_ij*2 en a_ij
            mov WORD[m+r9d], 0; igualamos a_ij-1 a 0

            add r12w, r11w; le sumamos a p el valor de m+r8w
            
         if_ap_1_e:

         add r13d, 2

         jmp for_ap_2_s
         
      for_ap_2_e:

      sub r8d, 8; restamos 2 a 30 cada vuelta
      jmp for_ap_1_s
   for_ap_1_e:

   if_ap_2_s:
      cmp r12w, 0
      jl if_ap_2_e

      mov BYTE[state], 32h; usamos el valor hexadecimal 32 eqivalente a '2'
      add WORD[score], r12w
   if_ap_2_e:

   ; sacamos de la pila el contenido que habiamos guardado de los registros
   pop r14
   pop r13
   pop r12
   pop r11
   pop r10
   pop r9
   pop r8
     
   mov rsp, rbp
   pop rbp
   ret
   

;;;;;; 
; Esta subrutina se da hecha. NO LA PODÉIS MODIFICAR.
; Leer una tecla llamando a la subrutina getchP1 y quedará guardada
; en la variable (charac).
; Según la tecla leída llamaremos a las funciones que corresponda.
;    ['i' (arriba),'j'(izquierda),'k' (abajo) o 'l'(derecha)] 
; Desplazar los números y hacer las parejas según la dirección escogida.
; Según la tecla pulsada, rotar la matriz llamando (rotateMatrixRP1),
; para poder hacer los desplazamientos de los números hacia la derecha
; (shiftNumbersRP1), hacer las parejas hacia la derecha (addPairsRP1) 
; y volver a desplazar los números hacia la derecha (shiftNumbersRP1) 
; con las parejas hechas, después seguir rotando la matriz llamando 
; (rotateMatrixRP1) hasta dejar la matriz en la posición inicial. 
; Para la tecla 'l' (derecha) no hay que hacer rotaciones, para el
; resto se tienen que hacer 4 rotaciones.
;    '<ESC>' (ASCII 27)  poner (state = '0') para salir del juego.
; Si no es ninguna de estas tecles no hacer nada.
; Los cambios producidos por estas subrutinas no se tiene que mostrar en 
; pantalla, por lo tanto, hay que actualizar después el tablero llamando 
; la subrutina UpdateBoardP1.
; 
; Variables globales utilizadas:   
; (charac): Carácter leído de teclado.
; (state) : Estado del juego. ('0': Salir ('ESC' pulsado), '1':jugar.
;;;;;  
readKeyP1:
   push rbp
   mov  rbp, rsp

   push rax 
      
   call getchP1    ; Leer una tecla y dejarla en charac.
   mov  al, BYTE[charac]
      
   readKeyP1_i:
   cmp al, 'i'      ; arriba
   jne  readKeyP1_j
      call rotateMatrixRP1
      
      call shiftNumbersRP1
      call addPairsRP1
      call shiftNumbersRP1  
      
      call rotateMatrixRP1
      call rotateMatrixRP1
      call rotateMatrixRP1
      jmp  readKeyP1_End
      
   readKeyP1_j:
   cmp al, 'j'      ; izquierda
   jne  readKeyP1_k
      call rotateMatrixRP1
      call rotateMatrixRP1
      
      call shiftNumbersRP1
      call addPairsRP1
      call shiftNumbersRP1  
      
      call rotateMatrixRP1
      call rotateMatrixRP1
      jmp  readKeyP1_End
      
   readKeyP1_k:
   cmp al, 'k'      ; abajo
   jne  readKeyP1_l
      call rotateMatrixRP1
      call rotateMatrixRP1
      call rotateMatrixRP1
      
      call shiftNumbersRP1
      call addPairsRP1
      call shiftNumbersRP1  
      
      call rotateMatrixRP1
      jmp  readKeyP1_End

   readKeyP1_l:
   cmp al, 'l'      ; derecha
   jne  readKeyP1_ESC
      call shiftNumbersRP1
      call addPairsRP1
      call shiftNumbersRP1  
      jmp  readKeyP1_End

   readKeyP1_ESC:
   cmp al, 27      ; Salir del programa
   jne  readKeyP1_End
      mov BYTE[state], '0'

   readKeyP1_End:
   pop rax
      
   mov rsp, rbp
   pop rbp
   ret


;;;;;
; Juego del 2048
; Subrutina principal del juego
; Permite jugar al juego del 2048 llamando todas las funcionalidades.
;
; Pseudo-código:
; Inicializar estado del juego, (state='1')
; Borrar pantalla (llamar a la función clearScreen_C).
; Mostrar el tablero de juego (llamar a la función printBoardP1_C).
; Actualizar el contenido del Tablero de Juego y los puntos que se han 
; hecho (llamar a la subrutina updateBoardP1).
; Mientras (state=='1') hacer
;   Leer una tecla (llamar a la subrutina readKeyP1) y llamar a las subrutina que corresponda.
;   Si hemos movido algún número al hacer los desplazamientos o al hacer
;   las parejas (state=='2'). Generar una nueva ficha (llamando a la subrutina
;   insertTileP1_C) y poner la variable state a '1' (state='1').
;   Actualizar el contenido del Tablero de Juego y los puntos que se han
;   hecho (llamar a la subrutina updateBoardP1).
; Fin mientras.
; Mostrar un mensaje debajo del tablero según el valor de la variable 
; (state). (llamar a la función printMessageP1_C).
; Salir: 
; Se ha terminado el juego.
; 
; Variables globales utilizadas:   
; (state)    : Estado del juego.
;              '0': Salir, hemos pulsado la tecla 'ESC' para salir.
;              '1': Continuamos jugando.
;              '2': Continuamos jugando pero se han hecho cambios en la matriz
;;;;;  
playP1:
   push rbp
   mov  rbp, rsp
   
   mov BYTE[state], '1'       ;state = '1';    
   
   call clearScreen_C
   call printBoardP1_C
   call updateBoardP1

   playP1_Loop:               ;while  {     //Bucle principal.
   cmp  BYTE[state], '1'      ;(state == '1')
   jne  playP1_End
      
      call readKeyP1          ;readKeyP1_C();
      cmp BYTE[state], '2'    ;state == '2';
      jne playP1_Next 
         call insertTileP1_C  ;insertTileP1_C();
         mov BYTE[state],'1'  ;state = '1';
      playP1_Next
      call updateBoardP1      ;updateBoardP1_C();
      
   jmp playP1_Loop

   playP1_End:
   call printMessageP1_C      ;printMessageP1_C();
   
   mov rsp, rbp
   pop rbp
   ret

