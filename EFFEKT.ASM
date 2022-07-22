;/**************************************************************************\
;*                                                                          *
;*                     Rutinok a "Bombázó" c.programhoz                     *
;*                                                                          *
;*                                  Írta :                                  *
;*                                                                          *
;*                               Török Viktor                               *
;*                                                                          *
;*                            ANNO DOMINI MCMXCVI                           *
;*                                                                          *
;\**************************************************************************/

CODE_SEG SEGMENT

 ASSUME CS : CODE_SEG

 EXTRN Randomize : PROC, Random : PROC

;********************************
; A képernyő rázása
;********************************

 PUBLIC Razas

 Razas PROC

  push ax
  push cx
  push dx

  call Randomize

  mov cx,70

 @Razas_eleje :

  mov dx,03d4h
  mov al,8
  out dx,al

  call Random
  and ax,15
  mov dx,03d5h
  out dx,al

  mov dx,03dah
  in al,dx

  mov dx,03c0h
  mov al,13h
  out dx,al

  call Random
  and al,7
  inc al
  out dx,al

  mov al,20h
  out dx,al

  mov dx,10000

 @IW :
  dec dx
  jne @IW

  mov dx,03dah

 @RW :
  in al,dx
  and al,8
  cmp al,8
  jne @RW

  loop @Razas_eleje

  mov dx,03d4h
  mov al,8
  out dx,al
  inc dx
  mov al,0
  out dx,al

  mov dx,03c0h
  mov al,13h
  out dx,al
  mov al,8
  out dx,al

  mov al,20h
  out dx,al

  pop dx
  pop cx
  pop ax

  ret

 Razas ENDP

CODE_SEG ENDS

 END
