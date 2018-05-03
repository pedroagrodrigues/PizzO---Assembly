;Periféricos
POWER                       EQU 0B0H    ;'Begins' the Program
Option                      EQU 0C0H    ;Input every choise
OK                          EQU 0D0H    ;Inputs 'OK' to end the choise
USERB                       EQU 0F3H    ;Begining of the user input segment
USERE                       EQU 0FAH    ;End of User input segment
PASSB                       EQU 0113H   ;Begining Password input segment
PASSE                       EQU 011AH   ;End of password input segment
;---Display---
Display                     EQU 20H     ;Memory position to start the Display
Display_End                 EQU 8FH     ;Memory position to end the Display
;---Constants---
EmptyCharacter              EQU 20H     ;To place the " " character
USERSCREEN                  EQU 53H     ;Saves the position where the inputed user will apear
PASSSCREEN                  EQU 73H     ;Saves the position place '*' where the password should be
BDDATACHECK                 EQU 3000H   ;Saves inputed username and password to check its existance in the DataBase
BD                          EQU 3010H   ;Position of the actual DataBase
;---StackPointer
StackPointer                EQU 2FF0H   ;Position for the StackPointer
;---Menus---
Place 2000H                             ;Saves menus to Display afterwards
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
place 3010H ;Placing an example user account
String "Pedro12312345678"
String "5000            "

;----Instructions
place 0000H
  Begin:
    MOV R0, Beginning
    JMP R0                          ;Jumps to the beguining of the code

place 6000H
Beginning:
  MOV SP, StackPointer            ;Sets the position of the StackPointer
  CALL CleanDisplay
  CALL CleanPerif
  CALL IS_ON
  ON:
    MOV R2, StartMenu             ;Sets the memory position of the screen to sho
    CALL ShowDisplay              ;Turns on the screen with starting Menu
    CALL CleanPerif               ;Cleans all the priferics
  FirstMenu:
    MOV R0, OK                    ;Places the priferic memory position in R0
    MOVB R0, [R0]                 ;Gets the actual value of the priferic "OK"
    MOV R2, 30H
    SUB R0, R2
    CMP R0, 1
    JNZ FirstMenu                 ;Keeps the FirstMenu on display untill the "OK" is pressed
    MOV R0, Option                ;Sets the memory position for the Option priferic
    MOVB R0, [R0]                 ;Reads the input Option
    SUB R0, R2
    CMP R0, 1                     ;Switch case for the FirstMenu options
    JZ DisplayRegistrationAUX        ;If no Option selected, Display Error
    CMP R0, 2                     ;1 for Registration
    JZ DisplayLogin               ;2 for Login
    JMP DisplayError

IS_ON:
  MOV R0, POWER                 ;Move the priferic memory code to R0
  MOVB R1, [R0]                 ;Gets the value of the Memory
  MOV R2, 30H                   ;This will be used to convert ASCII String to Hexadecimal
  SUB R1, R2
  CMP R1, 1                     ;Checks if the Machine is ON
  JNZ IS_ON                     ;Repeats untill the Priferic is set to 1 (ON)s
  RET

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

DisplayRegistrationAUX:
  CALL DisplayRegistration
  JMP ON

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

DisplayError:           ;Places the Error mensage on the Display
  PUSH R0
  PUSH R2
  MOV R2, ErrorMenu       ;Gets the position where the ErroMenu is saved
  CALL ShowDisplay
  CALL CleanPerif
  DisplayErrorLoop:     ;Keeps showing the Error untill "OK" is pressed
    MOV R0, OK
    MOVB R0,[R0]
    MOV R2, 30H
    SUB R0, R2
    CMP R0, 1
    JNZ DisplayErrorLoop  ;Keeps the loop going
  POP R2
  POP R0
  JMP ON                  ;Calls the FirstMenu



DisplayLogin:                   ;Displays a Menu for Login
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

    CALL GetUser
    CALL GetPass
    MOVB R0, [R3]               ;Places in R0 the value of the input OK
    MOV R7, 30H
    SUB R0, R7                  ;Converts the input from a string number to an integer number
    CMP R0, 1
  JNE LoginCycle              ;Keeps looping untill OK is "pressed"
  ;CALL BDCONSULT                ;Calls the consultation to the DataBase
  POP R0
  POP R1
  POP R2
  POP R3
  POP R4
  POP R5
  POP R7
  JMP ON

GetUser:                      ;Loops untill has cheked all user inputs
  PUSH R0
  PUSH R1
  PUSH R4
  PUSH R5
  PUSH R7
  MOV R0, USERB               ;Gets where the user input starts
  MOV R4, USERE               ;Gets where the user input ends
  MOV R2, USERSCREEN          ;Gets where in the screen is the user space
  ADD R4, 1                   ;Adds 1 to the password end position to make comparation easyer
  MOV R7, 5FH                 ;This is the ASCII code for "_"
    MOV R5, BDDATACHECK       ;Memory for a data comparation
  GetUserLoop:
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
    JNZ GetUserLoop               ;Keeps the loop going untill we have all characters
  POP R7
  POP R5
  POP R4
  POP R1
  POP R0
  RET

GetPass:                    ;Loops untill has checked all password inputs
  PUSH R0
  PUSH R1
  PUSH R2
  PUSH R4
  PUSH R5
  PUSH R7
  PUSH R8
  MOV R5, BDDATACHECK         ;Memory for a data comparation
  MOV R0, 8
  ADD R5, R0
  MOV R0, PASSB               ;Gets where the password input starts
  MOV R4, PASSE               ;Gets where the password input ends
  ADD R4, 1                   ;Adds 1 to the password end position to make comparation easyer
  MOV R2, PASSSCREEN          ;Gets where in the screen the password should be
  MOV R8, 2AH                 ;Saves the '*' to be placed as password in the screen
  MOV R7, 5FH                  ;This is the ASCII code for "_"

  GetPassLoop:
  MOVB R1, [R0]
  CMP R1, R7
  JZ NEXTCHARP
  MOVB [R2], R8
  NEXTCHARP:                ;Skips the screen input if there's nothing in the password
    MOVB [R5], R1
    ADD R0, 1
    ADD R2, 1
    ADD R5, 1
    CMP R0, R4
    JNZ GetPassLoop         ;Keeps the loop going untill we have all characters
  POP R8
  POP R7
  POP R5
  POP R4
  POP R2
  POP R1
  POP R0
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
  MOV R6, 16               ;Sets the end of comparation this is here so I can use R6 again
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
  MOV R9, R4              ;Places the memory position from the mached user so we can use it later on the program
ENDLOGIN:
POP R6
POP R5
POP R4
POP R3
POP R2
POP R1
POP R0
RET

DisplayRegistration:        ;Behaviour of the Menu Registration
PUSH R0
PUSH R2
PUSH R3
MOV R3, BDDATACHECK         ;Memory for a data comparation
MOV R2, RegistrationMenu    ;Screen to Display
CALL ShowDisplay
CALL CleanPerif
RegistrationCycle:
  CALL GetUser
  CALL GetPass
  MOV R0, OK
  MOVB R0, [R0]
  MOV R2, 30H
  SUB R0, R2
  CMP R0, 1
  JNZ RegistrationCycle
Call Register               ;Will attempt to save into the DataBase if theres no user with the same name
POP R5
POP R2
POP R0
RET

Register:
  PUSH R0
  PUSH R1
  PUSH R2
  PUSH R3
  PUSH R4
  PUSH R5
  PUSH R6
  MOV R0, BDDATACHECK   ;Checker
  MOV R1, BD
  MOV R2, BD
  MOV R3, 0             ;Counter
  MOV R4, 8             ;User length
  UserCheckLoop:
    MOVB R5, [R0]          ;First character
    MOVB R6, [R1]
    CMP R6, 0
    JZ Registering        ;The DataBase
    CMP R5, R6
    JNZ NextRegisterLoop  ;This user is not here
    ADD R0, 1             ;increments checker character
    ADD R1, 1
    ADD R3, 1
    CMP R3, R4
    JZ UserFound          ;User already exists cannot Register
    JMP UserCheckLoop     ;Keeps looping untill one of the breaks verify
  NextRegisterLoop:
    MOV R0, BDDATACHECK
    MOV R3, 0
    MOV R6, 20H
    ADD R2, R6
    MOV R1, R2
    JMP UserCheckLoop
  Registering:
    MOV R0, BDDATACHECK
    MOV R3, 0
    MOV R4, 16
    RegisteringLoop:
      MOVB R1, [R0]
      MOVB [R2], R1
      ADD R0, 1
      ADD R2, 1
      ADD R3, 1
      CMP R3, R4
      JZ RegisterEnd
      JMP RegisteringLoop

  UserFound:
    MOV R2, ErrorMenu
    CALL ShowDisplay
    CALL CleanPerif
    MOV R3, OK
    UserFoundLoop:
      MOV R2, 20H
      MOV R1, [R3]
      SUB R1, R2
      CMP R1, 1
      JNZ UserFoundLoop
  RegisterEnd:
  POP R6
  POP R5
  POP R4
  POP R3
  POP R2
  POP R1
  POP R0
  RET
