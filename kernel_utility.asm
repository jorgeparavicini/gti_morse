include 'LIB\FASMARM.INC'

PERIPHERAL_BASE = $3F000000
GPIO_BASE = $200000
TIMER_BASE = $3000
TIMER_CNT = $4

b start

set_gpio_to_output:
  ; Parameters
  ; r0 - GPIO number
  ; EX: 24
  push  {r11, lr}
  add   r11, sp, #0           ; Initialize Frame Pointer
  sub   sp, sp, #16           ; Initialize local stack

  str   r0, [r11, #-4]        ; Store GPIO Number as first local variable
  imm32 r6, #0x1999999A       ; Store the division multiplier for 10. 2^32/<10>+1
  umull r6, r7, r0, r6        ; Store the quotient in r7
  str   r7, [r11, #-8]        ; Store the quotient in second local variable. EX: 2

  mov   r6, #0x4              ; The GPFSEL Are offset by 4 Bytes
  mul   r6, r6, r7            ; To get the GPFSEL we need the gpio number / 10 * 0x4
  str   r6, [r11, #-12]       ; Store GPFSEL Offset in third local variable. EX: 0x8

  mov   r6, #0xA              ; Each GPFSEL Holds 10 Pins
  ldr   r7, [r11, #-8]        ; Load Quotient
  ldr   r8, [r11, #-4]        ; Load Pin Number
  mul   r6, r6, r7            ; Get the GPFSEL Base number We want fromm the quotient we calculated. For example for GPFSEL2 the base value is 20, GPFSEL1 = 10 etc.
  sub   r6, r8, r6            ; Calculate offset for the pin we want inside the GPFSEL
  str   r6, [r11, #-16]       ; EX: 4

  bl get_gpio_base

  mov   r8, #7                ; We first need to disable all 3 bits for the pin we want.
  mov   r9, #3                ; The bits are shifted as a pack of 3
  ldr   r6, [r11, #-16]       ; Load the remainder
  mul   r9, r9, r6            ; Position of first bit for the pin in the GPFSEL.
  lsl   r8, r9                ; Shift the bit mask
  mvn   r8, r8                ; Invert the mask
  ldr   r6, [r11, #-12]       ; Load the GPFSEL Address offset
  ldr   r7, [r0, r6]          ; Load current GPFSEL Value
  and   r7, r7, r8            ; AND the mask and the GPFSEL Value setting the 3 bits for our pin to 0
  mov   r8, #1                ; Output is 001
  lsl   r8, r9                ; Shift it to correct position
  orr   r7, r7, r8            ; Orr the values setting our pin to output.

  ldr   r6, [r11, #-12]       ; Load the GPFSEL Address oFFSET
  str   r7, [r0, r6]          ; Store out bit mask

  sub   sp, r11, #0
  pop   {r11, pc}

set_gpio_to_input:
  ; Parameters
  ; r0 - GPIO number
  ; EX: 24
  push  {r11, lr}
  add   r11, sp, #0           ; Initialize Frame Pointer
  sub   sp, sp, #16           ; Initialize local stack

  str   r0, [r11, #-4]        ; Store GPIO Number as first local variable
  imm32 r6, #0x1999999A       ; Store the division multiplier for 10. 2^32/<10>+1
  umull r6, r7, r0, r6        ; Store the quotient in r7
  str   r7, [r11, #-8]        ; Store the quotient in second local variable. EX: 2

  mov   r6, #0x4              ; The GPFSEL Are offset by 4 Bytes
  mul   r6, r6, r7            ; To get the GPFSEL we need the gpio number / 10 * 0x4
  str   r6, [r11, #-12]       ; Store GPFSEL Offset in third local variable. EX: 0x8

  mov   r6, #0xA              ; Each GPFSEL Holds 10 Pins
  ldr   r7, [r11, #-8]        ; Load Quotient
  ldr   r8, [r11, #-4]        ; Load Pin Number
  mul   r6, r6, r7            ; Get the GPFSEL Base number We want fromm the quotient we calculated. For example for GPFSEL2 the base value is 20, GPFSEL1 = 10 etc.
  sub   r6, r8, r6            ; Calculate offset for the pin we want inside the GPFSEL
  str   r6, [r11, #-16]       ; EX: 4

  bl get_gpio_base

  mov   r8, #7                ; We first need to disable all 3 bits for the pin we want.
  mov   r9, #3                ; The bits are shifted as a pack of 3
  ldr   r6, [r11, #-16]       ; Load the remainder
  mul   r9, r9, r6            ; Position of first bit for the pin in the GPFSEL.
  lsl   r8, r9                ; Shift the bit mask
  mvn   r8, r8                ; Invert the mask
  ldr   r6, [r11, #-12]       ; Load the GPFSEL Address offset
  ldr   r7, [r0, r6]          ; Load current GPFSEL Value
  and   r7, r7, r8            ; AND the mask and the GPFSEL Value setting the 3 bits for our pin to 0

  ldr   r6, [r11, #-12]       ; Load the GPFSEL Address oFFSET
  str   r7, [r0, r6]          ; Store out bit mask

  sub   sp, r11, #0
  pop   {r11, pc}

turn_gpio_on:
  ; Parameters
  ; r0 - GPIO Number
  push {r11, lr}
  add  r11, sp, #0
  sub  sp, sp, #4

  str  r0, [r11, #-4]

  bl  set_gpio_to_output
  bl  get_gpio_base

  ldr  r2, [r11, #-4]
  mov  r1, #1
  lsl  r1, r2
  str  r1, [r0, #0x1C]

  sub sp, r11, #0     ; Restore Stack pointer to the bottom of the local Frame
  pop {r11, pc}       ; Restore Previous Frame pointer and jump the LR

turn_gpio_off:
  ; Parameters
  ; r0 - GPIO Number
  push {r11, lr}
  add  r11, sp, #0
  sub  sp, sp, #4

  str  r0, [r11, #-4]

  bl  set_gpio_to_output
  bl  get_gpio_base

  ldr  r2, [r11, #-4]
  mov  r1, #1
  lsl  r1, r2
  str  r1, [r0, #0x28]

  sub sp, r11, #0     ; Restore Stack pointer to the bottom of the local Frame
  pop {r11, pc}       ; Restore Previous Frame pointer and jump the LR

get_gpio_base:
  ; Get the GPIO base
  ; Returns:
  ; r0 - The GPIO Base for the raspberry Pi 3
  mov r0, PERIPHERAL_BASE
  orr r0, r0, GPIO_BASE

  bx lr

sleep:
  mov r1, #1000
  mul r1, r1, r0

  mov r2, PERIPHERAL_BASE
  orr r2, r2, TIMER_BASE

  ldr r3, [r2, #4]

  .wait:
    ldr r4, [r2, #4]

    sub r4, r4, r3
    cmp r4, r1
    blt .wait

  bx lr

block:
  b block
