program MSD;
  uses CRT;

  type
    G255_     = string[255];

  var
    I,J,K,L,X,Y,CHECK,LOOP,MAN,SH,SM,FH,FM,DAY,B,G,C,Times,N,Index,
    ID,VL                     : integer;
    CH_                       : char;
    A                         : real;
    A_,B_,C_,D_,M_            : G255_;
    Courses                   : byte;
    Main_MSD                  : array [1..7,8..22,0..59] of boolean;
    MSD_BOOLEAN				        : boolean;
    MSD_Data                  : array [1..2000,1..21] of byte;
    Prt_MSD                   : array [1..7,8..22] of string[20];

  const
    First_check               : boolean = false;
    Run                       : array[1..20] of byte=
		 (1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1);
    Data_start  : array[1..20] of byte=
		 (1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
    Course_ID : array[1..20] of string[17]=(
{1}  'š…‚„š„ š……˜—’+',
{2}  '         € —……‰™+',
{3}  '     € „—‰ˆ‘‰ˆˆ‘+',
{4}  '           „‰š‹+',
{5}  '       € „—‰ˆš+',
{6}  '           …˜—‰+',
{7}  '          š‰Œ‚€+',
{8}  '         …˜—‰-š+',
{9}  '      š…€…™‡-š+',
{0}  '     „—‰ˆ‘‰ˆˆ‘-š+',
{1}  '                +',
{2}  '                +',
{3}  '                +',
{4}  '                +',
{5}  '                +',
{6}  '                +',
{7}  '                +',
{8}  '                +',
{9}  '                +',
{0}  '                +');
    Course_freq : array[1..20] of byte=
		 (5,3,4,3,3,4,1,1,2,1,0,0,0,0,0,0,0,0,0,0);
    Course_data : array[1..27] of string[29]=(
{ 1} '010001212001329109     „ˆŒ‚+',
{ 2} '010002410001129109     „ˆŒ‚+',
{ 3} '010003412301359109     „ˆŒ‚+',
{ 4} '010004108000929109     „ˆŒ‚+',
{ 5} '010005108001244109     š‰˜…+',
{ 6} '020006312001329109     €˜‰”™+',
{ 7} '020007610001129109  ‰‰ˆ™˜…+',
{ 8} '020008108000929109  ‰‰ˆ™˜…+',
{ 9} '030009208000929109    ‰—–‰Œ+',
{10} '030010210001129109    ‰—–‰Œ+',
{11} '030011108000929109      ‰ˆˆ‘+',
{12} '030012110001129109     Œ…™+',
{13} '040013408000929109    ‚˜…š+',
{14} '040014110001129109    ‚˜…š+',
{15} '040015109001454109    ‰‚…Œ+',
{16} '050016210001214109     …Œ”+',
{17} '050017410001214109      …ƒ+',
{18} '050018412001414109      …ƒ+',
{19} '060019212301359109      ‘‰‰…+',
{20} '060020410001129109      ‘‰‰…+',
{21} '060021408000929109     ‰…+',
{22} '060022412301359109     ‰…+',
{23} '070023317302059204      ƒ‰…ƒ+',
{24} '080024214001459204      ‰…—+',
{25} '090025414001459102      Œ‰€+',
{26} '090026415001559102      Œ‰€-',
{27} '100027215001559204      ‰ˆˆ‘+');

Procedure Clear_Main_MSD;
  begin
    for I := 1 to 7 do
     for J := 8 to 22 do
      for K := 0 to 59 do
       Main_MSD[I,J,K] := false;
{1} for J := 8 to 22 do
     for K := 0 to 59 do
      Main_MSD[1,J,K] := true;
{3} for J := 8 to 16 do
     for K := 0 to 59 do
      Main_MSD[3,J,K] := true;
{5} for J := 8 to 22 do
     for K := 0 to 59 do
      Main_MSD[5,J,K] := true;
  end;

Procedure Main_Screen;
  begin
    clrscr;
    writeln;
    writeln('                                  š…’™ š‹˜’');
    writeln('+------------+------------+------------+------------+------------+------------+');
    writeln('|      …     |      „     |      ƒ     |      ‚     |           |      €     |');
    writeln('+------------+------------+------------+------------+------------+------------+');
    for I := 8 to 22 do
    writeln('|            |            |            |            |            |            |');
    writeln('+------------+------------+------------+------------+------------+------------+');
  end;

procedure PMSD;
  begin
    clrscr;
    writeln('               š‹˜’™ ‰‘˜…—„ š‰™˜');
    writeln('   „–˜    ˜ƒ‡  ƒ’  „’™ …‰ ˜”‘      ‘˜…— ™     ID');
    writeln('========== === ==== ==== === ==== ================ ==');
  end;

Procedure Print_MSD;
  begin
    PMSD;
    for I := 1 to 23 do
     begin
       write  (copy(course_data[I],19,10),' ');
       write  (copy(course_data[I],16, 3),' ');
       write  (copy(course_data[I],12, 4),' ');
       write  (copy(course_data[I], 8, 4),'  ');
       write  (copy(course_data[I], 7, 1),'  ');
       write  (copy(course_data[I], 3, 4),' ');
       val(copy(course_data[I],1,2),ID,VL);
       write  (Course_ID[ID],' ');
       writeln(copy(course_data[I], 1, 2));
     end;
  end;

Procedure Paint_MSD;
  begin
    gotoxy(1,6);
    for I := 8 to 22 do
     begin
       str(I,A_);
       if length(A_) = 1 then A_ := ' ' + A_;
       write('|            |            |            |            |            |            ',A_);
     end;
    gotoxy(1,14);
    for I := 1 to Courses do
     begin
       K := Data_start[I]+RUN[I]-1;
       val(copy(course_data[K],1,2),ID,VL);
       D_ := copy(Course_ID[ID],5,12);
       if copy(Course_ID[ID],17,1) = '+'
        then begin
               A_ := copy(course_data[K], 8, 4);
               B_ := copy(course_data[K],12, 4);
               val(copy(A_,1,2),SH,VL);
               val(copy(A_,3,2),SM,VL);
               val(copy(B_,1,2),FH,VL);
               val(copy(B_,3,2),FM,VL);
               val(copy(course_data[K], 7, 1),DAY,VL);
               if SH = FH
                then begin
                       gotoxy((7-day)*13-11,SH-2);write(D_);
                     end
                else begin
                       for J := SH to FH-1 do
                        begin
                          gotoxy((7-day)*13-11,J-2);write(D_);
                        end;
                       gotoxy((7-day)*13-11,SH-1);write('            ');
                       gotoxy((7-day)*13-11,SH-1);
                        write(copy(course_data[K],16,3),' ');
                        write(copy(course_data[K],22,7));
                     end;
             end;
     end;
  end;

procedure MSD_RUN_CHECK;
  begin
    MSD_BOOLEAN := true;
    Clear_Main_MSD;
    str(Times-LOOP,A_);
    for I := length(A_) to 8 do A_ := ' ' + A_;
    gotoxy(47,24); write(A_);
    gotoxy(1,1);
    for Y := Courses downto 1 do write(RUN[Y],' ');
    gotoxy(67,1);writeln('‰…˜ ƒŒ”‰‰Œ—');
    for Y := 1 to Courses do
     begin
       K := Data_start[Y]+RUN[Y]-1;
       val(copy(course_data[K],1,2),ID,VL);
{+/-}  D_ := copy(Course_ID[ID],17,1);
       if D_ = '+' then
        begin
          if copy(course_data[K],29,1) = '-' then MSD_BOOLEAN := false;
          A_ := copy(course_data[K], 8, 4);
          B_ := copy(course_data[K],12, 4);
          val(copy(A_,1,2),SH,VL);
          val(copy(A_,3,2),SM,VL);
          val(copy(B_,1,2),FH,VL);
          val(copy(B_,3,2),FM,VL);
          val(copy(course_data[K], 7, 1),DAY,VL);
          if (SH<8) or (SH>22) or (FH<8) or (FH>22) or
             (SM<0) or (SM>59) or (FM<1) or (FM>60) then MSD_BOOLEAN := false;
          if SH = FH then FH := FH + 1;
{—…ƒ}    for I := SH to FH-1 do
           for J := SM to 59 do if Main_MSD[DAY,I,J] then MSD_BOOLEAN := false;
          for J := 0 to FM do if Main_MSD[DAY,I,J] then MSD_BOOLEAN := false;
{…š‹}    for I := SH to FH-1 do
           for J := SM to 59 do Main_MSD[DAY,I,J] := true;
          for J := 0 to FM do Main_MSD[DAY,I,J] := true;
        end;
     end;
		gotoxy(16+trunc(LOOP/Times*48),23); write('=');
    str(trunc(LOOP/Times*100),A_);
    gotoxy(18+3-length(A_),22); write(trunc(LOOP/Times*100));
    case MSD_BOOLEAN of
     true  : begin
               G := G + 1;
               str(G,A_);
               gotoxy(35+4-length(A_),24); write(G);
               Paint_MSD;
{              readln(D_);
}              for I := 1 to 20 do MSD_Data[G,I] := Run[I];
               MSD_Data[G,21] := 1;
             end;
     false : begin
               B := B + 1;
               str(B,A_);
               gotoxy(17+8-length(A_),24); write(B);
             end;
    end;
  end;

procedure MAIN;
  begin
    Main_Screen;
    gotoxy(15,21); write('+-------------------------------------------------+');
    gotoxy(15,22); write('|    0%          ‰”…˜‰– š—‰ƒ - š„             |');
    gotoxy(15,23); write('+-                                               -+');
    gotoxy(15,24); write('|          : ‰Œ…‘”      : ‰…ˆ          : …˜š… |');
    gotoxy(15,25); write('+-------------------------------------------------+');
    for LOOP := 1 to Times do
     begin
       MSD_RUN_CHECK;
       RUN[1] := RUN[1] + 1;
       for X := 1 to Courses do
        begin
          if RUN[X] > Course_freq[X]
           then begin
                  RUN[X]   := 1;
                  RUN[X+1] := RUN[X+1] + 1;
                end;
        end;
     end;
  end;

procedure Printing_MSD;
  begin
    Index := 1;
    MSD_BOOLEAN := false;
    repeat
     if MSD_Data[Index,21]=1
      then begin
             Main_Screen;
             gotoxy(67,1);writeln('‰…˜ ƒŒ”‰‰Œ—');
             gotoxy(15,21);write('+------------------- š…‹˜’ š‚–„ -----------------+');
             gotoxy(15,22);write('| „€„ š‹˜’Œ - Enter          š‹˜’ š‚–„Œ - ˜”‘ |');
             gotoxy(15,23);write('|    (˜…†‡™Œ š‰ €Œ) ‰…š„ š‹˜’ š—‰‡Œ - Del |');
             gotoxy(15,24);write('|      : ˜”‘ š‹˜’                 : š…‹˜’ ‹"„‘ |');
             gotoxy(15,25);write('+-------------------- “…‘ - End ------------------+');
             str(Index,A_);
             gotoxy(17+4-length(A_),24);write(Index);
             str(G,A_);
             gotoxy(46+4-length(A_),24);write(G);
             for I := 1 to 20 do RUN[I] := MSD_Data[Index,I];
             Paint_MSD;
             gotoxy(1,1);
             for Y := 1 to 21 do write(MSD_Data[Index,Y],' ');
             gotoxy(1,25);Readln(D_);
             if D_ = '' then Index := Index + 1;
             if (D_ = 'Del') or (D_ = 'del') or (D_ = 'DEL')
              then begin
                     MSD_Data[Index,21] := 0;
                     Index := Index + 1;
                   end;
             if (D_ = 'END') or (D_ = 'End') or (D_ = 'end') then MSD_BOOLEAN := true;
             for I := 1 to length(D_) do
              begin
                A_ := copy(D_,I,1);
                if (A_ < chr(48)) and (A_ > chr(57)) then D_ := 'BAD';
              end;
             if (D_ = '') or (D_ = 'Del') or (D_ = 'del') or (D_ = 'DEL') or
                (D_ = 'END') or (D_ = 'End') or (D_ = 'end')
              then gotoxy(1,1)
              else if (D_ <> 'BAD') then val(D_,Index,VL);
           end
      else Index := Index + 1;
     if Index > G then Index := 1;
    until MSD_BOOLEAN;
  end;

  begin
    clrscr;
    for I := 1 to 2000 do MSD_Data[I,21] := 0;
    for I := 2 to 20 do Data_start[I] := Data_start[I-1] + Course_freq[I-1];
    B := 0;
    G := 0;
    Courses := 10;
  	Times := 1;
  	for I := 1 to Courses do Times := Times * Course_freq[I];
    Print_MSD;
    MAIN;
    clrscr;
    for I := 1 to G+3 do
     begin
       write(I,' : ');
       for J := 1 to 21 do write(MSD_Data[I,J],' ');
       writeln;
     end;
    Readln(D_);
    if G > 0 then Printing_MSD;
  end.