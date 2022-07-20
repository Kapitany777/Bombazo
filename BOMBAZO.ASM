;/**************************************************************************\
;*                                                                          *
;*                               Bomb†z¢ j†tÇk                              *
;*                                                                          *
;*                                   årta :                                 *
;*                                                                          *
;*                                Tîrîk Viktor                              *
;*                                                                          *
;*                            ANNO DOMINI MCMXCVI                           *
;*                                                                          *
;\**************************************************************************/

;------------------------------ Veremszegmens -------------------------------

STACK_SEG SEGMENT STACK

 DB 256 DUP (' ')

STACK_SEG ENDS

;------------------------------- Adatszegmens -------------------------------

DATA_SEG SEGMENT

; A bevezetì szîveg

 Cim   db 'Bomb†z¢',0
 Iro   db 'årta : Tîrîk Viktor',0
 Datum db 'ANNO DOMINI MCMXCVI',0
 Spc   db 'Space...',0

 Gyoz  db 'Gyìzelem!',0

; A tervezett karakterek adatai

 Haziko  db 254,146,146,146,146,146,146,254,146,146,146,146,146,146,146,254
 Repulo1 db 128,192,224,240,255,255,255,127,63,0,0,0,0,0,0,0
 Repulo2 db 0,0,0,0,248,132,198,254,254,252,0,0,0,0,0,0
 Bomba   db 0,0,0,0,0,16,56,56,16,186,124,56,56,56,56,16

 xk dw 2
 yk dw 2    ; A repÅlì koordin†t†i

 bxk dw 0
 byk dw 0   ; A bomba koordin†t†i

 a db 0     ; SegÇdv†ltoz¢

DATA_SEG ENDS

;------------------------------- K¢dszegmens --------------------------------

CODE_SEG SEGMENT

 ASSUME CS : CODE_SEG, DS : DATA_SEG, SS : STACK_SEG, ES : CODE_SEG

 EXTRN Clear_Screen : PROC, CursorOff : PROC, Write_Text_ : PROC
 EXTRN Write_Big_Text : PROC, Raster_ : PROC
 EXTRN Randomize : PROC, Random : PROC
 EXTRN Razas : PROC

;************************************
; A j†tÇk bevezetì rÇsze
;************************************

 Bevezetes PROC

  call CursorOff

  mov bx,12
  mov cx,6
  push ds
  pop es
  mov di,offset Cim
  call Write_Big_Text

  mov bx,30
  mov cx,16
  lea si,Iro
  call Write_Text_

  mov bx,30
  mov cx,18
  lea si,Datum
  call Write_Text_

  mov bx,37
  mov cx,20
  lea si,Spc
  call Write_Text_

  call Raster_

  ret

 Bevezetes ENDP

;*************************************
; A karakterek megtervezÇse
;*************************************

 Karakterek_tervezese PROC

  push ax
  push bx
  push cx
  push dx
  push es
  push bp

  mov ax,1110h
  mov cx,4
  mov dx,0c0h
  mov bl,0
  mov bh,16
  push ds
  pop es
  mov bp,offset Haziko
  int 10h

  pop bp
  pop es
  pop dx
  pop cx
  pop bx
  pop ax

  ret

 Karakterek_tervezese ENDP

;*****************************
; A h†zak kirajzol†sa
;*****************************

 Hazak_kirajzolasa PROC

  mov dl,14+16
  call Clear_Screen

  mov ax,0b800h
  mov es,ax

  mov di,24*80+2
  mov cx,38
  mov ax,' '+96*256
  cld
  rep stosw

  call Randomize

  mov bx,3

 @Haz_kir :

  call Random
  and ax,7           
  add ax,15

  mov cx,ax

  mov di,40
  mul di
  mov di,ax
  add di,bx
  shl di,1
  mov al,'¿'
  mov ah,14+16

 @HK2 :
  mov es:[di],ax
  add di,80

  inc cx
  cmp cx,24
  jne @HK2

  inc bx
  cmp bx,37

  jne @Haz_kir

  ret

 Hazak_kirajzolasa ENDP

;*********************************
; A j†tÇk
;*********************************

 Jatek PROC

  mov ax,0b800h
  mov es,ax

 @Jatek_eleje :

 ; RepÅlì kirajzol†sa

  mov ax,80
  mov bx,yk
  mul bx
  mov di,xk
  shl di,1
  add di,ax

  mov al,'¡'
  mov es:[di],al
  mov al,'¬'
  mov es:[di+2],al

 ; Mi van a repÅlì elìtt?
  mov al,es:[di+4]
  mov a,al

 ; V†rakoz†s
  mov dx,60000

 @WW :
  dec dx
  jne @WW

  mov dx,03dah

 @RASW :
  in al,dx
  and al,8
  cmp al,8
  jne @RASW

 ; RepÅlì letîrlÇse
  mov al,' '
  mov es:[di],al
  mov es:[di+2],al

  cmp byk,0
 ; Ekkor nem kell bomb†t dobni
  je @NOBOMB

 ; Bomba mozgat†sa
  mov ax,80
  mov bx,byk
  mul bx
  mov di,bxk
  shl di,1
  add di,ax

  mov al,' '
  mov es:[di],al
  mov al,'√'
  mov es:[di+80],al
  inc byk

  cmp byk,23
  jne @NOBOMB

  mov al,' '
  mov es:[di+80],al
  mov ax,0
  mov byk,ax

 @NOBOMB :

 ; Volt-e billentyñlenyom†s?
  mov ah,1
  int 16h
  jz @Nem_b

  mov ah,0
  int 16h
 ; Space-t nyomtak?
  cmp al,' '
  jne @Nem_b

  cmp byk,0
 ; MÇg repÅl a bomba
  jne @Nem_b

  mov ax,xk
  mov bxk,ax
  mov ax,yk
  inc ax
  mov byk,ax

 @Nem_b :

  inc xk

  cmp xk,38
  jne @NOSVEG

 ; Sor vÇgÇre ÇrtÅnk
  mov ax,2
  mov xk,ax
  inc yk

 @NOSVEG :

  mov al,a
  cmp al,32
  jne @Utkozes

  cmp yk,23
  je @Gyozelem

  jmp @Jatek_eleje

 @Utkozes :

  call Razas
  mov ah,8
  int 21h
  jmp @Jatek_vege

 @Gyozelem :

  mov ah,8
  int 21h

  mov ax,3
  int 10h

  call CursorOff 

  mov bx,5
  mov cx,6
  push ds
  pop es
  mov di,offset Gyoz
  call Write_Big_Text

  mov ah,8
  int 21h

 @Jatek_vege :

  ret

 Jatek ENDP

;*****************************
; A fìprogram
;*****************************

 START :

  mov ax,DATA_SEG
  mov ds,ax

  mov ax,3
  int 10h

  call Bevezetes

; 40x25-îs kÇpernyì bekapcsol†sa

  mov ax,0
  int 10h

  call Karakterek_tervezese

  call CursorOff

  call Hazak_kirajzolasa

  mov ah,8
  int 21h

  call Jatek

  mov ax,3
  int 10h

  mov ah,4ch
  int 21h

CODE_SEG ENDS

 END START