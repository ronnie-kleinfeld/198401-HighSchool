program hezka;
  var
    h,i,a,b,x,y:integer;
    f,s:real;
  begin
    writeln ('enter basis and maarich');
    readln(a,b);
    if a<0 then
     begin
       a:=-a;
       h:=1;
     end;
    if b<0 then
     begin
       b:=-b;
       i:=1;
     end;
    s:=a; f:=a;
    for x:=1 to (b-1) do for y:=1 to (a-1) do s:=s+f; f:=s;
    if i=1 then s:=1/s;
    if h=1 then if a mod 2=1 then s:=-s;
    if b=0 then s:=1;
    writeln(s:10:4);
  end.