	;; code
	LLAC y
	COPY %rD
	LOAD %rA %rD 
	LLAC x
	COPY %rD 
	LOAD %rB %rD 
	ADD %rA %rB 
	COPY %rC 
	SGT %rC %rA 
	COPY %rB 
	LLAC next
	COPY %rD 
	BRIS %rB %rD 
	HALT 
next: 
	SLT  %rC %rA
	COPY %rB
	LLAC next2
	COPY %rD 
	BRIC %rB %rD 
	HALT
next2:
	SA 255
	COPY %rB 
	SA 0
	COPY %rD 
	OR %rB %rD 
	COPY %rB 
	SA 254
	COPY %rD 
	AND %rB %rD 
	COPY %rB 
	NOT %rB
	COPY %rB 
	LLAC z
	COPY %rD 
	STOR %rB %rD 
	SUB %rC %rA 
	COPY %rA 
	SEQ %rA %rB 
	COPY %rC 
	LLAC end
	COPY %rD 
	BRIS %rC %rD
	ADD %rC %rD 
	COPY %rD 
end:
	HALT
;Data
x:	1
y:	5
z:	0
	