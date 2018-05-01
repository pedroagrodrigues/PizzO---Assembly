;Periféricos
POWER                       EQU 1A0H
Option                      EQU 1B0H
OK                          EQU 1C0H
USERB                       EQU 1D0H
USERE                       EQU 1D8H
PASSB                       EQU 1E0H
PASSE                       EQU 1E8H
USERSCREEN                  EQU 233H
PASSSCREEN                  EQU 253H
BDDATACHECH                 EQU 3000H
BD                          EQU 3010H
;---Display---
Display                     EQU 20H
Display_End                 EQU 8FH
;---Constants---
EmptyCharacter              EQU 20H
;---StackPointer
StackPointer                EQU 2FF0H
;---Menus---
Place 2000H
StartMenu:
  String "                "
  String "                "
  String "    Welcome     "
  String "1 - Registration"
  String "2 - Login       "
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
  String "                "
  String "                "
  String "     ERROR      "
  String "     Wrong      "
  String "     Option     "
  String "                "
  String "                "
;---Fim Menus ---
;---Screen Frame ---
place 10H
  String "================"
place 90H
  String "================"
;---initial user account---
place 3010H
String "Pedro12312345678"
String "50              "

;---actual program
place 0000H
  Begin:
    MOV R0, Beginning
    jmp R0                          ;Jumps to the beguining of the code

place 6000H
  Beginning:
    MOV SP, StackPointer            ;Sets the position of the StackPointer
    CALL CleanDisplay
    CALL CleanPerif
    MOV R0, POWER                   ;Move the priferic memory code to R0
    IS_ON:
      MOVB R1, [R0]                 ;Gets the value of the Memory
      CMP R1, 1
      JNE IS_ON                     ;Repeats untill the Priferic is set to 1 (ON)
    ON:
      MOV R2, StartMenu             ;Sets the memory position of the screen to sho
      CALL ShowDisplay              ;Turns on the screen with starting Menu
      CALL CleanPerif               ;Cleans all the priferics
    FirstMenu:
      MOV R0, Option                ;Sets the memory position for the Option priferic
      MOVB R0, [R0]                 ;Reads the input Option
      CMP R0, 0
      JZ FirstMenu                  ;Keeps the FirstMenu on Display untill an option is selected
      CMP R0, 1                     ;Switch case for the FirstMenu options
      JZ DisplayRegistration        ;1 for Registration
      CMP R0, 2                     ;2 for Login
      JZ DisplayLogin




  CleanDisplay:
    PUSH R0
    PUSH R1
    PUSH R2
    MOV R0, Display                 ;Saves the memory position where the Display begins
    MOV R1, Display_End             ;Saves where the Display ends
    MOV R2, EmptyCharacter          ;Saves the EmptyCharacter 20H wich is a " "
    CleaningCycle:                  ;Cleans the menu from Display position
      MOVB [R0], R2
      ADD R0, 1
      CMP R0, R1
      JLE CleaningCycle             ;Keeps the loop untill all the Display is filled with " "
    POP R2
    POP R1
    POP R0
    RET

  CleanPerif:                       ;Sets all priferics to 0
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
    MOV R0, USERB
    MOV R1, USERE
    CleaningUser:               ;Cleans the menu from USER priferic
      MOVB [R0], R3
      ADD R0, 1
      CMP R0, R1
      JLE CleaningUser
    MOV R0, PASSB
    MOV R1, PASSE
    CleaningPass:               ;Cleans the menu from PASS priferic
      MOVB [R0], R3
      ADD R0, 1
      CMP R0, R1
      JLE CleaningPass
    POP R0
    POP R1
    POP R2
    POP R3
    RET

  ShowDisplay:                      ;Sets the Display for the menu that needs to be shown
    PUSH R3
    PUSH R2
    PUSH R1
    PUSH R0
    mov R0, Display
    mov R1, Display_End
    Cycle:                          ;Places the Display char by char
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

  DisplayRegistration:            ;Behaviour of the Menu Registration
    PUSH R0
    PUSH R2
    MOV R2, RegistrationMenu
    CALL ShowDisplay
    CALL CleanPerif
    MOV R0, OK
    RegistrationCycle:
    CMP R5,0
    JZ RegistrationCycle
    POP R2
    POP R0

  DisplayLogin:                   ;Behaviour of the Menu Login
    PUSH R6
    PUSH R5
    PUSH R4
    PUSH R3
    PUSH R2
    PUSH R1
    PUSH R0
    MOV R2, LoginMenu             ;Sets the position of the Login screen
    CALL ShowDisplay              ;Displays the Screen
    CALL CleanPerif               ;Cleans all Perif
    MOV R3, OK
    LoginCycle:
      MOV R0, USERB
      MOV R4, USERE
      MOV R2, USERSCREEN
      MOV R5, BDDATACHECH
      MOV R6, [R6]
      GetUser:
        MOVB R1, [R0]
        CMP R1, 0
        JZ NEXTCHARU
        MOVB [R2], R1
        NEXTCHARU:
        MOVB [R5], R1
        ADD R0, 1
        ADD R2, 1
        ADD R5, 1
        CMP R0, R4
        JNE GetUser
      MOV R0, PASSB
      MOV R4, PASSE
      MOV R2, PASSSCREEN
      MOV R8, 2AH
      GetPass:
        MOVB R1, [R0]
        CMP R1, 0
        JZ NEXTCHARP
        MOVB [R2], R8
        NEXTCHARP:
        MOVB [R5], R1
        ADD R0, 1
        ADD R2, 1
        ADD R5, 1
        CMP R0, R4
        JNE GetPass
      MOVB R0, [R3]
      CMP R0, 1
      JNE LoginCycle
    CALL BDCONSULT
    POP R0
    POP R1
    POP R2
    POP R3
    POP R4
    POP R5
    POP R6

  BDCONSULT:
    PUSH R0
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5
    PUSH R6
    MOV R0, BDDATACHECH
    MOV R1, BD
    MOV R4, BD
    TRYLOGIN:
      MOVB R2, [R1]
      CMP R2, 0
      JZ ENDLOGIN
      MOVB R3, [R0]
      CMP R2, R3
      JNZ NEXTUSER
      ADD R0, 1
      ADD R1, 1
      ADD R5, 1
      MOV R6, 8
      CMP R5, R6
      JZ LOGGED
      JMP TRYLOGIN
    NEXTUSER:
      MOV R0, BDDATACHECH
      MOV R6, 20H
      ADD R4, R6
      MOV R1, R4
      JMP TRYLOGIN
    LOGGED:
      MOV R9, 1
    ENDLOGIN:
    POP R6
    POP R5
    POP R4
    POP R3
    POP R2
    POP R1
    POP R0
    RET
