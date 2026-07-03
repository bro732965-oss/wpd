.model small
.stack 100h

.data
    cmd db 20, 0, 20 dup('$')
    bird db 20, 0, 20 dup('$')
    runs db 20, 0, 20 dup('$')
    runing db 'program.exe', 0
    brick db 0
    ask db 0
    name db 20, 0, 20 dup('$')
    filename db 'test.txt', 0
    text db 20, 0, 20 dup('$')
    len db 0
    handle dw ?
    msg1 db 'Message 1$'
    msg2 db 'Message 2$'
    msg3 db 'Message 3$'
    err_msg db 'none$'

.code
s1:
    mov ax, @data
    mov ds, ax

    mov ah, 01h
    int 21h
    mov [cmd], al

    cmp [cmd], '1'
    je  driver1

    cmp [cmd], '2'
    je  run

    cmp [cmd], '3'
    je  msgs1

    cmp [cmd], '4'
    je  msgs2

    cmp [cmd], '5'
    je  msgs3

    cmp [cmd], '6'
    je  read

    cmp [cmd], '7'
    je  as

    cmp [cmd], '8'
    je  w

    cmp [cmd], '9'
    je  r

    cmp [cmd], 'a'
    je  rec

    ; Если ни одна не подошла
    mov ah, 09h
    mov dx, offset err_msg
    int 21h
    jmp s1

driver1:
    mov ah, 09h
    mov dx, offset msg1
    int 21h
    jmp s1

run:
    mov ah, 4Bh
    mov al, 0
    mov dx, offset runing
    int 21h
    jmp s1

msgs1:
    mov ah, 09h
    mov dx, offset msg1
    int 21h
    jmp s1

msgs2:
    mov ah, 09h
    mov dx, offset msg2
    int 21h
    jmp s1

msgs3:
    mov ah, 09h
    mov dx, offset msg3
    int 21h
    jmp s1

as:
    mov ah, 01h
    int 21h
    mov [brick], al
    jmp s1

read:
    mov ah, 09h
    mov dx, offset brick
    int 21h
    jmp s1

; --- Создание файла ---
r:
    mov ah, 3Ch
    mov cx, 0
    mov dx, offset filename
    int 21h
    mov [handle], ax
    jmp s1

; --- Запись в файл ---
w:
    mov ah, 40h
    mov bx, [handle]
    mov cx, 10
    mov dx, offset text
    int 21h
    jmp s1

; --- Чтение файла ---
rec:
    mov ah, 3Fh
    mov bx, [handle]
    mov cx, 10
    mov dx, offset text
    int 21h
    jmp s1

end s1