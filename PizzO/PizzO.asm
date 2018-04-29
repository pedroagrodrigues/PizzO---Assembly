;Periféricos
POWER                       EQU 1A0H
Option                      EQU 1B0H
OK                          EQU 1C0H
;---Display---
Display                     EQU 200h
Display_End                 EQU 26FH
;---Constantes
EmptyCharacter              EQU 20H
;---StackPointer
StackPointer                EQU 3000H
;---Menus---
Place 2000H
StartMenu:
  String "    Welcome     "
  String "1 - Registration"
  String "2 - Login       "
  String "                "
  String "                "
  String "                "
  String "                "
LoginMenu:
  String "   Menu Login   "
  String "                "
  String "   Username:    "
  String "                "
  String "   Password:    "
  String "                "
  String "                "
RegistrationMenu:
  String "New Registration"
  String "                "
  String "   Username:    "
  String "                "
  String "   Password:    "
  String "                "
  String "                "
ErrorMenu:
  String "     ERROR      "
  String "     Opcao      "
  String "                "
  String "    ERRADA      "
  String "                "
  String "                "
  String "                "

;---Fim Menus ---

place 0000H
  Begin:
    MOV R0, Beginning
    jmp R0

place 6000H
  Beginning:
    MOV SP, StackPointer
    CALL CleanDisplay
    CALL CleanPerif
    MOV R0, POWER
    IS_ON:
      MOVB R1, [R0]
      CMP R1, 1
      JNE IS_ON
    ON:
      MOV R2, StartMenu
      CALL ShowDisplay
      CALL CleanPerif
    FirstMenu:
      MOV R0, Option
      MOVB R0, [R0]
      CMP R0, 0
      JZ FirstMenu
      CMP R0, 1
      JZ DisplayRegistration
      CMP R0, 2
      JZ DisplayLogin




  CleanDisplay:
    PUSH r0
    PUSH r1
    PUSH r2
    MOV r0, Display
    MOV r1, Display_End
    MOV r2, EmptyCharacter
    CleaningCycle:
      MOVB [r0], r2
      ADD r0, 1
      CMP r0, r1
      JLE CleaningCycle
    POP r2
    POP r1
    POP r0
    RET

  CleanPerif:
    PUSH R3
    PUSH R2
    PUSH R1
    PUSH R0
    MOV R0, POWER
    MOV R1, Option
    MOV R2, OK
    MOV R3, 0
    MOVB [R0], R3
    MOVB [R1], R3
    MOVB [R2], R3
    POP R0
    POP R1
    POP R2
    POP R3
    RET

  ShowDisplay:
    PUSH R3
    PUSH R2
    PUSH R1
    PUSH R0
    mov R0, Display
    mov R1, Display_End
    Cycle:
      MOV R3, [R2]
      MOV [R0], R3
      ADD R2, 2
      ADD R0, 2
      CMP R0, R1
      JLE Cycle
    POP R0
    POP R1
    POP R2
    POP R3
    RET

  DisplayRegistration:
    PUSH R0
    PUSH R2
    MOV R2, RegistrationMenu
    CALL ShowDisplay
    CALL CleanPerif
    MOV R0, OK
    RegistrationCycle:

    POP R2
    POP R0

  DisplayLogin:
    PUSH R0
    PUSH R2
    MOV R2, LoginMenu
    CALL ShowDisplay
    CALL CleanPerif
    MOV R0, OK
    LoginCycle:

    POP R2
    POP R0
