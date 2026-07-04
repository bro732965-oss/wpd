.model small
.stack 100h

.data
    cmd db 0, 20, 0 dup('$')
    a1 db '0'
    a2 db '0'
    a3 db '1'
    a4 db '0'
    box db '0'
    msg_ok db '[ok]$'
    filename db 'save.dat', 0
    handle dw ?
    buffer db 4 dup('$')

.code
start:
    mov ax, @data
    mov ds, ax

A:
    mov ah, 01h
    int 21h
    mov [cmd], al

    cmp [cmd], '1'
    je  driver1

    cmp [cmd], '2'
    je  driver2

    cmp [cmd], '3'
    je  driver3

    cmp [cmd], '4'
    je  driver4

    cmp [cmd], '5'
    je  export_data

    cmp [cmd], '6'
    je  import_data

    cmp [cmd], 't'
    je  test

    jmp A

; --- driver1: ввод данных ---
driver1:
    mov ah, 01h
    int 21h
    mov [a1], al
    jmp A

; --- driver2: графика (синий квадрат) ---
driver2:
    mov ax, 0x0013
    int 0x10
    mov ax, 0xA000
    mov es, ax
    mov di, 0
    mov cx, 2500
    mov al, 1
    rep stosb
    mov ah, 0x00
    int 0x16
    jmp A

; --- driver3: звук (beep) ---
driver3:
    mov al, 0B6h
    out 43h, al
    mov ax, 4560
    out 42h, al
    mov al, ah
    out 42h, al
    in al, 61h
    or al, 00000011b
    out 61h, al
    mov cx, 1000
delay:
    loop delay
    in al, 61h
    and al, 11111100b
    out 61h, al
    jmp A

; --- driver4: вывод ---
driver4:
    mov ah, 09h
    mov dx, offset a1
    int 21h
    jmp A

; --- export: сохранение данных в файл ---
export_data:
    ; Собираем данные в буфер
    mov al, [a1]
    mov [buffer], al
    mov al, [a2]
    mov [buffer+1], al
    mov al, [a3]
    mov [buffer+2], al
    mov al, [a4]
    mov [buffer+3], al

    ; Создаём файл
    mov ah, 3Ch
    mov cx, 0
    mov dx, offset filename
    int 21h
    mov [handle], ax

    ; Записываем данные
    mov ah, 40h
    mov bx, [handle]
    mov cx, 4
    mov dx, offset buffer
    int 21h

    ; Закрываем файл
    mov ah, 3Eh
    mov bx, [handle]
    int 21h

    jmp A

; --- import: загрузка данных из файла ---
import_data:
    ; Открываем файл
    mov ah, 3Dh
    mov al, 0
    mov dx, offset filename
    int 21h
    mov [handle], ax

    ; Читаем данные
    mov ah, 3Fh
    mov bx, [handle]
    mov cx, 4
    mov dx, offset buffer
    int 21h

    ; Закрываем файл
    mov ah, 3Eh
    mov bx, [handle]
    int 21h

    ; Загружаем данные из буфера в переменные
    mov al, [buffer]
    mov [a1], al
    mov al, [buffer+1]
    mov [a2], al
    mov al, [buffer+2]
    mov [a3], al
    mov al, [buffer+3]
    mov [a4], al

    jmp A

; --- test: запуск всех команд по очереди ---
test:
    call driver1
    call driver2
    call driver3
    call driver4
    mov ah, 09h
    mov dx, offset msg_ok
    int 21h
    jmp A

end start