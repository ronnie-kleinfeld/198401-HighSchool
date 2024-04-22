       IDENTIFICATION		       DIVISION.
      *****************************************************************
       PROGRAM-ID.		       SORT.
       AUTHOR.			       RAANAN-K.
       INSTALLATION.		       RAANAN-K.
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
	    SELECT KT-TALMIDIM
	     ASSIGN TO DISK
	     FILE STATUS IS MH-KT-FILE-STATUS
	     ORGANIZATION IS LINE SEQUENTIAL.
      *===============================================================*
	    SELECT ST-TALMIDIM
	     ASSIGN TO DISK.
      *****************************************************************
       DATA			       DIVISION.
      *****************************************************************
       FILE			       SECTION.
      *---------------------------------------------------------------*
       FD KT-TALMIDIM
	   VALUE OF FILE-ID IS 'TALMIDIM.DAT'
	   LABEL RECORD STANDARD.
       01 KT-REC.
	 03 KT-SHEM-PRATI	       PIC X(10).
	 03 KT-SHEM-MISHPACHA	       PIC X(10).
	 03 KT-TZ		       PIC X(10).
	 03 KT-KTOVET		       PIC X(15).
	 03 KT-TV-ZIYON.
	   05 KT-TV-ZIYON-M OCCURS 20 TIMES.
	     07 KT-TV-ZIYON-P	       PIC 9(03).
      *===============================================================*
       SD ST-TALMIDIM.
       01 ST-REC.
	 03 ST-SHEM-PRATI	       PIC X(10).
	 03 ST-SHEM-MISHPACHA	       PIC X(10).
	 03 ST-TZ		       PIC X(10).
	 03 ST-KTOVET		       PIC X(15).
	 03 ST-TV-ZIYON.
	   05 ST-TV-ZIYON-M OCCURS 20 TIMES.
	     07 ST-TV-ZIYON-P	       PIC 9(03).
      *===============================================================*
       WORKING-STORAGE		       SECTION.
      *---------------------------------------------------------------*
       01 EZ-SADOT-EZER.
	 03 EZ-REC.
	   05 EZ-SHEM-PRATI	     PIC X(10).
	   05 EZ-SHEM-MISHPACHA      PIC X(10).
	   05 EZ-TZ		     PIC X(10).
	   05 EZ-KTOVET 	     PIC X(15).
	   05 EZ-TV-ZIYON.
	     07 EZ-TV-ZIYON-M OCCURS 20 TIMES.
	       09 EZ-TV-ZIYON-P 	 PIC 9(03).
      *===============================================================*
       01 I-INDEXIM.
	 03 I01-INDEX		       PIC 9(05).
      *===============================================================*
       01 MH-MAPHTECHOT-HASHVAA.
	 03 MH-KT-FILE-STATUS	       PIC X(02).
	   88 MH-KT-FILE-STATUS-TAKIN  VALUE '00'.
	 03 MH-PT-FILE-STATUS	       PIC X(02).
	   88 MH-PT-FILE-STATUS-TAKIN  VALUE '00'.
      *===============================================================*
       01 SW-SWITCHIM.
	 03 SW01-SOF-KOVETS	       PIC X VALUE '0'.
	   88 SW01-SOF-KOVETS-TAKIN    VALUE '9'.
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
	    SORT ST-TALMIDIM
	     ASCENDING KEY ST-KTOVET
	     INPUT PROCEDURE C-MIYON-KOVETS
	     OUTPUT PROCEDURE D-HAAVART-KOVETS.
       B-EXIT. EXIT.
      *===============================================================*
       C-MIYON-KOVETS		       SECTION.
      *---------------------------------------------------------------*
       C00.
	    PERFORM CZA-ATCHALAT-MIYON.
	    PERFORM C10-NIHOL 5 TIMES.
	    PERFORM CZZ-SIYOM-MIYON.
       C-EXIT. EXIT.
      *===============================================================*
       C10-NIHOL		       SECTION.
      *===============================================================*
       C10.
	    PERFORM CC-TIPUL.
	    PERFORM CD-KRIA.
       C10-EXIT. EXIT.
      *===============================================================*
       CC-TIPUL 		       SECTION.
      *---------------------------------------------------------------*
       CC00.
	    MOVE KT-SHEM-PRATI TO ST-SHEM-PRATI.
	    MOVE KT-SHEM-MISHPACHA TO ST-SHEM-MISHPACHA.
	    MOVE KT-TZ TO ST-TZ.
	    MOVE KT-KTOVET TO ST-KTOVET.
	    MOVE KT-TV-ZIYON TO ST-TV-ZIYON.
	     RELEASE ST-REC FROM KT-REC.
       CC-EXIT. EXIT.
      *===============================================================*
       CD-KRIA			       SECTION.
      *---------------------------------------------------------------*
       CD00.
	    READ KT-TALMIDIM
	     AT END
	      MOVE '9' TO SW01-SOF-KOVETS.
	      GO TO CD-EXIT.
	    IF NOT MH-KT-FILE-STATUS-TAKIN
	      DISPLAY 'çâêÖöê ïÅÖó öÄâòóÅ Ñåóö'
	      STOP RUN.
       CD-EXIT. EXIT.
      *===============================================================*
       CZA-ATCHALAT-MIYON	       SECTION.
      *---------------------------------------------------------------*
       CZA00.
	    OPEN INPUT KT-TALMIDIM.
	    IF NOT MH-KT-FILE-STATUS-TAKIN
	     DISPLAY 'ïÅÖó öáâöîÅ Ñåóö'
	     STOP RUN.
	    PERFORM CD-KRIA.
       CZA-EXIT. EXIT.
      *===============================================================*
       CZZ-SIYOM-MIYON		       SECTION.
      *---------------------------------------------------------------*
       CZZ00.
	    CLOSE KT-TALMIDIM.
       CZZ-EXIT. EXIT.
      *===============================================================*
       D-HAAVART-KOVETS 	       SECTION.
      *---------------------------------------------------------------*
       D00.
	    PERFORM DB-HASAGA 5 TIMES.
       D-EXIT. EXIT.
      *===============================================================*
       DB-HASAGA		       SECTION.
      *---------------------------------------------------------------*
       DB00.
	    PERFORM DC-KRIA.
	    DISPLAY EZ-SHEM-PRATI
		    EZ-SHEM-MISHPACHA
		    EZ-KTOVET
		    EZ-TZ.
       DB-EXIT. EXIT.
      *===============================================================*
       DC-KRIA			       SECTION.
      *---------------------------------------------------------------*
       DC00.
	    RETURN ST-TALMIDIM INTO EZ-REC
	     AT END
	      MOVE '9' TO SW01-SOF-KOVETS
	      GO TO D-EXIT.
       DC-EXIT. EXIT.
      *===============================================================*
