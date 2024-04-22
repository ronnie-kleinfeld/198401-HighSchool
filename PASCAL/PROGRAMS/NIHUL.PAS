program NIHUL;
  type
    PEOLOT      = record
                    SIGN  : char;
                    KOD   : integer;
                    MONEY : real;
                    DATE  : string[6];
                    DATEA : string[6];
                    BAL   : real;
                  end;
    REGTYPE     = record
                    AX,BX,CX,DX,BP,SI,DI,DS,ES,FLAGS : integer;
                  end;
    HALFREGTYPE = record
                    AL,AH,BL,BH,CL,CH,DL,DH          : byte
                  end;
    GA_ = string[255];
  var
    F1                                              : FILE OF PEOLOT;
    R1                                              : PEOLOT;
    REGS                                            : REGTYPE;
    SAVEREG                                         : REGTYPE;
    SAVEHALF                                        : HALFREGTYPE absolute SAVEREG;
    A,B,C,D,E,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z : integer;
    YIT,YI                                          : real;
    INCI1,INCI2,INCI3,INCI4,INCI5,INCI6,INCI7,INCI8,
    INCI9,INCI10,INCI11,INCI12,INCI13,INCI14,INCI15 : integer;
    A_,B_,C_,D_,E_,F_,G_                            : string[255];
    INCS1,INCS2,INCS3,INCS4,INCS5,INCS6             : string[255];
    CH_,VIEW_,CH2_,CH3_                             : char;
    INCC1,INCC2,INCC3                               : char;
    INCB1                                           : boolean;

  const
    INKEYP : boolean = false;
    INC15  : STRING[27] = 'tcdsvuzjyhlfkonibxg;p.mera,';
    TAF : array[65..79] of GA_ = (
     '… …—”','… —”','— …—”','… …’',
     '…… …’','— €–…','’— …€… …','… …’',
     '… …€–…','…”‘','€€ ‘','… €',' €',
     '… ','… ');

  function EXIST(FILENAME : GA_) : boolean;
    var
      FIL : FILE;
    begin
      assign(FIL,FILENAME);
      {$I-};
      reset(fil);
      EXIST := ioresult = 0;
      {$I+};
      close(FIL);
    end;

  procedure OPEN_FILE;
    begin
      if EXIST('NIHUL.DAT')
       then begin
              assign(F1,'NIHUL.DAT');
              reset(F1);
            end
       else begin
              assign(F1,'NIHUL.DAT');
              rewrite(F1);
              R1.SIGN  := ' ';
              R1.KOD   := 0;
              R1.MONEY := 0;
              R1.DATE  := '';
              R1.DATEA := '';
              R1.BAL   := 0;
              seek(F1,1);
              write(F1,R1);
            end;
    end;

  function INKEY : char;
    var
      AC : char;
    begin
      if INKEYP
       then begin
              INKEY  := AC;
              INKEYP := false;
            end
       else begin
              SAVEREG.AX := 0;
              intr($16,SAVEREG);
              if SAVEHALF.AL = 0
               then begin
                      INKEY  := #27;
                      AC     := chr(SAVEHALF.AH);
                      INKEYP := true;
                    end
               else begin
                      INKEY  := chr(SAVEHALF.AL);
                      INKEYP := false;
                    end;
           end;
    end;

  function SCREEN(INCI1,INCI2 : integer) : char;
    function ZIMZOM(INCI1 : integer) : integer;
      begin
        if INCI1>256 then begin
                           INCI1 := INCI1-256;
                           INCI1 := ZIMZOM(INCI1);
                         end;
         ZIMZOM := INCI1;
       end;
    function GET_CHAR : integer;
      begin
        SAVEREG.AX := $800;
        SAVEREG.BX := 0;
        INTR($10,SAVEREG);
        GET_CHAR := SAVEREG.AX;
      end;
    begin
      INCI3 := WHEREX;
      INCI4 := WHEREY;
      gotoxy(INCI1,INCI2);
      SCREEN := chr(ZIMZOM(GET_CHAR));
      gotoxy(INCI3,INCI4);
    end;
  function LEFT(INCS1 : GA_; INCI1 : integer) : GA_;
    begin
      LEFT := copy(INCS1,1,INCI1);
    end;

  function RIGHT(INCS1 : GA_; INCI1 : integer) : GA_;
    begin
      RIGHT := copy(INCS1,length(INCS1)-INCI1+1,INCI1);
    end;

  function POST(INCS1,INCS2 : GA_; INCI1 : integer) : integer;
    begin
      POST := pos(INCS2,right(INCS1,INCI1));
    end;

  function VAT(INCS6 : GA_) : integer;
    begin
      val(INCS6,INCI13,INCI14);
      VAT := INCI13;
    end;

{--------------------------------------------------------------------------}

  function INPUT_D(INCI4,INCI5 : integer;INCC3 : char;INCS2 : GA_) : GA_;
    const
      INPUT_MIN : array[1..6] of char = ('0','0','0','0','0','0');
      INPUT_MAX : array[1..6] of char = ('3','9','1','9','9','9');
      DATE_KOD       : boolean             = true;
    begin
      if DATE_KOD then begin
                    INCI1   := wherex;
                    INCI2   := wherey;
                    DATE_KOD := false;
                  end;
      gotoxy(INCI4,INCI5); for INCI3 := 1 to 6 do write(INCC3);
      gotoxy(INCI4,INCI5); write(INCS2);
      INCI13 := INCI4;
      INCI14 := INCI5;
      INCI6  := INCI4;
      INCI8  := INCI4;
      INCI7  := INCI6+5;
      repeat
       gotoxy(INCI4,INCI5);
       INCS1  := INKEY;
       INCC1 := right(INCS1,1);
       INCC2 := left (INCS1,1);
       case INCC2 of
        #27       : case INCC1 of
                     #27 : begin
                             gotoxy(INCI6,INCI5); for INCI3 := 1 to 6 do write(INCC3);
                             INCI4 := INCI6;
                             INCI8 := INCI6;
                           end;
                     #75 : INCI4 := INCI4-1;
                     #77 : INCI4 := INCI4+1;
                    end;
        #32..#255 : if INCI4 = INCI7+1
                     then write(#7)
                     else begin
                            if (INCC2 < INPUT_MIN[INCI4-INCI6+1]) or (INCC2 > INPUT_MAX[INCI4-INCI6+1])
                             then INCC2 := #27;
                            if not (INCC2 in ['0'..'9']) then INCC2 := #27;
                            if INCC2 <> #27
                             then begin
                                    write(INCC2);
                                    INCI4 := INCI4+1;
                                    INCI8 := INCI8+1;
                                  end;
                          end;
       end;
       if INCI4 > INCI7 then INCI4 := INCI7+1;
       if INCI8 > INCI7 then INCI8 := INCI7+1;
       if INCI4 < INCI6 then INCI4 := INCI6;
      until INCC2 = #13;
      INCS1 := '';
      for INCI15 := INCI13 to INCI13+6 do INCS1 := INCS1+SCREEN(INCI15,INCI14);
      if (length(INCS1) = 6) and ((VAT(left(INCS1,2))   <  1) or
                                  (VAT(left(INCS1,2))   > 31) or
                                  (VAT(copy(INCS1,3,2)) <  1) or
                                  (VAT(copy(INCS1,3,2)) > 12))
       then begin
              write(#7);
              INCS1 := INPUT_D(INCI6,INCI5,INCC3,INCS2);
            end;
      INPUT_D := INCS1;
      gotoxy(INCI1,INCI2);
    end;

  function INPUT_N(INCI4,INCI5,INCI6,INCI7 : integer;INCC1 : char) : GA_;
    procedure INPUT_M;
      begin
        INCI10 := INCI8+2;
        INCI11 := INCI8+INCI7+1;
        INCI12 := INCI10;
        repeat
         gotoxy(INCI10,INCI5); write(INCS3);
         gotoxy(INCI12,INCI5);
         INCS1 := INKEY;
         INCC3 := right(INCS1,1);
         INCC2 := left (INCS1,1);
         case INCC2 of
          #08      : if INCI12 = INCI10
                      then exit
                      else begin
                             INCS3 := left(INCS3,length(INCS3)-1);
                             gotoxy(INCI12-1,INCI5); write(INCC1);
                             INCI12 := INCI12-1;
                           end;
          #27      : if INCC3 = #27
                      then begin
                             gotoxy(INCI10,INCI5); for INCI3 := 1 to INCI7 do write(INCC1);
                             INCS3  := '';
                             INCI12 := INCI10;
                           end;
          #48..#57 : if INCI12 = INCI11+1
                      then write(#7)
                      else begin
                             INCS3  := INCS3+INCC2;
                             INCI12 := INCI12+1;
                           end;
         end;
        until INCC2 = #13;
      end;

    begin
      INCI1 := wherex;
      INCI2 := wherey;
      INCS2 := '';
      INCS3 := '';
      gotoxy(INCI4,INCI5); for INCI3 := 1 to INCI6 do write(INCC1);
      if INCI7 <> 0
       then begin
              write('.');
              for INCI3 := 1 to INCI7 do write(INCC1);
            end;
      INCI8 := INCI4+INCI6-1;
      INCI9 := INCI4;
      INCI4 := INCI8;
      repeat
       gotoxy(INCI4+1,INCI5); write(INCS2);
       gotoxy(INCI8,INCI5);
       INCS1 := INKEY;
       INCC3 := right(INCS1,1);
       INCC2 := left (INCS1,1);
       case INCC2 of
        #08      : if INCI4 = INCI8
                    then write(#7)
                    else begin
                           INCS2 := left(INCS2,length(INCS2)-1);
                           gotoxy(INCI4+1,INCI5); write(INCC1);
                           INCI4 := INCI4+1;
                         end;
        #27      : case INCC3 of
                    #27 : begin
                            gotoxy(INCI9,INCI5); for INCI3 := 1 to INCI6 do write(INCC1);
                            INCS2 := '';
                            INCI4 := INCI8;
                          end;
                   end;
        #46      : if INCI7 <> 0 then INPUT_M;
        #48      : if INCI4 = INCI8
                    then write(#7)
                    else begin
                           INCS2 := INCS2+INCC2;
                           INCI4 := INCI4-1;
                         end;
        #49..#57 : if INCI4 = INCI9-1
                    then write(#7)
                    else begin
                           INCS2 := INCS2+INCC2;
                           INCI4 := INCI4-1;
                         end;
       end;
      until INCC2 = #13;
      INPUT_N := INCS2;
      if INCI7 <> 0 then INPUT_N := INCS2+'.'+INCS3;
      if INCS3 = ''   then INPUT_N := INCS2+'.0';
      if (length(INCS2) = 0) and (length(INCS3) = 0) then INPUT_N := '';
      gotoxy(INCI1,INCI2);
    end;

{--------------------------------------------------------------------------}

  procedure MAIN_MENU;
    begin
      clrscr;
      writeln('');
      writeln('        By Raanan Kleinfeld   1987 (c) All rights reserved MADA');
      writeln('');
      writeln('');
      writeln('');
      writeln('  .… € .L        .— €–… .F     .… …—” .A');
      writeln(' . € .M   .’— …€… … .G       .… —” .B');
      writeln('   .…  .N        .… …’ .H        .— …—” .C');
      writeln('   .…  .O     .… …€–… .I        .… …’ .D');
      writeln('                              .…”‘ .J     .…… …’ .E');
      writeln('                         .€€ ‘ .K');
      writeln('');
      writeln('                                . .P');
      writeln('');
      writeln('                                .…‘ .Q');
      writeln('');
      writeln('                           _ :  —');
      CH_ := INKEY;
      CH_ := upcase(CH_);
      if not (CH_ in ['A'..'Q'])
        then begin
               write(#7);
               MAIN_MENU;
             end;
    end;

  procedure OD_PAAM;
    begin
      gotoxy(28,22); write('_ ? (€- ,-) € …’');
      CH2_:= INKEY;
      if CH2_ in ['k','K',''] then CH_ := ' ';
    end;

  procedure PAGE;
    procedure GET_MONEY;
      begin
        B_ := INPUT_N(50,10,5,1,'0');
        if B_ = '' then GET_MONEY;
        YI := VAT(B_) + VAT(right(B_,1))/10;
      end;
    begin
      gotoxy(12,05); write('ษออออออออออออัออออออออออัออออออออออัออออออออออัอออออป');
      gotoxy(12,06); write('บ        ณ .’ € ณ   €  ณ   …‘   ณ …— บ');
      gotoxy(12,07); write('วฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤถ');
      gotoxy(12,08); write('บ            ณ          ณ          ณ          ณ     บ  …—');
      gotoxy(12,09); write('วฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤถ');
      gotoxy(12,10); write('บ            ณ          ณ          ณ          ณ     บ …');
      gotoxy(12,11); write('ศออออออออออออฯออออออออออฯออออออออออฯออออออออออฯอออออผ');
      seek(F1,filesize(F1)-1);
      read(F1,R1);
      gotoxy(15,8); write(R1.BAL:9:1);
      gotoxy(28,8); write(R1.DATEA);
      gotoxy(39,8); write(R1.DATE);
      gotoxy(50,8); write(R1.MONEY:7:1);
      gotoxy(60,8);
      if R1.KOD = 0 then write('---')
                    else write(R1.KOD:3);
      A_  := INPUT_N(60,10,3,0,'0');
      if A_ = '' then begin
                        A := 0;
                        gotoxy(60,10); write('---');
                      end
                 else A := VAT(A_);
      GET_MONEY;
      C_  := INPUT_D(39,10,'0','010187');
      D_  := INPUT_D(28,10,'0','010187');
      YIT := YI*S+R1.BAL;
      gotoxy(15,10); write((YIT):9:1);
      R1.SIGN  := CH_;
      R1.KOD   := A;
      R1.MONEY := YI;
      R1.DATE  := C_;
      R1.DATEA := D_;
      R1.BAL   := YIT;
      seek(F1,filesize(F1));
      write(F1,R1);
    end;

  procedure ASK_KEY;
    begin
      CH3_ := INKEY;
      CH3_ := upcase(CH3_);
      if not (CH3_ in ['A'..'O','Z'])
        then begin
               write(#7);
               ASK_KEY;
             end;
    end;

  procedure CASES;
    begin
      case CH_ of
       'Q' : halt;
       'A'..'O' : begin
                    clrscr;
                    gotoxy((80-length(TAF[ord(CH_)])) div 2,2); write(TAF[ord(CH_)]);
                    case CH_ of
                     'A'..'E','L','O' : S := +1;
                     'F'..'J','M','N' : S := -1;
                    end;
                    PAGE;
                    OD_PAAM;
                  end;
       'P' : begin
               gotoxy(18,14); write('_ : ……’”  (Z) …€ …‘ …’” ’ •');
               gotoxy(1,15);  write('                                                                               ');
               gotoxy(1,16);  write('                                                                               ');
               gotoxy(1,17);  write('                                                                               ');
               ASK_KEY;
               clrscr;
               gotoxy(4,01); write('ษออออออออออออัออออออออออัออออออออออัออออออออออัอออออัออออออออออออออออออัอออป');
               gotoxy(4,02); write('บ        ณ .’ € ณ . € ณ   …‘   ณ …— ณ     …’”      ณ – บ');
               gotoxy(4,03); write('วฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤถ');
               for I := 4 to 21 do
                begin
                  gotoxy(4,I); write('บ            ณ          ณ          ณ          ณ     ณ                  ณ   บ');
                end;
               gotoxy(4,22); write('ศ            <- "‘ อออฯออออออออออฯออออออออออฯอออออฯออออออออออออออออออฯอออผ');
               seek(F1,filesize(F1)-1);
               read(F1,R1);
               gotoxy(06,22); write(R1.BAL:10:1);
               I := 1;
               repeat
                J := 0;
                repeat
                 J := J + 1;
                 I := I + 1;
                 seek(F1,I);
                 read(F1,R1);
                 if (CH3_ = 'Z') or (CH3_ = R1.SIGN)
                  then begin
                         gotoxy(06,J+3); write(R1.BAL:10:1);
                         gotoxy(20,J+3); write(R1.DATEA);
                         gotoxy(31,J+3); write(R1.DATE);
                         gotoxy(41,J+3); write(R1.MONEY:8:1);
                         gotoxy(52,J+3);
                         if R1.KOD = 0 then write('---')
                                       else write(R1.KOD:3);
                         gotoxy(58,J+3); write(TAF[ord(R1.SIGN)]:16);
                         gotoxy(77,J+3); write(R1.SIGN);
                       end
                  else J := J -1;
                until (J = 18) or (I = filesize(F1)-1);
                if J <> 18
                 then for K := J+1 to 18 do
                       begin
                         gotoxy(4,K+3); write('บ            ณ          ณ          ณ          ณ     ณ                  ณ   บ')
                       end;
                gotoxy(26,22); write('  … — ’ •');
                CH2_ := INKEY;
                gotoxy(4,22); write('ศ            <- "‘ อออฯออออออออออฯออออออออออฯอออออฯออออออออออออออออออฯอออผ');
                seek(F1,filesize(F1)-1);
                read(F1,R1);
                gotoxy(06,22); write(R1.BAL:10:1);
               until I = filesize(F1)-1;
               CH_ := ' ';
             end;
       else CH_ := ' ';
      end;
      if CH_ <> ' ' then CASES;
      MAIN_MENU;
      CASES;
    end;

begin
  SAVEREG.CX := $2000;
  SAVEREG.AX := $0100;
  intr($10,SAVEREG);
  OPEN_FILE;
  MAIN_MENU;
  CASES;
end.