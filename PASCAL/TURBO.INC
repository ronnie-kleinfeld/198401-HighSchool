{New commands :
   CURSOR(INCY1:byte);                                 - change the cursor => 0,1,2;
   SCREEN(INCI1,INCI2:integer):char                    - return a char of INCI2,INCI1
   CHEZKA(INCI1,INCI2:integer):integer;                - return INCI2 ^ INCI1
   SPC(INCI1:integer):G255                      - return a string of INCI1's spaces
   STRIG(INCS2:G255;INCI1:integer):G255  - return a string of INCI1's INCS2
   SWAP(INCI1,INCI2:integer)                           - swap INCI1 and INCI1 (integers)
   SWAP_(INCS1,INCS2:G255)                      - swap INCI1 and INCI1 (strings)
   SGN(INCI1:integer):integer                          - return the sign of INCI1
   LEFT(INCS1:G255;INCI1:integer):G255   - return the left side of INCS1 ending at INCI1
   RIGHT(INCS1:G255;INCI1:integer):G255  - return the right side of INCS1 starting at INCI1
   POST(INCS1,INCS2:G255;INCI1:integer):integer - searches for INCS2 in INCS1 starting at INCI1
   VAT(INCS2:G255):integer                      - return the integer of a numeric string
   INKEY:G255                                   - return the keyboard
   CLEAN_WINDOW(INCI1,INCI2,INCI3,INCI4:integer)       - clean a window
   TAKE_WINDOW(INCI1,INCI2,INCI3,INCI4:integer)        - open a window
   PUT_WINDOW(INCI1,INCI2,INCI3,INCI4:integer)         - close a window
   INPUT_E(LINE, COLUMN, LENGTH:integer; DELETE:char; KOD:byte):G255
   INPUT_H(LINE, COLUMN, LENGTH:integer; DELETE:char):G255
   INPUT_N(LINE, COLUMN, LENGTH, LENGTH:integer; DELETE:char):G255
   INPUT_T(LINE, COLUMN:integer; DELETE:char; INSERT:G255):G255
   INPUT_D(LINE, COLUMN:integer; DELETE:char; INSERT:G255):G255;
    - return a string
       KOD - (English)
              0 - All keyboard (only English).
              1 - All keyboard (English \ Hebrew).
              2 - File name.
              3 - Hexadecimal.
}
  type
    RGTP     = record
                 AX,BX,CX,DX,BP,SI,DI,DS,ES,FLAGS : integer;
               end;
    HALFRGTP = record
                 AL,AH,BL,BH,CL,CH,DL,DH          : byte
               end;
    G255     = string[255];
  const
    INC15 : STRING[27] = 'tcdsvuzjyhlfkonibxg;p.mera,';
  var
    SAVERG                              : RGTP;
    SAVEHF                              : HALFRGTP absolute SAVERG;
    WIK                                 : array[1..25,1..80] of char;
    INCI1,INCI2,INCI3,INCI4,INCI5,INCI6,INCI7,
    INCI8,INCI9,INCI10,INCI11,INCI12,INCI100,INCI101,INCI102    : integer;
    INCS1,INCS2,INCS3,INCS4,INCS5       : G255;
    INCC1,INCC2,INCC3                   : char;
    INCB1                               : boolean;
    INCY1                               : byte;

  procedure CURSOR(TURNON : byte);
    begin
      case INCY1 of
       0 : EXIT; {SAVERG.CX := $2000;}
       2 : if mem[0 : $449] = 7
            then SAVERG.CX := $0C0D
            else SAVERG.CX := $0607;
       1 : if mem[0 : $449] = 7
            then SAVERG.CX := $070D
            else SAVERG.CX := $0607;
      end;
      SAVERG.AX := $0100;
      intr($10,SAVERG)
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
        SAVERG.AX := $800;
        SAVERG.BX := 0;
        INTR($10,SAVERG);
        GET_CHAR := SAVERG.AX;
      end;
    begin
      INCI3 := WHEREX;
      INCI4 := WHEREY;
      gotoxy(INCI1,INCI2);
      SCREEN := chr(ZIMZOM(GET_CHAR));
      gotoxy(INCI3,INCI4);
    end;

  function CHEZKA(INCI1,INCI2 : integer) : integer;
    begin
      INCI3 := 1;
      for INCI4 := 1 to INCI1 do INCI3 := INCI3*INCI2;
      CHEZKA := INCI3;
    end;

  function SPC(INCI1 : integer) : G255;
    begin
      INCS1 := '';
      for INCI2 := 1 to INCI1 do INCS1 := INCS1+' ';
      SPC := INCS1;
    end;

  procedure SWAP(INCI1,INCI2 : integer); 
    begin
      INCI3 := INCI1;
      INCI1 := INCI2;
      INCI2 := INCI3; 
    end;

  procedure SWAP_(INCS1,INCS2 : G255);
    begin
      INCS3 := INCS1;
      INCS1 := INCS2;
      INCS2 := INCS3;
    end;

  function SGN(INCI1 : integer) : integer;
    begin
      case INCI1 of
       -32767..-1 : SGN := -1;
       0          : SGN := 0;
       1..32767   : SGN := 1;
      end;
    end;

  function LEFT(INCS1 : G255; INCI1 : integer) : G255;
    begin
      LEFT := copy(INCS1,1,INCI1);
    end;

  function RIGHT(INCS1 : G255; INCI1 : integer) : G255;
    begin
      RIGHT := copy(INCS1,length(INCS1)-INCI1+1,INCI1);
    end;

  function POST(INCS1,INCS2 : G255; INCI1 : integer) : integer;
    begin
      POST := pos(INCS2,right(INCS1,INCI1));
    end;

  function STRIG(INCS2 : G255; INCI1 : integer) : G255;
    begin
      INCS1 := '';
      for INCI2 := 1 to INCI1 do INCS1 := INCS1+INCS2;
      STRIG := INCS1;
    end;

  function VAT(INCS2 : G255) : integer;
    begin
      val(INCS2,INCI1,INCI2);
      VAT := INCI1;
    end;

  function INKEY : G255;
    begin
      SAVERG.AX := 0;
      intr($16,SAVERG);
      INCS1 := '';
      if SAVEHF.AL = 0
       then INCS1 := #27+chr(SAVEHF.AH)
       else INCS1 := chr(SAVEHF.AL);
      INKEY := INCS1;
    end;


  function INPUT_E(INCI2,INCI3,INCI4 : integer;INCC1 : char;INCI5 : byte) : G255;
    procedure COR;
      begin
        if INCB1 then CURSOR(2)
                 else CURSOR(1);
      end;
    begin
      INCS2 := 'tcdsvuzjyhlfkonibxg;p.mera,';
      INCS3 := 'ôêÅÇóãíâèáåäñéçî/òÉÄÖÑ'+#39+'ëàÜ';
      CURSOR(1);
      INCB1 := false;
      gotoxy(INCI2,INCI3); for INCI1 := 1 to INCI4 do write(INCC1);
      INCI6 := INCI2;
      INCI8 := INCI2;
      INCI7 := INCI6+INCI4-1;
      repeat
       COR;
       gotoxy(INCI2,INCI3);
       INCS1 := INKEY;
       INCC3 := right(INCS1,1);
       INCC2 := left (INCS1,1);
       case INCC2 of
        #08       : begin
                      if INCI2 = INCI6
                       then writeln(chr(07))
                       else begin
                              CURSOR(0);
                              for INCI1 := INCI2 to INCI7+1 do
                               begin
                                 gotoxy(INCI1-1,INCI3); write(SCREEN(INCI1,INCI3));
                               end;
                              gotoxy(INCI7,INCI3); write(INCC1);
                              COR;
                              INCI2 := INCI2-1;
                              INCI8 := INCI8-1;
                            end;
                    end;
        #27       : case INCC3 of
                     #27 : begin
                             gotoxy(INCI6,INCI3); for INCI1 := 1 to INCI4 do write(INCC1);
                             INCI2 := INCI6;
                             INCI8 := INCI6;
                             INCB1 := false;
                             COR;
                           end;
                     #71 : INCI2 := INCI6;
                     #75 : INCI2 := INCI2-1;
                     #77 : INCI2 := INCI2+1;
                     #79 : begin
                             INCI1 := INCI6;
                             repeat
                              INCI1 := INCI1+1;
                              INCS1 := SCREEN(INCI1,INCI3);
                             until (INCI1 = INCI7) or (INCS1 = INCC1);
                             INCI2 := INCI1;
                           end;
                     #82 : INCB1 := not(INCB1);
                     #83 : begin
                             CURSOR(0);
                             for INCI1 := INCI2 to INCI7 do
                              begin
                                gotoxy(INCI1,INCI3); write(SCREEN(INCI1+1,INCI3));
                              end;
                             gotoxy(INCI7,INCI3); write(INCC1);
                             COR;
                             INCI8 := INCI8-1;
                           end;
                    end;
        #32..#255 : begin
                      if INCI2 = INCI7+1
                       then writeln(chr(7))
                       else begin
                              case INCI5 of
                               0 : begin
                                     if INCC2 in ['Ä'..'í','î','ñ'..'ô']
                                      then INCC2 := chr(pos(INCC2,INCS3)+96);
                                     case INCC2 of
                                      'ö' : INCC2 := ',';
                                      'ì' : INCC2 := ';';
                                      'ï' : INCC2 := '.';
                                     end;
                                   end;
                               1 : if INCC2 in ['a'..'z',';','.',',']  then INCC2 := chr(pos(INCC2,INCS2)+127);
                               2 : begin
                                     INCC2 := upcase(INCC2);
                                     if not (INCC2 in ['A'..'Z','0'..'9','(',')','[',']','@','#','$','%','^','&','!','-','_',
                                      '/','~']) then INCC2 := #27;
                                   end;
                               3 : begin
                                     INCC2 := upcase(INCC2);
                                     if not (INCC2 in ['A'..'F','0'..'9']) then INCC2 := #27;
                                   end;
                              end;
                              if INCC2 <> #27 then
                               if INCB1
                                then begin
                                       CURSOR(0);
                                       for INCI1 := INCI7 downto INCI2+1 do
                                        begin
                                          gotoxy(INCI1,INCI3); write(SCREEN(INCI1-1,INCI3));
                                        end;
                                        gotoxy(INCI2,INCI3); write(INCC2);
                                       COR;
                                       INCI8 := INCI8+1;
                                     end
                                else begin
                                       write(INCC2);
                                       INCI2 := INCI2+1;
                                       INCI8 := INCI8+1;
                                     end;
                            end;
                    end;
       end;
       if INCI2 > INCI7 then INCI2 := INCI7+1;
       if INCI8 > INCI7 then INCI8 := INCI7+1;
       if INCI2 < INCI6 then INCI2 := INCI6;
      until INCC2 = #13;
      INCS1 := '';
      if INCI8 <> INCI6 then for INCI1 := INCI6 to INCI8-1 do INCS1 := INCS1+SCREEN(INCI1,INCI3);
      INPUT_E := INCS1;
    end;

  function INPUT_H(INCI2,INCI3,INCI4 : integer;INCC1 : char) : G255;
    procedure COR;
      begin
        if INCB1 then CURSOR(2)
                 else CURSOR(1);
      end;
    begin
      CURSOR(1);
      INCS2 := 'tcdsvuzjyhlfkonibxg;p.mera,';
      INCB1 := false;
      INCI5 := INCI2;
      INCI7 := INCI5;
      INCI6 := INCI5+INCI4-1;
      gotoxy(INCI2,INCI3); for INCI1 := INCI5 to INCI6 do write(INCC1);
      repeat
       COR;
       gotoxy(INCI6-(INCI2-INCI5),INCI3);
       INCS1 := INKEY;
       INCC3 := right(INCS1,1);
       INCC2 := left (INCS1,1);
       case INCC2 of
        #08       : begin
                      if INCI2 = INCI5
                       then writeln(chr(7))
                       else begin
                              CURSOR(0);
                              for INCI1 := INCI6-(INCI2-INCI5) downto INCI5 do
                               begin
                                 gotoxy(INCI1+1,INCI3); write(SCREEN(INCI1,INCI3));
                               end;
                              COR;
                              CURSOR(0); gotoxy(INCI5,INCI3); write(INCC1); COR;
                              INCI2 := INCI2-1;
                              INCI7 := INCI7-1;
                            end;
                    end;
        #27       : case INCC3 of
                    #27 : begin
                             gotoxy(INCI5,INCI3); for INCI1 := INCI5 to INCI6 do write(INCC1);
                             INCI2 := INCI5;
                           end;
                     #71 : INCI2 := INCI5;
                     #75 : INCI2 := INCI2+1;
                     #77 : INCI2 := INCI2-1;
                     #79 : begin
                             INCI1 := INCI6;
                             repeat
                              INCI1 := INCI1-1;
                              INCS1 := SCREEN(INCI1,INCI3);
                             until (INCI1 = INCI5) or (INCS1 = INCC1);
                             INCI2 := INCI6-(INCI1-INCI5);
                           end;
                     #82 : INCB1 := not(INCB1);
                     #83 : begin
                             CURSOR(0);
                             for INCI1 := INCI6-(INCI2-INCI5)-1 downto INCI5 do
                              begin
                                gotoxy(INCI1+1,INCI3); write(SCREEN(INCI1,INCI3));
                              end;
                             COR;
                             CURSOR(0); gotoxy(INCI5,INCI3); write(INCC1); COR;
                             INCI7 := INCI7-1;
                           end;
                    end;
        #32..#255 : begin
                      if INCI2 = INCI6+1
                       then writeln(chr(7))
                       else begin
                              if INCC2 in [#97..#122] then INCC2 := chr(pos(INCC2,INCS2)+127);
                              if INCB1
                               then begin
                                      CURSOR(0);
                                      for INCI1 := INCI5+1 to INCI6-(INCI2-INCI5) do
                                       begin
                                         gotoxy(INCI1-1,INCI3); write(SCREEN(INCI1,INCI3));
                                       end;
                                      COR;
                                      CURSOR(0);
                                      gotoxy(INCI6-(INCI2-INCI5),INCI3); write(INCC2); COR;
                                    end
                               else begin
                                      write(INCC2);
                                      INCI2 := INCI2+1;
                                    end;
                              INCI7 := INCI7+1;
                            end;
                    end;
       end;
       if INCI2 > INCI6 then INCI2 := INCI6+1;
       if INCI7 > INCI6 then INCI7 := INCI6+1;
       if INCI2 < INCI5 then INCI2 := INCI5;
      until INCC2 = #13;
      INCS1 := '';
      for INCI1 := INCI6-(INCI7-INCI5)+1 to INCI5+INCI4 do INCS1 := INCS1+SCREEN(INCI1,INCI3);
      INPUT_H := INCS1;
    end;

  function INPUT_N(INCI4,INCI5,INCI6,INCI7 : integer;INCC1 : char) : G255;
    procedure INPUT_M;
      begin
        INCI10 := INCI8+2;
        INCI11 := INCI8+INCI7+1;
        INCI12 := INCI10;
        repeat
         CURSOR(0);
         gotoxy(INCI10,INCI5); write(INCS3);
         CURSOR(1);
         gotoxy(INCI12,INCI5);
         INCS1 := INKEY;
         INCC3 := right(INCS1,1);
         INCC2 := left (INCS1,1);
         case INCC2 of
          #08      : if INCI12 = INCI10
                      then exit
                      else begin
                             INCS3 := left(INCS3,length(INCS3)-1);
                             CURSOR(0);
                             gotoxy(INCI12-1,INCI5); write(INCC1);
                             INCI12 := INCI12-1;
                           end;
          #27      : if INCC3 = #27
                      then begin
                             CURSOR(0);
                             gotoxy(INCI10,INCI5); for INCI3 := 1 to INCI7 do write(INCC1);
                             INCS3  := '';
                             INCI12 := INCI10;
                           end;
          #48..#57 : if INCI12 = INCI11+1
                      then writeln(chr(7))
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
      CURSOR(1);
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
       CURSOR(0);
       gotoxy(INCI4+1,INCI5); write(INCS2);
       CURSOR(1);
       gotoxy(INCI8,INCI5);
       INCS1 := INKEY;
       INCC3 := right(INCS1,1);
       INCC2 := left (INCS1,1);
       case INCC2 of
        #08      : if INCI4 = INCI8
                    then writeln(chr(7))
                    else begin
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
        #46      : if INCI7 <> 0 then INPUT_M;
        #48      : if INCI4 = INCI8
                    then writeln(chr(7))
                    else begin
                           INCS2 := INCS2+INCC2;
                           INCI4 := INCI4-1;
                         end;
        #49..#57 : if INCI4 = INCI9-1
                    then writeln(chr(7))
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
    end;