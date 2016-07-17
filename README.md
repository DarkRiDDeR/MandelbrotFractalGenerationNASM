Fractal generation of the Mandelbrotin in NASM. The project is based on http://github.com/duncanspumpkin/NeHeNASM

In order to compile these you will need NASM and ALINK at least or someother linker. To compile I use the following in a batch script.

The build example on OS Windows:

"./NASM/nasm.exe" -i "./include/" -fobj "./Main.asm"
"./NASM/nasm.exe" -i "./include/" -fobj "./WindowMain.asm"
"./NASM/nasm.exe" -i "./include/" -fobj "./InitGL.asm"
"./NASM/nasm.exe" -i "./include/" -fobj "./DrawGLScene.asm"
"./NASM/nasm.exe" -i "./include/" -fobj "./ResizeGLScene.asm"

"./ALINK/ALINK.EXE" -oPE "C:/kr/Main.obj" "./WindowMain.obj" "./InitGL.obj" "./WindowMain.obj" "./DrawGLScene.obj" "./ResizeGLScene.obj"

"./Main.exe"



