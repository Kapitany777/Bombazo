;/**************************************************************************\
;*                                                                          *
;*                     Alapvet“ k‚perny“kezel“ rutinok                      *
;*                                                                          *
;*                                  Œrta :                                  *
;*                                                                          *
;*                              T”r”k Viktor                                *
;*                                                                          *
;*                           ANNO DOMINI MCMXCVI                            *
;*                                                                          *
;\**************************************************************************/

;------------------------------ Stackszegmens ------------------------------

_STACK SEGMENT STACK

 db 256 dup (' ')

_STACK ENDS

;------------------------------- K¢dszegmens -------------------------------

_CODE SEGMENT

 ASSUME CS : _CODE, DS : _CODE, ES : _CODE, SS : _STACK

;---------------------------------------
; K‚perny“t”rl‚s
; Bemen“ adatok : dl - a h tt‚rsz¡n
;---------------------------------------

 PUBLIC Clear_Screen

 Clear_Screen PROC

  push ax
  push cx
  push es
  push di

  mov ax,0b800h
  mov es,ax
  mov di,0

  mov al,' '
  mov ah,dl
  mov cx,80*25
  cld

  rep stosw

  pop di
  pop es
  pop cx
  pop ax

  ret

 Clear_Screen ENDP

;-------------------------------
; Kurzor kikapcsol sa
;-------------------------------

 PUBLIC CursorOff

 CursorOff PROC

  push ax
  push cx

  mov ah,1
  mov cx,2020h
  int 10h

  pop cx
  pop ax

  ret

 CursorOff ENDP

;-------------------------------
; Kurzor bekapcsol sa
;-------------------------------

 PUBLIC CursorOn

 CursorOn PROC

  push ax
  push cx

  mov ah,1
  mov cx,0A0Bh
  int 10h

  pop cx
  pop ax

  ret

 CursorOn ENDP

;--------------------------------------------------
; Sz”veg ki¡r sa
;
; Bemen“ adatok : BX    - sz”veg X koordin t ja
;                 CX    - sz”veg Y koordin t ja   
;                 DS:SI - a sz”veg c¡me
;
; A sz”veget 0-val kell lez rni
;--------------------------------------------------

 PUBLIC Write_Text_

 Write_Text_ PROC

  push ax
  push bx
  push cx
  push ds
  push es
  push di
  push si
  push bp

  mov ax,0b800h
  mov es,ax

  mov ax,160
  mul cx
  shl bx,1
  add ax,bx
  mov di,ax

  mov bx,0
  mov bp,0
  mov ah,15

 @Kezdet_ :
  mov al,ds:[si+bx]
  cmp al,0
  je @EXIT_
  mov es:[di+bp],ax
  inc bx
  cmp bx,80
  je @EXIT_
  inc bp
  inc bp
  jmp @Kezdet_

 @EXIT_ :

  pop bp
  pop si
  pop di
  pop es
  pop ds
  pop cx
  pop bx
  pop ax

  ret

 Write_Text_ ENDP

;----------------------------------------------
; Sz m ki¡r sa
;
; Bemen“ adatok : AX - a sz m
;                 BX - a sz m X koordin t ja
;                 CX - a sz m Y koordin t ja
;----------------------------------------------

 PUBLIC Write_Number_

 Write_Number_ PROC

  mov si,ax

  mov ax,0b800h
  mov es,ax

  mov ax,160
  mul cx
  mov di,bx
  shl di,1
  add di,ax

  mov ax,si

  mov si,0ah     ; 10-zel osztunk
  mov cx,00h     ; vermelt sz mjegyek sz ma

 Nem_nulla :
  mov dx,00h
  div si         ; osztunk
  push dx        ; ez a marad‚k
  inc cx         ; +1 sz mjegy
  cmp ax,00h     ; nem fogyott m‚g el?
  jne Nem_nulla

 Kiiras :
  pop dx
  add dx,30h
  add dx,15*256
  mov es:[di],dx
  inc di
  inc di
  loop Kiiras

  ret

 Write_Number_ ENDP

_CODE ENDS

 END