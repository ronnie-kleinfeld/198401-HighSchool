   ' ***************************************
   ' *****      —‡™Ž š‰‰Žƒ„Œ „‹…š     *****
   ' *****          * „Ž‡ŒŽ *          *****
   ' *****                             *****
   ' *****     ƒŒ”‰‰Œ— ’˜ ‰ƒ‰ Œ’    *****
   ' ***** 1985 : „™       9-ˆ : „š‰‹ *****
   ' *****         ‚˜‰‰… ’… : „˜…Ž *****
   ' ***************************************
   KEY OFF
    CLS
    REM **************
    REM ****~€ Œ™****
    REM **************
    DIM A(52),A$(52),B(52),B$(52),V(52),V$(52),L(52),L$(52)
    A=53:X=26:Z=26:S=0:L=0:P=50:R=0:H=0:V1=0:V2=0:V3=0:V4=0:V5=0
    REM **************
    REM ****~ Œ™****
    REM **************
    FOR N=1 TO 13
    FOR M=1 TO 4
    READ R:L=L+1:V(L)=N:V$(L)=CHR$(R)
    NEXT M
    RESTORE 250
    NEXT N
    DATA 5,6,4,3
    LOCATE 1,31:PRINT "„”…— ‰”Œ— šŽ‰™˜"
    FOR M=0 TO 3
    L=0
    FOR N=M*13 TO (M+1)*13:IF R=58 THEN GOTO 320
    L=L+5:R=R+1:LOCATE M+3,L:PRINT V(N+1);V$(N+1)
    NEXT N,M
    LOCATE 10,26:PRINT "Š‰™Ž„Œ ‰ƒ‹ …„™Œ‹ ™—Ž Œ’ •‡Œ"
    GOSUB 880
    CLS
    REM **************
    REM ****~‚ Œ™****
    REM **************
    FOR N=1 TO 26
    A=A-1
  0 L=INT(RND*A)+1
  0 A(N)=V(L):V(L)=V(A)
  0 A$(N)=V$(L):V$(L)=V$(A)
  0 NEXT N
  0 FOR N=1 TO 26
  0 A=A-1
  0 L=INT(RND*A)+1
  0 B(N)=V(L):V(L)=V(A)
  0 B$(N)=V$(L):V$(L)=V$(A)
  0 NEXT N
  0 LOCATE 1,28:PRINT "‰—‡™„ Œ™ ‰”Œ—„ šŒ‰‡"
  0 LOCATE 3,36:PRINT "€ —‡™":LOCATE 4
  0 FOR N=1 TO 26
  0 PRINT A(N);A$(N)":";
  0 NEXT N
  0 LOCATE 8,36:PRINT " —‡™":LOCATE 9
  0 FOR N=1 TO 26
  0 PRINT B(N);B$(N);":";
  0 NEXT N
  0 LOCATE 18,26:PRINT "Š‰™Ž„Œ ‰ƒ‹ …„™Œ‹ ™—Ž Œ’ •‡Œ"
  0 GOSUB 880
  0 CLS
  0 REM **************
  0 REM ****~ƒ Œ™****
  0 REM **************
  0 CLS
  0 LOCATE 1,38:PRINT "—‡™Ž"
  0 LOCATE 3,37:PRINT "€ —‡™";:PRINT "    ";Z;" ‰”Œ—"
  0 FOR N=1 TO 80:LOCATE 12,N:PRINT "Í":NEXT N
  0 LOCATE 13,37:PRINT " —‡™";:PRINT "    ";X;" ‰”Œ—"
  0 LOCATE 20,27:PRINT P;"- …˜š…™ ‰…‰‘ ˜”‘Ž"
  0 LOCATE 3,30:PRINT A(1);A$(1):LOCATE 13,30:PRINT B(1);B$(1)
  0 LOCATE 5,1
  0 FOR N=1 TO Z
  0 PRINT A(N);A$(N);":";
  0 NEXT N
  0 LOCATE 15,1
  0 FOR N=1 TO X
  0 PRINT B(N);B$(N);":";
  0 NEXT N
  0 LOCATE 22,26:PRINT "Š‰™Ž„Œ ‰ƒ‹ …„™Œ‹ ™—Ž Œ’ •‡Œ":GOSUB 880
  0 P=P-1:IF P=-1 THEN R=1:GOTO 1390
  0 IF Z=0 OR X=0 THEN R=2:GOTO 1390
  0 IF A(A(1)+1)>Z OR B(B(1)+1)>X THEN R=3:GOTO 1390
  0 IF A(1)>B(1) THEN LOCATE 12,34:PRINT "‡–‰ € —‡™":V1=V1+1:GOTO 1020
  0 IF A(1)<B(1) THEN LOCATE 12,34:PRINT "‡–‰  —‡™":V2=V2+1:GOTO 1150
  0 IF A(1)=B(1) THEN H=H+1:V3=V3+1:IF H=1 THEN LOCATE 12,37:PRINT "„Ž‡ŒŽ":GOTO 890:ELSE LOCATE 12,37:PRINT "„Œ…”‹ „Ž‡ŒŽ":H=0:GOTO 890
  0 GOTO 650
  0 A$=INKEY$:IF A$="" THEN GOTO 880 ELSE RETURN
  0 IF A(A(1)+1)>B(B(1)+1) THEN V4=V4+1:V1=V1+1:GOTO 910 ELSE V5=V5+1:V2=V2+1:GOTO 1280
  0 IF A(A(1)+1)=B(B(1)+1) THEN GOTO 860
  0 LOCATE 12,31:PRINT "„Ž‡ŒŽ ‡–‰ € —‡™"
  0 FOR N=1 TO A(1)+1:L(N)=A(N):L$(N)=A$(N):NEXT N
  0 FOR N=1 TO A(1)+1
  0 A(Z+1)=L(N):A$(Z+1)=L$(N)
  0 FOR M=1 TO Z:A(M)=A(M+1):A$(M)=A$(M+1):NEXT M
  0 NEXT N
  0 FOR N=Z+1 TO Z+B(1)+1
  0 A(N)=B(1):A$(N)=B$(1):Z=Z+1:X=X-1
  0 FOR M=1 TO X:B(M)=B(M+1):B$(M)=B$(M+1):NEXT M
  00 NEXT N
  10 GOTO 650
  20 REM *******************
  30 REM ****‡–Ž € —‡™****
  40 REM *******************
  50 A(Z+1)=A(1):A$(Z+1)=A$(1)
  60 FOR N=1 TO Z
  70 A(N)=A(N+1):A$(N)=A$(N+1)
  80 NEXT N
  9  A(Z+1)=B(1):A$(Z+1)=B$(1)
  0  Z=Z+1:X=X-1
  1  FOR N=1 TO X
  2  B(N)=B(N+1):B$(N)=B$(N+1)
  3  NEXT N
  4  GOTO 650
  5  REM *******************
  6  REM ****‡–Ž  —‡™****
  7  REM *******************
  8  B(X+1)=B(1):B$(X+1)=B$(1)
  9  FOR N=1 TO X
  0  B(N)=B(N+1):B$(N)=B$(N+1)
  1  NEXT N
  2  B(X+1)=A(1):B$(X+1)=A$(1)
  3  X=X+1:Z=Z-1
  4  FOR N=1 TO Z
  5  A(N)=A(N+1):A$(N)=A$(N+1)
  6  NEXT N
  7  GOTO 650
  8  LOCATE 12,31:PRINT "„Ž‡ŒŽ ‡–‰ ' —‡™"
  9  FOR N=1 TO B(1)+1:L(N)=B(N):L$(N)=B$(N):NEXT N
  0  FOR N=1 TO B(1)+1
  1  B(X+1)=L(N):B$(X+1)=L$(N)
  2  FOR M=1 TO X:B(M)=B(M+1):B$(M)=B$(M+1):NEXT M
  3  NEXT N
  4  FOR N=1+X TO X+B(1)+2
  5  B(N)=A(1):B$(N)=A$(1):X=X+1:Z=Z-1
  6  FOR M=1 TO Z:A(M)=A(M+1):A$(M)=A$(M+1):NEXT M
  7  NEXT N
  8  GOTO 650
  9  REM ************
  0  REM ****…‰‘****
  1  REM ************
  2  CLS:LOCATE 1,38:PRINT "…‰‘"
  3  A$="-™ „€–…š‹ ‰‰š‘„ —‡™Ž„"
  4  IF R=1 THEN LOCATE 3,22:PRINT "‰—‡™Ž 50 …˜’";A$:GOTO 1480
   0 IF R=2 THEN LOCATE 3,17:PRINT "‰”Œ—„ …˜Ž‚ ‰—‡™„ ƒ‡€Œ";A$:GOTO 1480
   0 IF R=3 THEN LOCATE 3,13:PRINT "„Ž‡ŒŽ ‰”Œ—„ …˜Ž‚ ‰—‡™„ ƒ‡€Œ";A$:GOTO 1480
   0 GOTO 650
   0 LOCATE 5,61:PRINT "‰—‡™Ž ";50-P;" Š…šŽ"
   0 LOCATE 6,57:PRINT V1;"- '€ —‡™ ‡–‰"
   0 LOCATE 7,57:PRINT V2;"- ' —‡™ ‡–‰"
   0 LOCATE 9,62:PRINT "š…Ž‡ŒŽ ";V3;" …‰„"
   0 LOCATE 10,41:PRINT "'€ —‡™ ‡–‰ „™ š…Ž‡ŒŽ ";V4;" ‹…šŽ"
   0 LOCATE 11,41:PRINT "' —‡™ ‡–‰ „™ š…Ž‡ŒŽ ";V5;" ‹…šŽ"
   0 LOCATE 15,22:PRINT "™ƒ‡ —‡™Ž Œ‰‡š„Œ ‰ƒ‹ …„™Œ‹ ™—Ž Œ’ •‡Œ":GOSUB 880
   0 RUN
