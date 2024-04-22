10 ' ***************************************
20 ' *****     š‰‰’ š˜‰š”Œ „‹…š      *****
30 ' *****         * ‰‰Ž…‡ *          *****
40 ' *****                             *****
50 ' *****     ƒŒ”‰‰Œ— ’˜ ‰ƒ‰ Œ’    *****
60 ' ***** 1985 : „™       9-ˆ : „š‰‹ *****
70 ' *****         ‚˜‰‰… ’… : „˜…Ž *****
80 ' ***************************************
90 CLS
100 LOCATE 1,35:COLOR 1:PRINT "‰Ž…‡ š‰‰’":COLOR 7
110 FOR N=1 TO 10
120 PRINT TAB(3);N;TAB(7);""
130 NEXT N
140 DIM A(10)
150 FOR N=1 TO 9
160 LOCATE 14,5:INPUT B:A=0
170 FOR M=1 TO B
180 A=A+1:IF A>10 THEN A=1
190 IF A(A)=1 THEN GOTO 180
200 NEXT M
210 A(A)=1
220 LOCATE 15,1:PRINT N;". ";B;" †˜‹…„™ ˜”‘Ž„ ";A;" šŽ™ ˜”‘Ž„ ":LOCATE A+1,7:PRINT CHR$(2)
230 NEXT N
240 FOR N=1 TO 10
250 IF A(N)=0 THEN GOTO 270
260 NEXT N
270 FOR B=7 TO 79:LOCATE N+1,B-1:PRINT " ":LOCATE N+1,B:PRINT "":NEXT B
280 LOCATE N+1,68:PRINT "˜˜‡…™Ž €…„ "
290 LOCATE 20,1
300 END
