RS = $18      ; 24
EN = $19      ; 25
DATA4 = $C    ; 12
DATA5 = $10   ; 16
DATA6 = $14   ; 20
DATA7 = $15   ; 21

DISPLAY_BASE_ADDRESS = $3004
DISPLAY_OFFSET_ADDRESS = $3000
DISPLAY_MAX_ADDRESS = $3044     ; Allow 16 characters of 4 bytes each. The character at 3068 is always null - 00000

b start

init_display:
  push {r11, lr}
  add   r11, sp, #0           ; Initialize Frame Pointer
  sub   sp, sp, #16           ; Initialize local stack

  mov r0, #0
  mov r1, DISPLAY_OFFSET_ADDRESS
  mov r2, DISPLAY_MAX_ADDRESS
  init_address:
    str r0, [r1]
    add r1, r1, #4
    cmp r1, r2
    ble init_address          ; Set all character addresses to 0

  mov r0, RS                  ; Set all Pins to output
  bl set_gpio_to_output
  mov r0, EN
  bl set_gpio_to_output
  mov r0, DATA4
  bl set_gpio_to_output
  mov r0, DATA5
  bl set_gpio_to_output
  mov r0, DATA6
  bl set_gpio_to_output
  mov r0, DATA7
  bl set_gpio_to_output

  mov r0, #0x33     ; Enable 4 Bit Operating Mode
  mov r1, #0
  bl write8

  mov r0, #0x32     ; Enable 4 Bit Operating Mode
  mov r1, #0        ; It is a 2 Byte Command, hence the 2 different commands
  bl write8

  mov r0, #0x06     ; Left Align the text
  mov r1, #0
  bl write8

  mov r0, #0x0E     ; Display On, Cursor On, Blinking Off
  mov r1, #0
  bl write8

  mov r0, #0x28     ; Enable 2 Lines
  mov r1, #0
  bl write8

  mov r0, #1        ; Clear
  mov r1, #0
  bl write8
  bl long_delay     ; Clear requires a long delay

  mov r0, #0x48
  bl write_char

  mov r0, #0x41
  bl write_char

  mov r0, #0x4C
  bl write_char

  mov r0, #0x4C
  bl write_char

  mov r0, #0x4F
  bl write_char

  mov r0, #0x20
  bl write_char

  mov r0, #0x4D
  bl write_char

  mov r0, #0x45
  bl write_char

  mov r0, #0x4E
  bl write_char

  mov r0, #0x53
  bl write_char

  mov r0, #0x43
  bl write_char

  mov r0, #0x48
  bl write_char

  mov r0, #0x45
  bl write_char

  mov r0, #0x4E
  bl write_char


  sub  sp, r11, #0
  pop {r11, pc}



pulse_enable:
  push {lr}
  mov r0, EN
  bl turn_gpio_off
  bl delay
  mov r0, EN
  bl turn_gpio_on
  bl delay
  mov r0, EN
  bl turn_gpio_off
  pop {pc}

write8:
  ; r0: value between 0 and 255 to be written
  ; r1: 0 if command else data
  push {r11, lr}
  add   r11, sp, #0           ; Initialize Frame Pointer
  sub   sp, sp, #16           ; Initialize local stack

  str  r0, [r11, #-4]
  str  r1, [r11, #-8]

  bl long_delay

  ; START RS
  ; Write the value of the rs based on the passed value in r1

  ldr  r5, [r11, #-8]
  cmp  r5, #0
  beq  write8_rs_command

  write8_rs_data:
    mov  r0, RS
    bl turn_gpio_on
    b write8_rs_done

  write8_rs_command:
    mov  r0, RS
    bl turn_gpio_off
    b write8_rs_done

  write8_rs_done:

  ; END RS

  ; START Write Upper 4 bits

  ldr  r5, [r11, #-4]

  lsr  r1, r5, #4
  mov  r0, DATA4
  bl set_pin_if_lsb_is_set

  lsr  r1, r5, #5
  mov  r0, DATA5
  bl set_pin_if_lsb_is_set

  lsr  r1, r5, #6
  mov  r0, DATA6
  bl set_pin_if_lsb_is_set

  lsr  r1, r5, #7
  mov  r0, DATA7
  bl set_pin_if_lsb_is_set

  ; END Write Upper 4 bits
  bl pulse_enable

  ; START Write Lower 4 bits
  ldr  r5, [r11, #-4]

  mov  r1, r5
  mov  r0, DATA4
  bl set_pin_if_lsb_is_set

  lsr  r1, r5, #1
  mov  r0, DATA5
  bl set_pin_if_lsb_is_set

  lsr  r1, r5, #2
  mov  r0, DATA6
  bl set_pin_if_lsb_is_set

  lsr  r1, r5, #3
  mov  r0, DATA7
  bl set_pin_if_lsb_is_set
  ; END Write Lower 4 bits

  bl pulse_enable

  sub  sp, r11, #0
  pop {r11, pc}


shift_cursor_left:
  push {lr}

  mov r0, DISPLAY_OFFSET_ADDRESS
  ldr r1, [r0]
  cmp r1, #0
  beq shift_cursor_left_done      ; Skip the shifting, if the cursor is already to the leftmost position

  sub r1, #4
  str r1, [r0]                    ; Increase the cursor

  mov r0, #0x10
  mov r1, #0
  bl write8

  shift_cursor_left_done:

  pop {pc}

shift_cursor_right:
  push {lr}

  mov r0, DISPLAY_OFFSET_ADDRESS
  ldr r1, [r0]
  mov r2, DISPLAY_BASE_ADDRESS
  mov r3, DISPLAY_MAX_ADDRESS
  add r4, r1, r2
  sub r3, #4                    ; The last address is not part of the characters, it is a null terminator, hence remove one character
  cmp r4, r3
  bge shift_cursor_right_done

  add r1, #4
  str r1, [r0]


  mov r0, #0x14
  mov r1, #0
  bl write8

  shift_cursor_right_done:

  pop {pc}


set_pin_if_lsb_is_set:
  ; r0 = pin to set
  ; r1 = value to check
  push {lr}

  and  r1, r1, #1
  cmp  r1, #0
  beq lsb_off

  lsb_on:
    bl turn_gpio_on
    b lsb_done

  lsb_off:
    bl turn_gpio_off
    b lsb_done

  lsb_done:

  pop {pc}

write_char:
  ; r0 - character to write
  ; Make sure the index is set correctly
  ; TODO- check a new character fits
  push {r11, lr}
  add   r11, sp, #0           ; Initialize Frame Pointer
  sub   sp, sp, #4           ; Initialize local stack

  str r0, [r11, #-4]

  mov r1, #1
  bl write8
  mov r2, DISPLAY_OFFSET_ADDRESS
  mov r3, DISPLAY_BASE_ADDRESS
  ldr r1, [r2]
  ldr r0, [r11, #-4]
  str r0, [r3, r1]

  add r1, r1, #4
  str r1, [r2]

  sub  sp, r11, #0
  pop {r11, pc}

increase_char:
  push {lr}

  mov r0, DISPLAY_OFFSET_ADDRESS
  mov r1, DISPLAY_BASE_ADDRESS
  ldr r2, [r0]
  ldr r0, [r1, r2]

  cmp r0, #65                   ;
  blt increase_char_to_A
  cmp r0, #90
  bge increase_char_to_space

  add r0, r0, #1
  b increase_char_done

  increase_char_to_A:
    mov r0, #65
    b increase_char_done

  increase_char_to_space:
    mov r0, #32
    b increase_char_done

  increase_char_done:

  bl write_char
  bl shift_cursor_left

  pop {pc}

decrease_char:
  push {lr}

  mov r0, DISPLAY_OFFSET_ADDRESS
  mov r1, DISPLAY_BASE_ADDRESS
  ldr r2, [r0]
  ldr r0, [r1, r2]

  cmp r0, #32
  beq decrease_char_to_Z

  cmp r0, #65
  ble decrease_char_to_space

  cmp r0, #90
  bgt decrease_char_to_Z

  sub r0, r0, #1
  b decrease_char_done

  decrease_char_to_Z:
    mov r0, #90
    b decrease_char_done

  decrease_char_to_space:
    mov r0, #32
    b decrease_char_done

  decrease_char_done:
  bl write_char
  bl shift_cursor_left

  pop {pc}

delay:
  push {lr}
  mov r0, #1    ; Max execution of regular instructions is a few microseconds, wait the least posible amount.
  bl sleep
  pop {pc}

long_delay:
  push {lr}
  mov r0, #5    ; Max execution of a long instruction is 4.1 ms. Hence wait for more
  bl sleep
  pop {pc}
