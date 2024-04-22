       IDENTIFICATION		       DIVISION.
      *****************************************************************
       PROGRAM-ID.		       SHVIROT.
       AUTHOR.			       RAANAN-KLEINFELD.
       INSTALLATION.		       RAANAN-KLEINFELD.
       DATE-WRITTEN.		       27/03/87.
       DATE-COMPILED.		       27/03/87.
       SECURITY.		       CHOFSHI.
      *===============================================================*
      * 		     ö	Ö  ò  â  Å  ô			      *
      * 			  âÉâ åí			      *
      * 		      Éåîêââåó	èêíò			      *
      * 		1987 - Ñêô	9/Äâ - Ñöâã		      *
      * 			ÇòÅêââÖ çíÖê - ÑòÖé		      *
      *===============================================================*
      * 	       : çâÄÅÑ çâòÅÉÑ öÄ öíñÅéÖ ïÅÖó öáóÖå òôÄ öâêãÖö *
      * çâêÖöê	åô  öÖòÖô  15  çí çâîÉ âîå (èÖâé Äåå) ÖöÖÄ ÑëâîÉé .1  *
      * 						      .ìÉÅ    *
      * èÖòãÜÅ	SM-MORIM  çôÅ  ïÅÖóå  ÖöÖÄ öáåÖôÖ ïÅÖóÑ öÄ öêââéé .2  *
      * 						    .ÅôáéÑ    *
      * ÖöÖÄ  öáåÖôÖ  KM-MORIM	âîåÖ  KM-MACHOZ  âîå  ÑòâÅô íÖñâÅ .3  *
      * 		.ìÉÅ çâêÖöê åô öÖòÖô 30 åô çâîÉ âîå ÑëîÉÑå    *
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
	    SELECT	    KM-MORIM
	     ASSIGN	    TO DISK
	     FILE STATUS    IS MH-KM-FILE-STATUS
	     ORGANIZATION   IS LINE SEQUENTIAL.
      *===============================================================*
	    SELECT	    SM-MORIM
	     ASSIGN	    TO DISK.
      *===============================================================*
	    SELECT	    DM-MORIM
	     ASSIGN	    TO PRINTER.
      *****************************************************************
       DATA			       DIVISION.
      *****************************************************************
       FILE			       SECTION.
      *---------------------------------------------------------------*
       FD KM-MORIM
	   VALUE OF FILE-ID IS 'MORIM.DAT'
	   LABEL RECORD     IS STANDARD.
       01 KM-RECORD.
	 03 KM-SHEM		       PIC X(10).
	 03 KM-TZ		       PIC X(10).
	 03 KM-MASKORET 	       PIC 9(5).
	 03 KM-MACHOZ		       PIC 9(3).
	 03 KM-SCHOOL		       PIC 9(3).
      *===============================================================*
       SD SM-MORIM.
       01 SM-RECORD.
	 03 SM-MAFTEACH.
	   05 SM-MACHOZ 	       PIC 9(3).
	   05 SM-SCHOOL 	       PIC 9(3).
	   05 SM-TZ		       PIC X(10).
	 03 SM-SHEM		       PIC X(10).
	 03 SM-MASKORET 	       PIC 9(5).
      *===============================================================*
       FD DM-MORIM
	   LABEL RECORD     IS OMITTED.
       01 DM-RECORD		       PIC X(80).
      *===============================================================*
       WORKING-STORAGE		       SECTION.
      *---------------------------------------------------------------*
      * 		      * C -> CVUIM *			      *
      *===============================================================*
       01 C-CVUIM.
	 03 C-SHEM-TOCHNA	       PIC X(20)
				       VALUE ' > Ø   öÖòâÅô   Æ < '.
	 03 C-SHEM-KOVETS-KELET        PIC X(30)
			       VALUE '                  .d:MORIM.DAT'.
      *===============================================================*
      * 		   * EZ -> SADOT-EZER * 		      *
      *===============================================================*
       01 EZ-SADOT-EZER.
	 03 EZT-TAKALOT.
	   05 EZT-SIBAT-TAKALA	       PIC X(30) VALUE ALL SPACES.
	   05 EZT-M-TAKALA	       PIC 9(02) VALUE 0.
	   05 EZT-SHEM-KOVETS	       PIC X(30) VALUE ALL SPACES.
	 03 EZR-RECORD.
	   05 EZR-SHEM		       PIC X(10) VALUE ALL SPACES.
	   05 EZR-TZ		       PIC X(10) VALUE ALL SPACES.
	   05 EZR-MASKORET	       PIC 9(05) VALUE 0.
	   05 EZR-MACHOZ	       PIC 9(03) VALUE 0.
	   05 EZR-SCHOOL	       PIC 9(03) VALUE 0.
	 03 EZ-SHCMEI-SHVIROT.
	   05 EZS-SOCHEM-MASKORET      PIC 9(08) VALUE 0.
	   05 EZS-SOCHEM-MACHOZ        PIC 9(08) VALUE 0.
	   05 EZS-SOCHEM-SCHOOL        PIC 9(08) VALUE 0.
	 03 EZ-KODEM.
	   05 EZK-MACHOZ-KODEM	       PIC 9(03) VALUE 0.
	   05 EZK-SCHOOL-KODEM	       PIC 9(03) VALUE 0.
	 03 EZ-NOCHACHI.
	   05 EZN-MACHOZ-NOCHACHI      PIC 9(03) VALUE 0.
	   05 EZN-SCHOOL-NOCHACHI      PIC 9(03) VALUE 0.
      *===============================================================*
      * 		      * M -> MONIM *			      *
      *===============================================================*
       01 M-MONIM.
	 03 M-SHUROT-DAF	       PIC 9(03) VALUE 0.
	   88 M-SOF-DAF-DOCH-YASHAN    VALUE 15.
	   88 M-SOF-DAF-DOCH-CHADASH   VALUE 45.
	 03 M-SHUROT-KLALI	       PIC 9(05) VALUE 0.
	 03 M-DAPIM		       PIC 9(05) VALUE 0.
      *===============================================================*
      * 	       * MH -> MAPHTECHOT-HASHVAA *		      *
      *===============================================================*
       01 MH-MAPHTECHOT-HASHVAA.
	 03 MH-KM-FILE-STATUS	       PIC XX VALUE '00'.
	   88 MH-KM-FILE-STATUS-TAKIN  VALUE '00'.
      *===============================================================*
      * 		  * SH -> SADOT-HADPASA *		      *
      *===============================================================*
       01 SH-SADOT-HADPASA.
      *---------------------------------------------------------------*
	 03 SH-REVACH.
	   05 FILLER		       PIC X(80) VALUE ALL SPACES.
      *===============================================================*
	 03 SH-HEMSHECH-NEXT-DAF.
	   05 FILLER		       PIC X(80) VALUE ALL SPACES.
      *===============================================================*
	 03 SHA-KOTERET.
	   05 FILLER		       PIC X(09) VALUE ALL SPACES.
	   05 FILLER		       PIC X(10) VALUE '16-02-1987'.
	   05 FILLER		       PIC X(17) VALUE ALL SPACES.
	   05 FILLER		       PIC X(09) VALUE
				       'èÖôÄò áÖÉ'.
	   05 FILLER		       PIC X(13) VALUE ALL SPACES.
	   05 SHA-M-DAPIM	       PIC 9(05) VALUE 0.
	   05 FILLER		       PIC X(10) VALUE ' : ìÉ òîëé'.
      *===============================================================*
	 03 SHA-H-KOTERET.
	   05 FILLER		       PIC X(09) VALUE ALL SPACES.
	   05 FILLER		       PIC X(10) VALUE ALL '-'.
	   05 FILLER		       PIC X(17) VALUE ALL SPACES.
	   05 FILLER		       PIC X(09) VALUE ALL '-'.
	   05 FILLER		       PIC X(13) VALUE ALL SPACES.
	   05 FILLER		       PIC X(15) VALUE ALL '-'.
      *===============================================================*
	 03 SHA-SOF-DAF.
	   05 FILLER		       PIC X(26) VALUE ALL SPACES.
	   05 SH-M-TAL-DAF	       PIC 9(05) VALUE 0.
      *===============================================================*
	 03 SHA-KOTERET-B.
	   05 FILLER		       PIC X(13) VALUE ALL SPACES.
	   05 FILLER		       PIC X(07) VALUE 'òîë öâÅ'.
	   05 FILLER		       PIC X(03) VALUE ALL SPACES.
	   05 FILLER		       PIC X(04) VALUE 'ÜÖáé'.
	   05 FILLER		       PIC X(03) VALUE ALL SPACES.
	   05 FILLER		       PIC X(06) VALUE 'öòÖãôé'.
	   05 FILLER		       PIC X(03) VALUE ALL SPACES.
	   05 FILLER		       PIC X(10) VALUE 'öÖÑÜ öÉÖíö'.
	   05 FILLER		       PIC X(03) VALUE ALL SPACES.
	   05 FILLER		       PIC X(10) VALUE '    çô    '.
	   05 FILLER		       PIC X(01) VALUE ALL SPACES.
	   05 FILLER		       PIC X(03) VALUE '.ëé'.
      *===============================================================*
	 03 SHA-H-KOTERET-B.
	   05 FILLER		       PIC X(13) VALUE ALL SPACES.
	   05 FILLER		       PIC X(07) VALUE ALL '-'.
	   05 FILLER		       PIC X(03) VALUE ALL SPACES.
	   05 FILLER		       PIC X(04) VALUE ALL '-'.
	   05 FILLER		       PIC X(03) VALUE ALL SPACES.
	   05 FILLER		       PIC X(06) VALUE ALL '-'.
	   05 FILLER		       PIC X(03) VALUE ALL SPACES.
	   05 FILLER		       PIC X(10) VALUE ALL '-'.
	   05 FILLER		       PIC X(03) VALUE ALL SPACES.
	   05 FILLER		       PIC X(10) VALUE ALL '-'.
	   05 FILLER		       PIC X(01) VALUE ALL SPACES.
	   05 FILLER		       PIC X(03) VALUE ALL '-'.
      *===============================================================*
	 03 SHA-SHURA.
	   05 FILLER		       PIC X(15) VALUE ALL SPACES.
	   05 SHA-SCHOOL	       PIC 9(03) VALUE 0.
	   05 FILLER		       PIC X(06) VALUE ALL SPACES.
	   05 SHA-MACHOZ	       PIC 9(03) VALUE 0.
	   05 FILLER		       PIC X(04) VALUE ALL SPACES.
	   05 SHA-MASKORET	       PIC 9(05) VALUE 0.
	   05 FILLER		       PIC X(03) VALUE ALL SPACES.
	   05 SHA-TZ		       PIC X(10) VALUE ALL SPACES.
	   05 FILLER		       PIC X(03) VALUE ALL SPACES.
	   05 SHA-SHEM		       PIC X(10) VALUE ALL SPACES.
	   05 FILLER		       PIC X(01) VALUE ALL SPACES.
	   05 SH-M-SHUROT	       PIC 9(03) VALUE 0.
      *===============================================================*
	 03 SHB-KOTERET.
	   05 FILLER		       PIC X(09) VALUE ALL SPACES.
	   05 FILLER		       PIC X(10) VALUE '16-02-1987'.
	   05 FILLER		       PIC X(15) VALUE ALL SPACES.
	   05 FILLER		       PIC X(07) VALUE
				       'âêô áÖÉ'.
	   05 FILLER		       PIC X(17) VALUE ALL SPACES.
	   05 SHB-M-DAPIM	       PIC 9(05) VALUE 0.
	   05 FILLER		       PIC X(10) VALUE ' : ìÉ òîëé'.
      *===============================================================*
	 03 SHB-H-KOTERET.
	   05 FILLER		       PIC X(09) VALUE ALL SPACES.
	   05 FILLER		       PIC X(10) VALUE ALL '-'.
	   05 FILLER		       PIC X(15) VALUE ALL SPACES.
	   05 FILLER		       PIC X(07) VALUE ALL '-'.
	   05 FILLER		       PIC X(17) VALUE ALL SPACES.
	   05 FILLER		       PIC X(15) VALUE ALL '-'.
      *===============================================================*
	 03 SHB-KOTERET-B.
	   05 FILLER		       PIC X(13) VALUE ALL SPACES.
	   05 FILLER		       PIC X(06) VALUE 'öòÖãôé'.
	   05 FILLER		       PIC X(01) VALUE SPACE.
	   05 FILLER		       PIC X(10) VALUE '    çô    '.
	   05 FILLER		       PIC X(01) VALUE SPACE.
	   05 FILLER		       PIC X(10) VALUE 'öÖÑÜ öÉÖíö'.
      *===============================================================*
	 03 SHB-H-KOTERET-B.
	   05 FILLER		       PIC X(13) VALUE ALL SPACES.
	   05 FILLER		       PIC X(06) VALUE ALL '-'.
	   05 FILLER		       PIC X(01) VALUE SPACE.
	   05 FILLER		       PIC X(10) VALUE ALL '-'.
	   05 FILLER		       PIC X(01) VALUE SPACE.
	   05 FILLER		       PIC X(10) VALUE ALL '-'.
      *===============================================================*
	 03 SHB-MACHOZ.
	   05 FILLER		       PIC X(55) VALUE ALL SPACES.
	   05 SHB-MACHOZ-NOCHACHI      PIC 9(03) VALUE 0.
	   05 FILLER		       PIC X(10) VALUE ' : ÜÖáé ëé'.
      *===============================================================*
	 03 SHB-H-MACHOZ.
	   05 FILLER		       PIC X(55) VALUE ALL SPACES.
	   05 FILLER		       PIC X(13) VALUE ALL '-'.
      *===============================================================*
	 03 SHB-SCHOOL.
	   05 FILLER		       PIC X(40) VALUE ALL SPACES.
	   05 SHB-M-SCHOOL-NOCHACHI    PIC 9(03) VALUE 0.
	   05 FILLER		       PIC X(13)
				       VALUE ' : òîë öâÅ ëé'.
      *===============================================================*
	 03 SHB-H-SCHOOL.
	   05 FILLER		       PIC X(40) VALUE ALL SPACES.
	   05 FILLER		       PIC X(16) VALUE ALL '-'.
      *===============================================================*
	 03 SHB-SHURA.
	   05 FILLER		       PIC X(13) VALUE ALL SPACES.
	   05 SHB-MASKORET	       PIC 9(06) VALUE 0.
	   05 FILLER		       PIC X(01) VALUE SPACE.
	   05 SHB-SHEM		       PIC X(10) VALUE ALL SPACES.
	   05 FILLER		       PIC X(01) VALUE SPACE.
	   05 SHB-TZ		       PIC X(10) VALUE ALL SPACES.
      *===============================================================*
	 03 SHB-SOF-SCHOOL.
	   05 FILLER		       PIC X(33) VALUE ALL SPACES.
	   05 SHB-SOCHEM-SCHOOL        PIC 9(08) VALUE 0.
	   05 FILLER		       PIC X(15)
				       VALUE ' : òîë öâÅ ã`Ñë'.
      *===============================================================*
	 03 SHB-H-SOF-SCHOOL.
	   05 FILLER		       PIC X(33) VALUE ALL SPACES.
	   05 FILLER		       PIC X(23) VALUE ALL '-'.
      *===============================================================*
	 03 SHB-SOF-MACHOZ.
	   05 FILLER		       PIC X(48) VALUE ALL SPACES.
	   05 SHB-SOCHEM-MACHOZ        PIC 9(08) VALUE 0.
	   05 FILLER		       PIC X(12)
				       VALUE ' : ÜÖáé ã`Ñë'.
      *===============================================================*
	 03 SHB-H-SOF-MACHOZ.
	   05 FILLER		       PIC X(48) VALUE ALL SPACES.
	   05 FILLER		       PIC X(20) VALUE ALL '-'.
      *===============================================================*
	 03 SHB-SOF-KOVETS.
	   05 FILLER		       PIC X(28) VALUE ALL SPACES.
	   05 SHB-SOCHEM-MASKORET      PIC 9(08) VALUE 0.
	   05 FILLER		       PIC X(15)
				       VALUE ' : öÖòÖãôé ã`Ñë'.
      *===============================================================*
	 03 SHB-SOF-DAF.
	   05 FILLER		       PIC X(80) VALUE ALL SPACES.
      *===============================================================*
      * 		    * SW -> SWITCHIM *			      *
      *===============================================================*
       01 SW-SWITCHIM.
	 03 SW-SOF-KOVETS	       PIC 9 VALUE 0.
	   88 SW-SOF-KOVETS-TAKIN      VALUE 9.
	 03 SW-SOF-DAF		       PIC 9 VALUE 0.
	   88 SW-SOF-DAF-TAKIN	       VALUE 9.
	 03 SW-SHVIRA		       PIC 9 VALUE 0.
	   88 SW-SIYOM-SCHOOL	       VALUE 3 THRU 9.
	   88 SW-SIYOM-MACHOZ	       VALUE 6 THRU 9.
	   88 SW-SIYOM-KOVETS	       VALUE 9.
      *===============================================================*
      * 		    * TV -> TAVLAOT *			      *
      *===============================================================*
       01 TV-TAVLAOT.
	 03 TVF-FILLER-TAKALOT.
	   05 FILLER		       PIC X(30)
			       VALUE '                .àåóÑ ïÅÖó ìÖë'.
	   05 FILLER		       PIC X(30)
			       VALUE '                .èÖâé ïÅÖó ìÖë'.
	   05 FILLER		       PIC X(30)
			       VALUE '  .Äñéê Äå / áöîê Äå àåóÑ ïÅÖó'.
	   05 FILLER		       PIC X(30)
			       VALUE '      .âÖÄòã òÇëê Äå àåóÑ ïÅÖó'.
	   05 FILLER		       PIC X(30)
			       VALUE '   .ÑíñÅöÑ Äå èÖâé ïÅÖóÅ ÑÅâöã'.
	   05 FILLER		       PIC X(30)
			       VALUE '   .ÑíñÅöÑ Äå àåóÑ ïÅÖóé ÑÄâòó'.
	   05 FILLER		       PIC X(30)
			       VALUE '  .ÑíñÅöÑ Äå èÖâéÑ ïÅÖóé ÑÄâòó'.
	03 TVT-TAVLAT-TAKALOT REDEFINES TVF-FILLER-TAKALOT.
	  05 TVT-TAKALOT-M	       OCCURS 7 TIMES.
	    07 TVT-TAKALOT	       PIC X(30).
      *===============================================================*
       SCREEN			       SECTION.
      *---------------------------------------------------------------*
       01 MST-TAKALA.
	 03 LINE 5  COLUMN 35 VALUE 'Ñåóö äëé' HIGHLIGHT.
	 03 LINE 6  COLUMN 34 VALUE '----------' HIGHLIGHT.
	 03 LINE 8  COLUMN 12 PIC X(30) FROM C-SHEM-TOCHNA.
	 03	    COLUMN 44 VALUE ':öâêãÖö çô'.
	 03 LINE 10 COLUMN 37 PIC 9(02) FROM EZT-M-TAKALA.
	 03	    COLUMN 36 VALUE '.'.
	 03	    COLUMN 40 VALUE ': (MH) Ñåóö ëé'.
	 03 LINE 12 COLUMN 11 PIC X(30) FROM EZT-SIBAT-TAKALA.
	 03	    COLUMN 43 VALUE ': Ñåóö öÅâë'.
	 03 LINE 14 COLUMN 23 PIC X(30) FROM EZT-SHEM-KOVETS.
	 03	    COLUMN 45 VALUE ': ïÅÖó çô'.
      *****************************************************************
       PROCEDURE		       DIVISION.
      *****************************************************************
       A-TOCHNIT-RASHIT 	       SECTION.
      *---------------------------------------------------------------*
       A00.
	    PERFORM B-MIYON.
	    STOP RUN.
       A-EXIT. EXIT.
      *===============================================================*
       B-MIYON			       SECTION.
      *---------------------------------------------------------------*
       B00.
	    SORT	       SM-MORIM
	     ASCENDING KEY     SM-MAFTEACH
	      INPUT PROCEDURE  C-DOCH-YASHAN
	      OUTPUT PROCEDURE D-DOCH-CHADASH.
       B-EXIT. EXIT.
      *===============================================================*
       C-DOCH-YASHAN		       SECTION.
      *---------------------------------------------------------------*
       C00.
	    PERFORM CZA-ATCHALAT-DOCH-YASHAN.
	    PERFORM C10-NIHUL-DOCH-YASHAN UNTIL SW-SOF-KOVETS-TAKIN.
	    PERFORM CZZ-SIYOM-DOCH-YASHAN.
       C-EXIT. EXIT.
      *===============================================================*
       C10-NIHUL-DOCH-YASHAN	       SECTION.
      *---------------------------------------------------------------*
       C10.
	    PERFORM CBZA-ATCHALAT-DAF-YASHAN.
	    PERFORM CB10-NIHUL-PNIMI-DOCH-YASHAN
		   UNTIL SW-SOF-DAF-TAKIN.
	    MOVE 0 TO SW-SOF-DAF.
	    PERFORM CBZZ-SIYOM-DAF-YASHAN.
	    ADD 1 TO M-SHUROT-DAF.
	    ADD 1 TO M-SHUROT-KLALI.
       C10-EXIT. EXIT.
      *===============================================================*
       CB10-NIHUL-PNIMI-DOCH-YASHAN    SECTION.
      *---------------------------------------------------------------*
       CB10.
	    PERFORM CBB-HADPASAT-KOVETS.
	    PERFORM CBC-KRIAT-KOVETS.
	    IF M-SOF-DAF-DOCH-YASHAN OR SW-SOF-KOVETS-TAKIN
		   MOVE 9 TO SW-SOF-DAF
		   GO TO CB10-EXIT.
	    ADD 1 TO M-SHUROT-DAF.
	    ADD 1 TO M-SHUROT-KLALI.
       CB10-EXIT. EXIT.
      *===============================================================*
       CBB-HADPASAT-KOVETS	       SECTION.
      *---------------------------------------------------------------*
       CBB00.
	    IF SW-SOF-DAF-TAKIN
		   GO TO CBB-EXIT.
	    MOVE M-SHUROT-KLALI TO SH-M-SHUROT.
	    WRITE DM-RECORD FROM SHA-SHURA.
       CBB-EXIT. EXIT.
      *===============================================================*
       CBC-KRIAT-KOVETS 	       SECTION.
      *---------------------------------------------------------------*
       CBC00.
	    READ KM-MORIM
		   AT END
		      MOVE 9 TO SW-SOF-KOVETS
		      GO TO CBC-EXIT.
	    IF NOT MH-KM-FILE-STATUS-TAKIN
		   MOVE 6 TO EZT-M-TAKALA
		   MOVE C-SHEM-KOVETS-KELET TO EZT-SHEM-KOVETS
		   PERFORM ZT-TAKALOT.
	    MOVE KM-SHEM TO SHA-SHEM.
	    MOVE KM-TZ TO SHA-TZ.
	    MOVE KM-MASKORET TO SHA-MASKORET.
	    MOVE KM-MACHOZ TO SHA-MACHOZ.
	    MOVE KM-SCHOOL TO SHA-SCHOOL.
	    MOVE KM-SHEM TO SM-SHEM.
	    MOVE KM-TZ TO SM-TZ.
	    MOVE KM-MASKORET TO SM-MASKORET.
	    MOVE KM-MACHOZ TO SM-MACHOZ.
	    MOVE KM-SCHOOL TO SM-SCHOOL.
	    RELEASE SM-RECORD.
       CBC-EXIT. EXIT.
      *===============================================================*
       CBZA-ATCHALAT-DAF-YASHAN        SECTION.
      *---------------------------------------------------------------*
       CBZA00.
	    MOVE 1 TO M-SHUROT-DAF.
	    MOVE M-DAPIM TO SHA-M-DAPIM.
	    WRITE DM-RECORD FROM SHA-KOTERET.
	    WRITE DM-RECORD FROM SHA-H-KOTERET.
	    WRITE DM-RECORD FROM SH-REVACH.
	    WRITE DM-RECORD FROM SHA-KOTERET-B.
	    WRITE DM-RECORD FROM SHA-H-KOTERET-B.
       CBZA-EXIT. EXIT.
      *===============================================================*
       CBZZ-SIYOM-DAF-YASHAN	       SECTION.
      *---------------------------------------------------------------*
       CBZZ00.
	    ADD 1 TO M-DAPIM.
	    MOVE M-SHUROT-DAF TO SH-M-TAL-DAF.
	    IF NOT SW-SOF-KOVETS-TAKIN
		   WRITE DM-RECORD FROM SH-HEMSHECH-NEXT-DAF
		   AFTER ADVANCING 2.
	    WRITE DM-RECORD FROM SH-REVACH.
	    WRITE DM-RECORD FROM SHA-SOF-DAF
	     BEFORE ADVANCING PAGE.
       CBZZ-EXIT. EXIT.
      *===============================================================*
       CZA-ATCHALAT-DOCH-YASHAN        SECTION.
      *---------------------------------------------------------------*
       CZA00.
	    MOVE 1 TO M-DAPIM.
	    MOVE 1 TO M-SHUROT-KLALI.
	    OPEN INPUT KM-MORIM.
	    IF NOT MH-KM-FILE-STATUS-TAKIN
		   MOVE 3 TO EZT-M-TAKALA
		   MOVE C-SHEM-KOVETS-KELET TO EZT-SHEM-KOVETS
		   PERFORM ZT-TAKALOT.
	    OPEN OUTPUT DM-MORIM.
	    PERFORM CBC-KRIAT-KOVETS.
       CZA-EXIT. EXIT.
      *===============================================================*
       CZZ-SIYOM-DOCH-YASHAN	       SECTION.
      *---------------------------------------------------------------*
       CZZ00.
	    CLOSE KM-MORIM.
	    IF NOT MH-KM-FILE-STATUS-TAKIN
		   MOVE 4 TO EZT-M-TAKALA
		   MOVE C-SHEM-KOVETS-KELET TO EZT-SHEM-KOVETS
		   PERFORM ZT-TAKALOT.
	    CLOSE DM-MORIM.
       CZZ-EXIT. EXIT.
      *===============================================================*
       D-DOCH-CHADASH		       SECTION.
      *---------------------------------------------------------------*
       D00.
	    MOVE 0 TO SW-SOF-DAF.
	    MOVE 0 TO M-SHUROT-DAF.
	    MOVE 6 TO SW-SHVIRA.
	    PERFORM DZA-ATCHALAT-DOCH-CHADASH.
	    PERFORM DB-MACHOZ UNTIL SW-SIYOM-KOVETS.
	    PERFORM DZZ-SIYOM-DOCH-CHADASH.
       D-EXIT. EXIT.
      *===============================================================*
       DB-MACHOZ		       SECTION.
      *---------------------------------------------------------------*
       DB00.
	    MOVE 3 TO SW-SHVIRA.
	    PERFORM DBZA-ATCHALAT-MACHOZ.
	    PERFORM DC-SCHOOL UNTIL SW-SIYOM-MACHOZ.
	    PERFORM DBZZ-SIYOM-MACHOZ.
       DB-EXIT. EXIT.
      *===============================================================*
       DC-SCHOOL		       SECTION.
      *---------------------------------------------------------------*
       DC00.
	    MOVE 0 TO SW-SHVIRA.
	    PERFORM DCZA-ATCHALAT-SCHOOL.
	    PERFORM DD-AVODA UNTIL SW-SIYOM-SCHOOL.
	    PERFORM DCZZ-SIYOM-SCHOOL.
       DC-EXIT. EXIT.
      *===============================================================*
       DD-AVODA 		       SECTION.
      *---------------------------------------------------------------*
       DD00.
	    PERFORM DDB-TIPUL.
	    PERFORM DDC-KRIA.
	    PERFORM DDD-SHVIRA.
       DD-EXIT. EXIT.
      *===============================================================*
       DDB-TIPUL		       SECTION.
      *---------------------------------------------------------------*
       DDB00.
	    ADD EZR-MASKORET TO EZS-SOCHEM-SCHOOL.
	    MOVE EZR-MASKORET TO SHB-MASKORET.
	    MOVE EZR-TZ TO SHB-TZ.
	    MOVE EZR-SHEM TO SHB-SHEM.
	    WRITE DM-RECORD FROM SHB-SHURA.
	    ADD 1 TO M-SHUROT-DAF.
	    PERFORM DZH-HATCHALAT-DAF.
       DDB-EXIT. EXIT.
      *===============================================================*
       DDC-KRIA 		       SECTION.
      *---------------------------------------------------------------*
       DDC00.
	    RETURN SM-MORIM
		   AT END
		     MOVE 9 TO SW-SHVIRA
		     GO TO DDC-EXIT.
	    MOVE SM-SHEM TO EZR-SHEM.
	    MOVE SM-TZ TO EZR-TZ.
	    MOVE SM-MASKORET TO EZR-MASKORET.
	    MOVE SM-MACHOZ TO EZR-MACHOZ.
	    MOVE SM-SCHOOL TO EZR-SCHOOL.
	    MOVE EZR-MACHOZ TO EZN-MACHOZ-NOCHACHI.
	    MOVE EZR-SCHOOL TO EZN-SCHOOL-NOCHACHI.
       DDC-EXIT. EXIT.
      *===============================================================*
       DDD-SHVIRA		       SECTION.
      *---------------------------------------------------------------*
       DDD00.
	    IF EZ-KODEM = EZ-NOCHACHI
		   GO TO DDD-EXIT.
	    IF EZN-MACHOZ-NOCHACHI NOT = EZK-MACHOZ-KODEM
		   MOVE 6 TO SW-SHVIRA
		   GO TO DDD-EXIT.
	    IF EZN-SCHOOL-NOCHACHI NOT = EZK-SCHOOL-KODEM
		   MOVE 3 TO SW-SHVIRA.
       DDD-EXIT. EXIT.
      *===============================================================*
       DZA-ATCHALAT-DOCH-CHADASH       SECTION.
      *---------------------------------------------------------------*
       DZA00.
	    OPEN OUTPUT DM-MORIM.
	    PERFORM DDC-KRIA.
	    MOVE 1 TO M-DAPIM.
	    MOVE M-DAPIM TO SHB-M-DAPIM
	    WRITE DM-RECORD FROM SHB-KOTERET
	    WRITE DM-RECORD FROM SHB-H-KOTERET
	     BEFORE ADVANCING 2
	    MOVE 4 TO M-SHUROT-DAF.
       DZA-EXIT. EXIT.
      *===============================================================*
       DZZ-SIYOM-DOCH-CHADASH	       SECTION.
      *---------------------------------------------------------------*
       DZZ00.
	    MOVE EZS-SOCHEM-MASKORET TO SHB-SOCHEM-MASKORET.
	    WRITE DM-RECORD FROM SH-REVACH.
	    WRITE DM-RECORD FROM SHB-SOF-KOVETS.
	    WRITE DM-RECORD FROM SH-REVACH.
	    WRITE DM-RECORD FROM SH-REVACH.
	    WRITE DM-RECORD FROM SH-REVACH.
	    WRITE DM-RECORD FROM SHB-SOF-DAF
	     BEFORE ADVANCING PAGE.
	    CLOSE DM-MORIM.
       DZZ-EXIT. EXIT.
      *===============================================================*
       DBZA-ATCHALAT-MACHOZ	       SECTION.
      *---------------------------------------------------------------*
       DBZA00.
	    MOVE EZN-MACHOZ-NOCHACHI TO EZK-MACHOZ-KODEM.
	    MOVE 0 TO EZS-SOCHEM-MACHOZ.
	    MOVE EZN-MACHOZ-NOCHACHI TO SHB-MACHOZ-NOCHACHI.
	    WRITE DM-RECORD FROM SHB-MACHOZ.
	    ADD 1 TO M-SHUROT-DAF.
	    PERFORM DZH-HATCHALAT-DAF.
	    WRITE DM-RECORD FROM SHB-H-MACHOZ
	    ADD 1 TO M-SHUROT-DAF.
	    PERFORM DZH-HATCHALAT-DAF.
	    WRITE DM-RECORD FROM SH-REVACH.
	    ADD 1 TO M-SHUROT-DAF.
	    PERFORM DZH-HATCHALAT-DAF.
	    WRITE DM-RECORD FROM SH-REVACH.
	    ADD 1 TO M-SHUROT-DAF.
	    PERFORM DZH-HATCHALAT-DAF.
       DBZA-EXIT. EXIT.
      *===============================================================*
       DBZZ-SIYOM-MACHOZ	       SECTION.
      *---------------------------------------------------------------*
       DBZZ00.
	    MOVE EZS-SOCHEM-MACHOZ TO SHB-SOCHEM-MACHOZ.
	    WRITE DM-RECORD FROM SH-REVACH.
	    ADD 1 TO M-SHUROT-DAF.
	    PERFORM DZH-HATCHALAT-DAF.
	    WRITE DM-RECORD FROM SHB-H-SOF-MACHOZ.
	    ADD 1 TO M-SHUROT-DAF.
	    PERFORM DZH-HATCHALAT-DAF.
	    WRITE DM-RECORD FROM SHB-SOF-MACHOZ
	    ADD 1 TO M-SHUROT-DAF.
	    PERFORM DZH-HATCHALAT-DAF.
	    WRITE DM-RECORD FROM SH-REVACH.
	    ADD 1 TO M-SHUROT-DAF.
	    PERFORM DZH-HATCHALAT-DAF.
	    ADD EZS-SOCHEM-MACHOZ TO EZS-SOCHEM-MASKORET.
       DBZZ-EXIT. EXIT.
      *===============================================================*
       DCZA-ATCHALAT-SCHOOL	       SECTION.
      *---------------------------------------------------------------*
       DCZA00.
	    MOVE EZN-SCHOOL-NOCHACHI TO EZK-SCHOOL-KODEM.
	    MOVE EZN-SCHOOL-NOCHACHI TO SHB-M-SCHOOL-NOCHACHI.
	    WRITE DM-RECORD FROM SHB-SCHOOL.
	    ADD 1 TO M-SHUROT-DAF.
	    PERFORM DZH-HATCHALAT-DAF.
	    WRITE DM-RECORD FROM SHB-H-SCHOOL.
	    ADD 1 TO M-SHUROT-DAF.
	    PERFORM DZH-HATCHALAT-DAF.
	    WRITE DM-RECORD FROM SH-REVACH.
	    ADD 1 TO M-SHUROT-DAF.
	    PERFORM DZH-HATCHALAT-DAF.
	    WRITE DM-RECORD FROM SH-REVACH.
	    ADD 1 TO M-SHUROT-DAF.
	    PERFORM DZH-HATCHALAT-DAF.
	    WRITE DM-RECORD FROM SHB-KOTERET-B.
	    ADD 1 TO M-SHUROT-DAF.
	    PERFORM DZH-HATCHALAT-DAF.
	    WRITE DM-RECORD FROM SHB-H-KOTERET-B.
	    ADD 1 TO M-SHUROT-DAF.
	    PERFORM DZH-HATCHALAT-DAF.
	    MOVE 0 TO EZS-SOCHEM-SCHOOL.
       DCZA-EXIT. EXIT.
      *===============================================================*
       DCZZ-SIYOM-SCHOOL	       SECTION.
      *---------------------------------------------------------------*
       DCZZ00.
	    MOVE EZS-SOCHEM-SCHOOL TO SHB-SOCHEM-SCHOOL.
	    WRITE DM-RECORD FROM SH-REVACH.
	    ADD 1 TO M-SHUROT-DAF.
	    PERFORM DZH-HATCHALAT-DAF.
	    WRITE DM-RECORD FROM SHB-H-SOF-SCHOOL.
	    ADD 1 TO M-SHUROT-DAF.
	    PERFORM DZH-HATCHALAT-DAF.
	    WRITE DM-RECORD FROM SHB-SOF-SCHOOL.
	    ADD 1 TO M-SHUROT-DAF.
	    PERFORM DZH-HATCHALAT-DAF.
	    WRITE DM-RECORD FROM SH-REVACH.
	    ADD 1 TO M-SHUROT-DAF.
	    PERFORM DZH-HATCHALAT-DAF.
	    ADD EZS-SOCHEM-SCHOOL TO EZS-SOCHEM-MACHOZ.
       DCZZ-EXIT. EXIT.
      *===============================================================*
       DZS-SOF-DAF		       SECTION.
      *---------------------------------------------------------------*
       DZS00.
	    ADD 1 TO M-DAPIM.
	    WRITE DM-RECORD FROM SH-REVACH.
	    WRITE DM-RECORD FROM SH-REVACH.
	    WRITE DM-RECORD FROM SH-HEMSHECH-NEXT-DAF.
	    WRITE DM-RECORD FROM SH-REVACH.
	    WRITE DM-RECORD FROM SHB-SOF-DAF
	     BEFORE ADVANCING PAGE.
       DZS-EXIT. EXIT.
      *===============================================================*
       DZH-HATCHALAT-DAF	       SECTION.
      *---------------------------------------------------------------*
       DZH00.
	    IF M-SOF-DAF-DOCH-CHADASH
		   PERFORM DZS-SOF-DAF
		   MOVE M-DAPIM TO SHB-M-DAPIM
		   WRITE DM-RECORD FROM SHB-KOTERET
		   WRITE DM-RECORD FROM SHB-H-KOTERET
		    BEFORE ADVANCING 2
		   MOVE EZN-MACHOZ-NOCHACHI TO SHB-MACHOZ-NOCHACHI
		   WRITE DM-RECORD FROM SHB-MACHOZ
		   WRITE DM-RECORD FROM SHB-H-MACHOZ
		    BEFORE ADVANCING 2
		   MOVE EZN-SCHOOL-NOCHACHI TO SHB-M-SCHOOL-NOCHACHI
		   WRITE DM-RECORD FROM SHB-SCHOOL
		   WRITE DM-RECORD FROM SHB-H-SCHOOL
		    BEFORE ADVANCING 2
		   WRITE DM-RECORD FROM SHB-KOTERET-B
		   WRITE DM-RECORD FROM SHB-H-KOTERET-B
		   MOVE 14 TO M-SHUROT-DAF.
       DZH-EXIT. EXIT.
      *===============================================================*
       ZT-TAKALOT		       SECTION.
      *---------------------------------------------------------------*
       ZT00.
	    DISPLAY (1 1) ERASE.
	    MOVE TVT-TAKALOT-M(EZT-M-TAKALA) TO EZT-SIBAT-TAKALA.
	    DISPLAY MST-TAKALA.
	    STOP RUN.
       ZT-EXIT. EXIT.
      *===============================================================*
