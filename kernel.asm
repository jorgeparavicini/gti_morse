format binary as 'img'
include 'kernel_utility.asm'
include 'lcd_utility.asm'
include 'morse_utility.asm'

LEFT_SHIFT_PIN = $13
RIGHT_SHIFT_PIN = $6
INCREASE_LETTER_PIN = $D
DECREASE_LETTER_PIN = $B
PLAY_MORSE_PIN = $1A

start:
  mov sp, #0x6000 ; initialize Stack
  bl init_display
  mov r0, LEFT_SHIFT_PIN
  bl set_gpio_to_input

  main_loop:
    bl poll_inputs
    b main_loop

poll_inputs:
  push {lr}

  bl get_gpio_base
  ldr r1, [r0, #0x34]

  mov r2, #1
  lsl r2, r2, LEFT_SHIFT_PIN
  and r3, r1, r2
  cmp r3, #0
  bne left_shift

  mov r2, #1
  lsl r2, r2, RIGHT_SHIFT_PIN
  and r3, r1, r2
  cmp r3, #0
  bne right_shift

  mov r2, #1
  lsl r2, r2, INCREASE_LETTER_PIN
  and r3, r1, r2
  cmp r3, #0
  bne increase_letter

  mov r2, #1
  lsl r2, r2, DECREASE_LETTER_PIN
  and r3, r1, r2
  cmp r3, #0
  bne decrease_letter

  mov r2, #1
  lsl r2, r2, PLAY_MORSE_PIN
  and r3, r1, r2
  cmp r3, #0
  bne play_morse_

  b done_poll_inputs

 left_shift:
    bl shift_cursor_left
    bl action_delay
    b done_poll_inputs

 right_shift:
    bl shift_cursor_right
    bl action_delay
    b done_poll_inputs

 increase_letter:
    bl increase_char
    bl action_delay
    b done_poll_inputs

 decrease_letter:
    bl decrease_char
    bl action_delay
    b done_poll_inputs

 play_morse_:
    bl play_morse
    bl action_delay
    b done_poll_inputs

 done_poll_inputs:

   pop {pc}

action_delay:
  push {lr}
  mov r0, #300
  bl sleep
  pop {pc}
