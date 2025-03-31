10 REM PRODUCE A STABLE MAZE
20 PRINT CHR$(147)
30 FOR I=1024 TO 2023
40 POKE I,77.5+RND(1)
50 NEXT I

100 REM SET INITIAL X AND Y WALKER LOCATION AND DIRECTION
110 REM DIRECTION IS EITHER 0 LEFT, 1 RIGHT, 2 UP, 3 DOWN
120 X=INT(RND(0) * 39) : XOLD=-1
130 Y=INT(RND(0) * 24) : YOLD=-1
140 DIR=INT(RND(0) * 3)
150 WALL=-1
160 GOSUB 500

200 REM WAIT FOR LEGAL MOVE GIVEN LOCATION AND DIRECTION
210 GET A$ : IF A$="" GOTO 210
220 IF A$=" " THEN GOSUB 600 : GOTO 120 : REM HYPERSPACE
230 REM 77=BKSLASH (SHIFT-M), 78=FWDSLASH (SHIFT-N) 0 LEFT, 1 RIGHT, 2 UP, 3 DOWN
240 IF WALL=78 THEN GOTO 310
245 REM UP
250 IF (DIR=0 OR DIR=3) AND ASC(A$)=145 THEN DIR=2 : GOTO 400
255 REM RIGHT
260 IF (DIR=0 OR DIR=3) AND ASC(A$)=29 THEN DIR=1 : GOTO 400
265 REM DOWN
270 IF (DIR=1 OR DIR=2) AND ASC(A$)=17 THEN DIR=3 : GOTO 400
285 REM LEFT
290 IF (DIR=1 OR DIR=2) AND ASC(A$)=157 THEN DIR=0 : GOTO 400
300 GOTO 200

310 REM DOWN
320 IF (DIR=0 OR DIR=2) AND ASC(A$)=17 THEN DIR=3 : GOTO 400
330 REM RIGHT
340 IF (DIR=0 OR DIR=2) AND ASC(A$)=29 THEN DIR=1 : GOTO 400
350 REM UP
360 IF (DIR=1 OR DIR=3) AND ASC(A$)=145 THEN DIR=2 : GOTO 400
370 REM LEFT
380 IF (DIR=1 OR DIR=3) AND ASC(A$)=157 THEN DIR=0 : GOTO 400
390 GOTO 200

400 IF DIR=0 THEN X=X - 1 : GOTO 450
410 IF DIR=1 THEN X=X + 1 : GOTO 450
420 IF DIR=2 THEN Y=Y - 1 : GOTO 450
430 IF DIR=3 THEN Y=Y + 1

450 REM DETERMINE IF THE WALKER IS OFF THE SCREEN
460 IF X >= 0 AND X <= 39 AND Y >= 0 AND Y <= 24 THEN GOTO 160
470 GOSUB 600
480 GOTO 10

500 REM DRAW WALKER, RESTORING PREVIOUS WALL CHARACTER
510 GOSUB 600
520 XOLD=X : YOLD=Y
530 M=1024 + X + (Y * 40)
540 WALL=PEEK(M)
550 C=55296 + X + (Y * 40)
560 POKE C, 1 : POKE M, 87
570 RETURN

600 REM RESTORE WALL AT PREVIOUS WALKER LOCATION
610 IF XOLD=-1 THEN GOTO 630
620 POKE 1024 + XOLD + (YOLD * 40), WALL
630 RETURN

