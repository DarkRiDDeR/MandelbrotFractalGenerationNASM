"C:/Program Files (x86)/SASM/NASM/nasm.exe" -i "C:/Program Files (x86)/SASM/include/" -fobj "C:/kr/Main.asm"

"C:/Program Files (x86)/SASM/NASM/nasm.exe" -i "C:/Program Files (x86)/SASM/include/" -fobj "C:/kr/WindowMain.asm"

"C:/Program Files (x86)/SASM/NASM/nasm.exe" -i "C:/Program Files (x86)/SASM/include/" -fobj "C:/kr/InitGL.asm"

"C:/Program Files (x86)/SASM/NASM/nasm.exe" -i "C:/Program Files (x86)/SASM/include/" -fobj "C:/kr/DrawGLScene.asm"

"C:/Program Files (x86)/SASM/NASM/nasm.exe" -i "C:/Program Files (x86)/SASM/include/" -fobj "C:/kr/ResizeGLScene.asm"

"C:/Program Files (x86)/SASM/ALINK/ALINK.EXE" -oPE "C:/kr/Main.obj" "C:/kr/WindowMain.obj" "C:/kr/InitGL.obj" "C:/kr/WindowMain.obj" "C:/kr/DrawGLScene.obj" "C:/kr/ResizeGLScene.obj"


"C:/kr/Main.exe"




