;Periféricos
POWER                       EQU 0B0H
Option                      EQU 0C0H
OK                          EQU 0D0H
USERB                       EQU 0F3H
USERE                       EQU 0FAH
PASSB                       EQU 0113H
PASSE                       EQU 011AH
USERSCREEN                  EQU 53H
PASSSCREEN                  EQU 73H
BDDATACHECK                 EQU 3000H
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
;--- Buttons---
place 0B0H
  String "_ <- Power ON   "
  String "_ <- Option     "
  String "_ <- OK         "
  String "   Username:    "
  String "   ________     "
  String "   Password:    "
  String "   ________     "

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
      MOV R2, 30H
      SUB R1, R2
      CMP R1, 1
      JNZ IS_ON                     ;Repeats untill the Priferic is set to 1 (ON)
    ON:
      MOV R2, StartMenu             ;Sets the memory position of the screen to sho
      CALL ShowDisplay              ;Turns on the screen with starting Menu
      CALL CleanPerif               ;Cleans all the priferics
    FirstMenu:
      MOV R0, OK
      MOVB R0, [R0]
      MOV R2, 30H
      SUB R0, R2
      CMP R0, 1
      JNE FirstMenu
      MOV R0, Option                ;Sets the memory position for the Option priferic
      MOVB R0, [R0]                 ;Reads the input Option
      SUB R0, R2
      CMP R0, 1                     ;Switch case for the FirstMenu options
      JZ DisplayRegistration        ;1 for Registration
      CMP R0, 2                     ;2 for Login
      JZ DisplayLogin
      JMP FirstMenu                 ;Keeps the FirstMenu on Display untill an option is selected



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
    MOV R3, 5FH
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
    MOV R0, Display
    MOV R1, Display_End
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
    PUSH R7
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
      MOV R0, USERB               ;Gets where the user input starts
      MOV R4, USERE               ;Gets where the user input ends
      MOV R2, USERSCREEN          ;Gets where in the screen is the user space
      MOV R5, BDDATACHECK         ;Memory for a data comparation
      ADD R4, 1                   ;Adds 1 to the password end position to make comparation easyer
    GetUser:                      ;Loops untill has cheked all user inputs
        MOV R7, 5FH               ;This is the ASCII code for "_"
        MOVB R1, [R0]
        CMP R1, R7
        JZ NEXTCHARU              ;Jumps if he finds "_" meaning that user has not inserted nothing
        MOVB [R2], R1
        NEXTCHARU:
        MOVB [R5], R1             ;Copy the input of username to the DBDATACHECK
        ADD R0, 1
        ADD R2, 1
        ADD R5, 1
        CMP R0, R4
        JNZ GetUser               ;Keeps the loop going untill we have all characters
      MOV R0, PASSB               ;Gets where the password input starts
      MOV R4, PASSE               ;Gets where the password input ends
      ADD R4, 1                   ;Adds 1 to the password end position to make comparation easyer
      MOV R2, PASSSCREEN          ;Gets where in the screen the password should be
      MOV R8, 2AH                 ;Saves the '*' to be placed as password in the screen
      GetPass:                    ;Loops untill has checked all password inputs
        MOVB R1, [R0]
        CMP R1, R7
        JZ NEXTCHARP
        MOVB [R2], R8
        NEXTCHARP:                ;Skips the Screen '*' if there's no input on that place
        MOVB [R5], R1
        ADD R0, 1
        ADD R2, 1
        ADD R5, 1
        CMP R0, R4
        JNZ GetPass               ;Keeps the loop going untill we have all characters
      MOVB R0, [R3]               ;Places in R0 the value of the memory for the input of OK
      MOV R7, 30H
      SUB R0, R7                  ;Converts the input from a string number to an integer number
      CMP R0, 1
      JNE LoginCycle              ;Keeps looping untill OK is "pressed"
    CALL BDCONSULT                ;Calls the consultation to the DataBase
    POP R0
    POP R1
    POP R2
    POP R3
    POP R4
    POP R5
    POP R7
    RET

  BDCONSULT:                    ;Consults the DataBase
    PUSH R0
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5
    PUSH R6
    MOV R0, BDDATACHECK       ;Gets the initial position for the string it should compare
    MOV R1, BD                ;Gets the first position of the DataBase
    MOV R4, BD                ;Gets the first position of the DataBase to compare afterwards
    MOV R5, 0                 ;Places a 0 on R5 to use as a counter

    TRYLOGIN:
      MOVB R2, [R1]           ;Gets the 1st character from the DataBase to compare
      CMP R2, 0               ;Compares with '0' if it is zero we are at the end of the DataBase
      JZ ENDLOGIN             ;Leaves the DataBase
      MOVB R3, [R0]           ;Gets 1st character to compare with the one from the DataBase
      CMP R2, R3
      JNZ NEXTUSER            ;If the 1st not equal should jump to the NEXT USER
      ADD R0, 1
      ADD R1, 1
      ADD R5, 1
      MOV R6, 9               ;Sets the end of comparation this is here so I can use R6 again
      CMP R5, R6
      JZ LOGGED               ;If we get here it means that all 8 bytes compared mached, the login is sucessfull
      JMP TRYLOGIN
    NEXTUSER:
      MOV R0, BDDATACHECK     ;Resets the initial position for the comparation String
      MOV R6, 20H             ;Saves 20 to be incremented in memory
      ADD R4, R6              ;Increments the memory moves to the Next place in the DataBase
      MOV R1, R4              ;Gets the new Data to compare
      JMP TRYLOGIN            ;Jums to try login with the new Data
    LOGGED:
      MOV R9, R4               ;Places the memory position from the mached user so we can use it later on the program
    ENDLOGIN:
    POP R6
    POP R5
    POP R4
    POP R3
    POP R2
    POP R1
    POP R0
    RET
