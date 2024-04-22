Program IQ_START;
{$U+}
{$C+}
  var
    F1 : FILE;
    A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,EOD : integer;
    A_,B_,C_,D_,E_,F_,G_,H_,I_,J_,K_,L_,M_,N_,O_,P_,Q_,
    R_,S_,T_,U_,V_,W_,X_,Y_,Z_,ENT_                         : string[255];
    CH_                                                     : char;
    PRG,PRH                                                 : boolean;

procedure WORK;
  begin
    repeat
      clrscr;
      gotoxy(1,1);   write('By Raanan Kleinfeld                           1988 (c) All Rights Reserved MADA');
      gotoxy(33,4);  write('Œ…‚˜š - ˆ‰˜”š');
      gotoxy(33,5);  write('-------------');
      gotoxy(29,7);  write('           .„˜†’ .1');
      gotoxy(29,8);  write('       .‰ŒŒ‹ ’ƒ‰ .2  IQWYEDA');
      gotoxy(29,9);  write('          .š…˜…– .3');
      gotoxy(29,10); write('  .„—‰‚…Œ - „„ .4');
      gotoxy(29,11); write('        .„—‰ˆš .5');
      gotoxy(29,12); write('         .š‰Œ‚€ .6');
      gotoxy(29,13); write('   .„‰˜† ‰‰™˜š .7');
      gotoxy(29,17); write('    .‰™€˜ ˆ‰˜”šŒ .8 û');
      gotoxy(29,19); write('           .…‰‘ .9 û');
      gotoxy(31,21); write('_ : Šš˜‰‡ š€ ™—„');
      gotoxy(31,21); read(kbd,CH_);
      case CH_ of
       '1' : exit;
       '2' : exit;
       '3' : exit;
       '4' : exit;
       '5' : exit;
       '6' : exit;
       '7' : exit;
       '8' : PRH := true;
       '9' : begin
               PRH := true;
               PRG := true;
              end;
       else write(chr(7));
      end;
    until PRH;
  end;

procedure TEST;
  begin
  end;

procedure ENTER;
  begin
    repeat
      clrscr;
      gotoxy(1,1);   write('By Raanan Kleinfeld                           1988 (c) All Rights Reserved MADA');
      gotoxy(29,4);  write(' ‰…š š‘‹„ - ˆ‰˜”š');
      gotoxy(29,5);  write('----------------------');
      gotoxy(29,7);  write('           .„˜†’ .1');
      gotoxy(29,8);  write('       .‰ŒŒ‹ ’ƒ‰ .2  IQEYEDA');
      gotoxy(29,9);  write('          .š…˜…– .3');
      gotoxy(29,10); write('  .„—‰‚…Œ - „„ .4');
      gotoxy(29,11); write('        .„—‰ˆš .5');
      gotoxy(29,12); write('         .š‰Œ‚€ .6');
      gotoxy(29,13); write('   .„‰˜† ‰‰™˜š .7');
      gotoxy(29,17); write('    .‰™€˜ ˆ‰˜”šŒ .8 û');
      gotoxy(29,19); write('           .…‰‘ .9 û');
      gotoxy(31,21); write('_ : Šš˜‰‡ š€ ™—„');
      gotoxy(31,21); read(kbd,CH_);
      case CH_ of
       '1' : exit;
       '2' : exit;
       '3' : exit;
       '4' : exit;
       '5' : exit;
       '6' : exit;
       '7' : exit;
       '8' : PRH := true;
       '9' : begin
               PRH := true;
               PRG := true;
              end;
       else write(chr(7));
      end;
    until PRH;
  end;

procedure HELP1;
  begin
  end;

  begin
    PRG := false;
    repeat
      PRH := false;
      textmode;
      clrscr;
      gotoxy(1,1);   write('By Raanan Kleinfeld                           1988 (c) All Rights Reserved MADA');
      gotoxy(35,4);  write('‰™€˜ ˆ‰˜”š  IQS');
      gotoxy(34,5);  write('------------');
      gotoxy(32,7);  write('        .„˜†’ .1');
      gotoxy(32,9);  write('.‰…š š‘‹„ .2 û');
      gotoxy(32,11); write('      .š…‰‡ .3');
      gotoxy(32,13); write('       .Œ…‚˜š .4 û');
      gotoxy(32,17); write('        .…‰‘ .9 û');
      gotoxy(31,21); write('_ : Šš˜‰‡ š€ ™—„');
      gotoxy(31,21); read(kbd,CH_);
      case CH_ of
       '1' : HELP1;
       '2' : ENTER;
       '3' : TEST;
       '4' : WORK;
       '9' : PRG := true;
       else write(chr(7));
      end;
    until PRG;
  end.