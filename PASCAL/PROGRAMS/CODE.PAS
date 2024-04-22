program code;
var
a,b:string [100];
c,d,e,f,g,h,i,j,k,l:integer;
begin
writeln('enter 1 for hatzpana  enter 2 to pianuhach');
readln(f);
writeln('enter the string');
readln(a);
c:=length(a);
for e:=1 to c do begin
b:=copy(a,e,1);
if f=1 then l:=4  else l:=-4 ;
b:=chr(ord(b)+l);
if (ord( b)<97) and (ord (b)>92) then b:=chr(ord(b)+26);
if (ord (b)>122) and (ord(b)<127) then b:=chr(ord(b)-26);
write(b);
end;
end.
