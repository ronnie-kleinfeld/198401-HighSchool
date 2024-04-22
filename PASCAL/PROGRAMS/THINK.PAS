{PROCEDURE GO(S:TABLE;
             Q:INTEGER);
             VAR T,G:INTEGER;
BEGIN
Z:=Z+1;
IF Q>F THEN F:=Q;
FOR A:=1 TO 7 DO
   FOR B:=1 TO 7 DO
      IF (A IN [3..5]) OR (B IN [3..5]) THEN
      IF S[A,B]='þ' THEN BEGIN
         COUNT:=0;
           REPEAT
            REPEAT
            COUNT:=COUNT+1;
              CASE COUNT OF
              1:BEGIN    LET2:='W';X:=A ;Y:=B-1;X1:=A;Y1:=B-2;END;
              2:BEGIN    LET2:='Z';X:=A ;Y:=B+1;X1:=A;Y1:=B+2;END;
              3:BEGIN    LET2:='A';X:=A-1 ;Y:=B;X1:=A-2;Y1:=B;END;
              4:BEGIN    LET2:='S';X:=A+1 ;Y:=B;X1:=A+2;Y1:=B;END;
              END;
            STAGE[Q].CH:=LET2;
{           GOTOXY(40,12);WRITE('        ');
            GOTOXY(40,12);WRITELN(X,' ',Y,' ',X1,' ',Y1,' ',S[X1,Y1]);}{
            FLAG:=(S[X,Y]='þ') AND (S[X1,Y1]='ù')
            UNTIL FLAG OR (COUNT=4);;
{         --------------------------------            }{
            IF FLAG THEN BEGIN
            S[A,B]:='ù';
            S[X,Y]:='ù';
            S[X1,Y1]:='þ';
                           {   GOTOXY(X1*4,Y1*3);WRITE(S[X1,Y1]);
                               GOTOXY(A*4,B*3);WRITE(S[A,B]);
                               GOTOXY(X*4,Y*3);WRITE(S[X,Y]);}{
            STAGE[Q].P:=A;STAGE[Q].O:=B;
            GOTOXY(40,10);
            WRITELN ('        ');
            GOTOXY(40,10);
            WRITELN (' ',F,' ',Q);
{           REPEAT UNTIL KEYPRESSED;}{
            END;
          T:=A;G:=B;
          IF Q>=ZX THEN BEGIN
                        FOR A:=1 TO Q DO BEGIN
                        WRITE (STAGE[A].P,' ',STAGE[A].O,STAGE[A].CH);
                        WRITE (FLE,STAGE[A]);
                        HALT;END;END;
          IF   FLAG THEN GO(S,Q+1);
          A:=T;B:=G;
          UNTIL (COUNT=4);
        END;

END;


    }
TYPE
    RG     = record
               AX,BX,CX,DX,BP,FI,DI,DS,ES,FLAG : integer;
             end;
    TABLE=ARRAY [1..7,1..7] OF CHAR;
STP=RECORD
     P,O:INTEGER;
     CH:CHAR;
     END;
VAR
STAGE:ARRAY [1..37] OF STP;
SAVERG:RG;
board:ARRAY [1..7,1..7] OF BOOLEAN;
Z,COUNT,X,Y,X1,Y1,A1,B1,A,B,C,D,E,F,K:INTEGER;
HELP:ARRAY[1..7,1..7] OF CHAR;
CV,LET1,LET2,CH:CHAR;
FLAG:BOOLEAN;
G:TABLE;
FUNCTION SCREEN(INCI1,INCI2:INTEGER):CHAR;
  var
    INCI3,INCI4 : integer;

  function ZIMZOM(INCI1 : integer) : integer;
    begin
      if INCI1>256
       then begin
              INCI1 :=INCI1-256;
              INCI1 :=ZIMZOM(INCI1);
            end;
      ZIMZOM :=INCI1;
    end;
  function get_char : integer;
    begin
      SAVERG.AX := $800;
      SAVERG.BX :=0;
      INTR($10,SAVERG);
      get_char :=SAVERG.AX;
    end;
  begin
    INCI3 :=WHEREX;
    INCI4 :=WHEREY;
    gotoxy(INCI1,INCI2);
    SCREEN :=chr(ZIMZOM(get_char));
    gotoxy(INCI3,INCI4);
  end;
PROCEDURE BARD;
BEGIN
FOR A:=1 TO 7 DO
    FOR B:=1 TO 7 DO  BEGIN
          CH:=' ';
          FLAG:=((A IN [3..5]) OR (B IN [3..5])) AND (A*B<>16);
          IF FLAG THEN CH:='þ' ;
          IF (A=4) AND (B=4) THEN CH:='ù';
          GOTOXY(A*4,B*3);WRITE(CH);
          END;

   END;

BEGIN
CLRSCR;
Z:=0;
BARD;
A:=4;B:=4;K:=0;
  REPEAT           {1}
  K:=K+1;
  GOTOXY(40,20);WRITE('STEP:',K);
  GOTOXY (5,23);WRITE
  ('ENTER YOUR MOVE {+ TO QUIT,- TO GO BACK}');
    REPEAT            {2}
    A1:=A;B1:=B;
    GOTOXY(A1*4,B1*3);
    IF SCREEN(A1*4,B1*3)='þ' THEN WRITE ('Û') ELSE
    IF SCREEN(A1*4,B1*3)='ù' THEN WRITE ('O');
    GOTOXY(20,23);READ(KBD,LET1);
      IF LET1=#27 THEN BEGIN    {3}
      READ(KBD,LET2);
        CASE ORD(LET2) OF
        77:A1:=A1+1;
        75:A1:=A1-1;
        72:B1:=B1-1;
        80:B1:=B1+1;
        END;
      END;                         {3}
    IF (SCREEN(A1*4,B1*3) IN ['þ','ù'])
    AND (LET1=#27)  THEN BEGIN        {4}
      GOTOXY(A*4,B*3);
      STAGE[K].P:=A1;
      STAGE[K].O:=B1;
      IF SCREEN (A*4,B*3)='Û' THEN WRITE ('þ')
      ELSE IF SCREEN (A*4,B*3)='O' THEN WRITE ('ù');
      A:=A1;B:=B1;
      END;                               {4}
    UNTIL (LET1=#13) AND (SCREEN(A*4,B*3)='Û') OR (LET1='+') OR (LET1='-');{2}
      IF LET1=#13 THEN BEGIN      {5}
      GOTOXY(5,23);WRITE
      ('ENTER YOUR DIRECTION {A/S/W/Z}:        ');
      LET2:=' ';
        REPEAT                       {6}
          IF LET2<>' ' THEN BEGIN       {7}
          GOTOXY(5,22);WRITE('IMPOSSIBLE MOVE!!!!!');
          FOR E:=1 TO 9999 DO E:=E;
          GOTOXY(5,22);WRITE('                    ');
          END;                             {7}
        GOTOXY(36,23);READ (KBD,LET2);
          CASE LET2 OF
          'W':BEGIN    X:=A ;Y:=B-1;X1:=A;Y1:=B-2;END;
          'Z':BEGIN    X:=A ;Y:=B+1;X1:=A;Y1:=B+2;END;
          'A':BEGIN    X:=A-1 ;Y:=B;X1:=A-2;Y1:=B;END;
          'S':BEGIN    X:=A+1 ;Y:=B;X1:=A+2;Y1:=B;END;
          END;
        STAGE[K].CH:=LET2;
        FLAG:=(SCREEN(X*4,Y*3)='þ') AND (SCREEN(X1*4,Y1*3)='ù');
        UNTIL FLAG OR (LET2='Q');            {6}
          IF FLAG THEN BEGIN                  {8}
          GOTOXY(A*4,B*3);WRITE ('ù');
          GOTOXY(X*4,Y*3);WRITE ('ù');
          GOTOXY(X1*4,Y1*3);WRITE ('þ');
          A:=X1;B:=Y1;
          END                                    {8}
        ELSE K:=K-1;
        END;                                {5}

     IF LET1='-' THEN BEGIN
     K:=K-1;
     CLRSCR;
     CLRSCR;
     BARD;
     F:=0;
     REPEAT
      F:=F+1;
       A:=STAGE[F].P;B:=STAGE[F].O;
         CASE STAGE[F].CH OF
         'W':BEGIN    X:=A ;Y:=B-1;X1:=A;Y1:=B-2;END;
         'Z':BEGIN    X:=A ;Y:=B+1;X1:=A;Y1:=B+2;END;
         'A':BEGIN    X:=A-1 ;Y:=B;X1:=A-2;Y1:=B;END;
         'S':BEGIN    X:=A+1 ;Y:=B;X1:=A+2;Y1:=B;END;
         END;
       GOTOXY(A*4,B*3);WRITE ('ù');
       GOTOXY(X*4,Y*3);WRITE ('ù');
       GOTOXY(X1*4,Y1*3);WRITE ('þ');
      GOTOXY(5,23);
      WRITELN('PRESS ANY KEY TO CONTINUE,OR {S} TO STOP');
      READ(KBD,CV);
     UNTIL (F=K-1) OR (CV='S');
     K:=F;
     END;

 UNTIL LET1='+';                               {1}
 WRITELN;
 CLRSCR;
 FOR F:=1 TO K-1 DO
 WITH STAGE[F] DO BEGIN
      GOTOXY(25*(F MOD 3),F DIV 3+1);
      WRITELN (P,' ',O,' ',CH,'-------------------')     END
END.