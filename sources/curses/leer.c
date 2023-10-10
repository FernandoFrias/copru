#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef enum{no = 0, si} Logico;
//typedef enum{entero = 0, alfanumerico, alfabetico, numerico, etiqueta} Tipo;
typedef enum{espacio = -1, entero, alfanumerico, alfabetico, numerico, etiqueta} Tipo;

typedef struct pos{
	int fila;
	int inicio;
	int final;
	int longitud;
}Posicion;

typedef struct cmp{
	int numero;
	Tipo tipo;
	Posicion pos;
	char *leyenda;
	Logico signado;
	int decimales;
}Campo;

Logico compara(char a, char b)
{
	if((a == ' ' && b == ' ') || (a != ' ' && b != ' '))
		return si;
	else
		return no;
}

Logico numero_correcto(char *cadena, int ini, int fin, Logico *s, int *d)
{
	char caracter;
	int digitos = 0;
	int signos = 0;
	int puntos = 0;
	int otros = 0, c = 0;
	Logico respuesta = si;

	for(int contador = ini; contador <= fin; contador++)
	{
		caracter = cadena[contador];
		switch(caracter)
		{
			case '0' ... '9':
				++digitos;
				break;
			case '-':
			case '+':
				++signos;
				break;
			case '.':
				++puntos;
				break;
			default:
				++otros;
				break;
		}
	}

	if(otros > 0)
		respuesta = no;
	else
		if(signos > 1)
			respuesta = no;
		else
			if(signos == 1 && (cadena[ini] != '-' && cadena[ini] != '+'))
				respuesta = no;
			else
				if(puntos > 1)
					respuesta = no;
				else
					if(puntos == 1 && (cadena[ini] == '.' || cadena[fin] == '.'))
						respuesta = no;

	if(respuesta == si)
	{
		if(signos == 1)
			*s = si;
		else
			*s = no;
		if(puntos == 0)
			*d = 0;
		else
		{
			for(c = fin; c >= ini; c--)
				if(cadena[c] == '.')
					break;
			*d = fin - c;
		}
	}

	return respuesta;
}

Campo crea_campo(char *cadena, Tipo tipo, int linea, int ini, int fin)
{
	int dec, tot = (fin - ini) + 1, p = 0;
	Logico sig;
	Campo nuevo;

	nuevo.pos.fila = linea;
	nuevo.pos.inicio = ini;
	nuevo.pos.final = fin;
	nuevo.pos.longitud = tot;

	if(tipo == etiqueta)
	{
		nuevo.leyenda = malloc(sizeof(char) * (tot + 1));
		for(int c = ini; c <= fin; c++)
			nuevo.leyenda[p++] = cadena[c];
		nuevo.leyenda[tot] = '\0';
		nuevo.tipo = tipo;
		nuevo.signado = no;
		nuevo.decimales = 0;
	}
	else
		if(tipo == numerico)
			if(numero_correcto(cadena, ini, fin, &sig, &dec) == si)
			{
				nuevo.signado = sig;
				nuevo.decimales = dec;
				if(nuevo.decimales > 0)
					nuevo.tipo = numerico;
				else
					nuevo.tipo = entero;
			}
			else
			{
				printf("numero erroneo:");
				for(int c = ini; c <= fin; c++)
					printf("%c", cadena[c]);
				printf("\n");
				exit(1);
			}
		else
		{
			nuevo.tipo = tipo;
			nuevo.signado = no;
			nuevo.decimales = 0;
		}

	return nuevo;
}

void imprime_campo(Campo campo)
{
	if(campo.tipo == etiqueta)
	{
		printf("numero = %d\n", campo.numero);
		printf("    leyenda = %s\n", campo.leyenda);
		printf("    posicion = %02d,%02d,%02d,%02d\n", campo.pos.fila, campo.pos.inicio, campo.pos.final, campo.pos.longitud);
	}
	else
	{
		printf("numero = %d\n", campo.numero);
		printf("    posicion = %02d,%02d,%02d,%02d\n", campo.pos.fila, campo.pos.inicio, campo.pos.final, campo.pos.longitud);
		printf("    signado = %d\n", campo.signado);
		printf("    decimales = %d\n", campo.decimales);
	}
}

Tipo define_tipo(char caracter)
{
	Tipo tipo;
	switch(caracter)
	{
		case '#': // Alfabetico
			tipo = alfabetico;
			break;
		case '*': // Alfanumerico
			tipo = alfanumerico;
			break;
		case '.':
		case '-':
		case '+':
		case '9': // Numerico o Entero
			tipo = numerico;
			break;
		case ' ':
			tipo = espacio;
			break;
		default: // Etiqueta
			tipo = etiqueta;
			break;
	}

	return tipo;
}

void analiza_renglon(char *renglon, int numlinea, Campo *campos, int *totcampos)
{
	char actual, anterior;
	int contador = 0;
	int ini = 0;
	int fin = 0;
	Tipo tipo;
	Logico igual;

	actual = renglon[contador];
	anterior = actual;
	while(contador < strlen(renglon))
	{
		igual = compara(anterior, actual);
		ini = contador;
		while(igual == si && contador < strlen(renglon))
		{
			actual = renglon[++contador];
			igual = compara(anterior, actual);
		};
		fin = contador;

		tipo = define_tipo(renglon[contador - 1]);
		if(tipo != espacio)
		{
			campos = (Campo *)realloc(campos, sizeof(Campo) * (*totcampos + 1));
			campos[*totcampos] = crea_campo(renglon, tipo, numlinea, ini, fin - 1);
			campos[*totcampos].numero = *totcampos + 1;
			imprime_campo(campos[*totcampos]);
			*totcampos = *totcampos + 1;
		}
			
		anterior = actual;
	};
}

int main()
{
	char linea[BUFSIZ], *renglon = NULL, nomarch[] = "pantalla.txt";
	FILE *file = fopen(nomarch, "r");
	int maxline, contador = 0, totcampos = 0;
	Campo *campos = NULL;

	if(!file)
		exit(1);

	while(fgets(linea, BUFSIZ, file) != NULL)
	{
		maxline = strlen(linea);
		renglon = malloc(sizeof(char) * maxline);
		strncpy(renglon, linea, maxline - 1);
		renglon[maxline] = '\0';

		analiza_renglon(renglon, contador++, campos, &totcampos);

		renglon = NULL;
	}

//	imprime_campo(campos[3]);

	fclose(file);
}

