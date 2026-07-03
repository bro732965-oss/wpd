.model small
.stack 100h

.data
    cmd db 0, 20, 0 dup('$')
    a db '0'
    b db '0'
    x db '0'
    filename db 'save.txt', 0
    handle dw ?

.code
s:
    mov ah, 01h
    int 21h
    mov [cmd], al

    cmp [cmd], '1'
    je  driver1

    cmp [cmd], '2'
    je  driver2

    cmp [cmd], '3'
    je  sim

    cmp [cmd], '4'
    je  sim1

    cmp [cmd], '5'
    je  brick

    jmp s

driver1:
    mov ah, 01h
    int 21h
    mov [a], al
    jmp s

driver2:
    mov ah, 01h
    int 21h
    mov [b], al
    jmp s

sim:
    ; Сравнение a и b
    mov al, [a]
    mov bl, [b]
    cmp al, bl
    je  equal
    mov [x], '0'
    jmp s
equal:
    mov [x], '1'
    jmp s

sim1:
    ; Сложение a + b (как символы)
    mov al, [a]
    add al, [b]
    sub al, '0'
    mov [x], al
    jmp s

brick:
    ; Сохраняем данные в файл
    mov ah, 3Ch
    mov cx, 0
    mov dx, offset filename
    int 21h
    mov [handle], ax

    ; Записываем данные
    mov ah, 40h
    mov bx, [handle]
    mov cx, 3
    mov dx, offset a
    int 21h

    mov ah, 3Eh
    mov bx, [handle]
    int 21h

    jmp s

end s