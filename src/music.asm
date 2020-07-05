        output "music.bin"

    db   #fe               ; ID archivo binario, siempre hay que poner el mismo 0FEh
    dw   INICIO            ; dirección de inicio
    dw   FINAL - 1         ; dirección final
    dw   INICIO            ; dircción del programa de ejecución (para cuando pongas r en bload"nombre_programa", r)

    org #d000   ; org se utiliza para decirle al z80 en que posición de memoria empieza nuestro programa (es la 33280 en decimal), en hezadecimal sería #8200

INICIO:
inicializar_tracker:
    di	
	ld		hl,SONG-99		; hl vale la direccion donde se encuentra la cancion - 99
	call	PT3_INIT			; Inicia el reproductor de PT3
	ei 
    ;Salimos al basic
    ret
reproducir_bloque:
    halt						;sincronizacion
	di
	call	PT3_ROUT			;envia datos a al PSG
	call	PT3_PLAY			;prepara el siguiente trocito de cancion que sera enviada mas tarde al PSG
    ei
    ;Volvemos al basic
    ret


tracker:
	include	"./src/PT3_player.asm"					;replayer de PT3
SONG:
	incbin "./src/song.pt3"			;musica de ejemplo


	;Variables del replayer... las coloco desde aqui.
	;mirar que hace la directiva MAP del SJASM
	map		#e000

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;PT3 REPLAYER
PT3_SETUP:		#1	;set bit0 to 1, if you want to play without looping
					;bit7 is set each time, when loop point is passed
PT3_MODADDR:	#2
PT3_CrPsPtr:		#2
PT3_SAMPTRS:		#2
PT3_OrnPtrs:		#2
PT3_PDSP:		#2
PT3_CSP:		#2 
PT3_PSP:		#2
PT3_PrNote:		#1
PT3_PrSlide:		#2
PT3_AdInPtA:		#2
PT3_AdInPtB:		#2
PT3_AdInPtC:		#2
PT3_LPosPtr:		#2
PT3_PatsPtr:		#2
PT3_Delay:		#1
PT3_AddToEn:		#1
PT3_Env_Del:		#1
PT3_ESldAdd:		#2
PT3_NTL3:		#2	; AND A / NOP (note table creator)

VARS:			#0

ChanA:			#29			;CHNPRM_Size
ChanB:			#29			;CHNPRM_Size
ChanC:			#29			;CHNPRM_Size

;GlobalVars
DelyCnt:		#1
CurESld:		#2
CurEDel:		#1
Ns_Base_AddToNs:	#0
Ns_Base:		#1
AddToNs:		#1

NT_:			#192	; Puntero a/tabla de frecuencias

AYREGS:			#0
VT_:			#14
EnvBase:		#2
VAR0END:		#0

T1_:			#0		
T_NEW_1:		#0
T_OLD_1:		#24
T_OLD_2:		#24
T_NEW_3:		#0
T_OLD_3:		#2
T_OLD_0:		#0
T_NEW_0:		#24
T_NEW_2:		#166
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;PT3 REPLAYER END

FINAL:











