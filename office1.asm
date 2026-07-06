.model small
.stack 200h

.data
    cmd db 0, 20, 0 dup('$')   ; буфер для ввода
    a db '0'                   ; переменная a
    b db '0'                   ; переменная b
    x db '0'                   ; переменная для результата
    msg_ok db '[OK]$'
    msg_err db '[ERR]$'

.code
start:
    mov ax, @data
    mov ds, ax

main:
    ; Вывод приглашения
    mov ah, 09h
    mov dx, offset msg_ok
    int 21h

    ; --- Ввод строки (до 20 символов) ---
    mov ah, 0Ah
    mov dx, offset cmd
    int 21h

    ; --- Сравниваем ПЕРВЫЙ символ введённой строки ---
    ; (cmd+2) — это начало введённого текста
    mov al, [cmd + 2]   ; берём первую букву команды

    cmp al, '1'
    je  cmd_input_a

    cmp al, '2'
    je  cmd_input_b

    cmp al, '3'
    je  cmd_compare

    cmp al, '4'
    je  cmd_video

    cmp al, 'q'
    je  exit

    jmp main

; --- 1. Ввод переменной a ---
cmd_input_a:
    mov ah, 09h
    mov dx, offset msg_ok
    int 21h

    mov ah, 01h
    int 21h
    mov [a], al
    jmp main

; --- 2. Ввод переменной b ---
cmd_input_b:
    mov ah, 09h
    mov dx, offset msg_ok
    int 21h

    mov ah, 01h
    int 21h
    mov [b], al
    jmp main

; --- 3. Сравнение a и b ---
cmd_compare:
    mov al, [a]
    mov bl, [b]
    cmp al, bl
    je  .equal
    mov [x], '0'
    jmp .show_result
.equal:
    mov [x], '1'
.show_result:
    mov ah, 09h
    mov dx, offset msg_ok
    int 21h

    mov dl, [x]
    add dl, '0'
    mov ah, 02h
    int 21h
    jmp main

; --- 4. Графика (синий квадрат) ---
cmd_video:
    mov ax, 0x0013
    int 0x10
    mov ax, 0xA000
    mov es, ax
    mov di, 0
    mov cx, 2500
    mov al, 1
    rep stosb
    jmp main

exit:
    mov ax, 4C00h
    int 21h

end start