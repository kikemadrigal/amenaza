        output "scloader.bin"

    db   #fe               ; ID archivo binario, siempre hay que poner el mismo 0FEh
    dw   INICIO            ; dirección de inicio
    dw   FINAL - 1         ; dirección final
    dw   INICIO            ; dircción del programa de ejecución (para cuando pongas r en bload"nombre_programa", r)

    org #9800   ; org se utiliza para decirle al z80 en que posición de memoria empieza nuestro programa (es la 33280 en decimal), en hezadecimal sería #8200

CHGMOD equ #005F   ; Cambia el modo de screen pero previamente necesita que se le asigne el modo en el registro a
LDIRVM equ #005C   ;Tansfiere bloques de la RAM a la VRAM, es la más importante, necesita previamente asignar valor al registro bc con la longitud, dc con la dirección de inicio de la VRAM y hl con la dirección de inicio de la RAM:
GTSTCK equ #00D5   ;si le pasas al registro a un 0 detectará los cursores,un 1 para el joystick 1 y 2 para el joystick 2
                   ;devuelve en a 1 arriba, 2 diagonal arriba derecha,3 derecha, asi hasta 7

INICIO:
    call inicializar_modo_pantalla
    call cargar_tiles_colores_mapa ;cargamos la pantalla con la foto de presentación
    ;call #009F
    ret


;Es la pantalla con la foto
cargar_tiles_colores_mapa:
;Para comprender como se distrivuye la memoria del VDP ir a: https://sites.google.com/site/multivac7/files-images/TMS9918_VRAMmap_G2_300dpi.png
;-----------------------------Tileset -------------------------------------------
    ;screen1 es el splash_screen o pantalla incial con la foto de presentación
    ld hl, tiles ; la rutina LDIRVM necesita haber cargado previamente la dirección de inicio de la RAM, para saber porqué he puesto 0000 fíjate este dibujo https://sites.google.com/site/multivac7/files-images/TMS9918_VRAMmap_G2_300dpi.png ,así es como está formado el VDP en screen 2
    ld de, #0000 ; la rutina necesita haber cargado previamente con de la dirección de inicio de la VRAM          
    ld bc, #1800; son los 3 bancos de #800
    call  LDIRVM ; Mira arriba, pone la explicación
    ;call depack_VRAM   
    ;call unpack 
;--------------------------------Colores--------------------------------------
    ld hl, color
    ld de, #2000 
    ld bc, #1800 ;son los 3 bancos de #800
    call  LDIRVM
    ;call depack_VRAM
    ;call unpack
;------------------------------Mapa o tabla de nombres-------------------------------
    ld hl, mapa
    ld de, #1800 
    ld bc, #300
    call  LDIRVM
    ;call depack_VRAM
    ;call unpack   
    ret
;*************************Final de cargar_pantalla_screen1 la de la foto**********************

inicializar_modo_pantalla:
     ;Cambiamos el modo de pantalla
    ld  a,2     ; La rutina CHGMOD nos obliga a poner en el registro a el modo de pantalla que queremos 
    call CHGMOD ; Mira arriba, pone la explicación, pone screen 2 y sprite de 16 sin apliar
    ret



;************************************Final de inicializar_modo_pantalla********************

;Este include lleva la rutina de descompresion de los archivos a VRAM
;Hay que meterle previamente en el reg. hl la dirección de la RAM y en DE la VRAM
;depack_VRAM:
;    include "src/PL_VRAM_Depack.asm"

;include "src/bios.asm"

;Este include lleva dentro la rutina depack para descomprimir archivos en ram
;la rutina unpack necesita que le metas previamente en el reg. hl la dirección de lso datos que uieres descomprimir y en de la direccion de la RAM
;include "src/unpack.asm"




;Esta es la pantalla con la foto
tiles:
    incbin "./src/scloader-tiles.bin.chr"
color:
    incbin "./src/scloader-tiles.-color.bin.clr"
mapa: 
    incbin "./src/scloader-map.bin"




FINAL:











