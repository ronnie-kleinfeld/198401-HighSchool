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

procedure PICTURE;
  begin
    assign(F1,'YEDA.DAT');
    if EXIST('YEDA.DAT')
     then begin
            reset(F1);  {çââó ïÅÖó}
            EOD := -1;
            {$I-}
            repeat
             EOD := EOD + 1;
             seek(F1,EOD);
             read(F1,R1);
            until ioresult <> 0;
            eod := eod - 1;
            {$I+}
          end
     else begin
            rewrite(F1); {ÖêêâÄ ïÅÖó}
            EOD := 0;
          end;
    writeln('         ÄôÖê                ÇôÖé                   ôÖòâî');
    writeln(EOD);
    for I := 0 to EOD do
     begin
       seek(F1,I);
       read(F1,R1);
       writeln(R1.SUBJECT,'   ',R1.ID,'   ',R1.INT,' ',R1.KOD);
     end;
  end;

  begin
    textmode;
    clrscr;
    PICTURE;
    close(F1);
  end.