1 ' Programa MSX Murcia 2020 / Program MSX Murcia 
1 ' MSX Basic'
1 ' 0-1000 Main: Pantalla presentación, Pantalla levl 1, pantalla game over'
1 ' 2000-10000 Rutinas generales: sistema renderizado 2000-2090, sistema de colisiones, ' 
1 '    captura de cursores y teclado, rutinas para mostrar la información por pantalla'
1 ' 10500-11190 Rutinas jugador: actualizar player, mover player '
1 ' 21000-21140 Rutinas enemigos: actualizar enemigo que te persigue, moviento aleatorio virus redondo '
1 ' 21300-21400 Rutinas bloques pantalla
1 ' 30000-40000 Ruinas pantallas: 
1 '       30000: Volcado de datos pantalla presentación screen5
1 '       30300: pantalla game over screen 0
1 '       33000: Pantalla level 1 screen 5: 
1 '             inicialización
1 '             inicialización de variables
1 '             iniciallización de pages
1 '             Copys pageo
1 '             carga de sprites y colores sprites



1 '------------------------------------'
1 '     Pantalla presentación / Splash screen '
1 '------------------------------------'
1 ' Se muestra la pantalla de presentación
40 gosub 30000

1 ' Al pulsar 1 tecla continuará la ejecución'
50 a$=inkey$: if a$="" goto 50 


1 '------------------------------------'
1 '     Pantalla 1 / Screen 1 '
1 '------------------------------------'

80 screen 0:cls
90 color 11,1,1
100 locate 10,5
110 print "Level 1"
120 locate 0,10
130 print "Recoge 20 virus antes de que se te acabe la energia"
140 locate 0,13
150 print "Collect 20 viruses before you run out of energy"
160 locate 0,21
1 ' Esto es un peueño retraso para mostrar la información de lo que va la pantalla 1'
170 for i=0 to 2000: next i
1 ' 1 necesitamos ddecirle que es screen 5, inicializamos la pantalla 1'
180 gosub 31000
1'  2 Necesitamos decirle la inicialización del personaje, de los enemigos y bloques
190 gosub 31500
1 ' Volcado de datos del archivo binario a la page 1 VRAM'
200 gosub 32000
1 ' Copys para pintar de la page 1 los objetos sólidos de la pantalla'
210 gosub 23000
1 ' Copys de la page 1 a la page 0 para pintar el fondo de la pantalla
220 gosub 32100
1 ' Cargamos los sprites de la pantalla 1'
230 gosub 33000
1 ' Creamos un flujo para poder pintar en la pantalla, esto afectará a los input y print que tenga #numero'
240 open "grp:" for output as #1
1 ' Como habíamos activados las interrupciones de los intervalos de tiempo, en la pantalla 1 podemos poner que el virus redondo cambie de posición cada cierto tiempo solo'
250 on interval=120 gosub 21100
1 ' Subrutina mostrar información del juego'
260 gosub 7000
1 ' Inicializamos la música de la 1 pantalla'
270 'bload "music.bin"
1' Necesitamos inicializar el reproductor hecho en ensamblador
280 'defusr=&hd000
1 ' Llamamos a la rutina inicializar música en ensamblador'
290 'a=usr(0)
1 ' Otenemos la referencia de la rutina en ensamblador para reproducir los bloques de música'
300 'defusr1=&hd009
1 ' Sistema de renderer'
310 gosub 2000


1 '------------------------------------'
1 '     Pantalla final / Game over '
1 '------------------------------------'
1' Dibujamos el texto de la pantalla game over
900 gosub 30300
1 ' Otra partida s/n,es posible borrar la interrogación con for i=0 to 7: vpoke base(2)+(63*8)+i,0: next i
910 locate 0,100
930 input "¿Otra partida S/N ";a$
940 if a$="s" or a$="S" then goto 80
950 if a$="n" or a$="N" then print "adios":for i=0 to 500: next i:cls:end
960 goto 930


990 end



























   





 
1 '-----------------------------------------------------------------'
1 '---------------------General rutines------------------------------'
1 '-----------------------------------------------------------------'

1 ' ----------------------'
1 '   Sistema de renderer
1 ' ----------------------'
    1' Inicio blucle
        1 ' Comprobar vidas '
        2000 gosub 3000
        1 ' Actualizamos bloque de musica a reproducir'
        2010 'a=usr1(0)
        1 'Llamamos a la subrutina pintar player'
        2020 gosub 10500
        1 ' Subrutinas actualizar sprites enemigos'
        2030 gosub 21000
        1 ' Llamamos a la subrutina de los cursores / joystick
        2040 gosub 6000 
        1 'Rutina comprobar colosiones'
        2050 gosub 5000
    1 ' El goto es como una especie de while para que vuelva  capturar el teclado y dibujar'
    2060 goto 2000
2090 return


1 ' Chequeo Vida juegador / personaje'
    1 ' Si se termina la energía vamos a la rutina de finalización pantalla 1'
    3000 if pe=0 then gosub 31300
3040 return

1 ' ----------------------'
1 '   Sistema de colisiones
1 ' ----------------------'

1 'Rutina comprobar colisiones https://developer.mozilla.org/es/docs/Games/Techniques/2D_collision_detection'
    1' Si hay colisión con el enemigo a perseguir vamos a la subrutina 5100
    5000 if px < ex(0) + ew(0) and  px + pw > ex(0) and py < ey(0) + eh(0) and ph + py > ey(0) then gosub 5100 
    5010 if px < ex(1) + ew(1) and  px + pw > ex(1) and py < ey(1) + eh(1) and ph + py > ey(1) then gosub 5200 
    1 ' Colisiones con objetos sólidos'

    5020 if px < ox(1) + ow(1) and px + pw > ox(1) and ph + py > oy(1) and py < oy(1) + oh(1) then gosub 5300


 
5040 return


1 ' ----------------------'
1 '   Rutina de colisión con el enemigo a perseguir
1 ' ----------------------'
1'Rutina colosión, le ponemos una x y una y aleatoria a los enemigos
    1 ' El movimiento aleatorio del virus redondo es con 1 set interval
    1' Le ponemos un soido
    5100 beep
    1 ' Aumentamos en 1 la captura del player'
    5110 pc=pc+1
    1 ' Aumentamos en 10 la energia del player'
    5120 pe=pe+10
    1' subrutina pintar información en pantalla
    5150 gosub 7000
5170 return

1 ' ----------------------'
1 '   Rutina de colisión con el enemigo que te persigue
1 ' ----------------------'
    1 ' Le ponemos 1 sonido'
    5200 beep
    1 ' Le quitamos la vida al personaje'
    5210 pe=0
5220 return

1 ' ----------------------'
1 '   Rutina de colisión con objetos sólidos
1 ' ----------------------'
    1 ' detectamos la dirección: pd=dirección arriba ^ 1, derecha > 3, abajo v 5, izquierda < 7
    5300 if pd=3 then px=px-pv
    5310 if pd=7 then px=px+pv
    5320 if pd=1 then py=py+pv
    5330 if pd=5 then py=py-pv
5340 return







1 ' ----------------------'
6000 'Subrutina captura movimiento joystick / cursores y boton de disparo'
1 ' ----------------------'
    1'1 Arriba, 2 arriba derecha, 3 derecha, 4 abajo derecha, 5 abajo, 6 abajo izquierda, 7 izquierda, 8 izquierda arriba
    6010 j=stick(0)
    6020 if j=3 and pe<>0 then  gosub 11050
    6030 if j=7 and pe<>0 then  gosub 11090
    6040 if j=1 and pe<>0 then  gosub 11130
    6050 if j=5 and pe<>0 then  gosub 11170 
6080 return

1 ' ----------------------'
1 '   Mostrar información
1 ' ----------------------'
1 ' Pintamos un rectangulo en la parte superior de la pantalla', color 14 gris claro, bf es un rectangulo relleno y mostramos las caputras
    7000 line (0,0)-(w, 10), 14, bf
    7010 preset (0,0)
    7020 print #1, "Vidas: "pe
    7030 preset (150,0)
    7040 print #1, "Capturas: "pc
7050 return


1 ' Mostramos la vida
    7100 preset (30,0)
    7110 print #1, "   "pe"     "
7120 return






















1 ' ------------------------------------------------------------------------------'
1 ' -------------------------Rutinas player --------------------------------------'
1 ' ------------------------------------------------------------------------------'



1 '------------------------'
1 'Subrutina actualizar player'
1 '------------------------'
    10500 put sprite 0,(px,py),,p
10550 return


1 '------------------------'
11040 'Subrutinas mover '
1 '------------------------'
1 'pd=dirección arriba ^ 1, derecha > 3, abajo v 5, izquierda < 7
1 'Mover derecha
    1' 1 se suma a la posición x la velocidad del player
    11050 px=px+pv
    1 ' Le ponemos como plano el 0'
    11060 p=0
    1 '  Para conseguir un movimeinto tenemos que crear la variable np=número de plano'
    11065 np=np+1
    11070 if np>1 then p=p+1: np=0
    1 ' Si la posición en x del player es mayor que el ancho de la pantalla la dejamos en esa posición'
    11075 if px>=w-pw then px=w-pw
    1 ' Descruento de energía cada vez que ande en todo el juego'
    11076 pe=pe-1
    1 ' Le ponemos al player la dirección derecha'
    11077 pd=3
    1 ' Mostramos la vida'
    11078 gosub 7100
11080 return
 1 ' Mover izquierda'
    11090 px=px-pv
    11100 p=2
    11105 np=np+1
    11110 if np>1 then p=p+1: np=0
    11115 if px<0 then px=0
    11116 pe=pe-1
    1 ' Le ponemos al player la dirección izquierda'
    11117 pd=7
    1 ' Mostramos la vida'
    11118 gosub 7100
11120 return
1 ' Mover arriba
    11130 py=py-pv
    11140 p=6
    11145 np=np+1
    11150 if np>1 then p=p+1: np=0
    11155 if py<=0 then py=0
    11156 pe=pe-1
    1 ' Le ponemos al player la dirección arriba'
    11157 pd=1
    1 ' Mostramos la vida'
    11158 gosub 7100
11160 return
1 ' Mover abajo'
    11170 py=py+pv
    11180 p=4
    11182 np=np+1
    11185 if np>1 then p=p+1: np=0
    11187 if py >=212-ph then py=212-ph
    11188 pe=pe-1
    1 ' Le ponemos al player la dirección abajo'
    11189 pd=5
    1 ' Mostramos la vida'
    11190 gosub 7100
11200 return



































1 ' ------------------------------------------------------------------------------'
1 ' ----------------Rutinas enemigos --------------------------------------'
1 ' ------------------------------------------------------------------------------'


1 '------------------------'
21000 'Subrutinas actualizar sprites enemigos'
1 '------------------------'
    1 ' Este es el enemigo a capturar
    21020 put sprite 8,(ex(0),ey(0)),,8 
    1 ' Este es el enemigo que te persigue'
    21030 'ex(1)=ex(1)+1
    1' Restamos la distancia de este enemigo con el personaje protragonista y aumentamos o dismiuimos la x e y del enemigo para que te persiga
    21040 dx=ex(1)-px: if dx<0 then ex(1)=ex(1)+1 else ex(1)=ex(1)-1
    21050 dy=ey(1)-py: if dy<0 then ey(1)=ey(1)+1 else ey(1)=ey(1)-1
    1 ' Esto es para ir cambiando de sprites del enemigo y hacer una animación'
    21060 ep(1)=ep(1)+1
    21070 if ep(1)>1 then ep(1)=0
    1 ' Si es un modulo de 2 ponemos el sprite 9, sino el 10'
    21080 if ep(1)=0 then put sprite 9,(ex(1),ey(1)),,9 else put sprite 10,(ex(1),ey(1)),,10
21090 return



1 ' Rutina movimiento sprite virus redondo'
    21100 ex(0)=(rnd(1)*w)-ew(0)
    21110 ey(0)=(rnd(1)*h)-eh(0)
    1' Esto es para evitar que no se ponga en la información
    21120 if ey(0)<30 goto 21100
21140 return































1 ' ------------------------------------------------------------------------------'
1 ' ----------------Rutinas Obtjetos pantalla------------------------------'
1 ' ------------------------------------------------------------------------------'
1 ' El 1 objeo son los ladrillos blancos del marco ov(0)'
1 ' El 2 objeos son los ladrillos rojos sólidos ox(1)'


1 '------------------------'
1 ' Pintar objetos sólidos
1 '------------------------'
        23000 'ox=rnd(1)*200
        23010 'oy=rnd(1)*200
        1 ' parámteros objetos, como son dubjos de 16px de alto y elegimos el bloque marrón que está en la 9 fila oy será 9*16
        23020 copy (0,9*16)-(0+ow(1),9*16+oh(1)),1 to (ox(1), oy(1)),0
    23030 return




































1 ' ------------------------------------------------------------------------------'
1 ' ----------------Pantallas / Niveles --------------------------------------'
1 ' ------------------------------------------------------------------------------'




1 ' ---------------------------------------------------------------------------------------'
1 '                                    Pantalla presentación
1 ' --------------------------------------------------------------------------------------'
    30000 COLOR 15,0,0: SCREEN 5
    30020 DATA 0,0,0,2,2,2,2,4,2,5,0,0,0,0,5,4,3,2,2,3,5,0,7,0
    30030 DATA 7,3,0,4,0,7,2,5,6,6,5,2,5,4,5,2,6,7,7,6,2,7,7,6
    30040 FOR C=0 TO 15:READ R,G,B:COLOR=(C,R,G,B):NEXT
    30050 BLOAD"FONDO.SC5",S
30080 return



1 ' ---------------------------------------------------------------------------------------'
1 '                                    Pantalla Game over
1 ' --------------------------------------------------------------------------------------'
    30300 screen 0
    30320 color 11,1,1
    30330 locate 0,10
    30340 print " Te han matado!!"
30380 return










1 ' ---------------------------------------------------------------------------------------'
1 '                                   Pantalla 1
1 ' --------------------------------------------------------------------------------------'
1' Inicialización pantalla 1
    1 ' Borramos la pantalla' 
    31000 cls
    1 ' Lo 1 es definir el color de caracteres 15 blanco, el fondo 7 azul claro y margen
    31120 color 15,7,7
    1 ' Lo 2 es comfigurar la pantalla con screen modo_video, tamaño_sprites'
    1 ' el tamaño_sprite puede ser 0 (8x8px), 1 (8x8px ampliado), 2 (16x16 x), 3 (16x16px) ampliado'
    31130 screen 5,2
    1 ' Desactivamos el sonido de las teclas
    31140 key off
    1' Defimos a basic que haga que las variables de empiezan desde la a a la z sean enteras de 16 bits, en lugar de las de 32 que asigna por defecto
    31150 defint a-z
    1 ' Activamos las interrupciones de los intervalos de tiempo para que haga algo cuando se cumplan los 60 segundos, cambie la posición del enemigo
    31160 interval on
    1 ' Parametros pantalla
    31170 let w=256: h=212 
31180 return

1 ' Finalización pantalla 1'
    31300 interval off
    31310 close #1
    1 ' Después de resetear las cosas en la pantalla, vamos a la pantalla de game over'
    31320 goto 900
31380 return


1 ' Inicialización de variables personaje, enemigos y objeto-bloques'
    1 ' parámteros personaje, posición x e y, anho  24y alto35, dirección arriba ^ 1, derecha > 3, abajo v 5, izquierda < 7
    31500 let px=10: let py=20: let pw=16: let ph=16: let pd=3
    1 ' variables para manejar los sprites, np=numero de paso; para hacer el movimeinto, p=plano; para cambiarlo en el put sprite
    31510 let np=0: let p=0
    1 ' Parametros del player o personaje de velocidad, energia y de caputras 
    31520 let pv=10: let pe=100: let pc=0
    31530 'dim ex(1),ey(1),ew(1),eh(1)
    1 ' Inicialización de enemigo a capturar, ep es el plano del enemigo para hacer una animación'
    31540 ex(0)=100: ey(0)=100: ew(0)=16: eh(0)=16: ep(0)=0
    1' Inicialización de enemigo que te persigue
    31550 ex(1)=200: ey(1)=180: ew(1)=16: eh(1)=16: ep(1)=0
    1'  os es objeto solido 0 (no) 1 (si), se utiliza para que no pueda moverse el personaje'
    1 ' El 1 objeo son los ladrillos blancos del marco'
    31560 ox(0)=0: oy(0)=0: ow(0)=16: oh(0)=16
    1 ' El 2 objeos son los ladrillos rojos sólidos'
    31570 ox(1)=100: oy(1)=100: ow(1)=16: oh(1)=16
31580 return


1' Cargamos la pantalla que está alacenada de un archivo binario a la página 1 dirección 32768
    32000 restore 32000
    32010 DATA 0,0,0,2,1,1,2,0,2,4,0,0,3,2,2,4,3,1,1,3,4,1,4,3
    32020 DATA 5,1,1,3,4,5,6,3,3,6,5,3,6,7,2,2,6,7,7,6,4,7,7,7 
    32030 FOR C=0 TO 15:READ R,G,B:COLOR=(C,R,G,B):NEXT
    32040 BLOAD"PAGE1.SC5",S,32768
    32050 color=restore
32060 return

1 'Pintar en pantalla el fondo'
1' pintamos los bloques blancos de arriba y de abajo
    32100 for i=0 to w-ow(0) step ow(0)
        1' 48 y 66 es la x e y de la page 0 del bloque elegido, 20 es el espacion del titulo de arroba
        32110 copy (48,66)-(48+ow(0),66+oh(0)),1 to (i, 10),0
        32120 copy (48,66)-(48+ow(0),66+oh(0)),1 to (i, h-oh(0)),0
    32130 next i
    1' pintamos los bloque blancos de izquierda y derecha
    32140 for i=0 to h-oh(0) step oh(0)
        32150 copy (48,66)-(48+ow(0),66+oh(0)),1 to (0, i),0
        32160 copy (48,66)-(48+ow(0),66+oh(0)),1 to (w-ow(0), i),0
    32170 next i
32180 return











1 '-----------------------------------------------------'
1 'Subrutina cargar sprites y colores sprites pantalla 1'
1 '-----------------------------------------------------'
    33000 s=base(29)
    1' 8 Es el número de sprites que tenemos dibujados
    33010 for i=0 to (32*11)-1
        33020 read a
        33030 vpoke s+i,a
    33040 next i


    1' Sprite 0, personaje mirando hacia la derecha 0
    33050 data &H03,&H07,&H04,&H04,&H07,&H07,&H03,&HFC
    33060 data &H9B,&H9C,&H97,&HF6,&H04,&H04,&H07,&H05
    33070 data &HC0,&HC0,&H80,&H80,&HC0,&HC0,&H00,&H80
    33080 data &HC0,&H70,&HF0,&H80,&H00,&H80,&H60,&H20
    1' Sprite 1, personaje mirando hacia la derecha 1
    33090 data &H03,&H07,&H04,&H04,&H07,&H07,&H03,&HFC
    33100 data &H9B,&H9C,&H97,&HF6,&H00,&H09,&H18,&H12
    33110 data &HC0,&HC0,&H80,&H80,&HC0,&HC0,&H00,&H80
    33120 data &HC0,&H70,&HF0,&H80,&H40,&H20,&H98,&H48
    1' Sprite 2, personaje mirando hacia la izquierda 0
    33130 data &H03,&H03,&H01,&H01,&H03,&H03,&H00,&H01
    33140 data &H03,&H0E,&H0F,&H01,&H00,&H01,&H06,&H04
    33150 data &HC0,&HE0,&H20,&H20,&HE0,&HE0,&HC0,&H3F
    33160 data &HD9,&H39,&HE9,&H6F,&H20,&H20,&HE0,&HA0
    1' Sprite 3, personaje mirando hacia la izquierda 1
    33170 data &H03,&H03,&H01,&H01,&H03,&H03,&H00,&H01
    33180 data &H03,&H0E,&H0F,&H01,&H02,&H04,&H19,&H12
    33190 data &HC0,&HE0,&H20,&H20,&HE0,&HE0,&HC0,&H3F
    33200 data &HD9,&H39,&HE9,&H6F,&H00,&H90,&H18,&H48
    1 ' Sprite 4, personaje mirando hacia arriba 0'
    33210 data &H01,&H03,&H02,&H02,&H03,&H03,&H00,&H02
    33220 data &H06,&H06,&H07,&H01,&H01,&H01,&H04,&H04
    33230 data &HC0,&HE0,&H20,&H20,&HE0,&HE0,&HC0,&H10
    33240 data &H18,&H18,&HF8,&HE8,&H20,&H20,&HC8,&HC8
    1 ' Sprite 5, personaje mirando hacia arriba 1
    33250 data &H00,&H01,&H01,&H01,&H01,&H01,&H00,&H02
    33260 data &H06,&H06,&H07,&H05,&H03,&H07,&H07,&H00
    33270 data &HE0,&HF0,&H10,&H10,&HF0,&HF0,&H60,&H10
    33280 data &H18,&H18,&HF8,&HE0,&H20,&HA0,&H70,&H70
    1 ' Sprite 6, personaje mirando hacia abajo 0'
    33290 data &H01,&H03,&H03,&H03,&H03,&H03,&H00,&H02
    33300 data &H06,&H06,&H07,&H01,&H01,&H01,&H01,&H03
    33310 data &HC0,&HE0,&HE0,&HE0,&HE0,&HE0,&HC0,&H10
    33320 data &H18,&H18,&HF8,&HE8,&H20,&H20,&HE0,&HF0
    1 ' Sprite 7, personaje mirando hacia abajo 1
    33330 data &H00,&H01,&H01,&H01,&H01,&H01,&H00,&H02
    33340 data &H06,&H06,&H07,&H05,&H01,&H03,&H07,&H00
    33350 data &HE0,&HF0,&HF0,&HF0,&HF0,&HF0,&H60,&H10
    33360 data &H18,&H18,&HF8,&HE0,&H20,&H20,&H60,&H60

    1' Virus redondo
    33370 data  &H19,&H18,&H47,&H7E,&H49,&H10,&H91,&HF3
    33380 data  &H91,&H28,&H38,&H24,&H07,&H08,&H10,&H71
    33390 data  &HC0,&H86,&HFE,&HA6,&HF0,&H89,&H0F,&H89
    33400 data  &H10,&H10,&H34,&H3C,&HE4,&H80,&H80,&HC0
    1 ' Virus largo 1'
    33410 data  &H0F,&H08,&H08,&H0C,&H04,&H83,&HC1,&HFF
    33420 data  &HC1,&H81,&H03,&H3E,&H62,&HCC,&H88,&H88
    33430 data  &HF0,&H10,&H10,&H30,&H20,&HC1,&H83,&HFF
    33440 data  &H83,&H81,&HE0,&H3E,&H32,&H13,&H11,&H11
    1' Virus largo 2
    33450 data &H0F,&H08,&H08,&H0C,&H04,&H03,&H01,&H27
    33460 data &H2D,&HF9,&H23,&H03,&H07,&H05,&H05,&H0F
    33470 data &HF0,&H10,&H10,&H30,&H20,&HC0,&H80,&HE2
    33480 data &HB2,&H8F,&HE2,&HC0,&HE0,&HA0,&HA0,&HF0


    1' Rellenamos la tabla de colores del sprite 0 
    33600 for i=0 to (16*11)-1
        33610 read a
        33620 vpoke &h7400+i, a
    33630 next i
    1' Sprite 0, personaje mirando hacia la derecha 0
    33700 data &H0F,&H0F,&H07,&H07,&H0F,&H0F,&H0F,&H08
    33710 data &H08,&H08,&H08,&H08,&H08,&H08,&H0F,&H0F
    1' Sprite 1, personaje mirando hacia la derecha 1
    33720 data &H0F,&H05,&H0A,&H0A,&H0B,&H0B,&H05,&H0B
    33730 data &H0F,&H05,&H0A,&H0A,&H0B,&H0B,&H05,&H0B
    1' Sprite 2, personaje mirando hacia la izquierda 0
    33740 data &H0F,&H05,&H0A,&H0A,&H0B,&H0B,&H05,&H0B
    33750 data &H0F,&H05,&H0A,&H0A,&H0B,&H0B,&H05,&H0B
    1' Sprite 3, personaje mirando hacia la izquierda 1
    33760 data &H0F,&H05,&H0A,&H0A,&H0B,&H0B,&H05,&H0B
    33770 data &H0F,&H05,&H0A,&H0A,&H0B,&H0B,&H05,&H0B
    1 ' Sprite 4, personaje mirando hacia arriba 0'
    33780 data &H0F,&H05,&H0A,&H0A,&H0B,&H0B,&H05,&H0B
    33790 data &H0F,&H05,&H0A,&H0A,&H0B,&H0B,&H05,&H0B
    1 ' Sprite 5, personaje mirando hacia arriba 1
    33800 data &H0F,&H0F,&H0F,&H0F,&H0F,&H0F,&H0F,&H0F
    33810 data &H0F,&H0F,&H0F,&H0F,&H0F,&H0F,&H0F,&H0F
    1 ' Sprite 6, personaje mirando hacia abajo 0'
    33820 data &H0F,&H0F,&H0F,&H0F,&H0F,&H0F,&H0F,&H0F
    33830 data &H0F,&H0F,&H0F,&H0F,&H0F,&H0F,&H0F,&H0F
    1 ' Sprite 7, personaje mirando hacia abajo 1
    33840 data &H0F,&H0F,&H0F,&H0F,&H0F,&H0F,&H0F,&H0F
    33850 data &H0F,&H0F,&H0F,&H0F,&H0F,&H0F,&H0F,&H0F
    1 ' Sprite 8, virus redondo'
    33860 data &H0A,&H0A,&H08,&H08,&H08,&H08,&H08,&H08
    33870 data &H08,&H08,&H08,&H08,&H08,&H0A,&H0A,&H0A
    1 ' Sprite 8, virus alargado 1'
    33880 data &H08,&H08,&H08,&H08,&H08,&H08,&H05,&H05
    33890 data &H05,&H05,&H05,&H03,&H03,&H03,&H03,&H03
    1 ' Sprite 8, virus alargado 2'
    33900 data &H08,&H08,&H08,&H08,&H08,&H08,&H05,&H05
    33910 data &H05,&H05,&H05,&H03,&H03,&H03,&H03,&H03
33990 return









1 ' ---------------------------------------------------------------------------------------'
1 '                                  Final Pantalla 1
1 ' --------------------------------------------------------------------------------------'






