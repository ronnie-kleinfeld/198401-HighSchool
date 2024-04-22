{$u+}
{$c+}

VAR
MAZE:ARRAY [0..71,0..21] OF BOOLEAN;
STEP:ARRAY [1..1400] OF INTEGER;
X3,Y3,X2,Y2,S,D,E,C,B,A,X,Y,X1,Y1:INTEGER;
BLOCK,Z:BOOLEAN;
CV:CHAR;
BEGIN
CLRSCR;
FOR X:=0 TO 71 DO
      FOR Y:=0 TO 21 DO BEGIN
                        MAZE[X,Y]:=FALSE;
                        END;
{
FOR Y:=1 TO 20 DO WRITELN(
'שששששששששששששששששששששששששששששששששששששששששששששששששששששששששששששששששששששש');
}
  FOR X:=1 TO 70 DO BEGIN
        GOTOXY(71,X);IF X<=20 THEN WRITE ('³');
        GOTOXY(X,21);WRITE ('ִ');END;
X:=1;Y:=1;B:=65;C:=0;
GOTOXY(1,1); WRITE('‏');
  REPEAT
  C:=C+1;
  STEP[C]:=X*100+Y;
  MAZE[X,Y]:=TRUE;
  gotoxy(1,22);write ('X=',X,' Y=',Y);
    D:=0;
    REPEAT
    D:=D+1;
    IF D=11 THEN BEGIN
            E:=C;
            C:=RANDOM(20)+1;
            IF E>20 THEN C:=E-C;
            X:=STEP[C] DIV 100;
            Y:=STEP[C] MOD 100;
                        FOR S:=C+1 TO E DO BEGIN
                          GOTOXY(STEP[S] DIV 100,STEP[S] MOD 100);
                          WRITE ('ש');
                          MAZE[STEP[S] DIV 100,STEP[S] MOD 100]:=FALSE;
                          END;
            END;
    X1:=X;Y1:=Y;
    A:=RANDOM(7)+1;
    IF (X1=1) OR (Y1=1) THEN A:=RANDOM(2)+7;
    IF X1=70 THEN A:=RANDOM(2)+3;
    IF Y1=20 THEN A:=6+RANDOM(2);
    CASE A OF
    1,2,7 : X1 := X1 + 1;
    3     : X1 := X1 - 1;
    4,8   : Y1 := Y1 + 1;
    6     : Y1 := Y1 - 1;
    END;
 {   BLOCK:=MAZE[X1+1,Y1] AND MAZE[X1-1,Y1] OR
          MAZE[X1,Y1+1] AND MAZE[X1,Y1-1]}
    UNTIL (ABS(Y1*2-21)<=19) AND (ABS(X1*2-71)<=69) AND (NOT(MAZE[X1,Y1]));
    X:=X1;Y:=Y1;
  X2:=STEP[C-1] DIV 100;
  Y2:=STEP[C-1] MOD 100;
  X3:=STEP[C-2] DIV 100;
  Y3:=STEP[C-2] MOD 100;
  IF Y1=Y2 THEN WRITE('ֽ');
  IF X1=X2 THEN WRITE('÷');
  GOTOXY(X2,Y2);
{   2
    ש
1 ש ‏ ש 3
    ש
    4    }

{1}
  IF (X1<X2) AND (X2=X3) AND (Y3<Y2) THEN WRITE('¼');
  IF (X1<X2) AND (X2=X3) AND (Y3>Y2) THEN WRITE('»');
{2}
  IF (Y1<Y2) AND (Y2=Y3) AND (X3<X2) THEN WRITE('¼');
  IF (Y1<Y2) AND (Y2=Y3) AND (X3>X2) THEN WRITE('ָ');
{3}
  IF (X1>X2) AND (X2=X3) AND (Y3<Y2) THEN WRITE('ָ');
  IF (X1>X2) AND (X2=X3) AND (Y3>Y2) THEN WRITE('ֹ');
{4}
  IF (Y1>Y2) AND (Y2=Y3) AND (X3<X2) THEN WRITE('»');
  IF (Y1>Y2) AND (Y2=Y3) AND (X3>X2) THEN WRITE('ֹ');

{ GOTOXY(X1,Y1);READ(KBD,CV);}
UNTIL (X=70) AND (Y=20);
GOTOXY(70,20);WRITE('‏');
END.