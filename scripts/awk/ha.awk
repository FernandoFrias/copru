BEGIN{
	RS="\t"
#	A = "Entity"# 1
#	B = "Entity Description"# 2
#	C = "GAAP Financial Statement Line"# 3
#	D = "Account"# 4
#	E = "Account Description"# 5
#	F = "Regulatory Account"# 6
#	G = "Level 2 CUSF Regulatory Account"# 7
#	H = "Level 2 CUSF Regulatory Account Description"# 8
#	I = "Level 2 CUSF Regulatory Account"# 9
#	J = "Level 2 CUSF Regulatory Account Description"# 10
#	K = "Sub Account"# 11
#	L = "Transaction Type"# 12
#	M = "Product Group"# 13
#	N = "Center"# 14
#	O = "Counter Party"# 15
#	P = "Location"# 16
#	Q = "Channel"# 17
#	R = "Customer"# 18
#	S = "User JE Category Name"# 19
#	T = "Journal Name"# 20
#	U = "JE Header ID"# 21
#	V = "Batch ID"# 22
#	W = "Document Sequence Number"# 23
#	X = "Batch Creation Date"# 24
#	Y = "Batch Created By Name"# 25
#	Z = "Batch Created By ID"# 26
#	AA = "Journal Posted Date"# 27
#	AB = "Journal Effective Date"# 28
#	AC = "Journal Posted Status"# 29
#	AD = "Ledger ID"# 30
#	AE = "Ledger Name"# 31
#	AF = "Entered Currency"# 32
#	AG = "Journal Line Number"# 33
#	AH = "Line Description"# 34
#	AI = "Entered Debit Amount"# 35
#	AJ = "Entered Credit Amount"# 36
#	AK = "Entered Amount"# 37
#	AL = "Accounted Debit Amount"# 38
#	AM = "Accounted Credit Amount"# 39
#	AN = "Accounted Amount"# 40
#	AO = "Drill Through Link"# 41
#	AP = "Reference3"# 42
#	AQ = "Reference7"# 43
#	AR = "Reference4"# 44
#	AS = "Reference8"# 45
#	AT = "Reference9"# 46
#	AU = "Journal Source Code"# 47
#	AV = "Journal Description"# 48
#	AW = "Batch Approver ID"# 49
#	AX = "Batch Approver Name"# 50
#	AY = "Accrual Reversal Flag"# 51
#	AZ = "Attribute3"# 52
#	BA = "Attribute2"# 53
#	BB = "Vendor Name"# 54
#	BC = "Attribute1"# 55
#	BD = "Policy Number"# 56
#	BE = "Payment/Receipt Number"# 57
#	BF = "Amount"# 58
#	BG = "RFC Code"# 59
#	BH = "UUID"# 60
#	BI = "Detailed Product"# 61
#	BJ = "Channel"# 62
#	BK = "Customer"# 63

	A  = "Entity"# 1
	B  = "Entity Description"# 2
	C  = "GAAP Financial Statement Line"# 3
	D  = "Account"# 4
	E  = "Account Description"# 5
	F  = "Regulatory Account"# 6
	G  = "CUSF Regulatory Account"# 7
	H  = "CUSF Regulatory Account Description"# 8
	I  = "Level 2 CUSF Regulatory Account"# 9
	J  = "Level 2 CUSF Regulatory Account Description"# 10
	K  = "Sub Account"# 11
	L  = "Transaction Type"# 12
	M  = "Product Group"# 13
	N  = "Center"# 14
	O  = "Counter Party"# 15
	P  = "Location"# 16
	Q  = "Channel"# 17
	R  = "Customer"# 18
	S  = "User JE Category Name"# 19
	T  = "Journal Source Code"# 20
	U  = "Journal Name"# 21
	V  = "JE Header ID"# 22
	W  = "Ledger ID"# 23
	X  = "Ledger Name"# 24
	Y  = "Journal Line Number"# 25
	Z  = "Journal Description"# 26
	AA = "Batch ID"# 27
	AB = "Batch Approver ID"# 28
	AC = "Batch Approver Name"# 29
	AD = "Accrual Reversal Flag"# 30
	AE = "Document Sequence Number"# 31
	AF = "Batch Created By ID"# 32
	AG = "Batch Created By Name"# 33
	AH = "Batch Creation Date"# 34
	AI = "Journal Posted Date"# 35
	AJ = "Journal Effective Date"# 36
	AK = "Journal Posted Status"# 37
	AL = "Line Description"# 38
	AM = "Entered Currency"# 39
	AN = "Attribute1"# 40
	AO = "Attribute2"# 41
	AP = "Attribute3"# 42
	AQ = "Reference3"# 43
	AR = "Reference7"# 44
	AS = "Reference4"# 45
	AT = "Reference8"# 46
	AU = "Reference9"# 47
	AV = "Vendor Name"# 48
	AW = "Policy Number"# 49
	AX = "Payment/Receipt Number"# 50
	AY = "RFC Code"# 51
	AZ = "Amount"# 52
	BA = "UUID"# 53
	BB = "Detailed Product"# 54
	BC = "Channel"# 55
	BD = "Customer"# 56
	BE = "Entered Debit Amount"# 57
	BF = "Entered Credit Amount"# 58
	BG = "Entered Amount"# 59
	BH = "Accounted Debit Amount"# 60
	BI = "Accounted Credit Amount"# 61
	BJ = "Accounted Amount"# 62
	BK = "Drill Through Link"# 63
}

function error(titulo, linea)
{
	printf("Se esperaba \"%s\" en la columna %d dentro del archivo Asientos, se tiene \"%s\"\n", titulo, NR, linea);
	exit 9
}

{
#	if(NR == 01) if(substr($0, 4, 6) != A) error(A, substr($0, 4, 6))
	if(NR == 01) if($0 != A) error(A, $0)
	if(NR == 02) if($0 != B) error(B, $0)
	if(NR == 03) if($0 != C) error(C, $0)
	if(NR == 04) if($0 != D) error(D, $0)
	if(NR == 05) if($0 != E) error(E, $0)
	if(NR == 06) if($0 != F) error(F, $0)
	if(NR == 07) if($0 != G) error(G, $0)
	if(NR == 08) if($0 != H) error(H, $0)
	if(NR == 09) if($0 != I) error(I, $0)
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
	if(NR == 26) if($0 != Z) error(Z, $0)
	if(NR == 27) if($0 != AA) error(AA, $0)
	if(NR == 28) if($0 != AB) error(AB, $0)
	if(NR == 29) if($0 != AC) error(AC, $0)
	if(NR == 30) if($0 != AD) error(AD, $0)
	if(NR == 31) if($0 != AE) error(AE, $0)
	if(NR == 32) if($0 != AF) error(AF, $0)
	if(NR == 33) if($0 != AG) error(AG, $0)
	if(NR == 34) if($0 != AH) error(AH, $0)
	if(NR == 35) if($0 != AI) error(AI, $0)
	if(NR == 36) if($0 != AJ) error(AJ, $0)
	if(NR == 37) if($0 != AK) error(AK, $0)
	if(NR == 38) if($0 != AL) error(AL, $0)
	if(NR == 39) if($0 != AM) error(AM, $0)
	if(NR == 40) if($0 != AN) error(AN, $0)
	if(NR == 41) if($0 != AO) error(AO, $0)
	if(NR == 42) if($0 != AP) error(AP, $0)
	if(NR == 43) if($0 != AQ) error(AQ, $0)
	if(NR == 44) if($0 != AR) error(AR, $0)
	if(NR == 45) if($0 != AS) error(AS, $0)
	if(NR == 46) if($0 != AT) error(AT, $0)
	if(NR == 47) if($0 != AU) error(AU, $0)
	if(NR == 48) if($0 != AV) error(AV, $0)
	if(NR == 49) if($0 != AW) error(AW, $0)
	if(NR == 50) if($0 != AX) error(AX, $0)
	if(NR == 51) if($0 != AY) error(AY, $0)
	if(NR == 52) if($0 != AZ) error(AZ, $0)
	if(NR == 53) if($0 != BA) error(BA, $0)
	if(NR == 54) if($0 != BB) error(BB, $0)
	if(NR == 55) if($0 != BC) error(BC, $0)
	if(NR == 56) if($0 != BD) error(BD, $0)
	if(NR == 57) if($0 != BE) error(BE, $0)
	if(NR == 58) if($0 != BF) error(BF, $0)
	if(NR == 59) if($0 != BG) error(BG, $0)
	if(NR == 60) if($0 != BH) error(BH, $0)
	if(NR == 61) if($0 != BI) error(BI, $0)
	if(NR == 62) if($0 != BJ) error(BJ, $0)
	if(NR == 63) if(substr($0, 1, 18) != BK) error(BK, substr($0, 1, 18)) 
}

