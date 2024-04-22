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
  var
    SAVERG                                                  : RGTP;
    SAVEHF                                                  : HALFRGTP absolute SAVERG;
    WIK                                                     : array[1..25,1..80] of char;
    INCI1,INCI2,INCI3,INCI4,INCI5,INCI6,INCI7,INCI8,INCI9,
    INCI10,INCI11,INCI12,INCI100,INCI101,INCI102,GETX,GETY,
    GETLEN,GETI,GETAA                                        : integer;
    INCS1,INCS2,INCS3,INCS4,INCS5,GETB_,GETMIKE_,ENT_       : G255;
    INCC1,INCC2,INCC3,GETDEL,GETCH_                         : char;
    INCB1                                                   : boolean;
    INCY1                                                   : byte;

  const
    VG  : string[27] = 'tcdsvuzjyhlfkonibxg;p.mera,';
    VG1 : string[27] = '€‚ƒ„…†‡ˆ‰Š‹ŒŽ‘’“”•–—˜™š';

  procedure CURSOR(TURNON : byte);
    begin
{     case INCY1 of
       0 : SAVERG.CX := $2000;
       2 : if mem[0 : $449] = 7
            then SAVERG.CX := $0C0D
            else SAVERG.CX := $0607;
       1 : if mem[0 : $449] = 7
            then SAVERG.CX := $070D
            else SAVERG.CX := $0607;
      end;
      SAVERG.AX := $0100;
      intr($10,SAVERG)
}   end;

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

  function GET(GETX,GETY,GETLEN:integer; GETDEL:char):G255;
    procedure GETB;
      begin
        repeat
         gotoxy(GETAA,GETY);
         INCS1 := INKEY;
         INCC3 := right(INCS1,1);
         INCC2 := left (INCS1,1);
         case INCC2 of
{„—‰‡Ž}   #08 : begin
                  if GETX+GETLEN-1-GETAA>0 then
                   begin
                     GETMIKE_ := right(GETMIKE_,length(GETMIKE_)-1);
                     GETAA := GETAA + 1;
                     gotoxy(GETAA,GETY); write(GETDEL);
                   end;
                end;
          #27 : begin
                  gotoxy(1,1); write('1');
                  case INCC3 of
                   #65 : begin
                           gotoxy(1,1); write('3');
                           ENT_ := '***';
                           GET  := 'A';
                           exit;
                         end;
                   #27 : begin
                           gotoxy(1,1); write('4');
                           ENT_ := 'ESC';
                           GET  := 'A';
                           exit;
                         end;
                  end;
                end;
{‰…š}  #32..#255 : begin
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

