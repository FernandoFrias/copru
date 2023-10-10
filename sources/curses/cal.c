#include <stdio.h>
#include <stdlib.h>
int dias[] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
int vmes[] = {0, 3, 3, 6, 1, 4, 6, 2, 5, 0, 3, 5};
char *vdia[7] = {"Domingo", "Lunes", "Martes", "Miercoles", "Jueves", "Viernes", "Sabado"};

//d  l  m  m  j  v  s  d  l  m  m  j  v  s  d  l  m  m  j  v  s  d  l  m  m  j  v  s  d  l  m  m  j  v  s  d  l  m  m  j  v  s
//1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
//                  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30

int yc(int s)
{
	int r = 0;
	switch(s)
	{
/*		case 17:
			r = 4;
			break;
		case 18:
			r = 2;
			break;*/
		case 19:
			r = 0;
			break;
		case 20:
			r = 6;
			break;
/*		case 21:
			r = 4;
			break;
		case 22:
			r = 2;
			break;
		case 23:
			r = 0;
			break;*/
	}
	return r;
}

int bisiesto(int y)
{
    return ((y % 4 == 0 && y % 100 != 0) || y % 400 == 0);
}

char *diaFecha(int y, int m, int d)
{
	char ssyy[5], ss[3], yy[3];
	int ssn, yyn, ad = 0, part;
	sprintf(ssyy, "%4d", y);
	ss[0] = ssyy[0];
	ss[1] = ssyy[1];
	ss[2] = '\0';
	yy[0] = ssyy[2];
	yy[1] = ssyy[3];
	yy[2] = '\0';

	ssn = atoi(ss);
	yyn = atoi(yy);

	int ax = yyn / 4;
	int parta = (yyn + ax) % 7;
	int partb = vmes[m - 1];
	int partc = yc(ssn);

	if(bisiesto(y))
		ad = 1;
	
	part = (parta + partb + partc + d + ad) % 7;

	return (vdia[part]);
}

int main(int argc, char *argv[])
{
	if(argc != 4)
	{
		printf("Uso: calendario ssaa mm dd");
		exit(0);
	}

	int y = atoi(argv[1]);
	int m = atoi(argv[2]);
	int d = atoi(argv[3]);

	if(y < 1900 || y > 2999)
	{
		printf("Año %d erroneo\n", y);
		printf("Uso: calendario ssaa mm dd");
		exit(0);
	}

	if(m < 1 || m > 12)
	{
		printf("Mes %d erroneo\n", m);
		printf("Uso: calendario ssaa mm dd");
		exit(0);
	}

	int td;
	if(bisiesto(y))
		if(m == 2)
			td = 29;
		else
			td = 28;
	else
		td = dias[m];

	if(d < 1 || d > td)
	{
		printf("Dia %d erroneo\n", d);
		printf("Uso: calendario ssaa mm dd");
		exit(0);
	}

	printf("Dia %s\n", diaFecha(y, m, d));

    return 0;
}

