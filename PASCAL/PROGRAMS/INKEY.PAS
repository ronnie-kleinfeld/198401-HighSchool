  function INKEY : G255;
    begin
      SAVERG.AX := 0;
      intr($16,SAVERG);
      INCS1 := '';
      if SAVEHF.AL = 0
       then INCS1 := #27+chr(SAVEHF.AH)
       else INCS1 := chr(SAVEHF.AL);
      INKEY := INCS1;
    end;