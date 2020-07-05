
rem para desactivar los mensajes de los programas
rem @echo off
rem sjasm (http://www.xl2s.tk/) es un compilador de ensamblador z80 que puedo convertir tu código ensamblador en los archivos binarios.rom y .bin
rem necesitamos el .bin de la pantalla de carga y del reproductor de música
start /wait tools/sjasm/sjasm.exe src/scloader.asm
start /wait tools/sjasm/sjasm.exe src/music.asm
move /Y scloader.bin ./src
move /Y music.bin ./src
rem del /F src/scloader.lst
rem del /F src/music.lst

rem /************Diskmanager******************/
rem Añadiendo archivos al .dsk, tenemos que crear antes el archivo disco.dsk con el programa disk manager
rem para ver los comandos abrir archivo DISKMGR.chm
rem AUTOEXEC.BAS es un archivo basic con el comando bload que hará que se autoejecute el main.bas
start /wait tools/Disk-Manager/DISKMGR.exe -A -F -C bin/main.dsk src/AUTOEXEC.BAS 
rem main.bas contiene mi código fuente
start /wait tools/Disk-Manager/DISKMGR.exe -A -F -C bin/main.dsk src/main.bas
rem le metemos el archivo binario con la pantalla de carga
start /wait tools/Disk-Manager/DISKMGR.exe -A -F -C bin/main.dsk src/scloader.bin
rem le metemos el archivo binario con la música
start /wait tools/Disk-Manager/DISKMGR.exe -A -F -C bin/main.dsk src/music.bin

rem imagen de la pantalla de presentación
start /wait tools/Disk-Manager/DISKMGR.exe -A -F -C bin/main.dsk assets/FONDO.SC5
rem imagen de la page1 de la primera pantalla
start /wait tools/Disk-Manager/DISKMGR.exe -A -F -C bin/main.dsk assets/PAGE1.SC5


rem /***********Abriendo el emulador***********/
rem Abriendo con openmsx, presiona f9 al arrancar para que vaya rápido
start /wait emulators/openmsx/openmsx.exe -machine Philips_NMS_8255 -diska bin/main.dsk
rem Abriendo con FMSX https://fms.komkon.org/fMSX/fMSX.html
rem start /wait emulators/fMSX/fMSX.exe -diska main.dsk


