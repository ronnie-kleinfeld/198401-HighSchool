10 ' ***************************************
20 ' *****                 *****
30 ' *****                     *****
40 ' *****                             *****
50 ' *****            *****
60 ' ***** 1986 -        9- -  *****
70 ' *****              -  *****
80 ' ***************************************
90 CLS:KEY OFF:DEF SEG=0:DEF SEG=PEEK(&H42)+256*PEEK(&H43)
100 GOSUB 1760
110 LOCATE 5,33:COLOR 1,0:PRINT ":   :":COLOR 3,0
120 LOCATE 7,32:PRINT ".  .01"
130 LOCATE 8,32:PRINT ".  .02"
140 LOCATE 9,31:PRINT ". /  .03"
150 LOCATE 10,28:PRINT ".   .04"
160 LOCATE 11,40:PRINT ". .09"
170 LOCATE 21,33:PRINT "  "
180 E$=INKEY$:IF E$="" THEN GOTO 180
190 IF E$="1" THEN LOCATE 7,46:COLOR 0,7:PRINT ".01":COLOR 3,0:GOTO 250
200 IF E$="2" THEN LOCATE 8,46:COLOR 0,7:PRINT ".02":COLOR 3,0:GOTO 540
210 IF E$="3" THEN LOCATE 9,46:COLOR 0,7:PRINT ".03":COLOR 3,0:GOTO 780
220 IF E$="4" THEN LOCATE 10,46:COLOR 0,7:PRINT ".04":COLOR 3,0:GOTO 940
230 IF E$="9" THEN LOCATE 11,46:COLOR 0,7:PRINT ".09":COLOR 3,0:GOTO 2390
240 BEEP:GOTO 170
250 ' *****   *****
260 Y=4:S=1:RESTORE 400:GOSUB 1860:GOSUB 1760
270 LOCATE 4,32:COLOR 1,0:PRINT ":   :":COLOR 3,0
280 LOCATE 18,32:PRINT "___  "
290 LOCATE 21,27:PRINT " {ŽŮ} {RETURN}  "
300 FOR I=1 TO 6:READ P,O,L,A$,H$:LOCATE 2*I+4,19:PRINT H$:NEXT I
310 IF M=100 THEN GOSUB 1760:LOCATE 10,25:COLOR 23:PRINT "    ":FOR I=1 TO 1000:NEXT I:COLOR 3,0:RUN
320 LOCATE 18,32:PRINT USING "###";M+1:RESTORE 400
330 Y=Y+2:READ P,O,L,E$,H$
340 POKE 8,P:LOCATE Y,O:LINE INPUT A$:A$=LEFT$(A$,L)
350 POKE 8,0:BEEP:LOCATE Y,1:PRINT "ş                 ";H$:FOR J=60 TO 79:LOCATE Y,J:PRINT " ";:NEXT J:LOCATE Y,80:PRINT "ş":POKE 8,P
360 LOCATE Y,O:PRINT "                ":LOCATE Y,O:PRINT A$
370 ON S GOSUB 480,490,500,510,520,530
380 S=S+1:IF S<7 THEN GOTO 330
390 PUT #1,M+1
400 DATA 1,53,10,FAMILY,"__________                        "
410 DATA 1,53,10,SELF,"__________                         "
420 DATA 0,19,10,IDENTITY,"__________                  "
430 DATA 1,48,15,ADRESS,"_______________                     "
440 DATA 0,19,6,ACCOUNT,"______                          "
450 DATA 0,19,16,BALANCE,"________________               "
460 X$="EOF":RSET FAMILY$=X$:X$="":RSET SELF$=X$:LSET IDENTITY$=X$:RSET ADRESS$=X$:LSET ACCOUNT$=X$:LSET BALANCE$=X$
470 PUT #1,M+2:CLOSE #1:GOTO 100
480 RSET FAMILY$=A$:RETURN
490 RSET SELF$=A$:RETURN
500 LSET IDENTITY$=A$:RETURN
510 RSET ADRESS$=A$:RETURN
520 LSET ACCOUNT$=A$:RETURN
530 LSET BALANCE$=A$:RETURN
540 ' *****   *****
550 X=1:T=6:RESTORE 400:GOSUB 1940:IF EF=1 THEN 100
560 GOSUB 1760
570 LOCATE 4,32:COLOR 1,0:PRINT ":   :":COLOR 3,0:ASF=1:GOSUB 2250
580 LOCATE 21,3:PRINT "(Esc)    (Return) ,     (-)  (+)  "
590 LOCATE T,61:PRINT "Ž"
600 E$=INKEY$:IF E$="" THEN 600 ELSE BEEP
610 IF E$="+" THEN LOCATE T,61:PRINT " ":T=T+2:X=X+1:IF T>16 THEN T=T-2:X=X-1
620 IF E$="-" THEN LOCATE T,61:PRINT " ":T=T-2:X=X-1:IF T<6 THEN T=T+2:X=X+1
630 IF E$=CHR$(27) THEN PUT #1,A:CLOSE #1:GOTO 100
640 IF E$=CHR$(13) THEN GOTO 660
650 LOCATE T,61:PRINT "Ž":GOTO 600
660 ON X+1 GOSUB 720,730,740,750,760,770:READ P,O,L,A$,H$:POKE 8,0:LOCATE T,19:PRINT H$
670 POKE 8,P:LOCATE T,O:LINE INPUT A$:A$=LEFT$(A$,L)
680 ON X+1 GOSUB 480,490,500,510,520,530
690 POKE 8,0:LOCATE T,1:PRINT "ş                 ";H$:FOR J=60 TO 79:LOCATE T,J:PRINT " ";:NEXT J:LOCATE T,80:PRINT "ş":POKE 8,P
700 LOCATE T,O:PRINT "                ":LOCATE T,O:PRINT A$
710 POKE 8,0:T=T+2:X=X+1:IF T>16 THEN T=T-2:X=X-1:GOTO 590 ELSE GOTO 590
720 RESTORE 400:RETURN
730 RESTORE 410:RETURN
740 RESTORE 420:RETURN
750 RESTORE 430:RETURN
760 RESTORE 440:RETURN
770 RESTORE 450:RETURN
780 ' *****  /  *****
790 ASF=1:GOSUB 1940:GOSUB 1760:S=A:LOCATE 4,31:COLOR 1,0:PRINT ":  /  :":COLOR 3,0:GOSUB 2250:LOCATE 21,5:PRINT ".      (Esc)  (/)  -  / "
800 LOCATE 21,5:PRINT ".      (Esc)  (/)  -  / "
810 E$=INKEY$:IF E$="" THEN 810
820 IF E$="N" OR E$="n" THEN 860
830 IF E$="V" OR E$="v" THEN 880
840 IF E$=CHR$(27) THEN CLOSE #1:GOTO 790
850 BEEP:GOTO 810
860 GOSUB 2380:LOCATE 21,41:PRINT ":   ":LOCATE 21,24:LINE INPUT A$:D=VAL(A$):B=VAL(BALANCE$):BC=B-D:LOCATE 16,18:PRINT "                ":LOCATE 16,18:PRINT BC:IF BC<0 THEN LOCATE 16,8:COLOR 0,7:PRINT " ":COLOR 3,0
870 GOSUB 2380:LOCATE 21,12:PRINT "( / ) ?";D;"        ":GOSUB 900:GOSUB 2380
880 GOSUB 2380:LOCATE 21,41:PRINT ":   ":LOCATE 21,24:LINE INPUT A$:D=VAL(A$):B=VAL(BALANCE$)
890 GOSUB 2380:BC=B+D:LOCATE 16,18:PRINT BC:LOCATE 21,29:PRINT ": ( / )   ":GOSUB 900
900 E$=INKEY$:IF E$="" THEN 900
910 IF E$="F" OR E$="f" THEN A$=STR$(BC):GET #1,A:RSET FAMILY$=FAMILY$:RSET SELF$=SELF$:LSET IDENTITY$=IDENTITY$:RSET ADRESS$=ADRESS$:LSET ACOOUNT$=ACCOUNT$:LSET BALANCE$=A$:PUT #1,A:CLOSE #1:GOTO 100
920 IF E$="K" OR E$="k" THEN CLOSE #1:GOTO 100
930 BEEP:GOTO 900
940 ' *****  *****
950 GOSUB 1760
960 LOCATE 4,32:COLOR 1,0:PRINT ":   :":COLOR 3,0
970 LOCATE 6,18:PRINT ".()       .01"
980 LOCATE 7,33:PRINT ".     .02"
990 LOCATE 8,46:PRINT ".  .03"
1000 LOCATE 9,39:PRINT ".   .09"
1010 LOCATE 21,33:PRINT "  "
1020 E$=INKEY$:IF E$="" THEN 1020
1030 IF E$="1" THEN LOCATE 6,57:COLOR 0,7:PRINT ".01":COLOR 3,0:GOTO 1080
1040 IF E$="2" THEN LOCATE 7,57:COLOR 0,7:PRINT ".02":COLOR 3,0:GOTO 1160
1050 IF E$="3" THEN LOCATE 8,57:COLOR 0,7:PRINT ".03":COLOR 3,0:GOTO 1180
1060 IF E$="9" THEN LOCATE 9,57:COLOR 0,7:PRINT ".09":COLOR 3,0:GOTO 100
1070 BEEP:GOTO 1020
1080 ' *****       *****
1090 ASF=1:RESTORE 400:GOSUB 1760:GOSUB 1860:LOCATE 4,35:COLOR 1,0:PRINT " ":COLOR 3,0:LOCATE 21,14:PRINT " (Esc)   (-)     (+) ":A=1:RESTORE 400
1100 GET #1,A:GOSUB 2250
1110 E$=INKEY$:IF E$="" THEN 1110
1120 IF E$="+" THEN A=A+1:IF A>M THEN BEEP:A=M:GOTO 1110
1130 IF E$="-" THEN A=A-1:IF A<1 THEN BEEP:A=1:GOTO 1110
1140 IF E$=CHR$(27) THEN CLOSE #1:ASF=0:GOTO 940
1150 GOTO 1100
1160 ' *****      *****
1170 ASF=0:GOSUB 1940:IF XT=1 THEN CLOSE #1:GOTO 940 ELSE GOSUB 1760:LOCATE 4,27:COLOR 1,0:PRINT ":      :":COLOR 3,0:GOSUB 2250:CLOSE #1:GOTO 940
1180 ' *****  *****
1190 GOSUB 1760:GOSUB 1860
1200 IF ASD=0 THEN DIM A(M),D(M)
1210 H=0:L=1:G=0:D=1:ASD=1
1220 LOCATE 4,34:COLOR 1,0:PRINT ":        :":COLOR 3,0
1230 LOCATE 6,36:PRINT ".   .01"
1240 LOCATE 7,36:PRINT ".   .02"
1250 LOCATE 8,19:PRINT ".( +  )   .03"
1260 LOCATE 9,30:PRINT ".    .09"
1270 LOCATE 21,33:PRINT "  "
1280 E$=INKEY$:IF E$="" THEN 1280
1290 IF E$="1" THEN LOCATE 6,56:COLOR 0,7:PRINT ".01":COLOR 3,0:GOTO 1340
1300 IF E$="2" THEN LOCATE 7,56:COLOR 0,7:PRINT ".02":COLOR 3,0:GOTO 1340
1310 IF E$="3" THEN LOCATE 8,56:COLOR 0,7:PRINT ".03":COLOR 3,0:GOTO 1340
1320 IF E$="9" THEN LOCATE 9,56:COLOR 0,7:PRINT ".09":COLOR 3,0:CLOSE #1:GOTO 950
1330 BEEP:GOTO 1280
1340 GOSUB 1760:E=VAL(E$)
1350 FOR I=1 TO M:GET #1,I:B=VAL(BALANCE$)
1360 IF E=1 AND B>=0 THEN A(L)=B:L=L+1:IF B>H THEN H=B
1370 IF E=2 AND B<0 THEN A(L)=B:L=L+1:IF ABS(B)>ABS(H) THEN H=B
1380 IF E=3 THEN D(D)=B:D=D+1:IF B>G THEN G=B
1390 NEXT I
1400 IF E=3 THEN 1580
1410 ' *****  /  -  *****
1420 FOR I=6 TO 18:LOCATE I,4:PRINT "×":NEXT I:LOCATE 3,33:COLOR 1,0:IF E=1 THEN PRINT ":   :" ELSE PRINT ":   :"
1430 COLOR 3,0:IF E=1 THEN CY=18:LOCATE 18,4 ELSE CY=6:LOCATE 6,4
1440 PRINT "Î":FOR I=1 TO L-1:LOCATE CY,I+4:PRINT "Ř":NEXT I
1450 FOR I=1 TO L-1:IF H=0 THEN H=1
1460 IF E=1 THEN K=INT(12*A(I)/H-.5):CS=17:CF=17-K:ST=-1 ELSE K=ABS(INT(12*A(I)/H-.5)):CS=7:CF=7+K:ST=1
1470 FOR J=CS TO CF STEP ST:LOCATE J,I+4:PRINT "ş":NEXT J:NEXT I
1480 LOCATE 21,32:PRINT "   ":IF INKEY$="" THEN 1480
1490 IF L<70 THEN CLOSE #1:GOTO 1190
1500 FOR J=5 TO 79:FOR I=17 TO 5 STEP -1:LOCATE I,J:PRINT " ":NEXT I,J
1510 IF E=1 THEN CY=18:LOCATE 18,4 ELSE CY=6:LOCATE 6,4
1520 PRINT "Î":FOR I=1 TO L-71:LOCATE CY,I+4:PRINT "Ř":NEXT I
1530 FOR I=1 TO L-1:IF H=0 THEN H=1
1540 IF E=1 THEN K=INT(12*A(I)/H-.5):CS=17:CF=17-K:ST=-1 ELSE K=ABS(INT(12*A(I)/H-.5)):CS=7:CF=7+K:ST=1
1550 FOR J=CS TO CF STEP ST:LOCATE J,I+4:PRINT "ş":NEXT J:NEXT I
1560 LOCATE 21,32:PRINT "   ":IF INKEY$="" THEN 1550
1570 CLOSE #1:GOTO 1190
1580 ' ***** ( + )  -  *****
1590 LOCATE 3,24:COLOR 1,0:PRINT ": ( + )  -  :":COLOR 3,0
1600 FOR I=6 TO 18:LOCATE I,4:PRINT "×":NEXT I:FOR I=1 TO D-1:LOCATE 12,I+4:PRINT "Ř":NEXT I:LOCATE 12,4:PRINT "Î"
1610 FOR I=1 TO D-1:IF G=0 THEN G=1
1620 IF D(I)<0 THEN K=(ABS(INT(6*D(I)/G-.5)))-1:FOR J=13 TO 14+K:LOCATE J,I+4:PRINT "Ű":NEXT J
1630 IF D(I)>=0 THEN K=INT(6*D(I)/G-.5):FOR J=11 TO 11-K STEP -1:LOCATE J,I+4:PRINT "Ű":NEXT J
1640 NEXT I
1650 LOCATE 21,32:PRINT "   ":IF INKEY$="" THEN 1650
1660 IF D<70 THEN CLOSE #1:GOTO 1190
1670 FOR J=5 TO 79:FOR I=17 TO 5 STEP -1:LOCATE I,J:PRINT " ":NEXT I,J
1680 FOR I=1 TO D-71:LOCATE 18,I+4:PRINT "Ř":NEXT I
1690 FOR I=71 TO L-1
1700 IF D(I)<0 THEN K=(ABS(INT(6*D(I)/G+.5)))-1:FOR J=13 TO 13+K:LOCATE J,I+4:PRINT "Ű":NEXT J
1710 IF D(I)>=0 THEN K=INT(6*D(I)/G-.5):FOR J=11 TO 11-K STEP -1:LOCATE J,I+4:PRINT "Ű":NEXT J
1720 NEXT I
1730 LOCATE 21,32:PRINT "   ":IF INKEY$="" THEN 1650
1740 CLOSE #1:GOTO 1190
1750 END
1760 ' ****   ****
1770 LOCATE 1,1:PRINT "  '                                         MADA   "
1780 LOCATE 2,1:PRINT "ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍť"
1790 FOR I=3 TO 19
1800 LOCATE I,1:PRINT "ş                                                                              ş"
1810 NEXT I
1820 LOCATE 20,1:PRINT "ĚÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍš"
1830 LOCATE 21,1:PRINT "ş                                                                              ş"
1840 LOCATE 22,1:PRINT "ČÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍź"
1850 RETURN
1860 ' *****    *****
1870 OPEN "R",#1,"R-BANK.DAT",67
1880 FIELD #1,10 AS FAMILY$,10 AS SELF$,10 AS IDENTITY$,15 AS ADRESS$,6 AS ACCOUNT$,16 AS BALANCE$
1890 FOR I=1 TO 100:GET #1,I
1900 IF EOF(1) THEN GOTO 1930
1910 IF FAMILY$="       EOF"OR FAMILY$="       FOE" THEN 1930
1920 NEXT I
1930 M=I-1:RETURN
1940 ' ***** ...   -  *****
1950 F$="":S$="":XT=0:EF=0:X=0:RESTORE 400:GOSUB 1860:GOSUB 1760:IF SDF=0 THEN DIM F$(M),S$(M)
1960 FOR I=1 TO M:GET #1,I:F$(I)=FAMILY$:S$(I)=SELF$:NEXT I
1970 SDF=1:W=0:LOCATE 4,17:PRINT "? (//)   /   /  - ":LOCATE 21,12:PRINT "    (Esc)    (//) "
1980 E$=INKEY$:IF E$="" THEN 1980
1990 IF E$="A" OR E$="a" THEN LOCATE 4,24:COLOR 0,7:PRINT "":COLOR 3,0:GOTO 2080
2000 IF E$="J" OR E$="j" THEN LOCATE 4,22:COLOR 0,7:PRINT "":COLOR 3,0:GOTO 2170
2010 IF E$="E" OR E$="e" THEN LOCATE 4,20:COLOR 0,7:PRINT "":COLOR 3,0:GOTO 2040
2020 IF E$=CHR$(27) THEN CLOSE #1:EF=1:XT=1:GOTO 100
2030 BEEP:GOTO 1970
2040 IF W=3 THEN 1970
2050 LOCATE 6,30:PRINT "___   ":LOCATE 6,30:LINE INPUT A$:A=VAL(A$):W=W+1:GOSUB 2240
2060 IF A<1 OR A>M THEN BEEP:GOTO 2040
2070 GET #1,A:GOTO 2230
2080 IF W=3 THEN GOSUB 2240:GOTO 1970
2090 LOCATE 6,1:PRINT "ş                                                 :   ":POKE 8,1:LOCATE 6,31:LINE INPUT A$:POKE 8,0:W=W+1:GOSUB 2240
2100 FOR I=1 TO M:GET #1,I:X=0:FOR Q=1 TO 2:IF Q=1 THEN SHP$=FAMILY$ ELSE SHP$=SELF$
2110 D=LEN(A$):IF D=10 THEN 2120 ELSE F=11-D:B$=A$:FOR L=1 TO 10:MID$(A$,F,1)=B$:NEXT L:A$=B$
2120 COLOR 3,8:LOCATE 22,1:PRINT SHP$;" ";FAMILY$;" ";SELF$;" ";A$
2130 FOR J=1 TO 10:IF MID$(SHP$,J,1)=MID$(A$,J,1) THEN X=X+1
2140 LOCATE 20,1:PRINT X;" ";J:NEXT J:IF X=LEN(SHP$) THEN 2160
2150 NEXT Q,I:LOCATE 8,25:PRINT "     ":FOR P=1 TO 1000:NEXT P:LOCATE 8,25:PRINT "                             ":GOTO 2080
2160 A=I:GOTO 2230
2170 IF W=3 THEN GOTO 1970
2180 POKE 8,0:LOCATE 6,32:PRINT "        :   ":LOCATE 6,32:LINE INPUT A$:W=W+1:A=VAL(A$):GOSUB 2240
2190 FOR I=1 TO M:GET #1,I
2200 IF A=VAL(ACCOUNT$) THEN A=I:GOTO 2230
2210 NEXT I
2220 LOCATE 8,31:PRINT "   ":FOR I=1 TO 1000:NEXT I:LOCATE 8,31:PRINT "                  ":GOTO 2170
2230 POKE 8,0:RETURN
2240 LOCATE 6,1:PRINT "ş                                                                              ş":RETURN
2250 ' *****   *****
2260 RESTORE 400:FOR I=1 TO 6:READ P,O,L,A$,H$:LOCATE 2*I+4,19:PRINT H$:NEXT I
2270 LOCATE 18,32:PRINT "___  ":B=VAL(BALANCE$)
2280 LOCATE 18,32:PRINT USING "###";A
2290 POKE 8,1:LOCATE 6,53:PRINT FAMILY$
2300 POKE 8,1:LOCATE 8,53:PRINT SELF$
2310 POKE 8,0:LOCATE 10,19:PRINT IDENTITY$
2320 POKE 8,1:LOCATE 12,48:PRINT ADRESS$
2330 POKE 8,0:LOCATE 14,19:PRINT ACCOUNT$
2340 POKE 8,0:LOCATE 16,8:PRINT "           ";BALANCE$;" "
2350 IF B<0 THEN COLOR 0,7:LOCATE 16,8:PRINT " ":COLOR 3,0
2360 IF ASF=0 THEN LOCATE 21,32:PRINT "   ":E$=INKEY$:IF E$="" THEN 2360
2370 RETURN
2380 LOCATE 21,1:PRINT "ş                                                                              ş":RETURN
2390 END
