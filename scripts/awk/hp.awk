BEGIN{
	RS="\t"
	A = "Entity"
	B = "Account"# 2
	C = "Sub Account"# 3
	D = "Transaction Type"# 4
	E = "Currency Code"# 5
	F = "Regulatory Account"# 6
	G = "Regulatory Account Description"# 7
	H = "Level 3 Regulatory Account"# 8
	I = "Level 3 Regulatory Account Description"# 9
	J = "Level 2 Regulatory Account"# 10
	K = "Level 2 Regulatory Account Description"# 11
	L = "Level 1 Regulatory Account"# 12
	M = "Level 1 Regulatory Account Description"# 13
	N = "Level 2 CUSF Regulatory Account"# 14
	O = "Level 2 CUSF Regulatory Account Description"# 15
	P = "CUSF Regulatory Account"# 16
	Q = "CUSF Regulatory Account Description"# 17
	R = "Period From"# 18
	S = "Period To"# 19
	T = "Year"# 20
	U = "Ledger ID"# 21
	V = "Ledger Name"# 22
	W = "Beginning Balance Amount"# 23
	X = "Current Period Debit"# 24
	Y = "Current Period Credit"# 25
	Z = "Ending Balance"# 26
}

function error(titulo, linea)
{
	printf("Se esperaba \"%s\" en la columna %d dentro del archivo Pesos, se tiene \"%s\"\n", titulo, NR, linea);
	exit 9
}

{
#	if(NR == 1) if(substr($0, 1, 6) != "Entit") error(A, substr($0, 1, 6))
	if(NR == 1) if($0 != A) error(A, $0)
	if(NR == 2) if($0 != B) error(B, $0)
  	if(NR == 3) if($0 != C) error(C, $0)
  	if(NR == 4) if($0 != D) error(D, $0)
  	if(NR == 5) if($0 != E) error(E, $0)
  	if(NR == 6) if($0 != F) error(F, $0)
  	if(NR == 7) if($0 != G) error(G, $0)
  	if(NR == 8) if($0 != H) error(H, $0)
  	if(NR == 9) if($0 != I) error(I, $0)
  	if(NR == 10) if($0 != J) error(J, $0)
  	if(NR == 11) if($0 != K) error(K, $0)
  	if(NR == 12) if($0 != L) error(L, $0)
  	if(NR == 13) if($0 != M) error(M, $0)
  	if(NR == 14) if($0 != N) error(N, $0)
  	if(NR == 15) if($0 != O) error(O, $0)
  	if(NR == 16) if($0 != P) error(P, $0)
  	if(NR == 17) if($0 != Q) error(Q, $0)
  	if(NR == 18) if($0 != R) error(R, $0)
  	if(NR == 19) if($0 != S) error(S, $0)
  	if(NR == 20) if($0 != T) error(T, $0)
  	if(NR == 21) if($0 != U) error(U, $0)
  	if(NR == 22) if($0 != V) error(V, $0)
  	if(NR == 23) if($0 != W) error(W, $0)
  	if(NR == 24) if($0 != X) error(X, $0)
  	if(NR == 25) if($0 != Y) error(Y, $0)
  	if(NR == 26) if(substr($0, 1, 14) != Z) error(Z, substr($0, 1, 14))
}

END{
}

