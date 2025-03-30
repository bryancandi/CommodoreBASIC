10 FOR I = 32 TO 255 : REM Change range as needed
20 IF I = 129 OR I = 144 OR I = 158 THEN GOTO 50 : REM Exclude some known color codes
21 IF I >= 131 AND I <= 161 THEN GOTO 50 : REM Exclude some color and empty character codes
25 PRINT I; " = "; CHR$(I);
26 COUNT = COUNT + 1
40 IF COUNT = 10 THEN GOSUB 100: COUNT = 0
50 NEXT I
60 END

100 PRINT : PRINT "PRESS ANY KEY TO CONTINUE"
110 GET A$
120 IF A$ = "" THEN 110
130 RETURN
