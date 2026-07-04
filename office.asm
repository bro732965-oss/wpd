.model small
.stack 100h

.data
    cmd db 0, 20, 0 dup('$')
    a1 db '0'
    a2 db '0'
    a3 db '1'
    a4 db '0'
    box db '0'
    msg_ok db 'Тест завершён!$'

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

; --- test: запуск всех команд по очереди ---
test:
    ; Шаг 1: запускаем driver1 (ввод)
    call driver1

    ; Шаг 2: запускаем driver2 (графика)
    call driver2

    ; Шаг 3: запускаем driver3 (звук)
    call driver3

    ; Шаг 4: запускаем driver4 (вывод)
    call driver4

    ; Шаг 5: выводим сообщение
    mov ah, 09h
    mov dx, offset msg_ok
    int 21h

    jmp A

end start