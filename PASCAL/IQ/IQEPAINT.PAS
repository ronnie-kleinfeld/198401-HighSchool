program IQEPAINT;
{$I GRAPH.P}
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
    ANY                                                     : array[1..12480] of integer;
{$I IQ.INC}

procedure PAINT;
  begin
    FG1 := false;
    repeat
     R_  := INKEY;
     case copy(R_,2,1) of
      #80 : begin setheading(180); forwd(1); end;
      #72 : begin setheading(0);   forwd(1); end;
      #77 : begin setheading(90);  forwd(1); end;
      #75 : begin setheading(270); forwd(1); end;
      #65 : begin
              EOG := true;
              FG1 := true;
            end;
     end;
    until FG1;
  end;

  begin
    hires;
    hideturtle;
    wrap;
    EOG := false;
    repeat
     gotoxy(5,1);  write('ˆ ‰ ˜ ” š');
     gotoxy(5,2);  write('=========');
     gotoxy(1,4);  write('          …— -F1');
     gotoxy(1,5);  write('        Œ‚’ -F2');
     gotoxy(1,6);  write('  „˜…– ‰…Œ‰ -F3');
     gotoxy(1,7);  write('’…‰˜ ‰…Œ‰ -F4');
     gotoxy(1,8);  write(' š‰‹…š …‰‘ -F7');
     gotoxy(2,10); write('_ Šš˜‰‡ š€ ™—„');
     PAINT;
    until EOG;
  end.