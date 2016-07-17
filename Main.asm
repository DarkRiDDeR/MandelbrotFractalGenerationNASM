;*************************************
;*    Draw.asm by Duncan Frost       *
;*            05/04/2013             *
;*************************************

%include "WIN32N.inc"
extern GetModuleHandleA 
extern GetCommandLineA 
extern ExitProcess 

extern WindowMain

;; Import the Win32 API functions. 
import GetModuleHandleA kernel32.dll 
import GetCommandLineA kernel32.dll 
import ExitProcess kernel32.dll 

segment code public use32 class=CODE

;; In order to make this code as similar as possible to NeHe's OpenGL tutorial
;; we will first get all of the params of WinMain and call the WinMain function
;; if we were going for as small a program as possible this could be done all in
;; the WinMain function.

;; Entry point of program
..start: 
push dword 0 
;; GetModuleHandleA returns handle to the file used to create this proc when null (0) is param
call [GetModuleHandleA] 

;;Store the result in the ebx reg.
mov ebx, eax 

;; Returns a pointer to the command line arguments. If we are not using commandline params this is
;; not requried.
call [GetCommandLineA] 
;;Since we only use this to send to WinMain there is no point saving it to a variable

;; For the sake of making things look like a normal C prog we have a winmain func
;; this will be passed all the normal winmain params (i.e. handle to instance, previous instance,
;; commandline params, show param).
push dword SW_SHOWDEFAULT 
push eax   ;;push pointer to command line arguments 
;; And a NULL 
push dword 0 
;; Then the hInstance variable. 
push ebx 

;; And we make a call to WindowMain(). See below.
call WindowMain 

;; The program should be complete now push the result of our prog and exit.
push eax 
call [ExitProcess] 
;; Exit Point of our program