def up = [up]
def down = [down]
def left = [left]
def right = [right]
def pgup = [page up]
def pgdn = [page down]
def home = [begin line]
def end = [end line]
def ins = [insert toggle]
def del = [delete char]
def enter = [begin line] [down]
def backspace = [rubout]
def esc = [command toggle]
def tab = [tab]
def s-tab = [backtab]
def c-left = [backtab word]
def c-right = [tab word]
def c-pgup = [top edge]
def c-pgdn = [bottom edge]
def c-home = [top] [begin line]
def c-end = [bottom] [begin line]
def c-enter = [execute]
def c-backspace = [delete line]
def f1 = [cursor command] [begin line] [erase end line] 'edit A:'
def f2 = [cursor command] [begin line] [erase end line] 'save' [execute] [command toggle]
def f3 =
def f4 =
def f5 = [cursor command] [begin line] [erase end line] 'quit '
def f6 = [erase end line]
def f7 = [cursor command] [begin line] [erase end line] 'print '
def f8 = [cursor command] [begin line] [erase end line] 'e' [execute] [command toggle]
def f9 = [insert line]
def f10 = [cursor command] [begin line] [erase end line] 'dir A:*.*' [execute] [begin line] [erase end line] '? diskspace A:' [execute]
def c-f1 =
def c-f2 = [cursor command] [begin line] [erase end line] 'edit PE.PRO' [execute] [command toggle]
def c-f3 =
def c-f4 =
def c-f5 =
def c-f6 = [cursor command] [begin line] [erase end line] 'macro PE.PRO' [execute] [command toggle]
def c-f7 = [cursor command] [begin line] [erase end line] 'edit PE.HLP' [execute] [command toggle]
def c-f8 =
def c-f9 =
def c-f10 =
def a-f1 = [cursor command] [begin line] [erase end line] 'set display b/w 80'
def a-f2 = [cursor command] [begin line] [erase end line] 'set display color 80'
def a-f3 = [cursor command] [begin line] [erase end line] 'set display mono'
def a-f4 =
def a-f5 = '1234567890'
def a-f6 = [mark block] [tab word] [mark block] [begin mark] [delete mark]
def a-f7 = [shift left]
def a-f8 = [shift right]
def a-f9 = [cursor command] [begin line] [erase end line] 'dir B:*.*' [execute] [begin line] [erase end line] '? diskspace B:' [execute]
def a-f10 = [cursor command] [begin line] [erase end line] 'dir C:*.*' [execute] [begin line] [erase end line] '? diskspace C:' [execute]
def s-f1 = '�'
def s-f2 = '�'
def s-f3 = '�'
def s-f4 = '�'
def s-f5 = '�'
def s-f6 = '�'
def s-f7 = '�'
def s-f8 = '�'
def s-f9 = '�'
def s-f10 = '�'
def a-a =
def a-b =
def a-c =
def a-d =
def a-e =
def a-f =
def a-g =
def a-h =
def a-i =
def a-j =
def a-k =
def a-l =
def a-m =
def a-n =
def a-o =
def a-p =
def a-q =
def a-r =
def a-s =
def a-t =
def a-u =
def a-v =
def a-w =
def a-x =
def a-y =
def a-z =
def c-a =
def c-b = [mark block]
def c-c = [copy mark]
def c-d = [delete mark]
def c-e =
def c-f = [fill mark]
def c-g = [dos]
def c-h = [copy from command]
def c-i = [set margins 1 80 1] [push mark] [mark line] [center in margins] [unmark] [pop mark] [set margins 1 254 1]
def c-j = [join]
def c-k =
def c-l = [mark line]
def c-m = [move mark]
def c-n =
def c-o = [overlay block]
def c-p = [print mark]
def c-q = [unmark] [backtab word] [left] [mark char] [end word] [mark char] [begin mark]
def c-r = [redraw]
def c-s = [split]
def c-t = [copy to command]
def c-u = [unmark]
def c-v = [undo]
def c-w = [unmark] [right] [tab word] [mark char] [end word] [right] [mark char] [begin mark]
def c-x =
def c-y = [begin line] [tab word] [tab word] [tab word] [mark block] [tab word] [tab word] [tab word] [left] [left] [mark block] [down] [insert line] [right 7] '01 ' [copy mark] [tab word] [rubout] [tab word] [rubout] [rubout] [end line] '.' [unmark]
def c-z = [zoom window]
def a-minus = [split screen]
def a-equals = [next window]
def a-1 = [027] [056]
def a-2 = [027] [060]
def a-3 = ''
def a-4 = [027] [084]
def a-5 = [020]
def a-6 = [018]
def a-7 = [027] [045] [000]
def a-8 = [027] [070]
def a-9 = [027] [072]
def a-0 = [024]
def s-end = [027] [051] [014] [015]
def s-down = [027] [051] [007] [027] [083] [000] [015]
def s-pgdn = [027] [083] [001]
def s-left = [027] [083] [000]
def s-pad5 = [014]
def s-right = [015]
def s-home = [027] [045] [001]
def s-up = [027] [069]
def s-pgup = [027] [070]
def s-ins = [027] [051] [018]
def s-del = ''
set tabs 8 13 20 30 40 50 60 70 80 90 100 120 140 160 180 200 220 240 250 255
set margins 1 254 1
set display mono
set display b/w 80
