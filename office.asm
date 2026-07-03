.model small
.stack 100h

.data
    a db 20, 0, 20 dup('$')
    box db 0
    box1 db 0
    com1 db 0
    com2 db 0
    drv db 0           
    Flag db 0
    msg1 db 'Driver 1$'
    msg2 db 'Driver 2$'
    err_msg db 'none$'
    
    ; Данные для файла
    filename db 'file.txt', 0
    buffer db 0, 0, 0   ; место для Flag, drv, box
    handle dw ?

.code
sp1:
    mov ax, @data
    mov ds, ax

    mov ah, 01h
    int 21h
    mov [a], al

    cmp [a], '1'
    je  driver

    cmp [a], '2'
    je  driver2

    cmp [a], '3'
    je  read

    cmp [a], '4'
    je  com

    cmp [a], '5'
    je  flag

    cmp [a], '6'        ; ← добавлена команда export
    je  export

    mov ah, 09h
    mov dx, offset err_msg
    int 21h
    jmp sp1

driver:
    mov ah, 01h
    int 21h
    mov [box], al
    mov ax, [box]
    jmp sp1

driver2:
    mov ah, 01h
    int 21h
    mov [box1], al
    mov bx, [box1]
    jmp sp1

read:
    mov bx, @data
    jmp sp1

com:
    mov ah, 01h
    int 21h
    mov [com1], al

    mov ah, 01h
    int 21h
    mov [com2], al

    mov al, [com1]
    mov bl, [com2]
    cmp al, bl

    je  equal
    mov [drv], 0     
    jmp sp1

equal:
    mov [drv], 1        
    jmp sp1

flag:
    mov ax, @data       
    mov [Flag], al        
    jmp sp1

export:
    ; Копируем данные в буфер
    mov al, [Flag]
    mov [buffer], al
    mov al, [drv]
    mov [buffer + 1], al
    mov al, [box]
    mov [buffer + 2], al

    ; Создаём файл
    mov ah, 3Ch
    mov cx, 0
    mov dx, offset filename
    int 21h
    mov [handle], ax

    ; Записываем в файл
    mov ah, 40h
    mov bx, [handle]
    mov cx, 3
    mov dx, offset buffer
    int 21h

    ; Закрываем файл
    mov ah, 3Eh
    mov bx, [handle]
    int 21h

    jmp sp1

end sp1