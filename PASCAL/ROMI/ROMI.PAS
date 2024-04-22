{                                                      … ’ ”‘…    }
{                                ’  … €  €  DIM - ’     }
{                …€ …”  …— ’ “…‘ ’   € … ”‘…    }
{     … ……— ’€ DIM - ’  ’ ”‘ € ’  €    }
{                     ’ – *** 65 *** … … …—                   }
{   CLIB1                               : array[1..65] of string[20];         }
{   CLIB2                               : array[1..65] of integer;            }
{                                                                             }
{Change here number of cities in library -- …  ’ ”‘ € € …}
{                         ||                                                  }
{   MAXSTORE  : integer = 65;                                                 }
{   CLIB      :  array[1..65] of string[20]=(                                 }
{    '052 … €',                                                         }
{    '057 —”…€',                                                            }
{    '03 … …€',                                                          }
{          .                                                                  }
{          .                                                                  }
{                 <-----------------  …”‘… ’ € ”‘…  “…‘    }

program ROMI;
{$U+}
{$C+}
  type
    MAIN       = record
                   CITY             : integer;
                   STORE_           : string[20];
                   ADRESS_          : string[30];
                   NAME_            : string[15];
                   PHONE1_,
                   PHONE2_,
                   PHONE3_          : string[12];
                   EXE              : boolean;
                 end;
    SORT       = record
                   SCITY            : integer;
                   SSTORE_          : string[20];
                   SADRESS_         : string[30];
                   SNAME_           : string[15];
                   SPHONE1_,
                   SPHONE2_,
                   SPHONE3_         : string[12];
                 end;
    REGTYPE     = record
                    AX,BX,CX,DX,BP,SI,DI,DS,ES,FLAGS : integer;
                  end;
    HALFREGTYPE = record
                    AL,AH,BL,BH,CL,CH,DL,DH          : byte
                  end;
    G255     = string[255];
  var
    F1                        : FILE OF MAIN;
    R1                        : MAIN;
    F2                        : FILE OF SORT;
    R2                        : SORT;
    REGS,SAVEREG              : REGTYPE;
    SAVEHALF                  : HALFREGTYPE absolute SAVEREG;
    U                         : real;
    EODA,A,B,C,D,E,F,G,H,I,J,K,L,M,T,FLAG,S,STORE_KOD : integer;
    AA_,A_,BB_,B_,CC_,C_,DD_,D_,EE_,E_,FF_,F_,GG_,G_,H_,TY_,
    I_,J_,K_,L_,M_,BC_        : string[255];
    INKEYP                    : boolean;
    CH_,BCH_                  : char;
    PROGRAM_END,EBOL          : BOOLEAN;
    WIK                                 : array[1..25,1..80] of char;
    INCI1,INCI2,INCI3,INCI4,INCI5,INCI6,INCI7,
    INCI8,INCI9,INCI10,INCI11,INCI12,INCI100,
    INCI101,INCI102,GETAA,GETLEN,GETI,EOD,NFL                : integer;
    INCS1,INCS2,INCS3,INCS4,INCS5,INCS6,GETB_,GETMIKE_,ENT_  : G255;
    INCC1,INCC2,INCC3,GETDEL,GETCH_     : char;
    INCB1,SOF                           : boolean;
    INCY1                               : byte;
    ASD                                 : array[1..100] of SORT;
    CLIB1                               : array[1..65] of string[20];{<--||}
    CLIB2                               : array[1..65] of integer;   {<--||}
  const                                                                 {||}
    INC15    : string[27] = 'tcdsvuzjyhlfkonibxg;p.mera,';              {||}
    VG       : string[27] = 'tcdsvuzjyhlfkonibxg;p.mera,';              {||}
    VG1      : string[27] = '€…‘’“”•–—';              {||}
    FIL_NAME : string[12] = 'ROMISTOR.DAT';                             {||}
    HGH      : array[0..8] of integer = (8,9,11,13,15,17,18,19,8);      {||}
                                                                        {||}
{Change here number of cities in library -- …  ’ ”‘ € € …}
{                         ||                                                  }
    MAXSTORE  : integer = 65;
    CLIB      :  array[1..65] of string[20]=(
     '053 … €',
     '057 —”…€',
     '03 … …€',
     '03 €—’ …€',
     '059 €',
     '08 …€',
     '051 …—€',
     '057 ’ €',
     '06 € ',
     '03 — ',
     '03  ',
     '03 ’',
     '052 –',
     '06 ',
     '03 ……',
     '04 ”',
     '04 …’',
     '06 ',
     '08 ',
     '04 ’—',
     '02 …',
     '052 €‘ ”',
     '06 … ”',
     '04 €',
     '08 …',
     '04 ',
     '08 …– ‘',
     '06 –',
     '05 ',
     '03 …‘',
     '04 …’',
     '06 …”’',
     '03 …— ”',
     '04 €€ —',
     '04 —€ —',
     '…— …',
     '04 —–… —',
     '03 ’ €',
     '03 …– …€',
     '08 ……',
     '08 ',
     '03  € ',
     '03 ’”€ ',
     '03  ',
     '03 … ',
     '04  ',
     '052 … …-',
     '052 ’',
     '03 € ',
     '057 € —',
     '08 ',
     '—',
     '06 …',
     '03 …',
     '06 —’ ',
     '06 ',
     '06 ”–',
     '06  …–',
     '08 – ',
     '04  —',
     '057 ’',
     '04 —’ …',
     '04  ',
     '051  —',
     '03 ……€ —');

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
                      BC_    := AC;
                      INKEYP := true;
                    end
               else begin
                      INKEY  := chr(SAVEHALF.AL);
                      INKEYP := false;
                      BC_    := 'EC';
                    end;
           end;
    end;

  function EXIST(FILENAME : G255) : boolean;
    var
      FIL : FILE;
    begin
      assign(FIL,FILENAME);
      {$I-}
      reset(fil);
      {$I+}
      EXIST := ioresult = 0;
      close(FIL);
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

  function GET(GETX,GETY,GETLEN:integer; GETDEL:char):G255;
    procedure GETB;
      begin
        repeat
         gotoxy(GETAA,GETY);
         INCS1 := INKEY;
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
                  if (BC_ = 'A') and INKEYP
                   then begin
                          ENT_  := '***'; EBOL := true;
                          GET   := 'A';
                          exit;
                        end;
                  if (INCC3 = #27) and (BC_ = 'EC')
                   then begin
                          ENT_ := 'ESC';
                          FLAG := FLAG - 1;
                          GET  := 'A';
                          exit;
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
      gotoxy(INCI4,INCI5); for INCI3 := 1 to INCI6 do write(INCC1);
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
        #08      : if INCI4 <> INCI8
                    then begin
                           INCS2 := left(INCS2,length(INCS2)-1);
                           gotoxy(INCI4+1,INCI5); write(INCC1);
                           INCI4 := INCI4+1;
                         end;
        #27 : begin
                if (BC_ = 'A') and INKEYP
                 then begin
                        gotoxy(INCI9,INCI5); for INCI3 := 1 to INCI6 do write(INCC1);
                        ENT_ := '***'; EBOL := true;
                        INPUT_N := '';
                        exit;
                      end;
                if (INCC3 = #27) and (BC_ = 'EC')
                 then begin
                        gotoxy(INCI9,INCI5); for INCI3 := 1 to INCI6 do write(INCC1);
                        ENT_ := 'ESC';
                        FLAG := FLAG - 1;
                        INPUT_N := '';
                        exit;
                      end;
              end;
        #45,
        #48..#57 : if (INCI7 = 1) and (INCC2 = #45)
                    then SOF := false
                    else if INCI4 <> INCI9-1
                          then begin
                                 INCS2 := INCS2+INCC2;
                                 INCI4 := INCI4-1;
                               end;
       end;
      until INCC2 = #13;
      INPUT_N := INCS2;
      if length(INCS2) = 0 then INPUT_N := '';
      gotoxy(INCI1,INCI2);
    end;

  procedure LOGO;
    begin
      clrscr;
      gotoxy(16,2); writeln('ษออออออออออออออออออออออออออออออออออออออออออออออป');
      gotoxy(16,3); writeln('บ ROMI LTD                   ~’  … บ');
      gotoxy(16,4); writeln('ศออออออออออออออออออออออออออออออออออออออออออออออผ');
      gotoxy(16,6); writeln('ษออออออออออออออออออออออออออออออออออออออออออออออป');
      gotoxy(16,7); writeln('บ                  € ”                  บ');
      gotoxy(16,8); writeln('บ                                              บ');
      gotoxy(16,9); writeln('บ                       .…”€ … ‘ .1  บ');
      gotoxy(16,10);writeln('บ                            .… ‘” .2  บ');
      gotoxy(16,11);writeln('บ                            .… … .3  บ');
      gotoxy(16,12);writeln('บ                                              บ');
      gotoxy(16,13);writeln('บ                                              บ');
      gotoxy(16,14);writeln('บ                     .… € •…— ‘” .7  บ');
      gotoxy(16,15);writeln('บ                                              บ');
      gotoxy(16,16);writeln('บ                                     .“…‘ .9  บ');
      gotoxy(16,17);writeln('บ                   :  € /—          บ');
      gotoxy(16,18);writeln('ศออออออออออออออออออออออออออออออออออออออออออออออผ');
      gotoxy(34,17);
    end;

  procedure OUTPUT_LOGO;
    begin
      gotoxy(16,2); writeln('ษออออออออออออออออออออออออออออออออออออออออออออออป');
      gotoxy(16,3); writeln('บ ROMI LTD                   ~’  … บ');
      gotoxy(16,4); writeln('ศออออออออออออออออออออออออออออออออออออออออออออออผ');
      gotoxy(16,6); writeln('ษออออออออออออออออออออออออออออออออออออออออออออออป');
      gotoxy(16,7); writeln('บ                 …‘” ”                 บ');
      gotoxy(16,8); writeln('บ                                              บ');
      gotoxy(16,9); writeln('บ                          .’  …”€ .1  บ');
      gotoxy(16,10);writeln('บ                     .” ’  …”€ .2  บ');
      gotoxy(16,11);writeln('บ                     .-€ •€  …… .3  บ');
      gotoxy(16,12);writeln('บ                              .’  .4  บ');
      gotoxy(16,13);writeln('บ                                              บ');
      gotoxy(16,14);writeln('บ                     .… € ……  .7  บ');
      gotoxy(16,15);writeln('บ                                              บ');
      gotoxy(16,16);writeln('บ                                     .“…‘ .9  บ');
      gotoxy(16,17);writeln('บ                   :  € /—          บ');
      gotoxy(16,18);writeln('ศออออออออออออออออออออออออออออออออออออออออออออออผ');
      gotoxy(34,17);
    end;

  procedure CHECK_FIL(INCS1 : G255);
    begin
      assign(F1,INCS1);
      if EXIST(INCS1)
       then begin
              reset(F1);
              EOD := -1;
              {$I-}
              repeat
                EOD := EOD + 1;
                seek(F1,EOD);
                read(F1,R1);
              until ioresult <> 0;
              {$I+}
              if EOD=0
               then rewrite(F1)
               else begin
                      repeat
                      EOD := EOD - 1;
                      seek(F1,EOD);
                      read(F1,R1);
                      until (R1.EXE=true) or (EOD=0);
                      if (EOD=0) and (R1.EXE=false)
                       then begin
                              rewrite(F1);
                              exit;
                            end;
                      EOD := EOD + 1;
                    end;
            end
       else begin
              rewrite(F1);
              EOD := 0;
            end;
    end;

    procedure ENTER_LOG;
      begin
        gotoxy(16,1); writeln('ษออออออออออออออออออออออออออออออออออออออออออออออป');
        gotoxy(16,2); writeln('บ ROMI LTD                   ~’  … บ');
        gotoxy(16,3); writeln('ศออออออออออออออออออออออออออออออออออออออออออออออผ');
        gotoxy( 1,4); writeln('                                                                                ');
        gotoxy( 5,5); writeln('ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป');
        gotoxy( 5,6); writeln('บ ____ : ”‘            …”€  … ‘                      บ');
        gotoxy( 5,7); writeln('บ                                                                    บ');
        gotoxy( 5,8); writeln('บ                                                                    บ');
        gotoxy( 5,9); writeln('บ                      ____________________       ___ :   ’        บ');
        gotoxy( 5,10);writeln('บ                                                                    บ');
        gotoxy( 5,11);writeln('บ                                ____________________ :  …        บ');
        gotoxy( 5,12);writeln('บ                                                                    บ');
        gotoxy( 5,13);writeln('บ                      ______________________________ : …        บ');
        gotoxy( 5,14);writeln('บ                                                                    บ');
        gotoxy( 5,15);writeln('บ                                     _______________ :            บ');
        gotoxy( 5,16);writeln('บ                                                                    บ');
        gotoxy( 5,17);writeln('บ                                     `’ ____________ : …”        บ');
        gotoxy( 5,18);writeln('บ                                     ` ____________                บ');
        gotoxy( 5,19);writeln('บ                                        ____________                บ');
        gotoxy( 5,20);writeln('วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ');
        gotoxy( 5,21);writeln('บ …‘ F7  …—  ESC  — ณ                                      บ');
        gotoxy( 5,22);writeln('ศอออออออออออออออออออออออออออออฯออออออออออออออออออออออออออออออออออออออผ');
      end;

  function RER(INCS1 : G255) : G255;
    begin
      INCS2 := '';
      for INCI1 := length(INCS1) downto 1 do INCS2 := INCS2 + copy(INCS1,INCI1,1);
      RER := INCS2;
    end;

  procedure UP_PRINTER;
    begin
      write(lst,chr(27),chr(60),
                chr(24),
                chr(27),chr(51),chr(18),
                chr(27),chr(56));
    end;

  procedure CITIES;
    procedure CIT_SORT;
      begin
        for I := 1 to MAXSTORE do
         begin
           CLIB1[I] := CLIB[I];
           CLIB2[I] := I;
         end;
        for I := 1 to MAXSTORE-1 do
         begin
           F := 0;
           for J := 1 to MAXSTORE-I do
            begin
              if not (RER(CLIB1[J]) < RER(CLIB1[J+1]))
               then begin
                      B_         := CLIB1[J];
                      CLIB1[J]   := CLIB1[J+1];
                      CLIB1[J+1] := B_;
                      B          := CLIB2[J];
                      CLIB2[J]   := CLIB2[J+1];
                      CLIB2[J+1] := B;
                      F          := 1;
                    end;
            end;
           if F = 0 then exit;
         end;
      end;
    begin
      CIT_SORT;
      UP_PRINTER;
      writeln(lst,'                            ',
              chr(27),chr(45),chr(1),
              chr(14),'’ ',chr(20),
              chr(27),chr(45),chr(0));
      UP_PRINTER;
      writeln(lst,chr(10));
      writeln(lst,'|…—         ’         |…—         ’         |…—         ’         |');
      writeln(lst,'|------------------------|------------------------|------------------------|');
      I := 1;
      G := trunc(MAXSTORE div 3);
      repeat
       str(CLIB2[I],A_);   D_ := CLIB1[I];
       str(CLIB2[I+1],B_); E_ := CLIB1[I+1];
       str(CLIB2[I+2],C_); F_ := CLIB1[I+2];
       writeln(lst,'|',A_:3,' ',D_:20,'|',B_:3,' ',E_:20,'|',C_:3,' ',F_:20,'|');
       I := I + 3;
      until I > G*3;
      H := MAXSTORE mod 3;
      case H of
       1 : begin
             str(CLIB2[MAXSTORE],A_);
             D_ := CLIB1[MAXSTORE];
             writeln(lst,'|',A_:3,' ',D_:20,'|');
           end;
       2 : begin
             str(CLIB2[MAXSTORE-1],A_); D_ := CLIB1[MAXSTORE-1];
             str(CLIB2[MAXSTORE],B_);   E_ := CLIB1[MAXSTORE];
             writeln(lst,'|',A_:3,' ',D_:20,'|',B_:3,' ',E_:20,'|');
           end;
      end;
      writeln(lst,chr(12));
    end;

  procedure MOV_FIL;
    begin
      I := 0; {ROMISTOR.DAT}
      S := 0; {ASD[0..100]}
      repeat
       seek(F1,I);
       read(F1,R1);
       if R1.EXE and ((R1.CITY = STORE_KOD) or (STORE_KOD = 0))
        then begin
               S := S + 1;
               ASD[S].SCITY    := R1.CITY;
               ASD[S].SSTORE_  := R1.STORE_;
               ASD[S].SADRESS_ := R1.ADRESS_;
               ASD[S].SNAME_   := R1.NAME_;
               ASD[S].SPHONE1_ := R1.PHONE1_;
               ASD[S].SPHONE2_ := R1.PHONE2_;
               ASD[S].SPHONE3_ := R1.PHONE3_;
             end;
       I := I + 1;
      until I = EODA;
    end;

  procedure SORT_MOV;
    begin
      for I := 1 to S-1 do
       begin
         for J := I to S-1 do
          begin
            str(ASD[I].SCITY,TY_);   A_ := concat(TY_,RER(ASD[I].SSTORE_));
            str(ASD[J+1].SCITY,TY_); B_ := concat(TY_,RER(ASD[J+1].SSTORE_));
            if A_ > B_
             then begin
                    K  := ASD[I].SCITY;
                    B_ := ASD[I].SSTORE_;
                    C_ := ASD[I].SADRESS_;
                    D_ := ASD[I].SNAME_;
                    E_ := ASD[I].SPHONE1_;
                    F_ := ASD[I].SPHONE2_;
                    G_ := ASD[I].SPHONE3_;
                    ASD[I].SCITY    := ASD[J+1].SCITY;
                    ASD[I].SSTORE_  := ASD[J+1].SSTORE_;
                    ASD[I].SADRESS_ := ASD[J+1].SADRESS_;
                    ASD[I].SNAME_   := ASD[J+1].SNAME_;
                    ASD[I].SPHONE1_ := ASD[J+1].SPHONE1_;
                    ASD[I].SPHONE2_ := ASD[J+1].SPHONE2_;
                    ASD[I].SPHONE3_ := ASD[J+1].SPHONE3_;
                    ASD[J+1].SCITY    := K;
                    ASD[J+1].SSTORE_  := B_;
                    ASD[J+1].SADRESS_ := C_;
                    ASD[J+1].SNAME_   := D_;
                    ASD[J+1].SPHONE1_ := E_;
                    ASD[J+1].SPHONE2_ := F_;
                    ASD[J+1].SPHONE3_ := G_;
                  end;
         end;
       end;
    end;

  procedure PRIN_MOV;
    begin
      UP_PRINTER;
      writeln(lst,chr(10));
      writeln(lst,'              ',chr(14),STORE_KOD:3,' - ’ …… ',chr(20));
      AA_ := '';
      for I := 4 to (80-length(CLIB[STORE_KOD])) div 2 do AA_ := AA_ + ' ';
      writeln(lst,AA_,chr(27),chr(45),chr(1),chr(14),
                      CLIB[STORE_KOD],
                      chr(20),chr(27),chr(45),chr(0),chr(10),chr(15));
      writeln(lst,'               …”       …”   …’ …” ',
                  '                          …              ',
                  '        …         `‘');
      writeln(lst,'           ============ ============ ============ ',
                  '=============== ============================== ',
                  '==================== ===');
      I := 0;
      repeat
       I := I + 1;
       writeln(lst,'           ',
                   ASD[I].SPHONE3_:12,' ',ASD[I].SPHONE2_:12,' ',ASD[I].SPHONE1_:12,' ',
                   ASD[I].SNAME_:15,' ',ASD[I].SADRESS_:30,' ',ASD[I].SSTORE_:20,' ',I:3);
      until I = S;
      writeln(lst,chr(18),chr(12));
    end;

  procedure PRIN_MOV_ALL;
    begin
      I := 0;
      repeat
       I := I + 1;
       writeln(lst,
       ASD[I].SPHONE3_:12,' ',
       ASD[I].SPHONE2_:12,' ',
       ASD[I].SPHONE1_:12,' ',
       ASD[I].SNAME_:15,' ',
       ASD[I].SADRESS_:30,' ',
       ASD[I].SSTORE_:20,' ',
       CLIB[ASD[I].SCITY]:20,' ',
       ASD[I].SCITY:3);
      until I = S;
      writeln(lst,chr(10));
    end;

  procedure OUTPUT_FIL;
    begin
      CHECK_FIL(FIL_NAME); EODA := EOD;
      if (not EXIST(FIL_NAME)) or (EODA = 0) then begin
                                                          close(F1);
                                                          exit;
                                                        end;
    end;

  procedure PRIN_FIL;
    begin
      OUTPUT_FIL;
      if (not EXIST(FIL_NAME)) or (EODA = 0)
       then begin
              gotoxy(16,15);writeln('บ       ’ ‘ …’ •€ — …”€      บ');
              for I := 1 to 1000 do gotoxy(1,1);
              CH_ := '9';
              exit;
            end;
      STORE_KOD := 0;
      UP_PRINTER;
      writeln(lst,chr(10));
      writeln(lst,'                       ',chr(14),'•€ …… ',chr(20));
      writeln(lst,chr(10));
      writeln(lst,chr(15));
      writeln(lst,'    …”       …”   …’ …” ',
                  '                          …             ',
                  '        …                  ’         …—');
      writeln(lst,'============ ============ ============ ',
                  '=============== ============================== ',
                  '==================== ==================== ===');
      repeat
       STORE_KOD := STORE_KOD + 1;
       MOV_FIL;
       if S > 1 then SORT_MOV;
       if S > 0 then PRIN_MOV_ALL;
      until STORE_KOD = MAXSTORE;
      close(F1);
      writeln(lst,chr(12));
    end;

  procedure CITY_STORE;
    begin
      STORE_KOD := 1;
      SOF := false;
      S := 1;
      repeat
       EBOL := false;                                 { true -> F7 — • € }
       gotoxy(16,10);writeln('บ                      .’ ” ……  .2  บ');
       gotoxy(16,11);writeln('บ                                              บ');
       gotoxy(16,12);writeln('บ   ___________________    ___ : ’ …—      บ');
       gotoxy(16,13);writeln('บ                                              บ');
       gotoxy(16,14);writeln('บ                                              บ');
       gotoxy(16,15);writeln('บ            ……  ’ …— —           บ');
       if S = 0
        then begin
               gotoxy(16,16);writeln('บ           … ’ …… …”€ €          บ');
               gotoxy(16,17);writeln('บ        €– F7 …€ € ’ … €        บ');
             end
        else begin
               gotoxy(16,16);writeln('บ                  F7 - €–                 บ');
               gotoxy(16,17);writeln('บ                                              บ');
             end;
       repeat
        gotoxy(16,12);writeln('บ   ___________________    ___ : ’ …—      บ');
        A_ := INPUT_N(43,12,3,1,'_');
        if EBOL then begin
                       close(F1);
                       exit;
                     end;
        val(A_,A,GETI); STORE_KOD := A;
       until (A > 0) and (A < MAXSTORE + 1);
       gotoxy(43,12); writeln('___');
       gotoxy(43,12); writeln(A:3);
       gotoxy((20-length(CLIB[A]))+20,12);write(CLIB[A]);
       gotoxy(16,15);writeln('บ              €€ …” —            บ');
       gotoxy(16,16);writeln('บ                                              บ');
       gotoxy(16,17);writeln('บ                                              บ');
       OUTPUT_FIL;
       if (not EXIST(FIL_NAME)) or (EODA = 0)
        then begin
               gotoxy(16,15);writeln('บ       ’ ‘ …’ •€ — …”€      บ');
               for I := 1 to 1000 do gotoxy(1,1);
               CH_ := '9';
               close(F1);
               exit;
             end;
      MOV_FIL;
      until S > 0;
      if S > 1 then SORT_MOV;
      PRIN_MOV;
      close(F1);
    end;

  procedure ALL_STORE;
    begin
      OUTPUT_FIL;
      if (not EXIST(FIL_NAME)) or (EODA = 0)
       then begin
              gotoxy(16,15);writeln('บ       ’ ‘ …’ •€ — …”€      บ');
              for I := 1 to 1000 do gotoxy(1,1);
              CH_ := '9';
              exit;
            end;
      STORE_KOD := 0;
      UP_PRINTER;
      writeln(lst,chr(10));
      writeln(lst,'                       ',chr(14),'•€ …… ',chr(20));
      writeln(lst,chr(10));
      writeln(lst,chr(15));
      writeln(lst,'    …”       …”   …’ …” ',
                  '                          …             ',
                  '        …                  ’         …—');
      writeln(lst,'============ ============ ============ ',
                  '=============== ============================== ',
                  '==================== ==================== ===');
      repeat
       STORE_KOD := STORE_KOD + 1;
       MOV_FIL;
       if S > 0 then PRIN_MOV_ALL;
      until STORE_KOD = MAXSTORE;
      close(F1);
      writeln(lst,chr(12));
    end;

  procedure CITY_BOOK;
    begin
      OUTPUT_FIL;
      if (not EXIST(FIL_NAME)) or (EODA = 0)
       then begin
              gotoxy(16,15);writeln('บ       ’ ‘ …’ •€ — …”€      บ');
              for I := 1 to 1000 do gotoxy(1,1);
              CH_ := '9';
              exit;
            end;
      STORE_KOD := 0;
      repeat
       STORE_KOD := STORE_KOD + 1;
       MOV_FIL;
       if S > 1 then SORT_MOV;
       if S > 0 then PRIN_MOV;
      until STORE_KOD = MAXSTORE;
      close(F1);
      writeln(lst,chr(12));
    end;

  procedure OUTPUT;
    begin
      CH_ := '1';
      repeat
       if CH_ in ['1','2','3','4','7'] then OUTPUT_LOGO;
       gotoxy(34,17);write(' ');
       gotoxy(34,17);
       CH_ := ' ';
       CH_ := INKEY;
       gotoxy(34,17);write(CH_);
       if CH_ in ['1','3']
        then begin
               gotoxy(30,20); writeln(' €€ …” —');
             end;
       case CH_ of
         '1' : CITY_BOOK;                 { ’ ” ……   …”€ }
         '2' : CITY_STORE;                {           ’ ” ……  }
         '3' : PRIN_FIL;                  {       … •…— ……  }
         '4' : CITIES;                    {                   ’  }
         '7' : ALL_STORE;                 {             •…— ……  }
         '9' : CH_ := '9';                {                         …‘ }
       end;
       gotoxy(30,20); writeln('                     ');
      until CH_ = '9';
    end;

  procedure GET_N;
    begin
      FLAG := 1;   {1,2,3,4,5,6,7}
      EBOL := false;                                 { true -> F7 — • € }
{G}   repeat
{F}   repeat
{E}   repeat
{D}   repeat
{C}   repeat
{B}   repeat
{A}   repeat
       ENT_ := 'A';
       if FLAG = 1 then
        begin
          repeat
           gotoxy(39,21);write('Enter - …— ’  /  ’ …— —');
           gotoxy( 5,9); writeln('บ                      ____________________       ___ :   ’        บ');
           A_ := INPUT_N(55,9,3,1,'_');
           if ENT_ <> 'ESC' then FLAG := FLAG + 1
                            else FLAG := 1;
           if EBOL then exit;
           val(A_,A,GETI);
          until (A > 0) and (A < MAXSTORE + 1);
          if INCC2 = #13 then begin
                                gotoxy(55,9); write('___');
                                gotoxy(55,9); write(A:3);
                                gotoxy((20-length(CLIB[A]))+28,9); write(CLIB[A]);
                                gotoxy(36,21); write('                                      ');
                              end;
        end;
{A}   until FLAG > 1;
       if FLAG = 2 then
        begin
          gotoxy(5,11);write('บ                                ____________________ :  …        บ');
          B_ := GET(38,11,20,'_');
          if ENT_ <> 'ESC' then FLAG := FLAG + 1;
          if EBOL then exit;
        end;
{B}   until FLAG > 2;
       if FLAG = 3 then
        begin
          gotoxy(5,13);write('บ                      ______________________________ : …');
          C_ := GET(28,13,30,'_');
          if ENT_ <> 'ESC' then FLAG := FLAG + 1;
          if EBOL then exit;
        end;
{C}   until FLAG > 3;
       if FLAG = 4 then
        begin
          gotoxy(5,15); write('บ                                     _______________ :    ');
          D_ := GET(43,15,15,'_');
          if ENT_ <> 'ESC' then FLAG := FLAG + 1;
          if EBOL then exit;
        end;
{D}   until FLAG > 4;
       if FLAG = 5 then
        begin
          gotoxy(5,17); write('บ                                     `’ ____________ : …”        บ');
          E_ := INPUT_N(46,17,12,0,'_');
          if ENT_ <> 'ESC' then FLAG := FLAG + 1;
          if EBOL then exit;
        end;
{E}   until FLAG > 5;
       if FLAG = 6 then
        begin
          gotoxy(5,18); write('บ                                     ` ____________                บ');
          F_ := INPUT_N(46,18,12,0,'_');
          if ENT_ <> 'ESC' then FLAG := FLAG + 1;
          if EBOL then exit;
        end;
{F}   until FLAG > 6;
       if FLAG = 7 then
        begin
          gotoxy(5,19); write('บ                                        ____________');
          G_ := INPUT_N(46,19,12,0,'_');
          if ENT_ <> 'ESC' then FLAG := FLAG + 1;
          if EBOL then exit;
        end;
{G}   until FLAG > 7;
    end;

  procedure ENTER_STORE;
    begin
      ENTER_LOG;
      CHECK_FIL(FIL_NAME);
      repeat
        gotoxy(5,6);  write('บ ____ : ”‘            …”€  … ‘                      บ');
        gotoxy(5,9);  write('บ                      ____________________       ___ :   ’        บ');
        gotoxy(5,11); write('บ                                ____________________ :  …        บ');
        gotoxy(5,13); write('บ                      ______________________________ : …');
        gotoxy(5,15); write('บ                                     _______________ :    ');
        gotoxy(5,17); write('บ                                     `’ ____________ : …”        บ');
        gotoxy(5,18); write('บ                                     ` ____________                บ');
        gotoxy(5,19); write('บ                                        ____________');
        gotoxy(5,21); write('บ …‘ F7  …—  ESC  — ณ                                      บ');
        str(EOD+1,G_);
        gotoxy(7+4-length(G_),6); write(EOD+1);
        GET_N;
        if not EBOL
         then begin
                R1.EXE     := true;
                R1.CITY    := A;
                R1.STORE_  := B_;
                R1.ADRESS_ := C_;
                R1.NAME_   := D_;
                R1.PHONE1_ := E_;
                R1.PHONE2_ := F_;
                R1.PHONE3_ := G_;
                seek(F1,EOD);
                write(F1,R1);
                EOD := EOD + 1;
                repeat
                 gotoxy( 5,21); write('บ  `` - € /  `` -    — ณ                                      บ');
                 gotoxy(48,21); write('_ ? ”‘… … €');
                 gotoxy(48,21);
                 CH_ := INKEY;
                until (CH_ = 'N') or (CH_ = 'n') or (CH_ = 'k') or (CH_ = '') or (CH_ = 'K') or (CH_ = '') or
                      (CH_ = 'f') or (CH_ = 'F') or (CH_ = '') or (CH_ = 'y') or (CH_ = 'Y') or (CH_ = '');
              end
         else begin
                CH_ := '1';
                close(F1);
                exit;
              end;
      until (not EBOL) and ((CH_ = 'N') or (CH_ = 'n') or (CH_ = 'k') or (CH_ = '') or (CH_ = 'K') or (CH_ = ''));
      CH_ := '1';
      close(F1);
    end;

  procedure ERASE_STORE;
    begin
      gotoxy(5,20); write('วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ');
      gotoxy(5,21); write('บ  €– - € — / —…  - `` • ณ   : ??? … … —… บ');
      gotoxy(5,22); write('ศอออออออออออออออออออออออออออออออออออออออออออฯออออออออออออออออออออออออผ');
      INCC1 := INKEY;
      if INCC1 in ['f','F','']
       then begin
              seek(F1,EOD-1);
              read(F1,R1);
              seek(F1,I);
              write(F1,R1);
              R1.EXE := false;
              seek(F1,EOD-1);
              write(F1,R1);
              EOD := EOD - 1;
            end;
    end;

  procedure SHOW;
    begin
      gotoxy(7,6);   write(I+1:4);
      gotoxy(55,9);  write(R1.CITY:3);
      gotoxy(28,9);  write(CLIB[R1.CITY]:20);
      gotoxy(38,11); write(R1.STORE_:20);
      gotoxy(28,13); write(R1.ADRESS_:30);
      gotoxy(43,15); write(R1.NAME_:15);
      gotoxy(46,17); write(R1.PHONE1_:12);
      gotoxy(46,18); write(R1.PHONE2_:12);
      gotoxy(46,19); write(R1.PHONE3_:12);
    end;

  procedure CLS;
    begin
      gotoxy(5,6);  write('บ ____ : ”‘                  … …                          บ');
      gotoxy(5,9);  write('บ                      ____________________       ___ :   ’        บ');
      gotoxy(5,11); write('บ                                ____________________ :  …        บ');
      gotoxy(5,13); write('บ                      ______________________________ : …        บ');
      gotoxy(5,15); write('บ                                     _______________ :            บ');
      gotoxy(5,17); write('บ                                     `’ ____________ : …”        บ');
      gotoxy(5,18); write('บ                                     ` ____________                บ');
      gotoxy(5,19); write('บ                                        ____________                บ');
      gotoxy(5,20); write('วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ');
      gotoxy(5,21); write('บ        …‘ F7 —         ณ           …  € —            บ');
      gotoxy(5,22); write('ศอออออออออออออออออออออออออออออฯออออออออออออออออออออออออออออออออออออออผ');
    end;

  procedure FIND;
    begin
      CLS;
      repeat
       EBOL := false;
       repeat
        B_ := '';
        gotoxy(5,11); write('บ                                ____________________ :  …        บ');
        B_ := GET(38,11,20,'_');
        if EBOL then begin
                       close(F1);
                       INCB1 := true;
                       exit;
                     end;
       until B_ <> '';
       gotoxy(38,11); write(B_:20);
       I := -1;
       repeat
        I := I + 1;
        seek(F1,I);
        read(F1,R1);
        SOF := R1.STORE_ = B_;
       until (I = EOD-1) or (R1.EXE and SOF);
      until not ((I = EOD) and (not SOF));
      SHOW;
    end;

  procedure GET_CHANGE;
    begin
      seek(F1,I);
      read(F1,R1);
      gotoxy(5,20); write('วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ');
      gotoxy(5,21); write('บ  — …… ENTER  €… …— € —   ณ   €– F7 —   บ');
      gotoxy(5,22); write('ศออออออออออออออออออออออออออออออออออออออออออออออออฯอออออออออออออออออออผ');
      case K of
       1 : begin
             repeat
              gotoxy( 5,9); writeln('บ                      ____________________       ___ :   ’        บ');
              A_ := INPUT_N(55,9,3,1,'_');
              if EBOL then exit;
              val(A_,A,GETI);
             until (A > 0) and (A < MAXSTORE + 1);
             if INCC2 = #13 then begin
                                   gotoxy(55,9); write(A:3);
                                   gotoxy(28,9); write(CLIB[A]:20);
                                 end;
             R1.CITY := A;
           end;
       2 : begin
             gotoxy(5,11);write('บ                                ____________________ :  …        บ');
             B_ := GET(38,11,20,'_');
             if EBOL then exit;
             R1.STORE_ := B_;
           end;
       3 : begin
             gotoxy(5,13);write('บ                      ______________________________ : …');
             C_ := GET(28,13,30,'_');
             if EBOL then exit;
             R1.ADRESS_ := C_;
           end;
       4 : begin
             gotoxy(5,15); write('บ                                     _______________ :    ');
             D_ := GET(43,15,15,'_');
             if EBOL then exit;
             R1.NAME_ := D_;
           end;
       5 : begin
             gotoxy(5,17); write('บ                                     `’ ____________ : …”        บ');
             E_ := INPUT_N(46,17,12,0,'_');
             if EBOL then exit;
             R1.PHONE1_ := E_;
           end;
       6 : begin
             gotoxy(5,18); write('บ                                     ` ____________                บ');
             F_ := INPUT_N(46,18,12,0,'_');
             if EBOL then exit;
             R1.PHONE2_ := F_;
           end;
       7 : begin
             gotoxy(5,19); write('บ                                        ____________');
             G_ := INPUT_N(46,19,12,0,'_');
             if EBOL then exit;
             R1.PHONE3_ := G_;
           end;
      end;
      seek(F1,I);
      write(F1,R1);
    end;

  procedure CHANGING_STORE;
    begin
      K := 1;     {9,11,13,15,17,18,19}
      EBOL := false;
      CH_ := #13;
      repeat
       if CH_ = #13
        then begin
               gotoxy(5,20); write('วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ');
               gotoxy(5,21); write('บ   ENTER •… … …    ณ   “…” -/+   ณ   …‘ 9 - —   บ');
               gotoxy(5,22); write('ศออออออออออออออออออออออออออออออออฯอออออออออออออออฯอออออออออออออออออออผ');
             end;
       gotoxy(67,HGH[K-1]); write(' ');
       gotoxy(67,HGH[K]);   write('*');
       gotoxy(67,HGH[K+1]); write(' ');
       gotoxy(5,22);
       CH_  := INKEY;
       case CH_ of
        '+' : begin
                K := K + 1;
                if K > 7 then K := 7;
              end;
        '-' : begin
                K := K - 1;
                if K < 1 then K := 1;
              end;
        #13 : begin
                GET_CHANGE;
                EBOL := false;
                SHOW;
              end;
        '9' : EBOL := true;
       end;
      until EBOL;
    end;

  procedure CHANGE_DETAILS;
    begin
      ENTER_LOG;
      CHECK_FIL(FIL_NAME);
      INCB1 := false;
      repeat
       if not (BCH_ in ['+','-']) then FIND;
       if not INCB1
        then begin
               if not (BCH_ in ['+','-'])
                then begin
                       gotoxy(5,20); write('วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ');
                       gotoxy(5,21); write('บ … … … .2 ณ … —… .1 ณ “…” -/+ ณ …‘ F7 - — บ');
                       gotoxy(5,22); write('ศอออออออออออออออออออออออฯอออออออออออออออฯอออออออออออฯออออออออออออออออผ');
                     end;
               repeat
                BCH_ := INKEY;
                case BCH_ of
                 '1' : ERASE_STORE;                     {         … —… }
                 '2' : CHANGING_STORE;                  { … … … }
                 '+' : begin
                         I := I + 1;
                         if I > EOD-1 then I := EOD-1;
                         seek(F1,I);
                         read(F1,R1);
                         SHOW;
                       end;
                 '-' : begin
                         I := I - 1;
                         if I < 0 then I := 0;
                         seek(F1,I);
                         read(F1,R1);
                         SHOW;
                       end;
                end;
               until ((BCH_ = #27) and (BC_ = 'A') and INKEYP) or (BCH_ in ['1','2','+','-']);
               if ((BCH_ = #27) and (BC_ = 'A') and INKEYP) then INCB1 := true;
             end;
      until INCB1;
      CH_ := '3';
      close(F1);
    end;

  procedure PRIN_FASD;
    begin
      CHECK_FIL(FIL_NAME);
      UP_PRINTER;
      writeln(lst,chr(15));
      writeln(lst,'    …”       …”   …’ …” ',
                  '                          …             ',
                  '        …                  ’         …—');
      writeln(lst,'============ ============ ============ ',
                  '=============== ============================== ',
                  '==================== ==================== ===');
      for I := 0 to EOD - 1 do
       begin
         seek(F1,I);
         read(F1,R1);
         writeln(lst,R1.EXE:8,' ',
                     R1.PHONE2_:12,' ',
                     R1.PHONE1_:12,' ',
                     R1.NAME_:15,' ',
                     R1.ADRESS_:30,' ',
                     R1.STORE_:20,' ',
                     CLIB[R1.CITY]:20,' ',
                     R1.CITY:3,' ',
                     I:3);
       end;
      writeln(lst,chr(18));
      close(F1);
    end;

  procedure OPTIONS;
    begin
      PROGRAM_END := false;
      gotoxy(34,17);write(' ');
      gotoxy(34,17);
      CH_ := INKEY;
      gotoxy(34,17);write(CH_);
      case CH_ of
        '1' : ENTER_STORE;
        '2' : OUTPUT;
        '3' : CHANGE_DETAILS;
        '7' : PRIN_FASD;
        '9' : PROGRAM_END := true;
      end;
    end;

  begin
    CH_ := '1';
    repeat
      if CH_ in ['1','2','3','9'] then LOGO;
      OPTIONS;
    until PROGRAM_END;
  end.