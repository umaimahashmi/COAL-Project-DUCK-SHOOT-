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
;cursor
cursor  db 04,04,04,04,00,00,04,04,04,04
        db 04,04,04,04,00,00,04,04,04,04
        db 04,04,00,00,00,00,00,00,04,04
        db 04,04,00,00,00,00,00,00,04,04
        db 00,00,00,00,04,04,00,00,00,00
        db 00,00,00,00,04,04,00,00,00,00
        db 04,04,00,00,00,00,00,00,04,04
        db 04,04,00,00,00,00,00,00,04,04
        db 04,04,04,04,00,00,04,04,04,04
        db 04,04,04,04,00,00,04,04,04,04

xi dw 0
xf dw 0
yi dw 0
yf dw 0

duck_movement_xi dw 80 
duck_movement_xf dw 95 
duck_movement_yi dw 140
duck_movement_yf dw 159

cursor_movement_xi dw 140 
cursor_movement_xf dw 150 
cursor_movement_yi dw 140 
cursor_movement_yf dw 150 

NO_OF_TRIES_ONE_DUCK db 3

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
; Function to reset the screen
RESET_THE_SCREEN PROC
    MOV AH, 0
    MOV AL, 2
    INT 10H
    MOV AX, 13H
    INT 10H
    RET
RESET_THE_SCREEN ENDP





;shoot function
shoot proc
    ; Load duck's position into registers for comparison
    mov ax, duck_movement_xi
    sub ax, 15 ; Apply tolerance range to the left (sub 5 from initial X)
    mov bx, duck_movement_xf
    add bx, 15 ; Apply tolerance range to the right (add 5 to final X)
    mov cx, duck_movement_yi
    sub cx, 15 ; Apply tolerance range upwards (sub 5 from initial Y)
    mov dx, duck_movement_yf
    add dx, 15 ; Apply tolerance range downwards (add 5 to final Y)

    ; Check if the cursor is within the tolerance range of the duck
    cmp cursor_movement_xi, ax
    jl check_end
    cmp cursor_movement_xi, bx
    jg check_end
    cmp cursor_movement_yi, cx
    jl check_end
    cmp cursor_movement_yi, dx
    jg check_end

    IF_RIGHT:
    mov cursor_movement_xi,100 ; Initial X position of the duck
    mov cursor_movement_xf,110 ; Final X position of the duck
    mov cursor_movement_yi,140 ; Initial Y position of the duck
    mov cursor_movement_yf,150 ; Final Y position of the duck
    call RESET_THE_SCREEN
    call draw_cursor
    mov cx, 2000 
    shoot1:
    push cx
    mov cx,2000
        shoot2:
        loop shoot2
        pop cx
    loop shoot1 
    DEC NO_OF_TRIES_ONE_DUCK
    call ONE_DUCK
    ret
    
    check_end:
    call ONE_DUCK
shoot endp
;moving the duck
move_duck proc
    mov ah, 2Ch         ; Function to get system time
    int 21h             ; Get system time into CX:DX
    xor ax, ax          ; Clear AX
    mov ax, dx          ; Move DX into AX
    xor dx, dx          ; Clear DX
    mov cx, 4           ; Limit the random number between 0 and 3
    div cx              ; Divide AX by 4, remainder is now in DX (0, 1, 2, or 3)

    ; Handle movement based on the random direction
    cmp dx, 0   ; If DX = 0 right
    je RIGHT_MOVEMENT
    cmp dx, 1   ; If DX = 1 left
    je LEFT_MOVEMENT
    cmp dx, 2   ; If DX = 2 UP
    je UP_MOVEMENT
    cmp dx, 3   ; If DX = 2 down
    je DOWN_MOVEMENT

    ;here we will generate a random number so that we can in the variable for big movements
    RIGHT_MOVEMENT:
    add duck_movement_xi, 10
    add duck_movement_xf, 10
    ret
    LEFT_MOVEMENT:
    SUB duck_movement_xi, 10
    SUB duck_movement_xf, 10
    RET
    UP_MOVEMENT:
    add duck_movement_yi, 10
    add duck_movement_yf, 10
    RET
    DOWN_MOVEMENT:
    SUB duck_movement_yi, 10
    SUB duck_movement_yf, 10
    ret
move_duck endp
; Function to animate a single duck
ONE_DUCK PROC
    
    ;update the cursor and the duck position
    mov duck_movement_xi,80 
    mov duck_movement_xf,95 
    mov duck_movement_yi,140
    mov duck_movement_yf,159

    mov cursor_movement_xi,140 
    mov cursor_movement_xf,150 
    mov cursor_movement_yi,140 
    mov cursor_movement_yf,150
    ;check no of valid tries
    cmp NO_OF_TRIES_ONE_DUCK,0
    jz END_ONE_DUCK

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
        cmp al, 39h       ; space key shoot conditions
        je space_key
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
    
    space_key:
    call shoot
    ret
    upper_key:
    add cursor_movement_yi,12
    add cursor_movement_yf,12
    jmp L2_one_duck
    down_key:
    sub cursor_movement_yi,12
    sub cursor_movement_yf,12
    jmp L2_one_duck
    left_key:
    sub cursor_movement_xi,12
    sub cursor_movement_xf,12
    jmp L2_one_duck
    right_key:
    add cursor_movement_xi,12
    add cursor_movement_xf,12
    jmp L2_one_duck

END_ONE_DUCK:
    call RESET_THE_SCREEN
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
