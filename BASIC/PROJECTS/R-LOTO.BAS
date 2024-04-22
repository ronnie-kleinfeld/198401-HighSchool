10 ' ***************************************
20 ' *****   …… —‘‘ …   *****
30 ' *****                             *****
40 ' *****     ”— ’  ’    *****
50 ' ***** 1986 -        9- -  *****
60 ' *****            …— …€ - … *****
70 ' ***************************************
80 CLS
90 KEY OFF
100 DEF SEG=0:DEF SEG=PEEK(&H42)+256*PEEK(&H43):N=0
110 ' **** € ” ****
120 GOSUB 2440
130 COLOR 1,0:LOCATE 6,34:PRINT "€ ”":COLOR 0,1
140 LOCATE 8,30:PRINT ".… ‘ .01"
150 LOCATE 9,33:PRINT ".—‘‘ .02"
160 LOCATE 10,37:PRINT ".€– .99"
170 LOCATE 21,30:PRINT "_ :  € —"
180 POKE 8,1
190 LOCATE 21,51
200 LINE INPUT N$
210 POKE 8,0
220 IF N$="1" THEN 320
230 IF N$="2" THEN 940
240 IF N$="99" THEN 2550
250 LOCATE 21,2:PRINT "                                                                             "
260 BEEP
270 GOTO 170
280 ' **********************
290 ' **** … ‘ ****
300 ' **********************
310 '
320 ' **** … ‘ ” ****
330 GOSUB 2440
340 LOCATE 1,33:PRINT "ษออออออออออออออป"
350 LOCATE 2,33:PRINT "น … ‘ ฬ"
360 LOCATE 3,33:PRINT "ศออออออออออออออผ"
370 LOCATE 6,38:PRINT ".…€ .01"
380 LOCATE 7,42:PRINT ". .02"
390 LOCATE 8,31:PRINT ".€ ”  .99"
400 LOCATE 21,32:PRINT "_ :  € —"
410 POKE 8,1
420 LOCATE 21,49:LINE INPUT N$
430 POKE 8,0
440 IF N$="1" THEN L=1:GOTO 500
450 IF N$="2" THEN L=2:GOTO 700
460 IF N$="99" THEN GOTO 120
470 BEEP
480 LOCATE 21,2:PRINT "                                                                             "
490 GOTO 400
500 ' **** …€ ”‘  ****
510 GOSUB 2110
520 OPEN "R",#1,A$
530 FIELD #1,2 AS A$(1),2 AS A$(2),2 AS A$(3),2 AS A$(4),2 AS A$(5),2 AS A$(6)
540 GOSUB 2250
550 RANDOMIZE(TIMER)
560 FOR I=1 TO 6
570 A(I)=INT((RND(TIMER)*40)+.5)
580 FOR J=1 TO I-1
590 IF A(I)=A(J) THEN 570
600 NEXT J
610 READ X:LOCATE 13,X:PRINT A(I):RSET A$(I)=MKI$(A(I))
620 NEXT I
630 DATA 10,18,26,34,42,50
640 LOCATE 18,19:COLOR 1,0:PRINT "•…— … ‘  … — ’ — €":COLOR 0,1
650 E$=INKEY$:IF E$=" " THEN 660 ELSE 650
660 N$=W$:N=VAL(N$):E$="EOF":RSET N$=E$
670 PUT #1,N
680 CLOSE #1
690 GOTO 120
700 ' ****  … ‘ ****
710 GOSUB 2110
720 OPEN "R",#1,A$
730 FIELD #1,2 AS A$(1),2 AS A$(2),2 AS A$(3),2 AS A$(4),2 AS A$(5),2 AS A$(6)
740 GOSUB 2250
750 DIM Y$(6)
760 RESTORE 630
770 FOR I=1 TO 6
780 READ X
790 LOCATE 13,(X-1):PRINT "       "
800 LOCATE 13,(X+1):LINE INPUT Y$
810 A(I)=VAL(Y$):A=A(I)
820 FOR J=1 TO I-1
830 IF A(J)=A(I) THEN BEEP:GOTO 790
840 NEXT J
850 IF A<1 OR A>40 THEN BEEP:GOTO 790
860 RSET A$(I)=MKI$(A(I))
870 NEXT I
880 LOCATE 18,19:COLOR 1,0:PRINT "•…— … ‘  … — ’ — €":COLOR 0,1
890 E$=INKEY$:IF E$=" " THEN 660 ELSE 650
900 N=VAL(N$):E$="EOF":RSET N$=E$
910 PUT #1,N
920 CLOSE #1
930 GOTO 120
940 ' *********************
950 ' ***** —‘‘ *****
960 ' *********************
970 GOSUB 2440
980 LOCATE 4,35:COLOR 1,0:PRINT "—‘‘":COLOR 0,1
990 LOCATE 6,35:PRINT ".(4) … 1 .01"
1000 LOCATE 7,35:PRINT ".(26)  ซ .02"
1010 LOCATE 8,35:PRINT ".(52)  1 .03"
1020 LOCATE 9,33:PRINT ".(260)  5 .04"
1030 LOCATE 10,29:PRINT ".€ ”  .99"
1040 LOCATE 21,32:PRINT "_ :  € —"
1050 POKE 8,1
1060 LOCATE 21,49:LINE INPUT A$:A=VAL(A$)
1070 POKE 8,0
1080 IF A=1 THEN S=4:GOTO 1150
1090 IF A=2 THEN S=26:GOTO 1150
1100 IF A=3 THEN S=52:GOTO 1150
1110 IF A=4 THEN S=260:GOTO 1150
1120 BEEP
1130 LOCATE 21,32:PRINT "                 "
1140 GOTO 1040
1150 GOSUB 2110
1160 R=W-S:DIM T(S,6):R1=SGN(R):SD=S
1170 LOCATE 21,24:COLOR 0,7:PRINT "…’ … …‘  €":COLOR 0,1
1180 IF R1=-1 THEN GOTO 1300
1190 OPEN "R",#1,M$
1200 FIELD #1,2 AS A$(1),2 AS A$(2),2 AS A$(3),2 AS A$(4),2 AS A$(5),2 AS A$(6)
1210 FOR I=S TO R STEP -1
1220 GET #1,I
1230 FOR J=1 TO 6
1240 T(S,J)=CVI(A$(J))
1250 NEXT J
1260 S=S-1
1270 NEXT I
1280 CLOSE #1
1290 GOTO 1680
1300 OPEN "R",#1,A$
1310 FIELD #1,2 AS A$(1),2 AS A$(2),2 AS A$(3),2 AS A$(4),2 AS A$(5),2 AS A$(6)
1320 D=S
1330 IF D>52 THEN D=D-52:GOTO 1330
1340 FOR I=W TO 1 STEP -1
1350 GET #1,I
1360 FOR J=1 TO 6
1370 T(S,J)=CVI(A$(J))
1380 NEXT J
1390 S=S-1
1400 NEXT I
1410 CLOSE #1
1420 D=S
1430 ON (6-Y) GOSUB 1570,1590,1610,1630,1650
1440 IF D>52 THEN L=51
1450 IF D<52 THEN L=D
1460 IF D=52 THEN L=D-1
1470 FOR I=52 TO 52-L STEP -1
1480 GET #1,I
1490 FOR J=1 TO 6
1500 T(S,J)=CVI(A$(J))
1510 NEXT J
1520 S=S-1:IF S=0 THEN GOTO 1560
1530 NEXT I
1540 CLOSE #1
1550 GOTO 1420
1560 GOTO 1680
1570 OPEN "R",#1,"1985.DAT":FIELD #1,2 AS A$(1),2 AS A$(2),2 AS A$(3),2 AS A$(4),2 AS A$(5),2 AS A$(6):Y=Y-1
1580 RETURN
1590 OPEN "R",#1,"1984.DAT":FIELD #1,2 AS A$(1),2 AS A$(2),2 AS A$(3),2 AS A$(4),2 AS A$(5),2 AS A$(6):Y=Y-1
1600 RETURN
1610 OPEN "R",#1,"1983.DAT":FIELD #1,2 AS A$(1),2 AS A$(2),2 AS A$(3),2 AS A$(4),2 AS A$(5),2 AS A$(6):Y=Y-1
1620 RETURN
1630 OPEN "R",#1,"1982.DAT":FIELD #1,2 AS A$(1),2 AS A$(2),2 AS A$(3),2 AS A$(4),2 AS A$(5),2 AS A$(6):Y=Y-1
1640 RETURN
1650 OPEN "R",#1,"1981.DAT":FIELD #1,2 AS A$(1),2 AS A$(2),2 AS A$(3),2 AS A$(4),2 AS A$(5),2 AS A$(6)
1660 RETURN
1670 ' ***********************
1680 ' ***** …  *****
1690 ' ***********************
1700 GOSUB 2440
1710 LOCATE 3,62:COLOR 1,0:PRINT "… ":COLOR 0,1
1720 LOCATE 4,55:PRINT "ฺฤฤยฤฤาฤฤยฤฤาฤฤยฤฤาฤฤยฤฤฟ"
1730 LOCATE 5,55:PRINT "ณ XณFXบ XณFXบ XณFXบ XณFXณ"
1740 LOCATE 6,55:PRINT "รฤฤลฤฤืฤฤลฤฤืฤฤลฤฤืฤฤลฤฤด"
1750 FOR I=1 TO 10
1760 LOCATE I+6,55:PRINT "ณ";USING "##";I;:PRINT "ณ  บ";USING "##";I+10;:PRINT "ณ  บ";USING "##";I+20;:PRINT "ณ  บ";USING "##";I+30;:PRINT "ณ  ณ"
1770 NEXT I
1780 LOCATE 17,55:PRINT "ภฤฤมฤฤะฤฤมฤฤะฤฤมฤฤะฤฤมฤฤู"
1790 DIM Y(40)
1800 LOCATE 21,24:COLOR 0,7:PRINT "…’ … …‘  €":COLOR 0,1
1810 FOR I=1 TO SD
1820 FOR J=1 TO 6
1830 Y(T(I,J))=Y(T(I,J))+1
1840 NEXT J
1850 NEXT I
1860 LOCATE 21,24:PRINT "                              "
1870 FOR I=1 TO 10
1880 LOCATE I+6,59:PRINT USING "##";Y(I)
1890 LOCATE I+6,65:PRINT USING "##";Y(I+10)
1900 LOCATE I+6,71:PRINT USING "##";Y(I+20)
1910 LOCATE I+6,77:PRINT USING "##";Y(I+30)
1920 NEXT I
1930 LOCATE 3,24:PRINT "… “"
1940 FOR I=4 TO 15
1950 LOCATE I,5:PRINT "ล"
1960 NEXT I
1970 LOCATE 16,5:PRINT "ลลลลลลลลลลลลลลลลลลลลลลลลลลลลลลลลลลลลลลลลล"
1980 LOCATE 17,5:PRINT " 1   5   10   15   20   25   30   35   40"
1990 FOR I=1 TO 40
2000 IF Y(I)>H THEN H=Y(I):P=I
2010 NEXT I
2020 FOR I=1 TO 40
2030 L=INT(12*Y(I)/H-.5)
2040 FOR J=15 TO 15-L STEP -1
2050 LOCATE J,I+5:PRINT "บ"
2060 NEXT J
2070 NEXT I
2080 LOCATE 21,27:COLOR 1,0:PRINT "  … — ’ •":COLOR 0,1
2090 E$=INKEY$:IF E$=" " THEN GOTO 2100 ELSE 2090
2100 RUN
2110 REM **** € ‘ ****
2120 GOSUB 2440
2130 LOCATE 6,37:PRINT ":€"
2140 LOCATE 8,35:PRINT "____ : "
2150 LOCATE 8,35
2160 LINE INPUT A$:A=VAL(A$)
2170 IF A$<"1981" OR A$>"1986" THEN BEEP:GOTO 2140
2180 Y=(A-((INT(A/10))*10))-1:A$=A$+".DAT"
2190 LOCATE 10,37:PRINT "__ :’…"
2200 LOCATE 10,37:LINE INPUT W$
2210 W=VAL(W$):N$=W$
2220 IF W<1 OR W>52 THEN BEEP:GOTO 2190
2230 IF LEN(W$)=1 THEN LOCATE 10,38:PRINT "  ":W$=LEFT$(W$,1):LOCATE 10,37:PRINT W$
2240 RETURN
2250 ' **** …  ‘” ****
2260 GOSUB 2440
2270 IF L=1 THEN LOCATE 5,26:COLOR 1,0:PRINT " '’ …… € …":COLOR 0,1
2280 IF L=2 THEN LOCATE 5,29:COLOR 1,0:PRINT "  -  … ‘":COLOR 0,1
2290 LOCATE 7,8:PRINT "ษอออออออหอออออออหอออออออหอออออออหอออออออหอออออออหอออออออออออออออป"
2300 LOCATE 8,8:PRINT "บ       บ       บ       บ       บ       บ       บ               บ"
2310 LOCATE 9,8:PRINT "บ   1   บ   2   บ   3   บ   4   บ   5   บ   6   บ               บ"
2320 LOCATE 10,8:PRINT "บ       บ       บ       บ       บ       บ       บ               บ"
2330 LOCATE 11,8:PRINT "ฬอออออออฮอออออออฮอออออออฮอออออออฮอออออออฮอออออออฮอออออออออออออออน"
2340 LOCATE 12,8:PRINT "บ       บ       บ       บ       บ       บ       บ         ”‘ บ"
2350 LOCATE 13,8:PRINT "บ       บ       บ       บ       บ       บ       บ      ’     บ"
2360 LOCATE 14,8:PRINT "บ       บ       บ       บ       บ       บ       บ  …        บ"
2370 LOCATE 15,8:PRINT "ศอออออออสอออออออสอออออออสอออออออสอออออออสอออออออสอออออออออออออออผ"
2380 FOR I=2 TO 79
2390 LOCATE 20,I:PRINT " "
2400 NEXT I
2410 LOCATE 20,1:PRINT "บ"
2420 LOCATE 20,80:PRINT "บ"
2430 RETURN
2440 ' **** € ‘ ****
2450 LOCATE 1,1:PRINT "”— ’ '’                                         MADA …… …… "
2460 LOCATE 2,1:PRINT "ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป"
2470 FOR I=3 TO 19
2480 LOCATE I,1:PRINT "บ                                                                              บ"
2490 NEXT I
2500 LOCATE 20,1:PRINT "ฬออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออน"
2510 LOCATE 21,1:PRINT "บ                                                                              บ"
2520 LOCATE 22,1:PRINT "ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ"
2530 RETURN
2550 END
