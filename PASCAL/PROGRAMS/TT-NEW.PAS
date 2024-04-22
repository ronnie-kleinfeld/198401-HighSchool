 program tt(input,output);
 var a,b,g,i,n,m,r,ex,one,two,bdika,y,gh:integer;
     c,d,e,f,t:real;
    tot:array [1..5] of array [1..14] of char;
    a1,b1:array [1..14] of integer;
    w:char;

 PROCEDURE rnd;
 var x:integer;
 begin
 x:=random(2);
  case bdika of
  1:begin if x=0 then tot[5,r]:='x';
          if x=1 then tot[5,r]:='1' end;
  2:begin if x=0 then tot[5,r]:='x';
          if x=1 then tot[5,r]:='2' end;
  3:begin if x=0 then tot[5,r]:='1';
          if x=1 then tot[5,r]:='2' end
  end end;

 BEGIN
    for i:=1 to 14 do begin
      a1[i]:=1;b1[i]:=1
      end;
    clrscr;randomize;y:=0;gh:=0;
    for i:=1 to 14 do begin write (i,'- ');readln (a1[i],b1[i]) end;
    for r:=1 to 4 do begin gh:=gh+3;
    for i:=1 to 14 do begin a:=a1[i];b:=b1[i];
    m:=a-b;if m<0 then m:=b-a;if a>b then n:=b else n:=a;
    c:=n+((m)/(a+b));t:=a+b+c;d:=(a/t)*100;e:=(c/t)*100;f:=(b/t)*100;
    g:=random(100)+1;
    if g<d then tot[r,i]:='1' else if g>(d+e) then tot[r,i]:='2'
    else tot[r,i]:='x';
    gotoxy (gh+10,i);write (tot[r,i]) end;
    end end.