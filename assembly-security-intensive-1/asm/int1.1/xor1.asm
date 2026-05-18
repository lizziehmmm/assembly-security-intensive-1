.386
.model flat, stdcall
option casemap:none

include C:\masm32\include\windows.inc
include C:\masm32\include\kernel32.inc
include C:\masm32\include\user32.inc

includelib C:\masm32\lib\kernel32.lib
includelib C:\masm32\lib\user32.lib

.data
    titleText db "XOR string encryption", 0

    sourceStr db "HELLO ASM WORLD", 0

    key db 5Ah

fmtText db "Mubarakshina Liza, IKB-34", 13, 10
            db "XOR string encryption", 13, 10, 13, 10
            db "Original string:", 13, 10
            db "%s", 13, 10, 13, 10
            db "Encrypted string:", 13, 10
            db "%s", 13, 10, 13, 10
            db "Decrypted string:", 13, 10
            db "%s", 0

.data?
    encrypted db 256 dup(?)
    decrypted db 256 dup(?)
    buffer db 1024 dup(?)

.code
start:

    lea esi, sourceStr
    lea edi, encrypted

encrypt_loop:
    mov al, [esi]

    cmp al, 0
    je encrypt_done

    xor al, key

    mov [edi], al

    inc esi
    inc edi

    jmp encrypt_loop

encrypt_done:
    mov byte ptr [edi], 0

    lea esi, encrypted
    lea edi, decrypted

decrypt_loop:
    mov al, [esi]

    cmp al, 0
    je decrypt_done

    xor al, key

    mov [edi], al

    inc esi
    inc edi

    jmp decrypt_loop

decrypt_done:
    mov byte ptr [edi], 0

    invoke wsprintfA,\
        addr buffer,\
        addr fmtText,\
        addr sourceStr,\
        addr encrypted,\
        addr decrypted

    invoke MessageBoxA,\
        NULL,\
        addr buffer,\
        addr titleText,\
        MB_OK

    invoke ExitProcess, 0

end start