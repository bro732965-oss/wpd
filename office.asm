.model small
.stack 100h

.data
    ask_msg db 'Введи команду (1, 2, 3): $'
    err_msg db 'Неизвестная команда$'
    cmd db 0
    buffer db 20, 0, 20 dup('$')

.code
start:
    mov ax, @data
    mov ds, ax

    ; --- Вывод вопроса ---
    mov ah, 09h
    mov dx, offset ask_msg
    int 21h

    ; --- Ввод символа ---
    mov ah, 01h
    int 21h
    mov [cmd], al

    ; --- Сравнение и переход ---
    cmp [cmd], '1'
    je  driver1
    cmp [cmd], '2'
    je  driver2
    cmp [cmd], '3'
    je  driver3
    jmp unknown

driver1:
    mov ah, 09h
    mov dx, offset msg1
    int 21h
    jmp exit

driver2:
    mov ah, 09h
    mov dx, offset msg2
    int 21h
    jmp exit

driver3:
    mov ah, 09h
    mov dx, offset msg3
    int 21h
    jmp exit

unknown:
    mov ah, 09h
    mov dx, offset err_msg
    int 21h

exit:
    mov ax, 4C00h
    int 21h

.data
msg1 db 'Драйвер 1 (создание)$'
msg2 db 'Драйвер 2 (открытие)$'
msg3 db 'Драйвер 3 (удаление)$'

end start