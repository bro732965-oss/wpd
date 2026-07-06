.model small
.stack 100h

.data
    butter db 1000 dup('$')    ; Буфер
    List db '0'                ; Текущий символ
    model db 'hi'              ; Модель
    pos dw 0                   ; Позиция в буфере

.code
c:
    mov ah, 01h
    int 21h
    mov model, al
    cmp model, '{'
    je mode
    jmp c

mode:
    mov ah, 01h
    int 21h
    mov List, al
    
    ; Это вместо add butter, List (сохраняем в буфер)
    mov si, offset butter
    add si, pos
    mov [si], List
    inc pos
    
    cmp List, '}'
    je c
    jmp mode

end c