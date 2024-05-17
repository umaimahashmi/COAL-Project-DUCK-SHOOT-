.model small
.stack 100h

.data
;little duck
little_duck    db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
        db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
        db 00,00,00,00,00,00,14,14,14,00,00,00,00,00,00,00,00,00,00
        db 00,00,04,00,00,14,14,14,14,14,00,00,00,00,00,00,00,00,00
        db 00,00,04,04,04,14,00,00,14,14,00,00,00,00,00,00,14,14,00
        db 00,00,04,04,04,14,00,00,14,14,00,00,00,00,00,14,14,14,00
        db 00,00,00,04,04,14,14,14,14,14,14,14,14,14,14,14,14,14,00
        db 00,00,00,00,00,14,14,14,14,14,14,14,14,14,14,14,14,14,00
        db 00,00,00,00,00,00,14,14,14,14,14,14,14,14,14,14,14,14,00
        db 00,00,00,00,00,14,14,14,14,14,14,14,14,14,14,14,14,14,00
        db 00,00,00,00,14,14,14,14,14,14,14,14,14,14,14,14,14,00,00
        db 00,00,00,00,14,14,14,14,14,14,14,14,14,14,14,14,00,00,00
        db 00,00,00,00,14,14,14,14,14,14,14,14,14,14,14,00,00,00,00
        db 00,00,00,00,14,14,14,14,14,14,14,14,14,14,00,00,00,00,00
        db 00,00,00,00,00,14,14,14,00,00,00,00,00,00,00,00,00,00,00

cursor  db 04,04,04,04,04,04,04,04,04,04
        db 04,04,04,04,04,04,04,04,04,04
        db 04,04,04,04,04,04,04,04,04,04
        db 04,04,04,04,04,04,04,04,04,04
        db 04,04,04,04,04,04,04,04,04,04
        db 04,04,04,04,04,04,04,04,04,04
        db 04,04,04,04,04,04,04,04,04,04
        db 04,04,04,04,04,04,04,04,04,04
        db 04,04,04,04,04,04,04,04,04,04
        db 04,04,04,04,04,04,04,04,04,04
        db 04,04,04,04,04,04,04,04,04,04

xi dw 0
xf dw 0
yi dw 0
yf dw 0

duck_movement_xi dw 60 ; Initial X position of the duck
duck_movement_xf dw 75 ; Final X position of the duck
duck_movement_yi dw 150 ; Initial Y position of the duck
duck_movement_yf dw 169 ; Final Y position of the duck


cursor_movement_xi dw 150 ; Initial X position of the duck
cursor_movement_xf dw 160 ; Final X position of the duck
cursor_movement_yi dw 75 ; Initial Y position of the duck
cursor_movement_yf dw 85 ; Final Y position of the duck

.code
; Draw little duck
draw_little_duck2 proc
    mov si, offset little_duck
    mov ax, duck_movement_yi ; Start row
    mov xi, ax
    mov ax, duck_movement_yf ; End row
    mov xf, ax
    mov ax, duck_movement_xi ; Start column
    mov yi, ax
    mov ax, duck_movement_xf ; End column
    mov yf, ax
    mov ah, 0ch ; Function for plotting pixels
    mov dx, yi ; Y coordinate initial (up down)
y34:
    mov cx, xi ; X coordinate initial (left right)
x34:
    mov al, [si] ; Get character from little duck ASCII art
    int 10h ; Plot pixel
    inc si ; Move to next character in the art (right in the row)
    inc cx ; Move to the next column
    cmp cx, xf ; Compare current column to end column
    jb x34 ; Jump back if not yet reached the end of the row
    inc dx ; Move to the next row
    cmp dx, yf ; Compare current row to end row
    jb y34 ; Jump back if not yet reached the end of the art
    ret
draw_little_duck2 endp
; Draw the cursor
draw_cursor proc
    mov si, offset cursor
    mov ax, cursor_movement_yi ; Start row
    mov xi, ax
    mov ax, cursor_movement_yf ; End row
    mov xf, ax
    mov ax, cursor_movement_xi ; Start column
    mov yi, ax
    mov ax, cursor_movement_xf ; End column
    mov yf, ax
    mov ah, 0ch ; Function for plotting pixels
    mov dx, yi ; Y coordinate initial (up down)
y35:
    mov cx, xi ; X coordinate initial (left right)
x35:
    mov al, [si] ; Get character from little duck ASCII art
    int 10h ; Plot pixel
    inc si ; Move to next character in the art (right in the row)
    inc cx ; Move to the next column
    cmp cx, xf ; Compare current column to end column
    jb x35 ; Jump back if not yet reached the end of the row
    inc dx ; Move to the next row
    cmp dx, yf ; Compare current row to end row
    jb y35 ; Jump back if not yet reached the end of the art
    ret
draw_cursor endp

move_duck proc
    add duck_movement_xi, 3
    add duck_movement_xf, 3
    add duck_movement_yi, 3
    add duck_movement_yf, 3

    ret
move_duck endp


; Function to reset the screen
RESET_THE_SCREEN PROC
    MOV AH, 0
    MOV AL, 2
    INT 10H
    MOV AX, 13H
    INT 10H
    RET
RESET_THE_SCREEN ENDP

; Function to animate a single duck
ONE_DUCK PROC
    ; Setting initial position of the duck
    mov duck_movement_xi, 60
    mov duck_movement_xf, 75
    mov duck_movement_yi, 150
    mov duck_movement_yf, 169

    L2_one_duck:
        MOV AH, 00h
        MOV AL, 13h
        INT 10h
        call draw_little_duck2 
        call draw_cursor

        ;adding the delay
        mov cx, 2000 
        L3:
        push cx
        mov cx,3000
            L4:
            loop L4
        pop cx
        loop L3   
        call move_duck
        check_key:
        ; Read the scan code of the key pressed
        mov ah, 00h
        int 16h
        mov al, ah
        ; Check if the upward arrow key is pressed
        cmp al, 48h
        je left_key
        cmp al, 50h
        je right_key 
        cmp al, 4Dh
        je upper_key
        cmp al, 4Bh
        je down_key
        jmp check_key
        loop L2_one_duck
    
    upper_key:
    add cursor_movement_yi,8
    add cursor_movement_yf,8
    jmp L2_one_duck
    down_key:
    sub cursor_movement_yi,8
    sub cursor_movement_yf,8
    jmp L2_one_duck
    left_key:
    sub cursor_movement_xi,8
    sub cursor_movement_xf,8
    jmp L2_one_duck
    right_key:
    add cursor_movement_xi,8
    add cursor_movement_xf,8
    jmp L2_one_duck

    ret
ONE_DUCK ENDP

main proc
    mov ax, @data
    mov ds, ax

    call ONE_DUCK

    mov ah, 4ch
    int 21h
main endp

end main
