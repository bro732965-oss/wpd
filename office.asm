.model small
.stack 100h

.data
    cmd db 0, 20, 0 dup('$')
    a db '0'
    b db '0'
    x db '0'
    el db '0'
    asd db '0'
    asd1 db '0'
    asd2 db '0'
    asd3 db '0'
    asd4 db '0'
    ask db '0'
    filename db 'data.txt', 0
    handle dw ?

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

    cmp [cmd], '4'
    je  test_menu

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

; --- Меню работы с файлами ---
test_menu:
    mov ah, 01h
    int 21h
    mov [ask], al

    cmp [ask], '0'
    je  file_write

    cmp [ask], '1'
    je  file_read

    cmp [ask], '2'
    je  file_open

    jmp S

; --- Запись в файл ---
file_write:
    mov ah, 01h
    int 21h
    mov [asd], al          ; данные

    mov ah, 01h
    int 21h
    mov [asd1], al         ; длина

    mov ah, 3Ch
    mov cx, 0
    mov dx, offset filename
    int 21h
    mov [handle], ax

    mov ah, 40h
    mov bx, [handle]
    mov cl, [asd1]
    mov ch, 0
    mov dx, offset asd
    int 21h

    mov ah, 3Eh
    mov bx, [handle]
    int 21h
    jmp S

; --- Чтение из файла ---
file_read:
    mov ah, 01h
    int 21h
    mov [asd2], al         ; длина

    mov ah, 01h
    int 21h
    mov [asd3], al         ; куда читать

    mov ah, 3Dh
    mov al, 0
    mov dx, offset filename
    int 21h
    mov [handle], ax

    mov ah, 3Fh
    mov bx, [handle]
    mov cl, [asd2]
    mov ch, 0
    mov dx, offset asd3
    int 21h

    mov ah, 3Eh
    mov bx, [handle]
    int 21h
    jmp S

; --- Открытие файла ---
file_open:
    mov ah, 01h
    int 21h
    mov [asd4], al

    mov ah, 3Dh
    mov al, 0
    mov dx, offset asd4
    int 21h
    mov [handle], ax
    jmp S

end S