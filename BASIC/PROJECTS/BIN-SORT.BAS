10 ' *******************************************
20 ' ***** ���� ���� ����� ������ �� ����� *****
30 ' *******************************************
40 DIM T(20,4):IP=1:A=0:CLS
50 DATA 8,25,17,35,18,75,4,0,13,-5,7,55,14,Z
60 READ N$:IF N$="Z" THEN 190 ELSE N=VAL(N$):A=A+1
70 IF IP=1 THEN 150
80 IF IP>20 THEN PRINT "No place":END
90 K=1
100 ' ***** 1 *****
110 IF T(K,1)<N THEN IF T(K,3)=0 THEN T(K,3)=IP:GOTO 140 ELSE K=T(K,3):GOTO 100
120 IF T(K,1)=N THEN 180 ELSE IF T(K,2)=0 THEN T(K,2)=IP:GOTO 140
130 K=T(K,2):GOTO 100
140 T(IP,4)=K:' * 3 *
150 T(IP,1)=N:' * 4 *
160 'PRINT IP;N;K
170 IP=IP+1
180 GOTO 60
190 PRINT "�������������������ͻ"
200 PRINT "� I �IP � < � > �RET�"
210 PRINT "�������������������͹"
220 FOR I=1 TO A
230 PRINT "�";
240 PRINT USING "###";I;
250 PRINT "�";
260 PRINT USING "###";T(I,1);
270 PRINT "�";
280 PRINT USING "###";T(I,2);
290 PRINT "�";
300 PRINT USING "###";T(I,3);
310 PRINT "�";
320 PRINT USING "###";T(I,4);
330 PRINT "�"
340 NEXT I
350 PRINT "�������������������ͼ"
360 ' ********************************************
370 ' ***** Print Sorted Binaric Tree Sorted *****
380 ' ********************************************
390 DIM A(A):K=1:FOR I=1 TO A:A(I)=1:NEXT I
400 IF K=0 THEN END
410 IF T(K,2)<>0 THEN IF A(T(K,2))=1 THEN K=T(K,2):GOTO 400 ELSE 420
420 IF A(K)=0 THEN K=T(K,4):GOTO 400
430 PRINT T(K,1):A(K)=0
440 IF T(K,3)=0 THEN K=T(K,4):GOTO 400
450 IF A(T(K,3))=1 THEN K=T(K,3)
460 GOTO 400
3)=0 THEN END g$:��IF T(K,2)=0 AND T(K,3)=0 THEN K=1:GOTO 370 ��� I� � :� A(I):� I   