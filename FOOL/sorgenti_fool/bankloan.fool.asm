push 0
lhp  /* Class dec Account*/
push getMon
lhp
sw
lhp
push 1
add
shp
lhp  /* Class dec TradingAcc*/
push getInv
lhp
sw
lhp
push 1
add
shp
push getMon
lhp
sw
lhp
push 1
add
shp
lhp  /* Class dec BankLoan*/
push openLoan
lhp
sw
lhp
push 1
add
shp
push getLoan
lhp
sw
lhp
push 1
add
shp
lhp  /* Class dec MyBankLoan*/
push openLoan
lhp
sw
lhp
push 1
add
shp
push openLoan
lhp
sw
lhp
push 1
add
shp
push getLoan
lhp
sw
lhp
push 1
add
shp
push 40000
push 50000
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
push 9997
lw
lhp
sw
lhp
lhp
push 1
add
shp  /*End New of class TradingAcc */
lhp
sw
lhp
push 1
add
shp
push 9995
lw
lhp
sw
lhp
lhp
push 1
add
shp  /*End New of class MyBankLoan */
push 5000
push 20000
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
push 9997
lw
lhp
sw
lhp
lhp
push 1
add
shp  /*End New of class TradingAcc */
lfp  /* Class Method Call bl.openLoan */
lfp
push -7
add
lw
lfp
push -6
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
push -8
add
lw
push -1 /* null */
beq label10
push 0
b label11
label10:
push 1
label11:
push 1
beq label8
lfp  /* Class Method Call myLoan.getMon */
lfp
push -8
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
b label9
label8:
push 0
label9:
print
halt

getMon:
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

getInv:
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

getLoan:
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

openLoan:
cfp
lra
push 30000
lfp  /* Class Method Call m.getMon */
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
lfp  /* Class Method Call m.getInv */
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
add
bleq label2
push 0
b label3
label2:
push 1
label3:
push 1
beq label0
push -1 /* null */
b label1
label0:
lfp  /* Class Method Call loan.getMon */
lfp
lw
push -1
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
push 9998
lw
lhp
sw
lhp
lhp
push 1
add
shp  /*End New of class Account */
label1:
stm
sra
pop
pop
sfp
ltm
lra
js

openLoan:
cfp
lra
push 20000
lfp  /* Class Method Call l.getMon */
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
bleq label6
push 0
b label7
label6:
push 1
label7:
push 1
beq label4
push -1 /* null */
b label5
label4:
lfp  /* Class Method Call loan.getInv */
lfp
lw
push -1
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
lfp  /* Class Method Call loan.getMon */
lfp
lw
push -1
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
push 9997
lw
lhp
sw
lhp
lhp
push 1
add
shp  /*End New of class TradingAcc */
label5:
stm
sra
pop
pop
sfp
ltm
lra
js