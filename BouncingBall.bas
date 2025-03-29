10  REM BOUNCING BALL
20  PRINT "{CLR/HOME}" : REM Replace {CLR/HOME} with the clear-screen character
25  FOR X = 1 TO 10 : PRINT "{CRSR/DOWN}" : NEXT : REM Replace {CRSR/DOWN} with the actual cursor-down character
30  FOR BL = 1 TO 40
40  PRINT " ●{CRSR LEFT}"; : REM Replace {CRSR LEFT} with the actual cursor-left character
50  FOR TM = 1 TO 5
60  NEXT TM
70  NEXT BL
75  REM MOVE BALL RIGHT TO LEFT
80  FOR BL = 40 TO 1 STEP -1
90  PRINT " {CRSR LEFT}{CRSR LEFT}●{CRSR LEFT}"; : REM Same as above
100 FOR TM = 1 TO 5
110 NEXT TM
120 NEXT BL
130 GOTO 20