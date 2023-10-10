#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main()
{
	char *nombre = "Fernando";

	int cont = 0;
	printf("longitud = %d\n", strlen(nombre));
	while( !nombre[cont++] )
	{
		printf("mas\n");
	};

	printf("contador = %d\n", cont);
	return 0;
}

