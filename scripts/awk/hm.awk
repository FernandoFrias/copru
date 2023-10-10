BEGIN{
	RS="\t"
	A = "Oracle Account" # 1
	B = "Oracle Subaccount" # 2
	C = "Key" # 3
	D = "STAT" # 4
	E = "STAT NAME" # 5
	F = "NEW ACCOUNT CUSF" # 6
	G = "NEW NAME CUSF" # 7
}

function error(titulo, linea)
{
	printf("Se esperaba \"%s\" en la columna %d dentro del archivo Mapeo, se tiene \"%s\"\n", titulo, NR, linea);
	exit 9
}

{
#	if(NR == 01) if(substr($0, 1, 14) != A) error(A, substr($0, 1, 14))
	if(NR == 01) if($0 != A) error(A, $0)
	if(NR == 02) if($0 != B) error(B, $0)
	if(NR == 03) if($0 != C) error(C, $0)
	if(NR == 04) if($0 != D) error(D, $0)
	if(NR == 05) if($0 != E) error(E, $0)
	if(NR == 06) if($0 != F) error(F, $0)
	if(NR == 07) if(substr($0, 1, 13) != G) error(G, substr($0, 1, 13)) 
}

