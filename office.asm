.model small
.stack 100h

.data
    b db 20, 0, 20 dup('$')

.code
start:
    mov ax, @data
    mov ds, ax

    mov ah, 01h
    int 21h
    mov [b], al

    mov ax, [b]

    mov ax, 4C00h
    int 21h

end start