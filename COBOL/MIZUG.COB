       IDENTIFICATION		       DIVISION.
      *****************************************************************
       PROGRAM-ID.		       FORMAT.
       INSTALLATION.		       RAANAN-KLEINFELD.
       DATE-WRITTEN.		       01/01/87.
       DATE-COMPILED.		       01/01/87.
       SECURITY.		       CHOFSHI.
      *****************************************************************
       ENVIRONMENT		       DIVISION.
      *****************************************************************
       CONFIGURATION		       SECTION.
      *---------------------------------------------------------------*
       SOURCE-COMPUTER. 	       IBM-PC-XT.
       OBJECT-COMPUTER. 	       IBM-PC.
       SPECIAL-NAMES.
      *===============================================================*
       INPUT-OUTPUT		       SECTION.
      *---------------------------------------------------------------*
       FILE-CONTROL.
      *===============================================================*
	    SELECT KA-BANK
	     ASSIGN TO DISK
	     FILE STATUS IS MH-KA-FILE-STATUS
	     ORGANIZATION IS LINE SEQUENTIAL.
      *===============================================================*
	    SELECT KB-BANK
	     ASSIGN TO DISK
	     FILE STATUS IS MH-KB-FILE-STATUS
	     ORGANIZATION IS LINE SEQUENTIAL.
      *===============================================================*
	    SELECT KM-BANK
	     ASSIGN TO DISK
	     FILE STATUS IS MH-KM-FILE-STATUS
	     ORGANIZATION IS LINE SEQUENTIAL.
      *****************************************************************
       DATA			       DIVISION.
      *****************************************************************
       FILE			       SECTION.
      *---------------------------------------------------------------*
       FD KA-BANK
	   VALUE OF FILE-ID 'A:BANK.DAT'
	   LABEL RECORD STANDARD.
       01 KA-REC.
	 03 KA-CHESHBON 	       PIC 9(10).
	 03 KA-SHEM		       PIC X(10).
	 03 KA-TZ		       PIC X(10).
	 03 KA-DATE.
	   05 KA-DD		       PIC 9(2).
	   05 KA-MM		       PIC 9(2).
	   05 KA-YY		       PIC 9(2).
	 03 KA-KOD		       PIC 9(1).
	 03 KA-SCHOM		       PIC 9(7).
      *===============================================================*
       FD KB-BANK
	   VALUE OF FILE-ID 'A:BANK-B.DAT'
	   LABEL RECORD STANDARD.
       01 KB-REC.
	 03 KB-CHESHBON 	       PIC 9(10).
	 03 KB-SHEM		       PIC X(10).
	 03 KB-TZ		       PIC X(10).
	 03 KB-DATE.
	   05 KB-DD		       PIC 9(2).
	   05 KB-MM		       PIC 9(2).
	   05 KB-YY		       PIC 9(2).
	 03 KB-KOD		       PIC 9(1).
	 03 KB-SCHOM		       PIC 9(7).
      *===============================================================*
       FD KM-BANK
	   VALUE OF FILE-ID 'A:MIZUG.DAT'
	   LABEL RECORD STANDARD.
       01 KM-REC.
	 03 KM-CHESHBON 	       PIC 9(10).
	 03 KM-SHEM		       PIC X(10).
	 03 KM-TZ		       PIC X(10).
	 03 KM-DATE.
	   05 KM-DD		       PIC 9(2).
	   05 KM-MM		       PIC 9(2).
	   05 KM-YY		       PIC 9(2).
	 03 KM-KOD		       PIC 9(1).
	 03 KM-SCHOM		       PIC 9(7).
      *===============================================================*
       WORKING-STORAGE		       SECTION.
      *---------------------------------------------------------------*
       01 EZ-SADOT-EZER.
	 03 EZ-REC.
	   05 EZ-CHESHBON		 PIC 9(10).
	   05 EZ-SHEM			 PIC X(10).
	   05 EZ-TZ			 PIC X(10).
	   05 EZ-DATE.
	     07 EZ-DD			 PIC 9(2).
	     07 EZ-MM			 PIC 9(2).
	     07 EZ-YY			 PIC 9(2).
	   05 EZ-KOD			 PIC 9(1).
	   05 EZ-SCHOM			 PIC 9(7).
      *===============================================================*
       01 I-INDEXIM.
	 03 I-INDEX		       PIC 9(5) VALUE 0.
	 03 I-TORAN		       PIC 9(5) VALUE 0.
      *===============================================================*
       01 MH-MAPHTECHOT-HASHVAA.
	 03 MH-KA-FILE-STATUS	       PIC X(2).
	   88 MH-KA-FILE-STATUS-TAKIN  VALUE '00'.
	 03 MH-KB-FILE-STATUS	       PIC X(2).
	   88 MH-KB-FILE-STATUS-TAKIN  VALUE '00'.
	 03 MH-KM-FILE-STATUS	       PIC X(2).
	   88 MH-KM-FILE-STATUS-TAKIN  VALUE '00'.
      *===============================================================*
       01 TV-TAVLAOT.
	 03 TV-TORAN OCCURS 2 TIMES.
	   05 TV-CHESHBON	       PIC 9(10).
	   05 TV-SHEM		       PIC X(10).
	   05 TV-TZ		       PIC X(10).
	   05 TV-DATE.
	     07 TV-DD		       PIC 9(2).
	     07 TV-MM		       PIC 9(2).
	     07 TV-YY		       PIC 9(2).
	   05 TV-KOD		       PIC 9(1).
	   05 TV-SCHOM		       PIC 9(7).
      *===============================================================*
       01 SW-SWITCHIM.
	 03 SW-MIZUG		       PIC 9 VALUE 0.
	   88 SW-SOF-MIZUG	       VALUE 9.
      *****************************************************************
       PROCEDURE		       DIVISION.
      *****************************************************************
       D-MIZUG			       SECTION.
      *---------------------------------------------------------------*
       D00.
	    PERFORM DZA-ATCHALAT-MIZUG.
	    PERFORM D10-AVODA UNTIL SW-SOF-MIZUG.
	    PERFORM DZZ-SIYOM-MIZUG.
	    STOP RUN.
       D-EXIT. EXIT.
      *===============================================================*
       D10-AVODA		       SECTION.
      *---------------------------------------------------------------*
       D10.
	    PERFORM DA-TIPUL.
	    PERFORM DB-KRIAT-TORAN.
	    PERFORM DC-BCHIRAT-TORAN.
       D10-EXIT. EXIT.
      *===============================================================*
       DA-TIPUL 		       SECTION.
      *---------------------------------------------------------------*
       DA00.
	    WRITE KM-REC FROM EZ-REC.
       DA-EXIT. EXIT.
      *===============================================================*
       DB-KRIAT-TORAN		       SECTION.
      *---------------------------------------------------------------*
       DB00.
	    GO TO DB10
		  DB20
	     DEPENDING ON I-TORAN.
	    GO TO DB-EXIT. EXIT.
      *===============================================================*
       DB10.
	    READ KA-BANK
		   AT END
		     MOVE HIGH-VALUE TO TV-TORAN(1)
		     GO TO DB-EXIT.
	    MOVE KA-REC TO TV-TORAN(1).
	    GO TO DB-EXIT.
       DB10-END.
      *===============================================================*
       DB20.
	    READ KB-BANK
		   AT END
		     MOVE HIGH-VALUE TO TV-TORAN(2)
		     GO TO DB-EXIT.
	    MOVE KB-REC TO TV-TORAN(2).
       DB20-END.
       DB-EXIT. EXIT.
      *===============================================================*
       DC-BCHIRAT-TORAN 	       SECTION.
      *---------------------------------------------------------------*
       DC00.
	    MOVE TV-TORAN(1) TO EZ-REC.
	    MOVE 1 TO I-TORAN.
	    PERFORM D10 VARYING I-INDEX FROM 2 BY 1 UNTIL I-INDEX > 2.
	    IF EZ-REC = HIGH-VALUE
		   MOVE 9 TO SW-MIZUG.
	    GO TO DC-EXIT.
      *===============================================================*
       D10.
	    IF TV-TORAN(I-INDEX) < EZ-REC
		   MOVE TV-TORAN(I-INDEX) TO EZ-REC
		   MOVE I-INDEX TO I-TORAN.
       D10-END.
       DC-EXIT. EXIT.
      *===============================================================*
       DZA-ATCHALAT-MIZUG	       SECTION.
      *---------------------------------------------------------------*
       DZA00.
	    OPEN INPUT KA-BANK.
	    IF NOT MH-KA-FILE-STATUS-TAKIN
		   DISPLAY '•…— š‡‰š” „Œ—š'
		   STOP RUN.
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
       DZA-EXIT. EXIT.
      *===============================================================*
       DZZ-SIYOM-MIZUG		       SECTION.
      *---------------------------------------------------------------*
       DZZ00.
	    CLOSE KA-BANK.
	    CLOSE KB-BANK.
	    CLOSE KM-BANK.
       DZZ-EXIT. EXIT.
      *===============================================================*
