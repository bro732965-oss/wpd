.model small
.stack 100h

.data
    cmd db 0, 20, 0 dup('$')
    a db '0'
    b db '0'
    b1 db '0'
    b2 db '0'
    x db '0'
    ab db 'off'
    b3 db '0'
    d1 db 0
    d2 db 0

.code
S:
    mov ax, @data
    mov ds, ax

    mov ah, 01h
    int 21h
    mov [cmd], al

    cmp [cmd], '1'
    je  driver1

    cmp [cmd], '2'
    je  video

    cmp [cmd], '3'
    je  ab4

    jmp S

ab4:
    cmp bx, cx
    mov [x], al
    jmp S

video:
    mov ax, 0x0013
    int 0x10
    mov ax, 0xA000
    mov es, ax
    jmp S

driver1:
    mov ah, 01h
    int 21h
    cmp [cmd], '1'
    je  ab1
    cmp [cmd], '2'
    je  ab2
    cmp [cmd], '3'
    je  ab3
    jmp S

ab1:
    mov ah, 01h
    int 21h
    mov [a], al
    mov bx, [a]
    jmp S

ab2:
    mov ah, 01h
    int 21h
    mov [b], al
    mov cx, [b]
    jmp S

ab3:
    mov ah, 01h
    int 21h
    mov [b], al
    jmp S