.386
.model flat, stdcall
option casemap:none

include C:\masm32\include\windows.inc
include C:\masm32\include\kernel32.inc
include C:\masm32\include\user32.inc

includelib C:\masm32\lib\kernel32.lib
includelib C:\masm32\lib\user32.lib

.data
    titleText db "RSA signature demo", 0

    fmtText db "Mubarakshina Liza, IKB-34", 13, 10
            db "RSA-like digital signature", 13, 10, 13, 10
            db "Message m = %d", 13, 10
            db "Private exponent d = %d", 13, 10
            db "Modulus n = %d", 13, 10, 13, 10
            db "Signature = m^d mod n", 13, 10
            db "Signature = %d", 0

    mValue dd 12
    dValue dd 7
    nValue dd 33

.data?
    buffer db 512 dup(?)
    signature dd ?

.code
start:

    mov eax, 1
    mov ecx, dValue

power_loop:
    cmp ecx, 0
    je power_done

    imul eax, mValue

    xor edx, edx
    div nValue

    mov eax, edx

    dec ecx
    jmp power_loop

power_done:
    mov signature, eax

    invoke wsprintfA, addr buffer, addr fmtText, mValue, dValue, nValue, signature
    invoke MessageBoxA, NULL, addr buffer, addr titleText, MB_OK

    invoke ExitProcess, 0

end start