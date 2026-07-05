.model small
.stack 100h

.data
    cmd db 0, 20, 0 dup('$')
    a db '0'
    b db '0'
    x db '0'
    el db '0'

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
    je  compare

    jmp S

; --- Сравнение a и b ---
compare:
    mov al, [a]
    mov bl, [b]
    cmp al, bl
    je  equal
    mov [x], '0'
    jmp S

equal:
    mov [x], '1'
    jmp S

; --- Графика (синий квадрат) ---
video:
    mov ax, 0x0013
    int 0x10
    mov ax, 0xA000
    mov es, ax
    mov di, 0
    mov cx, 2500
    mov al, 1
    rep stosb
    jmp S

; --- Меню драйверов ---
driver1:
    mov ah, 01h
    int 21h
    cmp [cmd], '1'
    je  input_a

    cmp [cmd], '2'
    je  input_b

    cmp [cmd], '3'
    je  show_result

    jmp S

input_a:
    mov ah, 01h
    int 21h
    mov [a], al
    jmp S

input_b:
    mov ah, 01h
    int 21h
    mov [b], al
    jmp S

show_result:
    mov ah, 01h
    int 21h
    mov [el], al

    cmp [el], 'x'
    je  X

    cmp [el], 'a'
    je  A

    cmp [el], 'b'
    je  B

    jmp S

X:
    mov ah, 09h
    mov dx, offset x
    int 21h
    jmp S

A:
    mov ah, 09h
    mov dx, offset a
    int 21h
    jmp S

B:
    mov ah, 09h
    mov dx, offset b
    int 21h
    jmp S

end S