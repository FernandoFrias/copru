#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef enum{no = 0, si} Logico;
typedef enum{entero = 0, alfanumerico1, alfanumerico2, alfabetico, numerico, etiqueta} Tipo;

typedef struct cmp{
	int numero;		// 01 contador de campos
	int num_tipo;	// 02 contador tipo de campo
	int fila;		// 03 numero de fila
	int alto;		// 04 alto
	int columna;	// 05 numero de columna
	int longitud;	// 06 longitud
	Tipo tipo;		// 07 tipo de campo:
                    //    - entero            0
                    //    - alfanumerico1 (*) 1
                    //    - alfanumerico2 (X) 2
                    //    - alfabetico    (#) 3
                    //    - numerico          4
                    //    - etiqueta          5
	Logico signado;	// 08 signado
	int decimales;	// 09 decimales
	char *leyenda;	// 10 etiqueta
}Campo;

typedef struct pnt{
	char *nombre;	// 1 nombre
	int total;		// 2 total
	Campo *campos;	// 3 campos
}Pantalla;

Campo crea_campo(char *linea)
{
	int numfld, cont, numline, numcol, lng, tipo, signado, decs;
	Campo nuevo;

	sscanf(linea, "%02d,%02d,%02d,%02d,%02d,%1d,%1d,%1d\n", &numfld, &cont, &numline, &numcol, &lng, &tipo, &signado, &decs);

	nuevo.numero	= numfld;
	nuevo.num_tipo	= cont;
	nuevo.fila		= numline;
	nuevo.columna	= numcol;
	nuevo.longitud	= lng;
	nuevo.tipo		= tipo;
	nuevo.signado	= signado;
	nuevo.decimales	= decs;
	nuevo.leyenda	= malloc(sizeof(char) * (lng + 1));

	for(int c = 0; c < lng; c++)
		nuevo.leyenda[c] = linea[21 + c];
	nuevo.leyenda[lng] = '\0';

	return nuevo;
}

void valida_argumentos(int argc, char *argv[])
{
	char ext[] = ".dat";

	if (argc != 2)
	{
		printf("Uso: %s file.dat", argv[0]);
		exit(1);
	}

	Logico encontrado = si;
	for (int c = 0; c < 4; c++)
		if (argv[1][(strlen(argv[1]) - 4) + c] != ext[c])
		{
			encontrado = no;
			break;
		}

	if (encontrado == no)
	{
		printf("nombre de archivo %s incorrecto\n", argv[1]);
		exit(1);
	}
}

char *crea_nombre(char nom[])
{
	int tlen = strlen(nom);
	char *nm = malloc(sizeof(char) * (tlen + 1));
	for(int c = 0; c < tlen; c++)
		nm[c] = nom[c];
	nm[strlen(nom)] = '\0';

	return nm;
}

Campo *genera_campos(char *nomarch, int *t)
{
	char linea[BUFSIZ];
	FILE *file = fopen(nomarch, "r");
	int totcampos = 0;
	Campo *cmps = NULL;

	if(!file)
	{
		printf("Error al abrir el archivo %s", nomarch);
		exit(1);
	}

	while(fgets(linea, BUFSIZ, file) != NULL)
	{
		cmps = (Campo *)realloc(cmps, sizeof(Campo) * (totcampos + 1));
		cmps[totcampos] = crea_campo(linea);
		totcampos += 1;
	}
	fclose(file);

	*t = totcampos;

	return cmps;
}

void imprime_campo(Campo campo)
{
	printf("%02d,%02d,%02d,%02d,%02d,%1d,%1d,%1d,%s\n", campo.numero, campo.num_tipo, campo.fila, campo.columna, campo.longitud, campo.tipo, campo.signado, campo.decimales, campo.leyenda);
}

void imprime_campos_pantalla(Pantalla p)
{
	for (int c = 0; c < p.total; c++)
		imprime_campo(p.campos[c]);
}

Pantalla genera_pantalla(char *nombre)
{
	int t = 0;
	Pantalla p;

	p.nombre = crea_nombre(nombre);
	p.campos = genera_campos(nombre, &t);
	p.total = t;

	return p;
}

int main(int argc, char *argv[])
{
	valida_argumentos(argc, argv);

	Pantalla inicial = genera_pantalla(argv[1]);

	imprime_campos_pantalla(inicial);
}

