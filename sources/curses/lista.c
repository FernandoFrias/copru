#include <stdio.h>
#include <stdlib.h>
#include <malloc.h>
#include <string.h>

typedef struct nodo
{
	int dato;
	struct nodo *siguiente;
	struct nodo *anterior;
}Nodo;

Nodo *primero = NULL;
Nodo *ultimo = NULL;
Nodo *actual = NULL;

void agrega_nodo(int dato)
{
	Nodo *nuevo = malloc(sizeof(Nodo));
	nuevo->dato = dato;

	if(actual == NULL)
	{
		nuevo->siguiente = nuevo;
		nuevo->anterior = nuevo;
		primero = nuevo;
		ultimo = nuevo;
		actual = nuevo;
	}
	else
	{
		nuevo->siguiente = primero;
		nuevo->anterior = actual;
		actual->siguiente = nuevo;
		actual = nuevo;
		ultimo = nuevo;
		primero->anterior = ultimo;
	}
}

int anterior(Nodo *n)
{
	return n->anterior->dato;
}

int siguiente(Nodo *n)
{
	return n->siguiente->dato;
}

void recorre_adelante(Nodo *inicial, char *nom)
{
	Nodo *aux = inicial;
	int cont = 0;
	printf("\n%s\n  adelante -> ", nom);
	while(cont < 13)
	{
		printf("%d ", aux->dato);
		aux = aux->siguiente;
		++cont;
	};
	printf("\n");
}

void recorre_atras(Nodo *inicial, char *nom)
{
	Nodo *aux = inicial;
	int cont = 0;
	printf("\n%s\n  atras    <- ", nom);
	while(cont < 13)
	{
		printf("%d ", aux->dato);
		aux = aux->anterior;
		++cont;
	};
	printf("\n");
}

int main()
{
	agrega_nodo(1);
	agrega_nodo(2);
	agrega_nodo(3);
	agrega_nodo(4);
	agrega_nodo(5);

	recorre_adelante(primero, "primero");
	recorre_atras(primero, "primero");

	recorre_adelante(actual, "actual");
	recorre_atras(actual, "actual");

	recorre_adelante(ultimo, "ultimo");
	recorre_atras(ultimo, "ultimo");

	char *cadena = "Fernando";
	char *nom = NULL;
	int contador = 0;

	while(cadena[contador])
	{
		nom = (char *)realloc(nom, sizeof(char) * (contador + 1));
		nom[contador] = cadena[contador];
		++contador;
	}
	nom = (char *)realloc(nom, sizeof(char) * (contador + 1));
	nom[contador] = '\0';

	printf("largo = %d\n", contador);
	printf("largo 1 = %d\n", strlen(nom));
	printf("sf = %d\n", sizeof(cadena));
	printf("sfx = %d\n", sizeof(nom));

	return 0;
}

