PROCEDURE GET (VAR
                   WORD:MICK;                           { „ˆ‰Œ—Œ „š™Ž„ }
                   QUAN:INTEGER   );                    {  ‰˜‰Ž„ …‹˜…€ }
LABEL GT;
 VAR
     GWORD1:STRING[255];
     GFLAG:BOOLEAN;
     GC:CHAR;
     GIM,GI,GK,GX,GY:INTEGER;

BEGIN
 GIM:=0;GI:=0;GX:=WHEREX;GY:=WHEREY;
 IF FG1 THEN BEGIN
   GIM:=LENGTH(WORD);
   GWORD1:='';
   FOR GK:=GIM DOWNTO 1 DO GWORD1:=GWORD1+WORD[GK];
   WORD:=GWORD1;
   END;
 REPEAT
    GFLAG:=FALSE;
          GI:=GI+1;
          GT:GOTOXY(GX-GI+1,GY);
          READ(KBD,GC);
          IF (NOT (GC IN [#8,#13,#27])) AND  (GI>QUAN) THEN GOTO GT;
          IF (GC=#08) AND ((GI-1)=GIM) AND (GI<>1) THEN BEGIN { „—‰‡Ž }
                            GI:=GI-1;
                            GOTOXY(GX-GI+1,GY);WRITE(#32);GIM:=GIM-1;
                            WORD:=COPY(WORD,1,LENGTH(WORD)-1);
                            END;
          IF GC=#27 THEN BEGIN                              { Ž‘„ š††„ }
                         READ (KBD,GC);
                         IF (GC=#77) AND (GI>1) THEN GI:=GI-1;
                         IF (GC=#75) AND (GI<=GIM) THEN GI:=GI+1;
                         GOTO GT
                         END;
          FOR GK:=1 TO 27 DO IF GC=V[GK] THEN GC:=CHR(GK+127);
          FOR GK:=1 TO 27 DO IF GC=V1[GK] THEN GC:=CHR(GK+127);
          IF GC=#39 THEN GC:=',';
          IF GC IN ['W','w'] THEN GC:=#39;
          IF GC='/' THEN GC:='.';
          GFLAG:=GC IN [#13,#127..#155,'(',')',#39,#44..#57,#28,#32,'"'];
          IF NOT GFLAG THEN GOTO GT;
          IF GC<>#13 THEN BEGIN
          IF GIM<GI THEN GIM:=GI;
          WORD[GI]:=GC;
          END;
          GOTOXY(GX-GI+1,GY);WRITE(GC);
          UNTIL GC=#13;
 GWORD1:='';
 GK:=GIM+1;
 REPEAT
 GK:=GK-1;
 IF WORD[GK]=#32 THEN GIM:=GIM-1;
 UNTIL WORD[GK]<>#32;
 FOR GK:=GIM DOWNTO 1 DO GWORD1:=GWORD1+WORD[GK];
 WORD:=GWORD1;
 END;
