.model small
.stack 100h

.data
    cmd db 20, 0, 20 dup('$')
    bird db 20, 0, 20 dup('$')
    runs db 20, 0, 20 dup('$')
    runing db 20 dup('$'), 0    ; ← изменено
    brick db 0
    ask db 0
    name db 20, 0, 20 dup('$')
    filename db 'test.txt', 0
    text db 20, 0, 20 dup('$')
    len db 0
    handle dw ?
    pl db 0
    pi db 0
    col db 0
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
    cmp [cmd], 'b'
    je  pos
    cmp [cmd], 'c'
    je  g
    cmp [cmd], 't'
    je  on
    cmp [cmd], 'o'
    je  rauning
    cmp [cmd], 'n'              ; ← добавлено
    je  rename                  ; ← добавлено

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

; ... (остальные команды без изменений) ...

rauning:
    mov ah, 01h
    int 21h
    mov [runing], al
    jmp s1

; --- Новая команда rename ---
rename:                         ; ← добавлено
    mov ah, 0Ah
    mov dx, offset runs
    int 21h

    mov si, offset runs + 2
    mov di, offset runing
copy_loop:
    mov al, [si]
    mov [di], al
    inc si
    inc di
    cmp al, 13
    jne copy_loop

    jmp s1

end s1