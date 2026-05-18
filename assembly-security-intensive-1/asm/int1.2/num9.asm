.386
.model flat, stdcall
option casemap:none

include C:\masm32\include\windows.inc
include C:\masm32\include\kernel32.inc
include C:\masm32\include\user32.inc

includelib C:\masm32\lib\kernel32.lib
includelib C:\masm32\lib\user32.lib

.data
    titleText db "Buffer overflow canary", 0

    okText db "Mubarakshina Liza, IKB-34", 13, 10
           db "Canary is not changed.", 13, 10
           db "Buffer is safe.", 0

    failText db "Mubarakshina Liza, IKB-34", 13, 10
             db "Buffer overflow detected!", 13, 10
             db "Canary was changed.", 13, 10
             db "Emergency termination.", 0

    attackText db "THIS_STRING_IS_TOO_LONG", 0

.data?
    localBuffer db 8 dup(?)
    canary dd ?

.code
start:

    mov canary, 0DEADBEEFh

    lea esi, attackText
    lea edi, localBuffer

copy_loop:
    mov al, [esi]
    mov [edi], al

    cmp al, 0
    je check_canary

    inc esi
    inc edi
    jmp copy_loop

check_canary:
    cmp canary, 0DEADBEEFh
    jne overflow_detected

    invoke MessageBoxA, NULL, addr okText, addr titleText, MB_OK
    invoke ExitProcess, 0

overflow_detected:
    invoke MessageBoxA, NULL, addr failText, addr titleText, MB_ICONERROR
    invoke ExitProcess, 1

end start