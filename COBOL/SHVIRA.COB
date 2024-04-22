       H-MIZUG			       SECTION.
      *---------------------------------------------------------------*
       H00.
	    PERFORM DZA-ATCHALAT-MIZUG.
	    PERFORM D10-AVODA UNTIL SW-SOF-MIZUG.
	    PERFORM DZZ-SIYOM-MIZUG.
       H-EXIT. EXIT.
      *===============================================================*
       H10-AVODA		       SECTION.
      *---------------------------------------------------------------*
       H10.
	    PERFORM DA-TIPUL.
	    PERFORM DB-KRIAT-TORAN.
	    PERFORM DC-BCHIRAT-TORAN.
       H10-EXIT. EXIT.
      *===============================================================*
       HA-TIPUL 		       SECTION.
      *---------------------------------------------------------------*
       HA00.
	    MOVE EZ-CHESHBON TO KM-CHESHBON.
	    MOVE EZ-SHEM TO KM-SHEM.
	    MOVE EZ-TZ TO KM-TZ.
	    MOVE EZ-DATE TO KM-DATE.
	    MOVE EZ-KOD TO KM-KOD.
	    MOVE EZ-SCHOM TO KM-SCHOM.
	    WRITE KM-REC.
       HA-EXIT. EXIT.
      *===============================================================*
       HB-KRIAT-TORAN		       SECTION.
      *---------------------------------------------------------------*
       HB00.
	    GO TO DB10
		  DB20
	     DEPENDING ON I-TORAN.
	    GO TO DB-EXIT.
      *===============================================================*
       HB10.
	    RETURN SB-BANK
		   AT END
		     MOVE HIGH-VALUE TO TV-TORAN(1)
		     GO TO DB-EXIT.
	    MOVE SB-CHESHBON TO TV-CHESHBON(1).
	    MOVE SB-SHEM TO TV-SHEM(1).
	    MOVE SB-TZ TO TV-TZ(1).
	    MOVE SB-DATE TO TV-DATE(1).
	    MOVE SB-KOD TO TV-KOD(1).
	    MOVE SB-SCHOM TO TV-SCHOM(1).
	    GO TO DB-EXIT.
       HB10-END.
      *===============================================================*
       HB20.
	    READ KB-BANK
		   AT END
		     MOVE HIGH-VALUE TO TV-TORAN(2)
		     GO TO DB-EXIT.
	    MOVE KB-CHESHBON TO TV-CHESHBON(2).
	    MOVE KB-SHEM TO TV-SHEM(2).
	    MOVE KB-TZ TO TV-TZ(2).
	    MOVE KB-DATE TO TV-DATE(2).
	    MOVE KB-KOD TO TV-KOD(2).
	    MOVE KB-SCHOM TO TV-SCHOM(2).
       HB20-END.
       HB-EXIT. EXIT.
      *===============================================================*
       HC-BCHIRAT-TORAN 	       SECTION.
      *---------------------------------------------------------------*
       HC00.
	    MOVE TV-TORAN(1) TO EZ-REC.
	    MOVE 1 TO I-TORAN.
	    PERFORM DC10 VARYING I-INDEX FROM 2 BY 1
	     UNTIL I-INDEX > 2.
	    IF EZ-REC = HIGH-VALUE MOVE 9 TO SW-MIZUG.
	    GO TO DC-EXIT.
      *===============================================================*
       HC10.
	    IF TV-TORAN(I-INDEX) < EZ-REC
		   MOVE TV-TORAN(I-INDEX) TO EZ-REC
		   MOVE I-INDEX TO I-TORAN.
       HC10-END.
       HC-EXIT. EXIT.
      *===============================================================*
       HZA-ATCHALAT-MIZUG	       SECTION.
      *---------------------------------------------------------------*
       HZA00.
	    OPEN INPUT KB-BANK.
	    IF NOT MH-KB-FILE-STATUS-TAKIN
		   DISPLAY '•…— š‡‰š” „Œ—š'
		   STOP RUN.
	    OPEN OUTPUT KM-BANK.
	    IF NOT MH-KM-FILE-STATUS-TAKIN
		   DISPLAY '•…— š‡‰š” „Œ—š'
		   STOP RUN.
	    PERFORM DB-KRIAT-TORAN VARYING I-TORAN FROM 1 BY 1 UNTIL
	     I-TORAN > 2.
	    PERFORM DC-BCHIRAT-TORAN.
       HZA-EXIT. EXIT.
      *===============================================================*
       HZZ-SIYOM-MIZUG		       SECTION.
      *---------------------------------------------------------------*
       HZZ00.
	    CLOSE KB-BANK.
	    CLOSE KM-BANK.
       HZZ-EXIT. EXIT.
      *===============================================================*
