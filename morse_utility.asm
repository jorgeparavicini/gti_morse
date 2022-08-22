MORSE_PIN = $7
STATUS_PIN = $19
DIT_LENGTH = $12C
DAH_LENGTH = $384

b start

play_morse:
  push {r11, lr}
  add   r11, sp, #0           ; Initialize Frame Pointer
  sub   sp, sp, #4           ; Initialize local stack

  mov r0, STATUS_PIN
  bl turn_gpio_on

  mov r1, DISPLAY_BASE_ADDRESS          ; Offset

  play_morse_loop:
    ldr r0, [r1]
    cmp r0, #0
    str r1, [r11, #-4]
    beq play_morse_done
    bl play_char
    ldr r1, [r11, #-4]
    add r1, #4
    b play_morse_loop

  play_morse_done:

  mov r0, STATUS_PIN
  bl turn_gpio_off
  sub  sp, r11, #0
  pop {r11, pc}

play_char:
  push {r11, lr}

  cmp r0, #32
  beq play_space

  cmp r0, #65
  beq play_A

  cmp r0, #66
  beq play_B

  cmp r0, #67
  beq play_C

  cmp r0, #68
  beq play_D

  cmp r0, #69
  beq play_E

  cmp r0, #70
  beq play_F

  cmp r0, #71
  beq play_G

  cmp r0, #72
  beq play_H

  cmp r0, #73
  beq play_I

  cmp r0, #74
  beq play_J

  cmp r0, #75
  beq play_K

  cmp r0, #76
  beq play_L

  cmp r0, #77
  beq play_M

  cmp r0, #78
  beq play_N

  cmp r0, #79
  beq play_O

  cmp r0, #80
  beq play_P

  cmp r0, #81
  beq play_Q

  cmp r0, #82
  beq play_R

  cmp r0, #83
  beq play_S

  cmp r0, #84
  beq play_T

  cmp r0, #85
  beq play_U

  cmp r0, #86
  beq play_V

  cmp r0, #87
  beq play_W

  cmp r0, #88
  beq play_X

  cmp r0, #89
  beq play_Y

  cmp r0, #90
  beq play_Z

  pop {r11, pc}

play_dit:
  push {r11, lr}

  mov r0, MORSE_PIN
  bl turn_gpio_on
  mov r0, DIT_LENGTH
  bl sleep
  mov r0, MORSE_PIN
  bl turn_gpio_off

  pop {r11, pc}

play_dah:
  push {r11, lr}

  mov r0, MORSE_PIN
  bl turn_gpio_on
  mov r0, DAH_LENGTH
  bl sleep
  mov r0, MORSE_PIN
  bl turn_gpio_off

  pop {r11, pc}

play_character_pause:
  push {r11, lr}

  mov r0, DIT_LENGTH
  bl sleep

  pop {r11, pc}

play_letter_pause:
  push {r11, lr}

  mov r0, DAH_LENGTH
  bl sleep

  pop {r11, pc}

play_space:
  push {r11, lr}

  mov r0, #2100
  bl sleep

  pop {r11, pc}

play_A:
  push {r11, lr}

  bl play_dit
  bl play_character_pause
  bl play_dah
  bl play_letter_pause

  pop {r11, pc}

play_B:



push{r11, lr}



bl play_dah

bl play_character_pause

bl play_dit

bl play_character_pause

bl play_dit

bl play_character_pause

bl play_dit

bl play_letter_pause



pop{r11, pc}





play_C:



push{r11, lr}



bl play_dah

bl play_character_pause

bl play_dit

bl play_character_pause

bl play_dah

bl play_character_pause

bl play_dit

bl play_letter_pause



pop{r11, pc}





play_D:



push{r11, lr}



bl play_dah

bl play_character_pause

bl play_dit

bl play_character_pause

bl play_dit

bl play_letter_pause



pop{r11, pc}





play_E:



push{r11, lr}



bl play_dit

bl play_letter_pause



pop{r11, pc}







play_F:



push{r11, lr}



bl play_dit

bl play_character_pause

bl play_dit

bl play_character_pause

bl play_dah

bl play_character_pause

bl play_dit

bl play_letter_pause



pop{r11, pc}





play_G:



push{r11, lr}



bl play_dah

bl play_character_pause

bl play_dah

bl play_character_pause

bl play_dit

bl play_letter_pause



pop{r11, pc}





play_H:



push{r11, lr}



bl play_dit

bl play_character_pause

bl play_dit

bl play_character_pause

bl play_dit

bl play_character_pause

bl play_dit

bl play_letter_pause



pop{r11, pc}





play_I:



push{r11, lr}



bl play_dit

bl play_character_pause

bl play_dit

bl play_letter_pause



pop{r11, pc}





play_J:



push{r11, lr}



bl play_dit

bl play_character_pause

bl play_dah

bl play_character_pause

bl play_dah

bl play_character_pause

bl play_dah

bl play_letter_pause



pop{r11, pc}





play_K:



push{r11, lr}



bl play_dah

bl play_character_pause

bl play_dit

bl play_character_pause

bl play_dah

bl play_letter_pause



pop{r11, pc}





play_L:



push{r11, lr}



bl play_dit

bl play_character_pause

bl play_dah

bl play_character_pause

bl play_dit

bl play_character_pause

bl play_dit

bl play_letter_pause



pop{r11, pc}





play_M:



push{r11, lr}



bl play_dah

bl play_character_pause

bl play_dah

bl play_letter_pause



pop{r11, pc}





play_N:



push{r11, lr}



bl play_dah

bl play_character_pause

bl play_dit

bl play_letter_pause



pop{r11, pc}





play_O:



push{r11, lr}



bl play_dah

bl play_character_pause

bl play_dah

bl play_character_pause

bl play_dah

bl play_letter_pause



pop{r11, pc}





play_P:



push{r11, lr}



bl play_dit

bl play_character_pause

bl play_dah

bl play_character_pause

bl play_dah

bl play_character_pause

bl play_dit

bl play_letter_pause



pop{r11, pc}





play_Q:



push{r11, lr}



bl play_dah

bl play_character_pause

bl play_dah

bl play_character_pause

bl play_dit

bl play_character_pause

bl play_dah

bl play_letter_pause



pop{r11, pc}





play_R:



push{r11, lr}



bl play_dit

bl play_character_pause

bl play_dah

bl play_character_pause

bl play_dit

bl play_letter_pause



pop{r11, pc}





play_S:



push{r11, lr}



bl play_dit

bl play_character_pause

bl play_dit

bl play_character_pause

bl play_dit

bl play_letter_pause



pop{r11, pc}





play_T:



push{r11, lr}



bl play_dah

bl play_letter_pause



pop{r11, pc}





play_U:



push{r11, lr}



bl play_dit

bl play_character_pause

bl play_dit

bl play_character_pause

bl play_dah

bl play_letter_pause



pop{r11, pc}





play_V:
 push{r11, lr}

 bl play_dit
 bl play_character_pause
 bl play_dit
 bl play_character_pause
 bl play_dit
 bl play_character_pause
 bl play_dah
 bl play_letter_pause

 pop{r11, pc}


play_W:
 push{r11, lr}

 bl play_dit
 bl play_character_pause
 bl play_dah
 bl play_character_pause
 bl play_dah
 bl play_letter_pause

 pop{r11, pc}


play_X:
 push{r11, lr}

 bl play_dah
 bl play_character_pause
 bl play_dit
 bl play_character_pause
 bl play_dit
 bl play_character_pause
 bl play_dah
 bl play_letter_pause
 pop{r11, pc}


play_Y:
 push{r11, lr}

 bl play_dah
 bl play_character_pause
 bl play_dit
 bl play_character_pause
 bl play_dah
 bl play_character_pause
 bl play_dah
 bl play_letter_pause

 pop{r11, pc}


play_Z:
  push{r11, lr}

  bl play_dah
  bl play_character_pause
  bl play_dah
  bl play_character_pause
  bl play_dit
  bl play_character_pause
  bl play_dit
  bl play_letter_pause

  pop{r11, pc}