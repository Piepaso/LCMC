push 3
push 4
beq label2
push 0
b label3
label2:
push 1
label3:
push 1
beq label0
push 6
print
b label1
label0:
push 5
print
label1:
halt

push 3
push 4
bleq label3
b label4
label3:
beq label4
push 0
b label2
label4:
push 1
label2:
push 1
beq label0
push 6
print
b label1
label0:
push 5
print
label1:
halt