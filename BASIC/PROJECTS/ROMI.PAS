{  INPUT_N(LINE, COLUMN, LENGTH, LENGTH:integer; DELETE:char):G255
    - return a string
       KOD - (English)
              0 - All keyboard (only English).
              1 - All keyboard (English \ Hebrew).
              2 - File name.
              3 - Hexadecimal.
}

Program ROMI;
  type
    MAIN       = record
                   CITY             : integer;
                   STROE_           : string[30];
                   ADRESS_          : string[50];
                   NAME_            : string[15];
                   PHONE1_,
                   PHONE2_,
                   PHONE3_          : string[12];
                   EXE              : boolean;
                 end;
    CITY       = record
                   NUMBER           : integer;
                   CNTY_            : string[20];
                 end;
    REGTYPE     = record
                    AX,BX,CX,DX,BP,SI,DI,DS,ES,FLAGS : integer;
                  end;
    HALFREGTYPE = record
                    AL,AH,BL,BH,CL,CH,DL,DH          : byte
                  end;
    G255     = string[255];
  const
    INC15 : STRING[27] = 'tcdsvuzjyhlfkonibxg;p.mera,';

    VG  : string[27] = 'tcdsvuzjyhlfkonibxg;p.mera,';
    VG1 : string[27] = '€…‘’“”•–—';

  var
    F1                        : FILE OF MAIN;
    R1                        : MAIN;
    F2                        : FILE OF CITY;
    R2                        : CITY;
    REGS,SAVEREG              : REGTYPE;
    SAVEHALF                  : HALFREGTYPE absolute SAVEREG;
    A,B,C,D,E,F,G,H,I,J,K,L,M : integer;
    A_,B_,C_,D_,E_,F_,G_,H_,
    I_,J_,K_,L_,M_            : string[255];
    INKEYP                    : boolean;
    CH_                       : char;
    PROGRAM_END               : BOOLEAN;
    WIK                                 : array[1..25,1..80] of char;
    INCI1,INCI2,INCI3,INCI4,INCI5,INCI6,INCI7,
    INCI8,INCI9,INCI10,INCI11,INCI12,INCI100,
    INCI101,INCI102,GETAA,GETLEN,GETI                        : integer;
    INCS1,INCS2,INCS3,INCS4,INCS5,INCS6,GETB_,GETMIKE_,ENT_  : G255;
    INCC1,INCC2,INCC3,GETDEL,GETCH_     : char;
    INCB1                               : boolean;
    INCY1                               : byte;

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

  procedure CURSOR(TURNON : byte);
    begin
      case INCY1 of
       0 : EXIT; {SAVEREG.CX := $2000;}
       2 : if mem[0 : $449] = 7
            then SAVEREG.CX := $0C0D
            else SAVEREG.CX := $0607;
       1 : if mem[0 : $449] = 7
            then SAVEREG.CX := $070D
            else SAVEREG.CX := $0607;
      end;
      SAVEREG.AX := $0100;
      intr($10,SAVEREG)
    end;

  function LEFT(INCS1 : G255; INCI1 : integer) : G255;
    begin
      LEFT := copy(INCS1,1,INCI1);
    end;

  function RIGHT(INCS1 : G255; INCI1 : integer) : G255;
    begin
      RIGHT := copy(INCS1,length(INCS1)-INCI1+1,INCI1);
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

  function INKWY : G255;
    begin
      SAVEREG.AX := 0;
      intr($16,SAVEREG);
      INCS1 := '';
      if SAVEHALF.AL = 0
       then INCS1 := #27+chr(SAVEHALF.AH)
       else INCS1 := chr(SAVEHALF.AL);
      INKWY := INCS1;
    end;

  function GET(GETX,GETY,GETLEN:integer; GETDEL:char):G255;
    procedure GETB;
      begin
        repeat
         gotoxy(GETAA,GETY);
         INCS1 := INKWY;
         INCC3 := right(INCS1,1);
         INCC2 := left (INCS1,1);
         case INCC2 of
{—}   #08 : begin
                  if GETX+GETLEN-1-GETAA>0 then
                   begin
                     GETMIKE_ := right(GETMIKE_,length(GETMIKE_)-1);
                     GETAA := GETAA + 1;
                     gotoxy(GETAA,GETY); write(GETDEL);
                   end;
                end;
          #27 : begin
                  case INCC3 of
                   #65 : begin
                           ENT_ := '***';
                           GET  := 'A';
                           exit;
                         end;
                   #27 : begin
                           ENT_ := 'ESC';
                           GET  := 'A';
                           exit;
                         end;
                  end;
                end;
{…}  #32..#255 : begin
                        if GETAA>GETX-1 then
                         begin
                           GETI := 0;
                           repeat
                            GETI := GETI + 1;
                           until (copy(VG,GETI,1)=INCC2) or (GETI=28);
                           if copy(VG,GETI,1)=INCC2 then INCC2 := copy(VG1,GETI,1);
                           GETMIKE_ := INCC2 + GETMIKE_;
                           gotoxy(GETAA,GETY); writeln(GETMIKE_);
                           GETAA := GETAA - 1;
                         end;
                   end;
         end;
        until INCC2=#13;
      end;
    begin
      ENT_  := '';
      GETB_ := '';
      for GETI := 1 to GETLEN do GETB_ := GETB_ + GETDEL;
      gotoxy(GETX,GETY); write(GETB_);
      GETAA := GETX+GETLEN-1;
      GETMIKE_ := '';
      GETB;
      if ENT_ <> '' then exit;
      GET := GETMIKE_;
    end;

  function INPUT_N(INCI4,INCI5,INCI6,INCI7 : integer;INCC1 : char) : G255;
    begin
      INCI1 := wherex;
      INCI2 := wherey;
      INCS2 := '';
      INCS3 := '';
      CURSOR(1);
      gotoxy(INCI4,INCI5); for INCI3 := 1 to INCI6 do write(INCC1);
      if INCI7 <> 0
       then begin
              write('-');
              for INCI3 := 1 to INCI7 do write(INCC1);
            end;
      INCI8 := INCI4+INCI6-1;
      INCI9 := INCI4;
      INCI4 := INCI8;
      repeat
       CURSOR(0);
       gotoxy(INCI4+1,INCI5); write(INCS2);
       CURSOR(1);
       gotoxy(INCI8,INCI5);
       INCS1 := INKEY;
       INCC3 := right(INCS1,1);
       INCC2 := left (INCS1,1);
       case INCC2 of
        #08      : if INCI4 <> INCI8
                    then begin
                           INCS2 := left(INCS2,length(INCS2)-1);
                           CURSOR(0);
                           gotoxy(INCI4+1,INCI5); write(INCC1);
                           INCI4 := INCI4+1;
                         end;
        #27      : case INCC3 of
                    #27 : begin
                            CURSOR(0);
                            gotoxy(INCI9,INCI5); for INCI3 := 1 to INCI6 do write(INCC1);
                            INCS2 := '';
                            INCI4 := INCI8;
                          end;
                   end;
        #45,
        #48..#57 : if INCI4 <> INCI9-1
                    then begin
                           INCS2 := INCS2+INCC2;
                           INCI4 := INCI4-1;
                         end;
       end;
      until INCC2 = #13;
      INPUT_N := INCS2;
      INPUT_N := INCS2;
      if (length(INCS2) = 0) and (length(INCS3) = 0) then INPUT_N := '';
      gotoxy(INCI1,INCI2);
    end;

  procedure LOGO;
    begin
      CURSOR(1);
      clrscr;
      gotoxy(16,2); writeln('ษออออออออออออออออออออออออออออออออออออออออออออออป');
      gotoxy(16,3); writeln('บ ROMI LTD                   ~’  … บ');
      gotoxy(16,4); writeln('ศออออออออออออออออออออออออออออออออออออออออออออออผ');
      gotoxy(16,6); writeln('ษออออออออออออออออออออออออออออออออออออออออออออออป');
      gotoxy(16,7); writeln('บ                  € ”                  บ');
      gotoxy(16,8); writeln('บ                                              บ');
      gotoxy(16,9); writeln('บ                       .…”€ … ‘ .1  บ');
      gotoxy(16,10);writeln('บ                                              บ');
      gotoxy(16,11);writeln('บ                                              บ');
      gotoxy(16,12);writeln('บ                                              บ');
      gotoxy(16,13);writeln('บ                                              บ');
      gotoxy(16,14);writeln('บ                                              บ');
      gotoxy(16,15);writeln('บ                                              บ');
      gotoxy(16,16);writeln('บ                                     .“…‘ .9  บ');
      gotoxy(16,17);writeln('บ                   :  € /—          บ');
      gotoxy(16,18);writeln('ศออออออออออออออออออออออออออออออออออออออออออออออผ');
      gotoxy(34,17);
    end;

  procedure BEEP;
    begin
      write(#7);
    end;

  procedure ENTER_STORE;
    procedure ENTER_LOG;
      begin
        gotoxy(16,1); writeln('ษออออออออออออออออออออออออออออออออออออออออออออออป');
        gotoxy(16,2); writeln('บ ROMI LTD                   ~’  … บ');
        gotoxy(16,3); writeln('ศออออออออออออออออออออออออออออออออออออออออออออออผ');
        gotoxy( 1,4); writeln('                                                                                ');
{                         12345678901234567890123456789012345678901234567890123456789012345678901234567890}
        gotoxy( 5,5); writeln('ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป');
        gotoxy( 5,6); writeln('บ                        …”€  … ‘                      บ');
        gotoxy( 5,7); writeln('บ                                                                    บ');
        gotoxy( 5,8); writeln('บ                                                                    บ');
        gotoxy( 5,9); writeln('บ                      ____________________        __ :   ’        บ');
        gotoxy( 5,10);writeln('บ                                                                    บ');
        gotoxy( 5,11);writeln('บ                      ______________________________ :  …        บ');
        gotoxy( 5,12);writeln('บ                                                                    บ');
        gotoxy( 5,13);writeln('บ  __________________________________________________ : …        บ');
        gotoxy( 5,14);writeln('บ                                                                    บ');
        gotoxy( 5,15);writeln('บ                                     _______________ :            บ');
        gotoxy( 5,16);writeln('บ                                                                    บ');
        gotoxy( 5,17);writeln('บ                           _________________________ : …”        บ');
        gotoxy( 5,18);writeln('บ                           _________________________                บ');
        gotoxy( 5,19);writeln('บ                           _________________________                บ');
        gotoxy( 5,20);writeln('วฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ');
        gotoxy( 5,21);writeln('บ …‘ F7 — ณ                                                     บ');
        gotoxy( 5,22);writeln('ศออออออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออผ');

      end;

    begin
      ENTER_LOG;
      A_ := INPUT_N(56,9,2,0,'_');
      B_ := GET(28,11,30,'_');
      C_ := GET( 8,13,50,'_');
      D_ := GET(43,15,15,'_');
      E_ := INPUT_N(33,17,25,0,'_');
      F_ := INPUT_N(33,18,25,0,'_');
      G_ := INPUT_N(33,19,25,0,'_');
      clrscr;
      gotoxy(1,1); writeln(' 123456789012345678901234567890123456789012345678901234567890');
      gotoxy(1,2); writeln('*************************************************************************');
      gotoxy(1,3); writeln('*************************************************************************');
      gotoxy(1,4); writeln('*************************************************************************');
      gotoxy(1,5); writeln('*************************************************************************');
      gotoxy(1,6); writeln('*************************************************************************');
      gotoxy(1,7); writeln('*************************************************************************');
      gotoxy(1,8); writeln('*************************************************************************');
      gotoxy(1,9); writeln('*************************************************************************');
      gotoxy(1,10);writeln('*************************************************************************');
      gotoxy(2,3);writeln(A_);
      gotoxy(2,4);writeln(B_);
      gotoxy(2,5);writeln(C_);
      gotoxy(2,6);writeln(D_);
      gotoxy(2,7);writeln(E_);
      gotoxy(2,8);writeln(F_);
      gotoxy(2,9);writeln(G_);
      repeat until keypressed;
    end;

  procedure OPTIONS;
    begin
      PROGRAM_END := false;
      gotoxy(34,17);write(' ');
      gotoxy(34,17);
      CH_ := INKEY;
      gotoxy(34,17);write(CH_);
      case CH_ of
        '1'  : ENTER_STORE;
        '9'  : PROGRAM_END := true;
        else BEEP;
      end;
    end;

  begin
    CH_ := '1';
    repeat
      case CH_ of
        '1','9' : LOGO;
      end;
      OPTIONS;
    until PROGRAM_END;
    CURSOR(0);
  end.;