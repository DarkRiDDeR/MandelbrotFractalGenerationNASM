;**************************************************
;*    Draw.asm by DarkRiDDeR (Roman Barinov)      *
;*            19/04/2015                          *
;**************************************************

%include "OPENGL32N.inc"

extern glShadeModel
extern glClearColor
extern glClearDepth
extern glEnable
extern glDepthFunc
extern glHint

import glShadeModel opengl32.dll
import glClearColor opengl32.dll
import glClearDepth opengl32.dll
import glEnable opengl32.dll
import glDepthFunc opengl32.dll
import glHint opengl32.dll

global InitGL

segment code public use32 class=CODE

InitGL:
  push dword GL_SMOOTH
  call [glShadeModel] ;Smooth shader model

  push dword 0 ; alpha        [TEST05]
  push dword 0 ; blue
  push dword 0 ; green
  push dword 0 ; red
  call [glClearColor] ;background color

  push dword [IGl_DEPTH+4] ;1.0
  push dword [IGl_DEPTH]
  call [glClearDepth] ;Depth buffer setup

  push dword GL_DEPTH_TEST
  call [glEnable] ;Enable depth testing

  push dword GL_LEQUAL
  call [glDepthFunc] ;Type of depth test

  push dword GL_NICEST
  push dword GL_PERSPECTIVE_CORRECTION_HINT
  call [glHint] ;Nice calculations. Performance hit to make look better
  
  ;Return true. We didnt check for errors so we assume it worked fine.
  mov dword eax,1
ret ;InitGL



section .data USE32

;; Double for defineing depth buffer
IGl_DEPTH         dq 1.0   ;Depth buffer

