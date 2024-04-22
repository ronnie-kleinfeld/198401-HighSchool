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
    A_,B_,C_,D_,E_,F_,G_,H_,I_,J_,K_,L_,M_,N_,O_,P_,Q_,
    R_,S_,T_,U_,V_,W_,X_,Y_,Z_,ENT_                         : string[255];
    CH_                                                     : char;
    EOG,FG1                                                 : boolean;
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

procedure CHG;
  begin
    D := 1;
    gotoxy(26,19); write('                           ');
    gotoxy(1,15);  write('บ            RETURN …’… … —   F7 … € €–            บ');
    case K of
     1 : begin
           gotoxy(1,8); write('บ                                                .................... :  €… บ');
           ENT_ := ' ';
           A_   := '';
           repeat
            A_ := GET(50,8,20,'.');
           until A_ <> '';
           if ENT_='***' then exit;
           R1.SUBJECT := A_;
           seek(F1,T-1);
           write(F1,R1);
         end;
     2 : begin
           gotoxy(1,10); write('บ                                                .................... :  … บ');
           ENT_ := ' ';
           B_   := '';
           repeat
            B_ := GET(50,10,20,'.');
           until (B_ <> '');
           if ENT_='***' then exit;
           R1.ID := B_;
           seek(F1,T-1);
           write(F1,R1);
         end;
     3 : begin
           gotoxy(1,12);  write('บ ................................................................... : …” บ');
           ENT_ := ' ';
           C_   := '';
           repeat
            C_ := GET(3,12,67,'.');
           until (C_ <> '');
           if ENT_='***' then exit;
           R1.INT := C_;
           seek(F1,T-1);
           write(F1,R1);
         end;
    end;
  end;

procedure CHANGE_MODE;
  begin
    FG1 := false;
    K := 1;
    D := 1;
    repeat
     gotoxy(72,8);  write('  €… ');
     gotoxy(72,10); write('  … ');
     gotoxy(72,12); write(' …” ');
     gotoxy(72,K*2+6); write('*');
     gotoxy(78,K*2+6); write('*');
     if D=1 then
      begin
        gotoxy(24,18); write('                               ');
        gotoxy(26,19); write('                           ');
        gotoxy(1,15);  write('บ      RETURN — …      … ’ –    F7 — …‘     บ');
        gotoxy(70-LENGTH(R1.SUBJECT),8); write(R1.SUBJECT);
        gotoxy(70-LENGTH(R1.ID),10);     write(R1.ID);
        gotoxy(70-LENGTH(R1.INT),12);    write(R1.INT);
        D := 0;
      end;
     ENT_ := ' ';
     gotoxy(28,19); write('   € —');
     repeat
      R_ := INKEY;
     until (R_='+') or (R_='-') or (R_=#13) or (copy(R_,1,1)=#27);
     CH_ := copy(R_,1,1);
     case CH_ of
      #13 : CHG;
      #27 : case copy(R_,2,1) of
             #65 : FG1 := true;
             #80 : if K<3 then K := K + 1;
             #72 : if K>1 then K := K - 1;
            end;
     end;
    until FG1;
    gotoxy(1,15); write('บ     ‘ - 1    … - 2    — - 3    … …‘ - 4    “…” –    บ');
    gotoxy(24,18); write('                               ');
    gotoxy(26,19); write('                           ');
    gotoxy(72,8);  write('  €… ');
    gotoxy(72,10); write('  … ');
    gotoxy(72,12); write(' …” ');
  end;

procedure DELETE_MODE;
  begin
    L := 1;
    for I := T to EOD-1 do
     begin
       seek(F1,I);
       read(F1,R1);
       seek(F1,I-1);
       write(F1,R1);
     end;
    R1.KOD := false;
    seek(F1,EOD-1);
    write(F1,R1);
    EOD := EOD - 1;
  end;

procedure FIL;
  begin
    if ENT_='***' then exit;
    R1.SUBJECT := A_;
    R1.ID      := B_;
    R1.INT     := C_;
    R1.KOD     := true;
    seek(F1,EOD);
    write(F1,R1);
    EOD := EOD + 1;
    gotoxy(1,10); writeln('บ                                                .................... :  … บ');
    gotoxy(1,12); writeln('บ ................................................................... : …” บ');
    str(eod+1,G_);
    gotoxy(3+6-LENGTH(G_),6); write(eod+1);
    J:=1;
  end;

procedure GETC;
  begin
    if ENT_='***' then exit;
    gotoxy(1,12);  write('บ ................................................................... : …” บ');
    ENT_ := ' ';
    C_ := '';
    repeat
     C_ := GET(3,12,67,'.');
    until (C_ <> '');
    if ENT_='***' then exit;
    if ENT_='ESC' then exit;
    FIL;
  end;

procedure GETB;
  begin
    if ENT_='***' then exit;
    gotoxy(1,10); write('บ                                                .................... :  … บ');
    ENT_ := ' ';
    B_ := '';
    repeat
     B_ := GET(50,10,20,'.');
    until (B_ <> '');
    if ENT_='***' then exit;
    if ENT_='ESC' then exit;
    GETC;
    if ENT_='ESC' then GETB;
    if J=1 then begin
                  J:=0;
                  GETB;
                end;
  end;

procedure GETA;
  begin
    if ENT_='***' then exit;
    if K=1 then
     begin
       gotoxy(1,8); write('บ                                                .................... :  €… บ');
       ENT_ := ' ';
       A_ := '';
       repeat
        A_ := GET(50,8,20,'.');
       until A_ <> '';
       K := 0;
     end;
    if ENT_='***' then exit;
    J:=0;
    GETB;
    if ENT_='***' then exit;
    if ENT_='ESC' then begin
                         K := 1;
                         GETA;
                       end;
  end;

procedure ENTER_MODE;
  begin
    gotoxy(1,6);   write('บ 000000 : •…— …—              ’ ‘                                บ');
    str(eod+1,G_);
    gotoxy(3+6-LENGTH(G_),6); write(eod+1);
    gotoxy(1,8);   write('บ                                                .................... :  €… บ');
    gotoxy(1,10);  write('บ                                                .................... :  … บ');
    gotoxy(1,12);  write('บ ................................................................... : …” บ');
    gotoxy(24,18); write('                               ');
    gotoxy(26,19); write('                           ');
    gotoxy(1,15);  write('บ                     ESC — …—      F7 — …‘                      บ');
    K := 1;
    ENT_ := ' ';
    GETA;
    L := 1;
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

procedure PICTURE;
  begin
    L := 1;
    gotoxy(1,1); writeln('By Raanan Kleinfeld                            1988 (c) All Rights Reserved MADA');
    CHECK_FIL;
    repeat
     if L=1 then
      begin
        T := EOD;
        gotoxy(1,5);   write('ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป');
        gotoxy(1,6);   write('บ 000000 : •…— …—              ’ ‘                                บ');
        gotoxy(1,7);   write('บ                                   þþþþþþþþþþ                                บ');
        gotoxy(1,8);   write('บ                                                .................... :  €… บ');
        gotoxy(1,9);   write('บ                                                                             บ');
        gotoxy(1,10);  write('บ                                                .................... :  … บ');
        gotoxy(1,11);  write('บ                                                                             บ');
        gotoxy(1,12);  write('บ ................................................................... : …” บ');
        gotoxy(1,13);  write('บ                                                                             บ');
        gotoxy(1,14);  write('ฬอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออน');
        gotoxy(1,15);  write('บ    ‘ - 1    … - 2    — - 3    … …‘ - 4    “…” –    บ');
        gotoxy(1,16);  write('ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ');
        gotoxy(24,18); write('                               ');
        gotoxy(26,19); write('                           ');
      end;
     if EOD>0 then
      begin
        seek(F1,T-1);
        read(F1,R1);
        str(T,J_);
        gotoxy(3+6-length(J_),6); write(T);
        gotoxy(70-LENGTH(R1.SUBJECT),8); write(R1.SUBJECT);
        gotoxy(70-LENGTH(R1.ID),10);     write(R1.ID);
        gotoxy(70-LENGTH(R1.INT),12);    write(R1.INT);
      end;
     if (EOD>0) and (L=1) then
      begin
        L := 0;
        gotoxy(24,18); write('•…— €– € …€ … …');
      end;
     if (EOD=0) and (L=1) then
      begin
        L := 0;
        gotoxy(36,18); write('— •…—');
      end;
     gotoxy(28,19); write('   € —');
     repeat
      R_ := INKEY;
     until (R_='1') or (R_='2') or (R_='3') or (R_='4') or
           (R_='5') or (R_='6') or (R_='+') or (R_='-') or (copy(R_,1,1)=#27);
     CH_ := copy(R_,1,1);
     case CH_ of
      '1' : ENTER_MODE;
      '2' : CHANGE_MODE;
      '3' : if EOD>0 then DELETE_MODE;
      '4' : EOG := true;
      #27 : case copy(R_,2,1) of
             #80,#75 : if T<EOD then T := T + 1;
             #72,#77 : if T>1   then T := T - 1;
             #71     : begin
                         T := 1;
                         if T>EOD then T := EOD;
                       end;
             #79     : T := EOD;
             #73     : begin
                         T := T - 10;
                         if T<1 then T := 1;
                       end;
             #81     : begin
                         T := T + 10;
                         if T>EOD then T := EOD;
                      end;
            end;
     end;
     gotoxy(3,6);   write('000000');
     gotoxy(50,8);  write('....................');
     gotoxy(50,10); write('....................');
     gotoxy(3,12);  write('...................................................................');
     gotoxy(24,18); write('                               ');
     gotoxy(21,18); write('     ');
    until EOG;
  end;

  begin
    textmode;
    clrscr;
    EOG := false;
    PICTURE;
    close(F1);
  end.