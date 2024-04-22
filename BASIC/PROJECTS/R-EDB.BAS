10 ' ***************************************
20 ' *****             …           *****
30 ' *****          …’ ’         *****
40 ' *****                             *****
50 ' *****     ”— ’  ’    *****
60 ' ***** 1986 :            :  *****
70 ' *****                      : … *****
80 ' ***************************************
90 KEY(11) ON:KEY(12) ON:KEY(13) ON:KEY(14) ON
100 CLS:KEY OFF:DEF SEG=0:DEF SEG=PEEK(&H42)+256*PEEK(&H43)
110 POKE 8,0:GOSUB 1580:COLOR 1,0:LOCATE 5,33:PRINT ": € ” :":COLOR 3,0
120 LOCATE 7,31:PRINT ". ’  .01"
130 LOCATE 8,36:PRINT ".” … .02"
140 LOCATE 9,28:PRINT ".… …’ ’ .03"
150 LOCATE 10,31:PRINT ".…’ ’ ‘” .04"
160 LOCATE 11,42:PRINT ".€– .09"
170 COLOR 0,7:LOCATE 21,33:PRINT " ’ —":COLOR 3,0
180 E$=INKEY$:IF E$="" THEN 180
190 IF E$="1" THEN COLOR 0,7:LOCATE 7,49:PRINT ".01":COLOR 3,0:GOTO 250
200 IF E$="2" THEN COLOR 0,7:LOCATE 8,49:PRINT ".02":COLOR 3,0:GOTO 620
210 IF E$="3" THEN COLOR 0,7:LOCATE 9,49:PRINT ".03":COLOR 3,0:GOTO 580
220 IF E$="4" THEN COLOR 0,7:LOCATE 10,49:PRINT ".04":COLOR 3,0:GOTO 1420
230 IF E$="9" THEN COLOR 0,7:LOCATE 11,49:PRINT ".09":COLOR 3,0:GOTO 2010
240 BEEP:GOTO 180
250 ' *****  ’  *****
260 GOSUB 1850:GOSUB 1690:LOCATE 3,55:COLOR 1,0:PRINT ": … ‘ :"
270 COLOR 3,0:DAY=0:TIME=0:O$="":G$="":A$="":RESTORE 410
280 LOCATE 21,2:PRINT "(Esc) —… …€ ’…–—,(Q /) ”…  …—,…  …‘ (Return) •"
290 READ SX,FX:DAY=DAY+1:Y=8
300 FOR I=0 TO 9
310 POKE 8,1:LOCATE Y,SX:PRINT "__________":X=SX
320 E$=INKEY$:IF E$="" THEN 320 ELSE X=X+1
330 IF E$="Q" OR E$="q" OR E$="/" THEN A$="":GOTO 310
340 IF E$=CHR$(27) THEN A$=G$:E$="":O$="":GOTO 390
350 IF E$=CHR$(13) THEN O$="":GOTO 390
360 IF X-1=FX THEN O$="":BEEP:GOTO 390
370 LOCATE Y,X-1:PRINT E$:A$=A$+E$
380 GOTO 320
390 EDB$(DAY,I)=A$:G$=A$:LOCATE Y,SX:PRINT "          ":LOCATE Y,SX:PRINT A$:A$="":Y=Y+1:IF DAY=6 AND I=9 THEN 420 ELSE NEXT I
400 GOTO 290
410 DATA 14,24,25,35,36,46,47,57,58,68,69,79
420 ' *****  … … *****
430 A$="":RESTORE 560:O$="":G$="":TIME=0
440 READ SX,FX:TIME=TIME+1:Y=8
450 FOR I=0 TO 9
460 POKE 8,0:LOCATE Y,SX:PRINT "___":X=SX
470 E$=INKEY$:IF E$="" THEN 470 ELSE X=X+1
480 IF E$="/" OR E$="Q" OR E$="q" THEN A$="":GOTO 460
490 IF E$=CHR$(27) THEN A$=G$:E$="":O$="":GOTO 540
500 IF E$=CHR$(13) THEN O$="":GOTO 540
510 IF X-1=FX THEN O$="":BEEP:GOTO 540
520 LOCATE Y,X-1:PRINT E$:A$=A$+E$
530 GOTO 470
540 T$(TIME,I)=A$:G$=A$:LOCATE Y,SX:PRINT "   ":LOCATE Y,SX:PRINT A$:A$="":Y=Y+1:IF TIME=2 AND I=9 THEN 570 ELSE NEXT I
550 GOTO 440
560 DATA 69,72,73,76
570 FOR I=1 TO 10:FOR J=1 TO 6:LSET A$(J)=EDB$(J,I-1):NEXT J:RSET START$=T$(1,I-1):RSET FINISH$=T$(2,I-1):PUT #1:NEXT I:CLOSE #1:GOTO 110
580 ' ***** …’ ’ *****
590 GOSUB 1850:GOSUB 1690:LOCATE 3,55:COLOR 1,0:PRINT ": … ’ :":COLOR 3,0:POKE 8,0:LOCATE 21,26:PRINT "  … — ’ •"
600 FOR I=1 TO 10:GET #1,I:FOR J=1 TO 6:EDB$(J,I)=A$(J):NEXT J:T$(I,1)=START$:T$(I,2)=FINISH$:NEXT I:GOSUB 1990
610 E$=INKEY$:IF E$="" THEN 610 ELSE POKE 8,0:CLOSE #1:GOTO 110
620 ' ***** … … *****
630 GOSUB 1850:GOSUB 1690:LOCATE 3,47:COLOR 1,0:PRINT ": … ’ ” … :":COLOR 3,0
640 FOR I=1 TO 10:GET #1,I:FOR J=1 TO 6:EDB$(J,I)=A$(J):NEXT J:T$(I,1)=START$:T$(I,2)=FINISH$:NEXT I:GOSUB 1990
650 RESTORE 670:FOR J=1 TO 6:FOR I=1 TO 2:READ D(J,I):NEXT I,J
660 FOR J=1 TO 2:FOR I=1 TO 2:READ T(J,I):NEXT I,J
670 DATA 14,24,25,35,36,46,47,57,58,68,69,79,69,72,73,76
680 KEY(11) OFF:KEY(12) OFF:KEY(13) OFF:KEY(14) OFF:POKE 8,0:LOCATE 21,2:PRINT " € ” …  (Esc) ,…’…–— (2) , ” …  (1) ’ • ":POKE 8,1
690 E$=INKEY$:IF E$="" THEN 690
700 IF E$=CHR$(27) THEN FOR I=1 TO 10:FOR J=1 TO 6:LSET A$(J)=EDB$(J,I):NEXT J:RSET START$=T$(I,1):RSET FINISH$=T$(I,2):PUT #1,I:NEXT I:CLOSE #1:GOTO 110
710 IF E$="1" THEN 1080
720 IF E$="2" THEN 740
730 BEEP:GOTO 690
740 ' ***** …’…–— … *****
750 DX=1:Y=8:LOCATE 21,2:POKE 8,0:PRINT "  …€ …’” … (Esc) ,…… (Return) ,… € ’  – ’ — ":POKE 8,1
760 SX=D(DX,1):FX=D(DX,2):LOCATE Y,SX-1:COLOR 0,7:PRINT "*":COLOR 3,0:LSD=0
770 IF LSD=1 THEN 760
780 KEY(11) ON:KEY(12) ON:KEY(13) ON:KEY(14) ON
790 E$=INKEY$
800 ON KEY(11) GOSUB 870
810 ON KEY(12) GOSUB 890
820 ON KEY(13) GOSUB 910
830 ON KEY(14) GOSUB 930
840 IF E$=CHR$(27) THEN GOSUB 950:GOTO 680
850 IF E$=CHR$(13) THEN GOSUB 960
860 GOTO 770
870 ' ***** ’ •  *****
880 IF Y=8 THEN BEEP:GOTO 760 ELSE GOSUB 950:Y=Y-1:LSD=1:RETURN
890 ' ***** € •  *****
900 IF DX=6 THEN BEEP:GOTO 760 ELSE GOSUB 950:DX=DX+1:LSD=1:RETURN
910 ' *****  •  *****
920 IF DX=1 THEN BEEP:GOTO 760 ELSE GOSUB 950:DX=DX-1:LSD=1:RETURN
930 ' *****  •  *****
940 IF Y=17 THEN BEEP:GOTO 760 ELSE GOSUB 950:Y=Y+1:LSD=1:RETURN
950 LOCATE Y,SX-1:COLOR 3,0:PRINT "บ":RETURN
960 ' ***** …’…–— … ‘ *****
970 COLOR 3,0:O$="":G$="":A$=""
980 POKE 8,0:LOCATE 21,2:PRINT "               (Q /) ”…  …—,… …‘ (Return) •              ":POKE 8,1
990 POKE 8,1:LOCATE Y,SX:PRINT "__________":X=SX
1000 E$=INKEY$:IF E$="" THEN 1000 ELSE X=X+1
1010 IF E$="Q" OR E$="q" OR E$="/" THEN A$="":GOTO 990
1020 IF E$=CHR$(13) THEN O$="":GOTO 1060
1030 IF X-1=FX THEN O$="":BEEP:GOTO 1060
1040 LOCATE Y,X-1:PRINT E$:A$=A$+E$
1050 GOTO 1000
1060 EDB$(DX,Y-7)=A$:G$=A$:LOCATE Y,SX:PRINT "          ":LOCATE Y,SX:PRINT A$
1070 LOCATE 21,2:POKE 8,0:PRINT " …€ …’” … , (Esc) …… (Return) ,… € ’  – ’ — ":POKE 8,1:RETURN
1080 ' *****  … *****
1090 DX=1:Y=8:LOCATE 21,2:POKE 8,0:PRINT "  …€ …’” … (Esc) ,…… (Return) ,… € ’  – ’ — ":POKE 8,0
1100 SX=T(DX,1):FX=T(DX,2):LOCATE Y,SX-1:COLOR 0,7:PRINT "*":COLOR 3,0:LSD=0
1110 IF LSD=1 THEN 1100
1120 KEY(11) ON:KEY(12) ON:KEY(13) ON:KEY(14) ON
1130 E$=INKEY$
1140 ON KEY(11) GOSUB 1210
1150 ON KEY(12) GOSUB 1230
1160 ON KEY(13) GOSUB 1250
1170 ON KEY(14) GOSUB 1270
1180 IF E$=CHR$(27) THEN GOSUB 1290:GOTO 680
1190 IF E$=CHR$(13) THEN GOSUB 1300
1200 GOTO 1110
1210 ' ***** ’ •  *****
1220 IF Y=8 THEN BEEP:GOTO 1100 ELSE GOSUB 1290:Y=Y-1:LSD=1:RETURN
1230 ' ***** € •  *****
1240 IF DX=1 THEN BEEP:GOTO 1100 ELSE GOSUB 1290:DX=DX-1:LSD=1:RETURN
1250 ' *****  •  *****
1260 IF DX=2 THEN BEEP:GOTO 1100 ELSE GOSUB 1290:DX=DX+1:LSD=1:RETURN
1270 ' *****  •  *****
1280 IF Y=17 THEN BEEP:GOTO 1100 ELSE GOSUB 1290:Y=Y+1:LSD=1:RETURN
1290 IF DX=1 THEN LOCATE Y,SX-1:COLOR 0,1:PRINT "บ":RETURN ELSE LOCATE Y,SX-1:COLOR 0,1:PRINT "-":RETURN
1300 ' *****  … ‘ *****
1310 COLOR 3,0:O$="":G$="":A$=""
1320 POKE 8,0:LOCATE 21,2:PRINT "              (Q /) ”…  …— ,… …‘ (Return) •              "
1330 LOCATE Y,SX:PRINT "___":X=SX
1340 E$=INKEY$:IF E$="" THEN 1340 ELSE X=X+1
1350 IF E$="Q" OR E$="q" OR E$="/" THEN A$="":GOTO 1330
1360 IF E$=CHR$(13) THEN O$="":GOTO 1400
1370 IF X-1=FX THEN O$="":BEEP:GOTO 1400
1380 LOCATE Y,X-1:PRINT E$:A$=A$+E$
1390 GOTO 1340
1400 T$(Y-7,DX)=A$:G$=A$:LOCATE Y,SX:PRINT "   ":LOCATE Y,SX:PRINT A$
1410 LOCATE 21,2:PRINT "  …€ …’” … (Esc) ,…… (Return) ,… € ’  – ’ — ":RETURN
1420 ' ***** …’ ’ ‘” *****
1430 GOSUB 1850:COLOR 0,7:LOCATE 10,30:PRINT "‘”  ’":COLOR 3,0
1440 FOR I=1 TO 10:GET #1,I:FOR J=1 TO 6:EDB$(J,I)=A$(J):NEXT J:T$(I,1)=START$:T$(I,2)=FINISH$:NEXT I
1450 FOR I=1 TO 10:FOR J=1 TO 6:X=10:ED$=EDB$(J,I)
1460 FOR K=1 TO 10:MID$(EDB$(J,I),X,1)=MID$(ED$,K,1):X=X-1:NEXT K
1470 NEXT J,I
1480 X=(80-LEN(A$))/2:LPRINT CHR$(27);CHR$(45);CHR$(1);
1490 LPRINT SPACE$(X-3);": ";A$;" :":LPRINT CHR$(27);CHR$(45);CHR$(0);:LPRINT
1500 LPRINT "ษออออออออออหออออออออออหออออออออออหออออออออออหออออออออออหออออออออออหอออออออหออป"
1510 LPRINT "บ      บ     บ   ’  บ     บ       บ   …€  บ  บ`บ"
1520 LPRINT "ฬออออออออออฮออออออออออฮออออออออออฮออออออออออฮออออออออออฮออออออออออฮอออออออฮออน"
1530 FOR I=1 TO 10:I$=MID$(STR$(I-1),2,1)
1540 LPRINT "บ";EDB$(6,I);"บ";EDB$(5,I);"บ";EDB$(4,I);"บ";EDB$(3,I);"บ";EDB$(2,I);"บ";EDB$(1,I);"บ";T$(I,1);"-";T$(I,2);"บ.";I$;"บ"
1550 NEXT I
1560 LPRINT "ศออออออออออสออออออออออสออออออออออสออออออออออสออออออออออสออออออออออสอออหอออสออผ"
1570 LPRINT SPACE$(62);"12-C ,11-B ,10-A":CLOSE #1:GOTO 110
1580 ' **** € ‘ ****
1590 LOCATE 1,1:PRINT "”— ’ '’";:PRINT TAB(59);"MADA …… …… "
1600 COLOR 0,7:LOCATE 1,32:PRINT "…’ ’ …":COLOR 3,0
1610 LOCATE 2,1:PRINT "ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป"
1620 FOR I=3 TO 19
1630 LOCATE I,1:PRINT "บ                                                                              บ"
1640 NEXT I
1650 LOCATE 20,1:PRINT "ฬออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออน"
1660 LOCATE 21,1:PRINT "บ                                                                              บ"
1670 LOCATE 22,1:PRINT "ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ"
1680 RETURN
1690 ' ***** …’ ’ …– *****
1700 GOSUB 1580:X=(80-LEN(A$))/2
1710 COLOR 1,0:LOCATE 3,X-2:PRINT ": ";A$;" :":COLOR 3,0
1720 LOCATE 5,2:PRINT "ษออออออออออหออออออออออหออออออออออหออออออออออหออออออออออหออออออออออหอออออออหออป"
1730 FOR I=6 TO 17
1740 LOCATE I,2:PRINT "บ          บ          บ          บ          บ          บ          บ   -   บ  บ"
1750 NEXT I
1760 LOCATE 7,2:PRINT "ฬออออออออออฮออออออออออฮออออออออออฮออออออออออฮออออออออออฮออออออออออฮอออออออฮออน"
1770 LOCATE 18,2:PRINT "ศออออออออออสออออออออออสออออออออออสออออออออออสออออออออออสออออออออออสอออหอออสออผ"
1780 LOCATE 6,2:PRINT "บ      บ     บ   ’  บ     บ       บ   …€  บ  บ`บ":LOCATE 19,62:PRINT "12-C ,11-B ,10-A"
1790 FOR I=0 TO 9:LOCATE I+8,77:PRINT ".";:PRINT USING "#";I:NEXT I
1800 RETURN
1810 ' ***** …€ — *****
1820 IF ERR=71 THEN LOCATE 13,23:COLOR 0,7:PRINT "… —‘ ‘ € ,… …€ —‘":LOCATE 14,26:PRINT "  … — ’ •…":COLOR 0,1:E$=INKEY$:IF E$="" THEN 1820
1830 IF ERR=71 THEN LOCATE 13,23:PRINT                 "                                  ":LOCATE 14,26:PRINT "                            ":RESUME
1840 LOCATE 23,1:PRINT "ERROR NUMBER - ";ERR;", ERROR LINE - ";ERL:GOTO 2000
1850 ' ***** –— ”… ’  *****
1860 GOSUB 1580:X=35:A$="":O$=""
1870 LOCATE 5,23:PRINT "(……€ 7 ’) ’ …  ‘"
1880 LOCATE 7,36:PRINT "_______"
1890 LOCATE 21,5:PRINT ".€ ”  (Esc)  — (Q /),(.) ……— …€ ( ) …… €"
1900 E$=INKEY$:IF E$="" THEN 1900 ELSE X=X+1
1910 IF X=43 OR E$=CHR$(13) THEN BEEP:LOCATE 7,36:PRINT "       ":GOTO 1970
1920 IF E$="Q" OR E$="q" OR E$="/" THEN A$="":E$="":O$="":X=35:BEEP:GOTO 1880
1930 IF E$=CHR$(27) THEN 110
1940 IF E$=" " OR E$="." THEN BEEP:X=X-1:GOTO 1900
1950 LOCATE 7,X:PRINT E$:LOCATE 7,X-1:PRINT O$:O$=E$
1960 A$=A$+E$:GOTO 1900
1970 LOCATE 7,36:PRINT A$:F$=A$+".EDB":OPEN "R",#1,F$,66:FIELD #1,10 AS A$(1),10 AS A$(2),10 AS A$(3),10 AS A$(4),10 AS A$(5),10 AS A$(6),3 AS START$,3 AS FINISH$
1980 RETURN
1990 ' *****  … ‘ *****
2000 FOR I=1 TO 10:LOCATE I+7,69:PRINT T$(I,1);"-";T$(I,2):NEXT I:POKE 8,1:X=14:FOR I=1 TO 10:FOR J=1 TO 6:LOCATE I+7,X:PRINT EDB$(J,I):X=X+11:NEXT J:X=14:NEXT I    :RETURN
2010 END