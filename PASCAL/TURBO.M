    EDIT
   ======
ctrl e-A  w-A screen       ctrl N - insert line
     c-v  z-V screen            Y - delete line
                                q+y-delete to eol
ctrl Q+ s - home                L - restore line
        d - right
        x - v                 Q+F - find string
        r - top of file       Q+L - repeat
        c - end of file       Q+A - find & replace

blocks                          U - abort
-------
ctrl Q+ b,k-move to begin,end

     K+ b,k-mark (F7,F8)
        C - copy
        V - move
        Y - del
        R - read
        W - write

PARTS -           CONTROL-CHARACTERS           COMPILER DIRECTIVE
--------          ------------------           --------------------
0 PROGRAM(option)  #10  - ascii 10             {$I INCLUDE.FIL}
1 LABEL            #$1B - ascii 1B hex         (*I INC.BAS*)
2 CONST            ^G   - control-g (bell)
3 TYPE             ^[   - esc
4 VAR
5 PROC

VARIABLES         comments
---------         -----------------------
1 INTEGER         {  eara  }
2 BYTE            (* eara *)
3 REAL
4 CHAR
  STRINGS
5 BOOLEAN

 program  tlm;
 program  gt_field (y,x,len);

 label    10,error, 999,quit ;

 const    limit = 255;
	  max   = 1024;
	  pswd  = 'raly';
	  crshom= ^['V' ;
	  digits= array[0..9] of char = '0123456789';

 type 	  number = integer;
	  upper  = 'A'..'Z';
   cube   = array [0..1,0..1,0..8]; of integer;
	  ascii  = set of 0..127;   ???
	  lower  = 'a'..'z';
	  day	 = (sun,mon,tue);      -------------->
	  days   = 0..365;
	  month  = (jan,feb,mars, apr);
	  list	 = array [1..10] of real;
	  name   = string [18];
	  matrix = array [day] of array [1..13] of byte;
                				   list;

 var	  i,j,k  : integer ;
	  period : day ;              --------------->
	  buffer : array[1..127] of byte ;

 var	  week   : array[1..7] of day;

          matrix [2][3] := 125;
          matrix [2,3]  := 133;
- - - - - - - - - - - - - - - - - - - - - - - - -

 type
	date = record
	  day: 1..31;
	  mon: (jan,feb,mar,,,,,,);
	  year: 1900..1999;
	  name: string[32];
	end;

 var
	birth: date;
	workd: array [1..5] of date;
. . . .. . . . . . .

	birth.day := 10;
	workd[3]  := workd [4];
. . . . . . . . . . . . . . . . . . .
   with birth do      (* no need to say : birth.day *)
        day = 33;
   end;

 if x > y then y := x;  else x := y;   (????)

 if x > y then begin
    i     := x+33 ;
    small := big;
 end;

 case parm of
   '+' : x := x+1;
   '-' : x := x-1;
 end;


 for i := 2 to 100 do
 begin
  .....
 end;


 while size>1 do size := x*3;

 while size>1 do
 begin
   ...
 end;


 repeat
   ....
 until upcase (answer) in  ['Y', 'N'] ;

 if ch in ('a','s','m') then
-----------------------------------------------------
                 strings
                =========

conect:		age    = 'eli' + 'boy' ;
= concat:

delete:		delete ( string, start, len);

insert:		insert ( src, target, start);

conv(num->str): str    ( val: left:right, string );

conv(str->num): val    ( string, var, rc);   rc=0 then ok.

copy =(mid$):   copy   ( string, start, length);

len(string)

substr:		pos    ( string1, string2) ,if s1 not found in s2
 				    then return 0;

			 files
			=======

 type	parit_name = string [80];
	paritim    = file of record
   name: parit_name;
	  pno : integer;
	end;

 var
 	pfile = paritim;


assign  (file_var, file_name);	- init (1)
rewrite (fv);			- init (2) for new file
reset   (fv);			- init (2) for old file
read	(fv,var);
write	(fv,var);

seek	(fv,n);			- seek(fv,filesize(fv)) to end of file
flush	(fv);			- put blk realy to disk;

close	(fv);
erase	(fv);
renam	(fv,string);

eof(fv);
filepos	(fv); 			- where file_ptr is;
filesize(fv);


text-file	logical device		standart-device
-----------	--------------		---------------
write	('your name');
read	(file_name);

readln	(fv);   con:			input
writeln	(fv);   trm:                    output
eoaln	(fv);   kbd:                    con,trm,kbd,lst,aux
		lst:			usr
		aux:
		usr: a.13, b.3.3


blk-block
----------
BlockRead	(fv,blk,no_of_blk_2_read);
BlockWrite	(fv,blk,no_of_blk_2_write);
==================================================================

			  procedures
			--------------
PRoCEDURE (N:number, I:integer, t:txt ; v:array [1..500] of int);

standart proc's :

clreol
clrscr
deline
insline
gotoXY (X,Y)
lowvideo
highvideo
int =	whereX;
int =	whereY;
WINDOW	(x1,y1,x2,y2);

MOVE (FRM_FLD, TO_FLD, LEN);

fillcahr (var, len, value);

if keypressed ...

sound (400);
delay (100);
nosound;

		VAL BASE ON SAME VAL
var
 str: string (80);
 st1: byte ABSOLUTE str;


		 POINTERS
		----------
ptr	= addr (name);
int	= seg  (name);
int	= cseg (name);	- where code start
int	= dseg (name);	- where data start
int	= sseg (name);	- where stack-pointer start
int	= ofs  (var);	- where offset of var

pointer = ptr (cseg,$80);

val :=	mem [0000:$0081];
       	mem [0000:$0081] := val;

	mem + mem = memw;

port (55) = 10;

x = memavail;	- in X 16

chain	(file);		- must be file.chn
execute (file);
	(compiled under h option )

p.115
getmem (p_var,len);	- get memory
---------------------------------------------------------------

		directive
		*********

B+	- IN,OUT TO NORMAL I/O.
C+	- CTRL/C ALLOWED
I+	- I/O ERROR CHECK AFTER EACH I/O. (IOresult)
$i	- include file
(*$I FILENAME *)

R- ***	- index check.
V+	- checks parameter to proc & func.
U-	- interrupts ctrl/c where you want.
K+	- STACK CHECKING.
-------------------------------------------------------
overlay proc....
