Program IQ;
{$U+}
{$C+}
  label
    A100,A110;

  type
    YEDA = record
             SUBJECT,
             ID      : string[20];
             INT     : string[67];
           end;

  var
    F1 : FILE OF YEDA;
    R1 : YEDA;
    A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,EOD : integer;
    A_,B_,C_,D_,E_,F_,G_,H_,I_,J_,K_,L_,M_,N_,O_,P_,Q_,
    R_,S_,T_,U_,V_,W_,X_,Y_,Z_,ENT_                         : string[255];
    CH_                                                     : char;
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

procedure GETA;
  begin
    ENT_ := ' ';
    B_ := '';
    repeat
     B_ := INPUT_H(50,10,20,'.');
    until (B_ <> '');
    if ENT_='***' then exit;
    ENT_ := ' ';
    C_ := '';
    repeat
     C_ := INPUT_H(3,12,67,'.');
    until (C_ <> '');
    if ENT_='***' then exit;
    R1.SUBJECT := A_;
    R1.ID      := B_;
    R1.INT     := C_;
    seek(F1,EOD);
    write(F1,R1);
    EOD := EOD+1;
    gotoxy(1,10); writeln('บ                                                .................... :  … บ');
    gotoxy(1,12); writeln('บ ................................................................... : …” บ');
    GETA;
  end;

procedure ENTERA;
  begin
    clrscr;
    gotoxy(1,1); writeln('By Raanan Kleinfeld                            1988 (c) All Rights Reserved MADA');
    assign(F1,'YEDA.DAT');
    if EXIST('YEDA.DAT')
     then begin
            reset(F1);
            EOD := 0;
          end
     else begin
            rewrite(F1);
            EOD := -1;
            {$I-}
            repeat
             EOD := EOD + 1;
             seek(F1,EOD);
             read(F1,R1);
            until ioresult <> 0;
            {$I+}
          end;
    gotoxy(1,5);   writeln('ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป');
    gotoxy(1,6);   writeln('บ                                   ’ ‘                                บ');
    gotoxy(1,7);   writeln('บ                                   þþþþþþþþþþ                                บ');
    gotoxy(1,8);   writeln('บ                                                .................... :  €… บ');
    gotoxy(1,9);   writeln('บ                                                                             บ');
    gotoxy(1,10);  writeln('บ                                                .................... :  … บ');
    gotoxy(1,11);  writeln('บ                                                                             บ');
    gotoxy(1,12);  writeln('บ ................................................................... : …” บ');
    gotoxy(1,13);  writeln('บ                                                                             บ');
    gotoxy(1,14);  writeln('ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ');
    gotoxy(34,16); writeln('F7 — …‘');
    ENT_ := ' ';
    A_ := '';
    repeat
     A_ := INPUT_H(50,8,20,'.');
    until A_ <> '';
    if ENT_='***' then exit;
    GETA;
  end;

procedure ENTER_YEDA;
  begin
    ENTERA;
    if ENT_ = '***'
     then begin
            write(chr(7));
            gotoxy(31,18); write('… ‘ …‘');
            for I := 1 to 2500 do
          end;
    close(F1);
  end;

procedure ENTER_DATA;
  begin
    repeat
      clrscr;
      gotoxy(1,1);   writeln('By Raanan Kleinfeld                            1988 (c) All Rights Reserved MADA');
      gotoxy(30,4);  writeln(': ’ ‘ ” :');
      gotoxy(30,5);  writeln('--------------------');
      gotoxy(32,7);  writeln('    . ’ .1');
      gotoxy(32,15); writeln('.€– - …‘ .9');
      gotoxy(31,20); writeln('_ :  € —');
      A_ := '';
      repeat
       A_ := INPUT_N(31,20,1,0,'0');
      until A_ <> '';
      A := vat(A_);
      case A of
       1 : ENTER_YEDA;
       9 : exit;
       else write(chr(7));
      end;
    until A = 9;
  end;

  begin
    repeat
      TEXTMODE;
      clrscr;
      gotoxy(1,1);   writeln('By Raanan Kleinfeld                            1988 (c) All Rights Reserved MADA');
      gotoxy(33,4);  writeln(': € ” :');
      gotoxy(33,5);  writeln('--------------');
      gotoxy(33,7);  writeln('.’ ‘ .1');
      gotoxy(31,15); writeln('.€– - …‘ .9');
      gotoxy(32,20); writeln('_ :  € —');
      Z_ := '';
      repeat
       Z_ := INPUT_N(32,20,1,0,'0');
      until Z_ <> '';
      Z := vat(Z_);
      case Z of
       1 : ENTER_DATA;
       9 : exit;
       else write(chr(7));
      end;
    until Z = 9;
  end.