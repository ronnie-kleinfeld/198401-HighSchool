10 ' ***************************************
20 ' *****            …            *****
30 ' *****   ……’ ’” € ’  *****
40 ' *****                             *****
50 ' *****     ”— ’  ’    *****
60 ' ***** 1986 -        9- -  *****
70 ' *****                      - … *****
80 ' ***************************************
90 CLS:KEY OFF:DEF SEG=0:DEF SEG=PEEK(&H42)+256*PEEK(&H43)
100 ' ***** –— *****
110 OPEN "R",#1,"STOCK.DAT",52
120 OPEN "R",#2,"STOCKB.DAT",16
130 FIELD #1,8 AS DAE$,8 AS AMMOUNT$,20 AS NAE$,1 AS TYPE$,1 AS IOT$
140 FIELD #2,8 AS BDAE$,8 AS BAMMOUNT$
150 I=I+1:GET #1,I
160 IF EOF(1) THEN 170 ELSE 150
170 EF=I:GET #2,1
180 LASTD$=BDAE$
190 LASTAM=CVD(BAMMOUNT$)
200 FOR I=1 TO 3
210 GET #2,I+1
220 DAE$(I)=BDAE$
230 AMM(I)=CVD(BAMMOUNT$)
240 NEXT I
250 ' ***** € ” *****
260 LOCATE 25,29:PRINT "                                ":GOSUB 2820
270 LOCATE 5,26:COLOR 1:PRINT ":    €   -     ”   :":COLOR 3,0
280 LOCATE 8,32:PRINT ".… ”‘… .01"
290 LOCATE 10,32:PRINT "      .€€ .02"
300 LOCATE 12,32:PRINT "       .…… .03"
310 LOCATE 15,32:PRINT "        .…‘ .05"
320 LOCATE 21,29:PRINT "_ : (” ”)  € —"
330 E$="":LOCATE 21,29:PRINT CHR$(95):LOCATE 21,29:PRINT " ":E$=INKEY$:IF E$="" THEN 330 ELSE LOCATE 21,29:PRINT E$
340 IF E$="1" THEN 390
350 IF E$="2" THEN 1510
360 IF E$="3" THEN 2270
370 IF E$="5" THEN CLOSE:END
380 BEEP:GOTO 320
390 ' ***** … ”‘… *****
400 ' ***** … ”‘… ‘ *****
410 CLS:LOCATE 25,1:PRINT TAB(29);"Esc - …—  ":GOSUB 2820
420 LOCATE 4,31:COLOR 1,0:PRINT ": €– / ‘ :":COLOR 3,0
430 LOCATE 6,14:PRINT "ษออออออออออออออออออออออออออออออออออออออออออออออออออป"
440 LOCATE 7,14:PRINT "บ                 __/__/____ : €               บ"
450 LOCATE 8,14:PRINT "บ                                                  บ"
460 LOCATE 9,14:PRINT "บ  ____________________ :   0000000 : ……’ ”‘ บ"
470 LOCATE 10,14:PRINT "บ                                                  บ"
480 LOCATE 11,14:PRINT "บ                 _____ : …’ …‘                  บ"
490 LOCATE 12,14:PRINT "ศออออออออออออออออออออออออออออออออออออออออออออออออออผ"
500 LOCATE 14,26:PRINT "ษอออออออออออออออออออออออออออป
510 LOCATE 15,26:PRINT "บ        …€         บ"
520 LOCATE 16,26:PRINT "บ  __ / __ / ____ : €  บ"
530 LOCATE 17,26:PRINT "บ            : ……’ ”‘   บ"
540 LOCATE 18,26:PRINT "ศอออออออออออออออออออออออออออผ"
550 ' ***** …€  … ‘ *****
560 LOCATE 17,30:PRINT LASTAM
570 DD$=MID$(LASTD$,1,2)
580 MM$=MID$(LASTD$,3,2)
590 YY$=MID$(LASTD$,5,4)
600 LOCATE 16,29:PRINT DD$;" / ";MM$;" / ";YY$
610 DD$="":MM$="":YY$=""
620 ' ***** € *****
630 IN=0:OT=0
640 DD$=MID$(DATE$,4,2):MM$=MID$(DATE$,1,2):YY$=MID$(DATE$,7,4)
650 LOCATE 21,2:PRINT SPACE$(78):LOCATE 7,32:PRINT DD$;"/";MM$;"/";YY$:DA$=DD$+MM$+YY$
660 LOCATE 21,21:PRINT "…  [Enter] ,…– € € —"
670 X=32:A$=MID$(DA$,1,1):W=1
680 E$="":LOCATE 7,X:PRINT "Û":LOCATE 7,X:PRINT A$:E$=INKEY$:IF E$="" THEN 680
690 IF E$=CHR$(13) THEN 820
700 IF ASC(E$)<48 OR ASC(E$)>57 THEN BEEP:GOTO 680
710 DD$=MID$(DA$,1,2)
720 MM$=MID$(DA$,3,2)
730 YY$=MID$(DA$,5,4)
740 MID$(DA$,W,1)=E$
750 W=W+1:LOCATE 7,X:PRINT E$
760 A$=MID$(DA$,W,1)
770 X=X+1:IF X=42 THEN X=41:BEEP:A$=MID$(DA$,W-1,1):W=W-1:GOTO 680
780 IF W=3 THEN X=35
790 IF W=5 THEN X=38
800 GOTO 680
810 ' ***** ……’ ”‘ *****
820 LOCATE 21,2:PRINT SPACE$(78):LOCATE 9,52:COLOR 1,0:PRINT ": ……’ ”‘":COLOR 3,0
830 LOCATE 21,14:PRINT " [Enter] , —…  [<-] ,……’ ”‘ —"
840 X1=49:AM=0:LOCATE 9,44:PRINT "000000 "
850 E$=INKEY$:IF E$="" THEN 850
860 IF E$=CHR$(27) THEN LOCATE 9,52:PRINT ": ……’ ”‘":GOTO 650
870 IF E$=CHR$(13) THEN LOCATE 9,44:PRINT "       ":LOCATE 9,43:PRINT AM/10:GOTO 930
880 IF E$=CHR$(8) THEN AM=0:GOTO 840
890 IF ASC(E$)<48 OR ASC(E$)>57 THEN BEEP:GOTO 850
900 IF X1=42 THEN BEEP:LOCATE 9,44:PRINT "       ":LOCATE 9,43:PRINT AM/10:GOTO 930
910 AM=AM+VAL(E$):LOCATE 9,X1:PRINT AM:AM=AM*10:X1=X1-1
920 GOTO 850
930 LOCATE 9,52:PRINT ": ……’ ”‘":AM=AM/10
940 ' *****  *****
950 LOCATE 21,2:PRINT SPACE$(78):LOCATE 9,38:COLOR 1,0:PRINT ": ":COLOR 3,0
960 POKE 8,0:LOCATE 21,19:PRINT " [Enter] , —…  [<-] , —":POKE 8,1:LOCATE 9,45:PRINT "____________________"
970 O$=" ":X2=45:A$="_":NM$=""
980 E$="":LOCATE 9,X2:PRINT CHR$(22):LOCATE 9,X2:PRINT O$:E$=INKEY$:IF E$="" THEN 980 ELSE X2=X2+1:IF NM$="" THEN X2=X2-1
990 IF E$=CHR$(27) THEN POKE 8,0:LOCATE 9,38:PRINT ": ":GOTO 810
1000 IF X2=65 OR E$=CHR$(13) THEN BEEP:LOCATE 9,45:PRINT "                    ":LOCATE 9,45:PRINT NM$:POKE 8,0:GOTO 1040
1010 IF E$=CHR$(8) THEN NM$="":GOTO 960
1020 LOCATE 9,X2:PRINT E$:LOCATE 9,X2-1:PRINT O$:O$=E$
1030 NM$=NM$+E$:GOTO 980
1040 LOCATE 9,38:PRINT ": "
1050 ' ***** …’ …‘ *****
1060 POKE 8,0:LOCATE 21,2:PRINT SPACE$(78):LOCATE 11,38:COLOR 1,0:PRINT ": …’ …‘":COLOR 3,0
1070 LOCATE 21,21:PRINT " - 3 , €” - 2 , — - 1 : —":COLOR 3,0
1080 E$=INKEY$:IF E$="" THEN 1080
1090 IF E$=CHR$(27) THEN LOCATE 11,38:PRINT ": …’ …‘":GOTO 940
1100 IF E$="1" THEN LOCATE 11,34:PRINT "—":LE$="1":GOTO 1140
1110 IF E$="2" THEN LOCATE 11,32:PRINT "€”":LE$="2":GOTO 1140
1120 IF E$="3" THEN LOCATE 11,32:PRINT "":LE$="3":GOTO 1140
1130 BEEP:GOTO 1080
1140 LOCATE 11,38:PRINT ": …’ …‘"
1150 ' ***** €– …€ ‘ *****
1160 LOCATE 21,2:PRINT SPACE$(78)
1170 LOCATE 21,16:PRINT "[2] (…—) …€– …€  [1] (—”‘) …‘ … €"
1180 E$=INKEY$:IF E$="" THEN 1180
1190 IF E$="1" THEN IO$="1":GOTO 1220
1200 IF E$="2" THEN IO$="2":GOTO 1220
1210 BEEP:GOTO 1180
1220 ' ***** … ‘ *****
1230 RSET DAE$=DA$
1240 RSET AMMOUNT$=MKD$(AM)
1250 LSET NAE$=NM$
1260 RSET TYPE$=LE$
1270 RSET IOT$=IO$
1280 PUT #1,EF:EF=EF+1
1290 IF IO$="1" THEN LASTAM=LASTAM+AM
1300 IF IO$="2" THEN LASTAM=LASTAM-AM
1310 RSET BDAE$=DA$:LASTD$=DA$
1320 RSET BAMMOUNT$=MKD$(LASTAM)
1330 PUT #2,1
1340 IF IO$="2" THEN 1390
1350 IF LE$="1" THEN DAE$(1)=DA$:AMM(1)=AMM(1)+AM
1360 IF LE$="2" THEN DAE$(2)=DA$:AMM(2)=AMM(2)+AM
1370 IF LE$="3" THEN DAE$(3)=DA$:AMM(3)=AMM(3)+AM
1380 GOTO 1420
1390 IF LE$="1" THEN DAE$(1)=DA$:AMM(1)=AMM(1)-AM
1400 IF LE$="2" THEN DAE$(2)=DA$:AMM(2)=AMM(2)-AM
1410 IF LE$="3" THEN DAE$(3)=DA$:AMM(3)=AMM(3)-AM
1420 FOR I=1 TO 3
1430 RSET BDAE$=DAE$(I):RSET BAMMOUNT$=MKD$(AMM(I)):PUT #2,I+1
1440 NEXT I
1450 LOCATE 21,2:PRINT SPACE$(78)
1460 LOCATE 21,25:PRINT "(€ - , - )  … …’ "
1470 E$=INKEY$:IF E$="" THEN 1470
1480 IF E$="F" OR E$="f" OR E$="" THEN 430
1490 IF E$="K" OR E$="k" OR E$="" THEN 250
1500 BEEP:GOTO 1470
1510 ' ***** €€ *****
1520 GOSUB 2820:LOCATE 5,32:COLOR 1,0:PRINT ": €€ ” :":COLOR 3,0
1530 LOCATE 7,43:PRINT ".— .1"
1540 LOCATE 9,41:PRINT ".€” .2"
1550 LOCATE 11,41:PRINT ". .3"
1560 LOCATE 13,37:PRINT ".…‘  .4"
1570 LOCATE 16,30:PRINT ".€ ”  .6"
1580 LOCATE 21,17:PRINT "_ : €€ …’”… ……’ …‘  € —":O$=" "
1590 E$=INKEY$:LOCATE 21,17:PRINT O$:LOCATE 21,17:PRINT "_":IF E$="" THEN 1590
1600 IF E$="1" THEN T$="1":GOTO 1660
1610 IF E$="2" THEN T$="2":GOTO 1660
1620 IF E$="3" THEN T$="3":GOTO 1660
1630 IF E$="4" THEN T$="4":GOTO 1660
1640 IF E$="6" THEN 250
1650 O$=E$:BEEP:GOTO 1590
1660 LOCATE 21,17:PRINT E$:X=1:O=EF-1:L=0:GOSUB 2820
1670 IF T$="1" THEN R$="—"
1680 IF T$="2" THEN R$="€”"
1690 IF T$="3" THEN R$=""
1700 IF T$="4" THEN R$="…‘ "
1710 LOCATE 3,40:PRINT ".";R$;" : …’ …‘"
1720 LOCATE 4,3:PRINT "ษออออออออออออออออออออออออออออออหออออออออออออออออออออออออออออออหออออออออออออป"
1730 LOCATE 5,3:PRINT "บ    (€–) …—    บ……’ '‘บ    (‘) —”‘    บ……’ '‘บ    €   บ"
1740 LOCATE 6,3:PRINT "ฬออออออออออออออออออออฮอออออออออฮออออออออออออออออออออฮอออออออออฮออออออออออออน"
1750 IF O=0 THEN BEEP:GOTO 250
1760 IF O<12 THEN P=O ELSE P=12:O=O-12
1770 FOR I=1 TO P
1780 GET #1,X:X=X+1:IF X=EF+1 THEN F=1:GOTO 1920
1790 IF T$="1" AND TYPE$<>"1" THEN 1780
1800 IF T$="2" AND TYPE$<>"2" THEN 1780
1810 IF T$="3" AND TYPE$<>"3" THEN 1780
1820 L=L+1:LOCATE L+6,3:PRINT "บ                    บ         บ                    บ         บ            บ"
1830 DD$=MID$(DAE$,1,2)
1840 MM$=MID$(DAE$,3,2)
1850 YY$=MID$(DAE$,5,4)
1860 LOCATE L+6,67:PRINT DD$;"/";MM$;"/";YY$
1870 IF IOT$="1" THEN XY1=27:XY2=56
1880 IF IOT$="2" THEN XY1=58:XY2=25
1890 POKE 8,1:LOCATE L+6,XY1:PRINT NAE$:POKE 8,0
1900 LOCATE L+6,XY2:PRINT CVD(AMMOUNT$)
1910 NEXT I
1920 LOCATE L+7,3:PRINT "ศออออออออออออออออออออสอออออออออสออออออออออออออออออออสอออออออออสออออออออออออผ"
1930 FOR I=L+8 TO 19:LOCATE I,2:PRINT SPACE$(78):NEXT I
1940 LOCATE 21,26:PRINT "  … — ’ —"
1950 E$=INKEY$:IF E$="" THEN 1950
1960 IF F=1 THEN 2010
1970 IF O<0 OR O=0 THEN 2010
1980 IF O<12 THEN P=O:O=O-12:L=0:GOTO 1770
1990 IF O>12 THEN O=O-12:P=12 ELSE P=O
2000 L=0:GOTO 1770
2010 ' *****  *****
2020 GOSUB 2820:LOCATE 4,(80-(LEN(R$)+4))/2:COLOR 1,0:PRINT ": ";R$;" :"
2030 COLOR 3,0:LOCATE 6,26:PRINT "ษอออออออออออออออออออออออออออป
2040 LOCATE 7,26:PRINT "บ                  บ"
2050 LOCATE 8,26:PRINT "บ  __ / __ / ____ : €  บ"
2060 LOCATE 9,26:PRINT "บ            : ……’ ”‘   บ"
2070 LOCATE 10,26:PRINT "ศอออออออออออออออออออออออออออผ"
2080 LOCATE 9,30:PRINT LASTAM
2090 DD$=MID$(LASTD$,1,2)
2100 MM$=MID$(LASTD$,3,2)
2110 YY$=MID$(LASTD$,5,4)
2120 LOCATE 8,29:PRINT DD$;" / ";MM$;" / ";YY$
2130 IF T$="4" THEN 2240
2140 LOCATE 14,26:PRINT "ษอออออออออออออออออออออออออออป
2150 LOCATE 15,26:PRINT "บ                       บ"
2160 LOCATE 16,26:PRINT "บ  __ / __ / ____ : €  บ"
2170 LOCATE 17,26:PRINT "บ            : ……’ ”‘   บ"
2180 LOCATE 18,26:PRINT "ศอออออออออออออออออออออออออออผ"
2190 I=VAL(T$):LOCATE 17,30:PRINT AMM(I):LOCATE 15,31:PRINT R$
2200 DD$=MID$(DAE$(I),1,2)
2210 MM$=MID$(DAE$(I),3,2)
2220 YY$=MID$(DAE$(I),5,4)
2230 LOCATE 16,29:PRINT DD$;" / ";MM$;" / ";YY$
2240 LOCATE 21,21:PRINT "€ ” …  … — ’ —"
2250 E$=INKEY$:IF E$="" THEN 2250
2260 GOTO 200
2270 ' ***** ‘” … *****
2280 GOSUB 2820:LOCATE 5,32:COLOR 1,0:PRINT ": …… ” :":COLOR 3,0
2290 LOCATE 7,43:PRINT ".— .1"
2300 LOCATE 9,41:PRINT ".€” .2"
2310 LOCATE 11,41:PRINT ". .3"
2320 LOCATE 13,37:PRINT ".…‘  .4"
2330 LOCATE 16,30:PRINT ".€ ”  .6"
2340 LOCATE 21,17:PRINT "_ : …… …’”… ……’ …‘  € —":O$=" "
2350 E$=INKEY$:LOCATE 21,17:PRINT O$:LOCATE 21,17:PRINT "_":IF E$="" THEN 2350
2360 IF E$="1" THEN T$="1":GOTO 2420
2370 IF E$="2" THEN T$="2":GOTO 2420
2380 IF E$="3" THEN T$="3":GOTO 2420
2390 IF E$="4" THEN T$="4":GOTO 2420
2400 IF E$="6" THEN 250
2410 O$=E$:BEEP:GOTO 2350
2420 LOCATE 21,17:PRINT E$:X=1
2430 IF T$="1" THEN R$="—"
2440 IF T$="2" THEN R$="€”"
2450 IF T$="3" THEN R$=""
2460 IF T$="4" THEN R$="…‘ "
2470 LPRINT CHR$(27);CHR$(45);CHR$(1);
2480 LPRINT CHR$(9);CHR$(9);CHR$(14);": ……’ …… … :"
2490 LPRINT CHR$(27);CHR$(45);CHR$(0);:LPRINT CHR$(20);
2500 LPRINT
2510 YY$=MID$(DATE$,7,4)
2520 MM$=MID$(DATE$,1,2)
2530 DD$=MID$(DATE$,4,2)
2540 LPRINT "        ";DD$;"/";MM$;"/";YY$;" : €                         .";R$;" : …’ …‘"
2550 LPRINT
2560 LPRINT "     (€–) …—     ……’ '‘    (‘) —”‘      ……’ '‘ …‘     €"
2570 LPRINT " -------------------- --------- -------------------- --------- --- ------------"
2580 GET #1,X:X=X+1:IF X=EF+1 THEN F=1:GOTO 2720
2590 IF T$="1" AND TYPE$<>"1" THEN 2580
2600 IF T$="2" AND TYPE$<>"2" THEN 2580
2610 IF T$="3" AND TYPE$<>"3" THEN 2580
2620 DD$=MID$(DAE$,1,2)
2630 MM$=MID$(DAE$,3,2)
2640 YY$=MID$(DAE$,5,4)
2650 ME$="":FOR I=20 TO 1 STEP -1
2660 ME$=ME$+MID$(NAE$,I,1)
2670 NEXT I:IF IOT$="1" THEN 2700
2680 LPRINT " ";ME$;" ";CVD(AMMOUNT$);SPACE$(9-LEN(STR$(CVD(AMMOUNT$))));"                                ";TYPE$;"   ";DD$;"/";MM$;"/";YY$
2690 GOTO 2580
2700 LPRINT "                                ";ME$;" ";CVD(AMMOUNT$);SPACE$(9-LEN(STR$(CVD(AMMOUNT$))));" ";TYPE$;"   ";DD$;"/";MM$;"/";YY$
2710 GOTO 2580
2720 LPRINT
2730 LPRINT CHR$(27);CHR$(69);SPACE$(17);". - 3 , €” - 2 , — - 1 : (……’) …‘":LPRINT CHR$(27);CHR$(70);
2740 IF T$="1" THEN LPRINT "                    ";AMM(1);": ";R$;
2750 IF T$="2" THEN LPRINT "                    ";AMM(2);": ";R$;
2760 IF T$="3" THEN LPRINT "                    ";AMM(3);": ";R$
2770 IF T$="4" THEN LPRINT "     ";AMM(3);":  ,";AMM(2);": €”";AMM(1);": —";
2780 LPRINT ;LASTAM;":  ";CHR$(14);" : …"
2790 LPRINT
2800 LPRINT CHR$(15);"'’ ……’ '    … ":LPRINT CHR$(18);
2810 GOTO 250
2820 ' **** € ‘ ****
2830 LOCATE 1,1:COLOR 0,1:PRINT "”— ’ '’              ……’ ' …          MADA …… …… ":COLOR 3,0
2840 LOCATE 2,1:PRINT "ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป"
2850 FOR I=3 TO 19
2860 LOCATE I,1:PRINT "บ                                                                              บ"
2870 NEXT I
2880 LOCATE 20,1:PRINT "ฬออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออน"
2890 LOCATE 21,1:PRINT "บ                                                                              บ"
2900 LOCATE 22,1:PRINT "ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ":RETURN
