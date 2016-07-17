;*************************************
;*    Draw.asm by Duncan Frost       *
;*            05/04/2013             *
;*************************************

%include "OPENGL32N.inc"
%include "GLU32N.inc"

extern glViewport
extern glMatrixMode
extern glLoadIdentity
extern gluPerspective

import glViewport opengl32.dll
import glMatrixMode opengl32.dll
import glLoadIdentity opengl32.dll
import gluPerspective glu32.dll

global ResizeGLScene

segment code public use32 class=CODE

;; Resize the OpenGL Scene
;;
;; 2 params width and height

ResizeGLScene:
.width equ 8
.height equ 12
.aspectRatio equ 8 ;Aspect ratio is a qword and takes 8 bytes
  enter .aspectRatio,0 ;Aspect ratio is furthest in stack
  
  ;Adds one to height if 0 to prevent divide by 0 problem
  cmp dword [ebp+.height],0
  jne .heightCheck 
  inc dword [ebp+.height]
 .heightCheck:

  push dword [ebp+.height]
  push dword [ebp+.width]
  push dword 0
  push dword 0
  call [glViewport] ;Change the viewport

  push dword GL_PROJECTION
  call [glMatrixMode]

  call [glLoadIdentity]  
  
  ;Now we need to do a little maths to work out the aspect ratio
  fild dword [ebp+.width]
  fild dword [ebp+.height]
  fdivp st1,st0 ;width/height ? I think...
  fstp qword [ebp-.aspectRatio] ;Store the aspect ratio

  push dword [RGlS_gluFAR+4]
  push dword [RGlS_gluFAR]
  push dword [RGlS_gluNEAR+4]
  push dword [RGlS_gluNEAR] ;Problem area
  push dword [ebp-.aspectRatio+4]
  push dword [ebp-.aspectRatio]
  push dword [RGlS_gluFOV+4]
  push dword [RGlS_gluFOV]
  call [gluPerspective]

  push dword GL_MODELVIEW
  call [glMatrixMode]

  call [glLoadIdentity]
  
  ;As we do not check for errors return true.
  mov dword eax,1
  leave
ret 8;ResizeGLScene 2 dword Params


section .data USE32

;; Doubles that will be used for defineing perspective
RGlS_gluFAR       dq __float64__(100.0) ;Field of view angle
RGlS_gluNEAR      dq __float64__(0.1)   ;Near clipping plane
RGlS_gluFOV       dq 45.0  ;Far clipping plane

