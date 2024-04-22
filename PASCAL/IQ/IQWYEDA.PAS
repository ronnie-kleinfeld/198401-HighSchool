program IQ;
{$U+}
{$C+}
  type
    YEDA = record
             SUBJECT,
             ID      : string[20];
             INT     : string[67];
             KOD     : boolean;
           end;

  var
    F1 : FILE OF YEDA;
    R1 : YEDA;
    A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,EOD : integer;
    A_,B_,C_,D_,E_,F_,G_,H_,I_,J_,K_,L_,M_,N_,O_,P_,Q_,R_,S_,T_,U_,V_,W_,X_,Y_,Z_,ENT_ : string[255];
    CH_ : char;
    OP,FG1  : boolean;
    MIN : array[1..5] of integer;
    ARI : array[1..10] of integer;
  {$I IQ.INC}

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

procedure CHECK_FIL;
  begin
    assign(F1,'YEDA.DAT');
    if EXIST('YEDA.DAT')
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
                    until (R1.KOD=true) or (EOD=0);
                    if (EOD=0) and (R1.KOD=false) then begin
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

procedure ASK;
  begin
    W := 0;
    Q := 0;
    CHECK_FIL;
    if EOD<16 then
     begin
       gotoxy(34,7);  write('ÖÅ Åñé òñÖê');
       gotoxy(35,8);  write('óâò ïÅÖóÑ');
       gotoxy(38,9);  write('ÖÄ');
       gotoxy(28,10); write('ïÅÖóÅ çâêÖöê óâîëé èâÄ');
       exit;
     end;
    gotoxy(1,1);  writeln('By Raanan Kleinfeld                            1988 (c) All Rights Reserved MADA');
    gotoxy(5,3);  write('…ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕª');
    gotoxy(5,4);  write('∫    : åâÇòö                                                         ∫');
    gotoxy(5,5);  write('∫ ==========                              : ÄôÖê                     ∫');
    gotoxy(5,6);  write('∫                  ˛˛˛˛˛˛˛˛˛˛˛˛˛˛˛˛˛˛˛˛˛˛˛˛˛˛˛˛˛˛˛                   ∫');
    gotoxy(5,7);  write('∫                                                                    ∫');
    gotoxy(5,8);  write('∫                                                   : ÇôÖé           ∫');
    gotoxy(5,9);  write('∫                            -------------------------------         ∫');
    gotoxy(5,10); write('∫                                                                    ∫');
    gotoxy(5,11); write('∫                                                                 .1 ∫');
    gotoxy(5,12); write('∫                                                                 .2 ∫');
    gotoxy(5,13); write('∫                                                                 .3 ∫');
    gotoxy(5,14); write('∫                                                                 .4 ∫');
    gotoxy(5,15); write('∫                                                                    ∫');
    gotoxy(5,16); write('∫ 9 - ôóÑ çÖâëå         _ : ÑêÖãêÑ ÑÅÖôöÑ öÄ ôóÑ                     ∫');
    gotoxy(5,17); write('∫                                                                    ∫');
    gotoxy(5,18); write('∫                                                                    ∫');
    gotoxy(5,19); write('»ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº');
    for I := 1 to 10 do ARI[I] := -1;
    for K := 1 to 10 do
     begin
       repeat
        MIN[5] := random(EOD);
        seek(F1,MIN[5]);
        read(F1,R1);
       until (ARI[1]<>MIN[5]) and
             (ARI[2]<>MIN[5]) and
             (ARI[3]<>MIN[5]) and
             (ARI[4]<>MIN[5]) and
             (ARI[5]<>MIN[5]) and
             (ARI[6]<>MIN[5]) and
             (ARI[7]<>MIN[5]) and
             (ARI[8]<>MIN[5]) and
             (ARI[9]<>MIN[5]) and
             (ARI[10]<>MIN[5]);
       ARI[K] := MIN[5];
       A_ := R1.SUBJECT;
       B_ := R1.ID;
       C_ := R1.INT;
       for I := 1 to 4 do MIN[I] := -1;
       for I := 1 to 4 do
        begin
          repeat
           B  := random(EOD);
           seek(F1,B);
           read(F1,R1);
          until (B<>MIN[1]) and (B<>MIN[2]) and (B<>MIN[3]) and (B<>MIN[4]) and (B<>MIN[5]);
          MIN[I] := B;
        end;
       B := random(4)+1;
       MIN[B] := MIN[5];
       gotoxy(7,4); write(K);
       gotoxy(46-length(A_),5); write(A_);
       gotoxy(56-length(B_),8); write(B_);
       for I := 1 to 4 do
        begin
          seek(F1,MIN[I]);
          read(F1,R1);
          gotoxy(70-length(R1.INT),I+10); write(R1.INT);
        end;
       buflen := 1;
       repeat
        write(chr(7));
        gotoxy(29,16); write('_ : ÑêÖãêÑ ÑÅÖôöÑ öÄ ôóÑ');
        gotoxy(29,16); read(kbd,CH_);
        gotoxy(29,16); write(CH_);
       until (CH_='1') or (CH_='2') or (CH_='3') or (CH_='4') or (CH_='9');
       if CH_='9' then exit;
       H := VAT(CH_);
       if H = B
        then begin
               gotoxy(27,18); write('  * * * ÑêÖãê ÑÅÖôöÑ * * *');
               W := W + 1;
             end
        else begin
               gotoxy(12,18); write('* * * ',B,' - ÄâÑ ÑêÖãêÑ ÑÅÖôöÑ * * * ÑêÖãê Äå ÑÅÖôöÑ * * *');
               Q := Q + 1;
             end;
       gotoxy(29,20); write('äâôéÑå âÉã ÖÑôåã ôóé ôóÑ');
       R_ := INKEY;
       gotoxy(29,20); write('                        ');
       gotoxy(5,4);   write('∫    : åâÇòö                                                         ∫');
       gotoxy(5,5);   write('∫ ==========                              : ÄôÖê                     ∫');
       gotoxy(5,8);   write('∫                                                   : ÇôÖé           ∫');
       gotoxy(5,11);  write('∫                                                                 .1 ∫');
       gotoxy(5,12);  write('∫                                                                 .2 ∫');
       gotoxy(5,13);  write('∫                                                                 .3 ∫');
       gotoxy(5,14);  write('∫                                                                 .4 ∫');
       gotoxy(5,18);  write('∫                                                                    ∫');
     end;
  end;

procedure PORT;
  procedure LKI;
    begin
      gotoxy(27,13); write('_ ? (Äå-å/èã-ã) åÖÇòö ÉÖí');
      buflen := 1;
      gotoxy(27,13); read(CH_);
      case CH_ of
       'f','ã','F' : PORT;
       'k','å','K' : exit;
       else begin
              write(chr(7));
              LKI;
            end;
      end;
    end;
  begin
    CH_ := ' ';
    ASK;
    if EOD<5 then exit;
    if CH_='9' then exit;
    clrscr;
    gotoxy(1,1);  write('By Raanan Kleinfeld                            1988 (c) All Rights Reserved MADA');
    gotoxy(37,4); write('öÖÄñÖö');
    gotoxy(37,5); write('------');
    gotoxy(31,7); write('   :    öÖêÖãê öÖÅÖôö òîëé');
    gotoxy(31,7); write(W);
    gotoxy(31,8); write('   : öÖêÖãê Äå öÖÅÖôö òîëé');
    gotoxy(31,8); write(Q);
    gotoxy(31,9); write(' % :           ÑáåñÑ âÜÖáÄ');
    gotoxy(29,9); write(W*10);
    LKI;
  end;

  begin
    textmode;
    PORT;
    close(F1);
  end.