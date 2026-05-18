.386
.model flat, stdcall
option casemap:none

include C:\masm32\include\windows.inc
include C:\masm32\include\kernel32.inc
include C:\masm32\include\user32.inc

includelib C:\masm32\lib\kernel32.lib
includelib C:\masm32\lib\user32.lib

STD_INPUT_HANDLE equ -10
STD_OUTPUT_HANDLE equ -11

.data
    author db "Mubarakshina Liza, IKB-34", 13, 10, 0
    askText db "Enter password:", 13, 10, 0
    okText db 13, 10, "Password is correct.", 13, 10, 0
    failText db 13, 10, "Password is incorrect.", 13, 10, 0
    exitText db 13, 10, "Press Enter to exit...", 0

    salt db "LIZA34", 0
    etalonHash dd 42F7E641h

.data?
    hInput dd ?
    hOutput dd ?
    written dd ?
    readed dd ?
    inputBuffer db 256 dup(?)
    waitBuffer db 8 dup(?)

.code

WriteText proc pText:DWORD
    push esi
    mov esi, pText

count_loop:
    cmp byte ptr [esi], 0
    je count_done
    inc esi
    jmp count_loop

count_done:
    sub esi, pText
    invoke WriteConsoleA, hOutput, pText, esi, addr written, NULL
    pop esi
    ret
WriteText endp

HashString proc pText:DWORD
    push esi
    xor eax, eax
    mov esi, pText

hash_loop:
    mov dl, [esi]
    cmp dl, 0
    je hash_done
    cmp dl, 13
    je hash_done
    cmp dl, 10
    je hash_done

    movzx edx, dl
    add eax, edx
    rol eax, 5
    xor eax, 0A5A5A5A5h

    inc esi
    jmp hash_loop

hash_done:
    pop esi
    ret
HashString endp

HashSalt proc
    push esi
    mov esi, offset salt

salt_loop:
    mov dl, [esi]
    cmp dl, 0
    je salt_done

    movzx edx, dl
    add eax, edx
    rol eax, 5
    xor eax, 0A5A5A5A5h

    inc esi
    jmp salt_loop

salt_done:
    pop esi
    ret
HashSalt endp

start:

    invoke AllocConsole

    invoke GetStdHandle, STD_INPUT_HANDLE
    mov hInput, eax

    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov hOutput, eax

    invoke WriteText, addr author
    invoke WriteText, addr askText

    invoke ReadConsoleA, hInput, addr inputBuffer, 255, addr readed, NULL

    invoke HashString, addr inputBuffer
    call HashSalt

    cmp eax, etalonHash
    je password_ok

password_fail:
    invoke WriteText, addr failText
    jmp finish

password_ok:
    invoke WriteText, addr okText

finish:
    invoke WriteText, addr exitText
    invoke ReadConsoleA, hInput, addr waitBuffer, 7, addr readed, NULL
    invoke ExitProcess, 0

end start