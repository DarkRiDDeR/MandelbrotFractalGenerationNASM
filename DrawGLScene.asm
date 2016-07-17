;**************************************************
;*    Draw.asm by DarkRiDDeR (Roman Barinov)      *
;*            19/04/2015                          *
;**************************************************

;Exposes "DrawGLScene" function - this will draw
;gl scene is a Mandelbrot fractal

%include "OPENGL32N.inc"
%include "GLU32N.inc"

extern glClear
extern glLoadIdentity
extern glTranslatef
extern glBegin
extern glVertex2f
extern glColor3f
extern glRotatef
extern glEnd

import glLoadIdentity opengl32.dll
import glClear opengl32.dll
import glTranslatef opengl32.dll
import glBegin opengl32.dll
import glVertex2f opengl32.dll
import glColor3f opengl32.dll
import glRotatef opengl32.dll
import glEnd opengl32.dll

global DrawGLScene

segment code public use32 class=CODE

;DrawGLScene This is the part which actually specifies what is being drawn.
;
;In future this will probably be moved to a seperate file to make it a bit 
;easier to follow.

    section .bss use32
    iter resd 1
    Y resd 1
    X resd 1
    y resd 1
    x resd 1
    red resd 1
    green resd 1
    blue resd 1
    koefColor resd 1
    temp resd 1
    ;CONTROL_WORD resw 1 ; настройки регистров сопроцессора
    ;CONTROL_TEMP resw 1 ; временные настройки регистров сопроцессора
    
    section .data use32
    position dd -6.0,0.0,0.0
    maxCoord dd 4.0
    maxY dd 2.0
    maxX dd 2.0
    step dd 0.005
    startY dd -4.0
    startX dd -2.4
    maxIter dd 100
    koefY dd 2.0
    stepColor dd 5.0, 1.0, 1.0 ; 0.1563, 0.3126, 0.4689
    
    
    DrawGLScene:
      push dword GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT
      call [glClear] ;Очистка screen и depth
      call [glLoadIdentity] ;Сброс матрицы видов (modelview matrix)
      
      push dword [position]
      push dword [position+4]
      push dword [position+8]
      call [glTranslatef] ; позиция
    
      push dword GL_QUADS
      call [glBegin]
        
        mov dword  eax, [startY]
        mov dword [y], eax
        .for1:
            finit ; очистка сопроцессора
            fld dword [maxY]
            fld dword [y]
            fcompp
            fstsw ax
            sahf
            jae .endfor1
       
            mov dword  eax, [startX]
            mov dword [x], eax
            .for2:
                fld dword [maxX]
                fld dword [x]
                fcompp
                fstsw ax
                sahf
                jae .endfor2
                xor eax, eax ; обнуляем переменные
                mov [X], eax
                mov [Y], eax    
                mov [iter], eax
            
                mov ecx, [iter]
                .while: ; цикл
                    cmp ecx, [maxIter] ; 2 условие
                    jae .endWhileNotDraw
                    fld dword [maxCoord] ; 1 условие
                    fld dword [X]
                    fmul dword [X]
                    fld dword [Y]
                    fmul dword [Y]
                    faddp
                    fcompp
                    fstsw ax
                    sahf
                    jae .endWhileDraw
                    
                    fld dword [X]
                    fmul dword [X]
                    fld dword [Y]
                    fmul dword [Y]
                    fsubp
                    fadd dword [x]
                    fstp dword [temp] ; вычислили temp = X*X - Y*Y + x
                    fld dword [X]
                    fmul dword [koefY]
                    fmul dword [Y]
                    fadd dword [y]
                    fstp dword [Y] ; вычислили Y = 2*X*Y + y
                    mov eax, [temp]
                    mov [X], eax ; X = temp
                    
                    add  ecx, 1
                    jmp .while
                .endWhileDraw:
                mov [iter], ecx
                
                ; вычисляем цвета и вычисляем координаты, ну и рисуем
                ; модификация модуля округления
                ;fstcw [CONTROL_WORD]
                ;mov ax, [CONTROL_WORD]
                ;or ah, 0b00000100   ; Set RC=1: округление к отриц. бесконечности
                ;mov [CONTROL_TEMP], ax
                ;fldcw [CONTROL_TEMP]   ; Загружаем новые настройки регистров
                
                fld dword [iter]
                fdiv dword [maxIter]
                fstp dword [koefColor]
                
                fld dword [stepColor]
                fmul dword [koefColor]
                fstp dword [blue] ; blue
                fld dword [stepColor+4]
                fmul dword [koefColor]
                fstp dword [green] ; green
                fld dword [stepColor+8]
                fmul dword [koefColor]
                fstp dword [red] ; red
                
                push dword [blue] ; [blue]
                push dword [green] ; [green]
                push dword [red] ; [red]
                call [glColor3f]
                push dword [y]
                push dword [x]
                call [glVertex2f] ; 1 вершина
                push dword [y]
                fld dword [x]
                fadd dword [step]
                fstp dword [temp]
                push dword [temp]
                call [glVertex2f] ; 2 вершина
                fld dword [y]
                fadd dword [step]
                fstp dword [temp]
                push dword [temp]
                fld dword [x]
                fadd dword [step]
                fstp dword [temp]
                push dword [temp]
                call [glVertex2f] ; 3 вершина
                fld dword [y]
                fadd dword [step]
                fstp dword [temp]
                push dword [temp]
                push dword [x]
                call [glVertex2f] ; 4 вершина
                
                .endWhileNotDraw:
                
                ;fldcw [CONTROL_TEMP] ; возвращаем стандартные флаги модуля округления
                fld dword [x] ; шаг 1-ого цикла
                fadd dword [step]
                fstp dword [x]
                jmp .for2
            .endfor2:
            fld dword [y] ; шаг 2-ого цикла
            fadd dword [step]
            fstp dword [y]
            jmp .for1
        .endfor1:
         call [glEnd]
    
    
      mov dword eax,1
      
    ret ;DrawGLScene