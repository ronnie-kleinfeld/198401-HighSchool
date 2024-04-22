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
    Run                       : array [1..20] of byte;
    Data_start                : array [1..20] of byte;
    Course_freq               : array [1..20] of byte;

  const
    Course_ID : array[1..20] of string[17]=(
{1}  'öÖÇÑêöÑÅ öÖêÖòóí+',
{2}  '         Ä óÖÖâô+',
{3}  '     Ä Ñóâàëâààë+',
{4}  '           ÑÅâöã+',
{5}  '       Ä Ñóâàéöé+',
{6}  '           Öòóâé+',
{7}  '          öâåÇêÄ+',
{8}  '         Öòóâé-ö+',
{9}  '      öÖÄêÖÅôá-ö+',
{0}  '     Ñóâàëâààë-ö+',
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
    Course_data : array[1..27] of string[29]=(
{ 1} '010001212001329109     ÑàêåÇ+',
{ 2} '010002410001129109     ÑàêåÇ+',
{ 3} '010003412301359109     ÑàêåÇ+',
{ 4} '010004108000929109     ÑàêåÇ+',
{ 5} '010005108001244109     öâòÖê+',
{ 6} '020006312001329109     Äòâîô+',
{ 7} '020007610001129109  èââàôòÖÅ+',
{ 8} '020008108000929109  èââàôòÖÅ+',
{ 9} '030009208000929109    âóñâåÅ+',
{10} '030010210001129109    âóñâåÅ+',
{11} '030011108000929109      âààë+',
{12} '030012110001129109     èéåÖô+',
{13} '040013408000929109    èéÇòÖö+',
{14} '040014110001129109    èéÇòÖö+',
{15} '040015109001454109    èéâÇÖå+',
{16} '050016210001214109     èÖéåî+',
{17} '050017410001214109      èÖêÉ+',
{18} '050018412001414109      èÖêÉ+',
{19} '060019212301359109      ëââÖ+',
{20} '060020410001129109      ëââÖ+',
{21} '060021408000929109     èéâÖê+',
{22} '060022412301359109     èéâÖê+',
{23} '070023317302059204      ÉâÖÉ+',
{24} '080024214001459204      âêÖó+',
{25} '090025414001459102      èåâÄ+',
{26} '090026415001559102      èåâÄ+',
{27} '100027215001559204      âààë+');

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

procedure Start_Page;
  begin
   	clrscr;
    writeln('MSD Check Up - Software');
    writeln(' Check  - for check up data');
    writeln(' New    - for entering new data');
    writeln(' Look   - Look in checked data, only after check command');
    writeln(' Course - List of courses');
    writeln(' Data   - Courses data');
    writeln(' ?      - Help');
    writeln(' EXIT   - terminate procedure');
    writeln('');
    writeln('Enter Command (upper case only)');
  end;

Procedure Main_Screen;
  begin
    clrscr;
    writeln;
    writeln('                                  öÖíô öãòíé');
    writeln('+------------+------------+------------+------------+------------+------------+');
    writeln('|      Ö     |      Ñ     |      É     |      Ç     |      Å     |      Ä     |');
    writeln('+------------+------------+------------+------------+------------+------------+');
    for I := 8 to 22 do
    writeln('|            |            |            |            |            |            |');
    writeln('+------------+------------+------------+------------+------------+------------+');
  end;

procedure Print;
  begin
{   MSD_Data[Index,21]}
{   Prt_MSD                   : array [1..7,8..22] of string[20];}
    for I := 1 to 20 do RUN[I] := MSD_Data[Index,I];
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

procedure Print_All;
  begin
  end;

procedure PMSD;
  begin
    clrscr;
    gotoxy(29,1); writeln('öãòíéÅô çâëòÖóÑ öéâôò');
    writeln('   Status    Ññòé    òÉá   Éí   Ñíôé çÖâ  òîëé      ëòÖó çô     ID òîëé');
    writeln('                          Ñíô            òñÖóé                     ìàÖô');
    writeln('   ====== ========== === ===== ===== === ===== ================ == ====');
    gotoxy(2,24); write('============================ (h) - Top of List ===============================');
    if MSD_BOOLEAN
     then begin
            gotoxy(2,25); write(' (+) - Down   (-) - Up   (P) - Print   (A) - Show erased Courses   (E) - Exit ');
          end
     else begin
            gotoxy(2,25); write(' (+) - Down   (-) - Up   (P) - Print   (A) - Hide erased Courses   (E) - Exit ');
          end;
  end;

Procedure Print_Line_List;
  begin
    write  ('      ');
    write  (copy(course_data[I],29,1),'   ');
    write  (copy(course_data[I],19,10),' ');
    write  (copy(course_data[I],16, 3),' ');
    write  (copy(course_data[I],12, 2),':');
    write  (copy(course_data[I],14, 2),' ');
    write  (copy(course_data[I], 8, 2),':');
    write  (copy(course_data[I],10, 2),'  ');
    write  (copy(course_data[I], 7, 1),'   ');
    write  (copy(course_data[I], 3, 4),' ');
    write  (copy(Course_ID[ID],1,16),' ');
    write  (copy(course_data[I], 1, 2));
    str(I,A_);
    D_ := '';
    for K := 1 to 4-length(A_) do D_ := D_ + ' ';
    write(D_ + A_);
    writeln;
  end;

Procedure Print_MSD;
  begin
    J := 1;
    MSD_BOOLEAN := false;
    repeat
     PMSD;
     gotoxy(1,5);
     I := J;
     repeat
      val(copy(course_data[I],1,2),ID,VL);
      if MSD_BOOLEAN = false
       then if copy(Course_data[I],29,1) = '+' then Print_Line_List
                                               else I := I;
	    if MSD_BOOLEAN = true then Print_Line_List;
      I := I + 1;
     until (I = 28) or (I = J + 18);
     D_ := '';
     gotoxy(1,23);write('=> ');readln(D_);
     A_ := copy(D_,1,1);
     if (A_ = '+') or (A_ = '') then J := J + 1;
     if A_ = '-' then J := J - 1;
     if A_ = 'a' then MSD_BOOLEAN := not(MSD_BOOLEAN);
     if A_ = 'h' then J := 1;
     if J < 1  then J := 1;
     if J > 27 then J := 27;
    until A_ = 'e';
    Start_Page;
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

procedure Printing_MSD;
  begin
    Index := 1;
    MSD_BOOLEAN := false;
    repeat
     if MSD_Data[Index,21]=1
      then begin
             Main_Screen;
             gotoxy(67,1);writeln('âêÖò Éåîêââåó');
             gotoxy(10,21);write('+------------------------ öÖãòíé öÇñÑ -----------------------+');
             gotoxy(10,22);write('| åÖãÑ ëîÉÑ - All   ÑÄÅÑ öãòíéå - Enter   öãòíé öÇñÑå - òîëé |');
             gotoxy(10,23);write('| öãòíé ëîÉÑ - Print             çâêÖöêÑé öãòíé öóâáéå - Del |');
             gotoxy(10,24);write('|           : òîëé öãòíé                 : öÖãòíé ã"Ñë       |');
             gotoxy(10,25);write('+------------------------- ìÖë - End ------------------------+');
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
             if (D_='All') or (D_='ALL') or (D_='all') then Print_All;
             if (D_='Print') or (D_='PRINT') or (D_='print') then Print;
             if (D_ = '') or (D_ = 'Del') or (D_ = 'del') or (D_ = 'DEL') or
                (D_ = 'END') or (D_ = 'End') or (D_ = 'end')
              then gotoxy(1,1)
              else if (D_ <> 'BAD') then val(D_,Index,VL);
           end
      else Index := Index + 1;
     if Index > G then Index := 1;
    until MSD_BOOLEAN;
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
    gotoxy(67,1);writeln('âêÖò Éåîêââåó');
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
{óÖÉÅ}    for I := SH to FH-1 do
           for J := SM to 59 do if Main_MSD[DAY,I,J] then MSD_BOOLEAN := false;
          for J := 0 to FM do if Main_MSD[DAY,I,J] then MSD_BOOLEAN := false;
{ÅÖöã}    for I := SH to FH-1 do
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
               readln(D_);
               for I := 1 to 20 do MSD_Data[G,I] := Run[I];
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
    gotoxy(15,22); write('|    0%          çâîÖòâñ öóâÉÅ - èöéÑ             |');
    gotoxy(15,23); write('+-                                               -+');
    gotoxy(15,24); write('|          : çâåÖëî      : çâÅÖà          : ÖòöÖê |');
    gotoxy(15,25); write('+-------------------------------------------------+');
		for I := 1 to 20 do RUN[I] := 1;
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

procedure Check_Data;
  begin
    clrscr;
    for I := 1 to 2000 do MSD_Data[I,21] := 0;
    val(copy(Course_data[1],1,2),B,VL);
    Data_start[1] := 1;
    Course_freq[1] := 1;
		for I := 2 to 20 do
     begin
       Data_start[I] := 0;
       Course_freq[I] := 0;
     end;
    for I := 2 to 27 do
     begin
       val(copy(Course_data[I],1,2),G,VL);
       if G = B
        then Course_freq[G] := Course_freq[G] + 1
        else begin
               B := B + 1;
               Course_freq[B] := 1;
             end;
     end;
    for I := 2 to 20 do Data_start[I] := Data_start[I-1] + Course_freq[I-1];
    B := 0;
    G := 0;
    Courses := 5;
  	Times := 1;
  	for I := 1 to Courses do Times := Times * Course_freq[I];
    MAIN;
  end;

procedure Enter_new_Data;
  begin





  end;

begin
  Start_Page;
	G := 0;
  repeat
   write('=> ');readln(D_);
   A_ := copy(D_,1,1);
   if A_ = 'c' then Check_Data;
   if A_ = 'n' then Enter_new_Data;
   if A_ = 'l' then begin
                      if G > 0 then begin
                                      Printing_MSD;
                                      gotoxy(1,25);
                                    end
                               else begin
                                      write(#7);
                                      writeln('Data has to be check first');
                                    end;
                    end;
   if A_ = 'd' then Print_MSD;
   if A_ = '?' then Start_page;
  until D_ = 'EXIT';
end.