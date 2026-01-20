push 0
lhp  /* Class dec List*/
push rest
lhp
sw
lhp
push 1
add
shp
push first
lhp
sw
lhp
push 1
add
shp
push printList
push append
push filter
push quicksort
push -1 /* null */
push 5
lhp
sw
lhp
push 1
add
shp
lhp
sw
lhp
push 1
add
shp
push 9998
lw
lhp
sw
lhp
lhp
push 1
add
shp  /*End New of class List */
push 2
lhp
sw
lhp
push 1
add
shp
lhp
sw
lhp
push 1
add
shp
push 9998
lw
lhp
sw
lhp
lhp
push 1
add
shp  /*End New of class List */
push 3
lhp
sw
lhp
push 1
add
shp
lhp
sw
lhp
push 1
add
shp
push 9998
lw
lhp
sw
lhp
lhp
push 1
add
shp  /*End New of class List */
push 4
lhp
sw
lhp
push 1
add
shp
lhp
sw
lhp
push 1
add
shp
push 9998
lw
lhp
sw
lhp
lhp
push 1
add
shp  /*End New of class List */
push 1
lhp
sw
lhp
push 1
add
shp
lhp
sw
lhp
push 1
add
shp
push 9998
lw
lhp
sw
lhp
lhp
push 1
add
shp  /*End New of class List */
push 2
lhp
sw
lhp
push 1
add
shp
lhp
sw
lhp
push 1
add
shp
push 9998
lw
lhp
sw
lhp
lhp
push 1
add
shp  /*End New of class List */
lfp
lfp
lfp
push -7
add
lw
lfp
stm
ltm
ltm
push -6
add
lw
js  /* End Function Call quicksort */
lfp
stm
ltm
ltm
push -3
add
lw
js  /* End Function Call printList */
halt

first:
cfp
lra
lfp
lw
push -1
add
lw
stm
sra
pop
sfp
ltm
lra
js

rest:
cfp
lra
lfp
lw
push -2
add
lw
stm
sra
pop
sfp
ltm
lra
js

makeList:
cfp
lra
lfp
push 1
add
lw
lfp
push 2
add
lw
lhp
sw
lhp
push 1
add
shp
lhp
sw
lhp
push 1
add
shp
push 9998
lw
lhp
sw
lhp
lhp
push 1
add
shp  /*End New of class List */
stm
sra
pop
pop
pop
sfp
ltm
lra
js

printList:
cfp
lra
push makeList
lfp
push 1
add
lw
push -1 /* null */
beq label2
push 0
b label3
label2:
push 1
label3:
push 1
beq label0
lfp
lfp  /* Class Method Call l.first */
lfp
push 1
add
lw
stm
ltm
ltm
lw
push 0
add
lw
js
print
lfp
lfp  /* Class Method Call l.rest */
lfp
push 1
add
lw
stm
ltm
ltm
lw
push 1
add
lw
js
lfp
lw
stm
ltm
ltm
push -3
add
lw
js  /* End Function Call printList */
lfp
stm
ltm
ltm
push -2
add
lw
js  /* End Function Call makeList */
b label1
label0:
push -1 /* null */
label1:
stm
pop
sra
pop
pop
sfp
ltm
lra
js

append:
cfp
lra
lfp
push 1
add
lw
push -1 /* null */
beq label6
push 0
b label7
label6:
push 1
label7:
push 1
beq label4
lfp
lfp
push 2
add
lw
lfp  /* Class Method Call l1.rest */
lfp
push 1
add
lw
stm
ltm
ltm
lw
push 1
add
lw
js
lfp
lw
stm
ltm
ltm
push -4
add
lw
js  /* End Function Call append */
lfp  /* Class Method Call l1.first */
lfp
push 1
add
lw
stm
ltm
ltm
lw
push 0
add
lw
js
lhp
sw
lhp
push 1
add
shp
lhp
sw
lhp
push 1
add
shp
push 9998
lw
lhp
sw
lhp
lhp
push 1
add
shp  /*End New of class List */
b label5
label4:
lfp
push 2
add
lw
label5:
stm
sra
pop
pop
pop
sfp
ltm
lra
js

accept:
cfp
lra
lfp
lw
push 3
add
lw
push 1
beq label8
lfp
push 1
add
lw
push 0
beq label10
push 0
b label11
label10:
push 1
label11:
b label9
label8:
lfp
push 1
add
lw
label9:
stm
sra
pop
pop
sfp
ltm
lra
js

filter:
cfp
lra
push accept
lfp
push 1
add
lw
push -1 /* null */
beq label14
push 0
b label15
label14:
push 1
label15:
push 1
beq label12
lfp
lfp  /* Class Method Call l.first */
lfp
push 1
add
lw
stm
ltm
ltm
lw
push 0
add
lw
js
lfp
push 2
add
lw
bleq label18
push 0
b label19
label18:
push 1
label19:
lfp
stm
ltm
ltm
push -2
add
lw
js  /* End Function Call accept */
push 1
beq label16
lfp
lfp
push 3
add
lw
lfp
push 2
add
lw
lfp  /* Class Method Call l.rest */
lfp
push 1
add
lw
stm
ltm
ltm
lw
push 1
add
lw
js
lfp
lw
stm
ltm
ltm
push -5
add
lw
js  /* End Function Call filter */
b label17
label16:
lfp
lfp
push 3
add
lw
lfp
push 2
add
lw
lfp  /* Class Method Call l.rest */
lfp
push 1
add
lw
stm
ltm
ltm
lw
push 1
add
lw
js
lfp
lw
stm
ltm
ltm
push -5
add
lw
js  /* End Function Call filter */
lfp  /* Class Method Call l.first */
lfp
push 1
add
lw
stm
ltm
ltm
lw
push 0
add
lw
js
lhp
sw
lhp
push 1
add
shp
lhp
sw
lhp
push 1
add
shp
push 9998
lw
lhp
sw
lhp
lhp
push 1
add
shp  /*End New of class List */
label17:
b label13
label12:
push -1 /* null */
label13:
stm
pop
sra
pop
pop
pop
pop
sfp
ltm
lra
js

quicksort:
cfp
lra
lfp
push 1
add
lw
push -1 /* null */
beq label22
push 0
b label23
label22:
push 1
label23:
push 1
beq label20
lfp  /* Class Method Call l.first */
lfp
push 1
add
lw
stm
ltm
ltm
lw
push 0
add
lw
js
b label21
label20:
push 0
label21:
lfp
push 1
add
lw
push -1 /* null */
beq label26
push 0
b label27
label26:
push 1
label27:
push 1
beq label24
lfp
lfp
lfp
push 0
lfp
push -2
add
lw
lfp  /* Class Method Call l.rest */
lfp
push 1
add
lw
stm
ltm
ltm
lw
push 1
add
lw
js
lfp
lw
stm
ltm
ltm
push -5
add
lw
js  /* End Function Call filter */
lfp
lw
stm
ltm
ltm
push -6
add
lw
js  /* End Function Call quicksort */
lfp
push -2
add
lw
lhp
sw
lhp
push 1
add
shp
lhp
sw
lhp
push 1
add
shp
push 9998
lw
lhp
sw
lhp
lhp
push 1
add
shp  /*End New of class List */
lfp
lfp
push 1
lfp
push -2
add
lw
lfp  /* Class Method Call l.rest */
lfp
push 1
add
lw
stm
ltm
ltm
lw
push 1
add
lw
js
lfp
lw
stm
ltm
ltm
push -5
add
lw
js  /* End Function Call filter */
lfp
lw
stm
ltm
ltm
push -6
add
lw
js  /* End Function Call quicksort */
lfp
lw
stm
ltm
ltm
push -4
add
lw
js  /* End Function Call append */
b label25
label24:
push -1 /* null */
label25:
stm
pop
sra
pop
pop
sfp
ltm
lra
js