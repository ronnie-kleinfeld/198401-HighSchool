{$u+}
{$c+}

VAR
MAZE:ARRAY [0..71,0..21] OF BOOLEAN;
STEP:ARRAY [1..1400] OF INTEGER;
X2,Y2,S,D,E,C,A,X,Y,X1,Y1,Q:INTEGER;
CV:CHAR;
HEROIN :BOOLEAN;
A_,C_,Q_ : STRING[255];
BEGIN
HEROIN := FALSE;
REPEAT
X2:=0;
Y2:=0;
S:=0;
D:=0;
E:=0;
C:=0;
A:=0;
X:=0;
Y:=0;
X1:=0;
Y1:=0;
Q:=0;
CV:=' ';
CLRSCR;
FOR X := 1 TO 1400 DO STEP[X] := 0;
FOR X:=0 TO 71 DO BEGIN
        GOTOXY(71,X);IF X IN [1..20] THEN WRITE ('³');
        GOTOXY(X,21);IF X IN [1..70] THEN WRITE ('Ä');
        FOR Y:=0 TO 21 DO MAZE[X,Y]:=FALSE;
   END;
        GOTOXY(71,X);IF X<=20 THEN WRITE ('³');
        GOTOXY(X,21);WRITE ('Ä');
X:=1;Y:=1;C:=1;Q:=0;
GOTOXY(1,1); WRITE('þ');
  REPEAT
  Q:=Q+1;
  STEP[1]:=101;
  MAZE[X,Y]:=TRUE;
  gotoxy(1,22);write ('X=',X,' Y=',Y);
  GOTOXY(1,23);WRITE ('STEP=',C,' TOTAL=',Q);
    D:=0;
    REPEAT
    D:=D+1;
    IF D=11 THEN BEGIN
            E:=C;
            C:=RANDOM(40)+1;
            IF E<=C THEN REPEAT C:=C-6; UNTIL E>C
                    ELSE C:=E-C;
            X:=STEP[C] DIV 100;
            Y:=STEP[C] MOD 100;
                        FOR S:=C+1 TO E DO BEGIN
                          GOTOXY(STEP[S] DIV 100,STEP[S] MOD 100);
                          WRITE ('ù');
                          MAZE[STEP[S] DIV 100,STEP[S] MOD 100]:=FALSE;
                          END;
            END;
    X1:=X;Y1:=Y;
    A:=RANDOM(28)+1;
    IF (X1=1) OR (Y1=1) THEN A:=RANDOM(2)+7;
    IF X1=70 THEN A:=RANDOM(2)+3;
    IF Y1=20 THEN A:=6+RANDOM(2);
    CASE A OF
    1,2,7,9,11,16,19,12,18,25,28: X1 := X1 + 1;
    3,20,10,15,22,26,27         : X1 := X1 - 1;
    4,8,5,13,24           : Y1 := Y1 + 1;
    6,14,21,23            : Y1 := Y1 - 1;
    END;
    UNTIL (Y1 IN [1..20]) AND (X1 IN [1..70]) AND (NOT(MAZE[X1,Y1]));
    C:=C+1;
    X:=X1;Y:=Y1;
  X2:=STEP[C-1] DIV 100;
  Y2:=STEP[C-1] MOD 100;
  GOTOXY(X1,Y1);
  IF Y1=Y2 THEN WRITE('Ä');
  IF X1=X2 THEN WRITE('³');
  GOTOXY(X2,Y2);
  STEP[C]:=X1*100+Y;
  S:=STEP[C-2]-STEP[C];
  CASE S OF
  -101:IF Y2=Y1 THEN WRITE ('À') ELSE WRITE('¿');
   99 :IF Y1=Y2 THEN WRITE ('Ù') ELSE WRITE('Ú');
  -99 :IF Y1=Y2 THEN WRITE ('Ú') ELSE WRITE('Ù');
   101:IF Y1=Y2 THEN WRITE ('¿') ELSE WRITE('À');
   END;
UNTIL (X=70) AND (Y=20);
GOTOXY(70,20);WRITE('þ');

A_ := 'STEP=';
STR(C,C_);
STR(Q,Q_);
A_ := CONCAT(A_,C_);
A_ := CONCAT(A_,' TOTAL=');
A_ := CONCAT(A_,Q_);

write(A_);
writeLN(LST,A_);
UNTIL HEROIN;
END.