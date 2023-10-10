#ifndef __panel_h__
#define __panel_h__
#include <ncurses.h>
#include <stdio.h>
#include <stdlib.h>
#include <malloc.h>
#include <string.h>
#include <panel.h>
#define AT 2 //lineas del panel titulo
#define INI 1
#define FIN 1
#define FILAS 24
#define COLUMNAS 80
#define TIPO 1
#define CSIACT blanco
#define CNOACT azul

typedef enum{negro = 0, rojo, verde, amarillo, azul, magenta, cyan, blanco} Color;

typedef enum{si = 0, no} Logico;

typedef enum{titulo = 0, principal} Activo;

typedef struct ptab{
	PANEL *titulo;
	PANEL *principal;
	char *nombre;
	int numero;
	int tini;
	int tfin;
	struct ptab *siguiente;
	struct ptab *anterior;
}pTab;

pTab *primera = NULL;
pTab *ultima = NULL;
pTab *actual = NULL;
Activo activo = principal;

void posiciones(int *a, int *b, char *nombre)
{
	pTab *auxiliar = NULL;
	if(actual == primera)
		*a = 0;
	else
		*a = ultima->anterior->tfin + 1;
	*b = *a + strlen(nombre) + 1;
}

void crea_borde_titulo(pTab *t, Color color)
{
	int mx, my;
	WINDOW *w = panel_window(t->titulo);
	getmaxyx(w, my, mx);
	wattron(w, COLOR_PAIR(color));

	mvwaddch(w, 0, 0, ACS_ULCORNER);					//esquina superior izquierda
	mvwaddch(w, 0, mx - 1, ACS_URCORNER);				//esquina superior derecha
	mvwhline(w, 0, 1, ACS_HLINE, strlen(t->nombre));	//linea horizontal superior 
	mvwhline(w, 1, 0, ACS_VLINE, AT - 1);				//linea vertical izquierda 
	mvwhline(w, 1, mx - 1, ACS_VLINE, AT - 1);			//linea vertical derecha

	mvwprintw(w, 1, 1, "%s", t->nombre);
	wattroff(w, COLOR_PAIR(color));
}

void crea_borde_principal(pTab *t, Color color)
{
	WINDOW *w = panel_window(t->principal);
	wattron(w, COLOR_PAIR(color));
	if(TIPO == 0)
	{
		wborder(w,ACS_VLINE,ACS_VLINE,ACS_HLINE,ACS_HLINE,ACS_ULCORNER,ACS_URCORNER,ACS_LLCORNER,ACS_LRCORNER);

		if(t == primera)
			mvwaddch(w, 0, t->tini, ACS_LTEE);
		else
			mvwaddch(w, 0, t->tini, ACS_BTEE);
		mvwaddch(w, 0, t->tfin, ACS_BTEE);
	}
	else
	{
		int px, py;
		getmaxyx(panel_window(t->principal), py, px);
		if(t == primera)
			mvwaddch(w, 0, 0, ACS_VLINE);			//esquina superior izquierda
		else
			mvwaddch(w, 0, 0, ACS_ULCORNER);		//esquina superior izquierda
		mvwaddch(w, 0, px - 1, ACS_URCORNER);		//esquina superior derecha
		mvwaddch(w, py - 1, 0, ACS_LLCORNER);		//esquina inferior izquierda
		mvwaddch(w, py - 1, px - 1, ACS_LRCORNER);	//esquina inferior derecha

		mvwhline(w, 0, t->tfin + 1, ACS_HLINE, px - t->tfin - 2);	//linea horizontal superior(a) 
		mvwhline(w, 0, 1, ACS_HLINE, t->tini - 1);					//linea horizontal superior(a) 
		if(t == primera)
			mvwaddch(w, 0, t->tini, ACS_VLINE);		//esquina inferior derecha
		else
			mvwaddch(w, 0, t->tini, ACS_LRCORNER);	//esquina inferior derecha
		mvwaddch(w, 0, t->tfin, ACS_LLCORNER);		//esquina inferior izquierda

		mvwhline(w, py - 1, 1, ACS_HLINE, px - 2);	//linea horizontal inferior 
		mvwvline(w, 1, 0, ACS_VLINE, py - 2);		//linea vertical izquierda 
		mvwvline(w, 1, px - 1, ACS_VLINE, py - 2);	//linea vertical derecha 
	}

	wattroff(w, COLOR_PAIR(color));
}

void crea_paneles(pTab *ptab, Color color)
{
	int alto_titulo = AT;
	int ancho_titulo = ptab->tfin - ptab->tini + 1;
	ptab->titulo = new_panel(newwin(alto_titulo, ancho_titulo, INI - 1, ptab->tini));
	crea_borde_titulo(ptab, color);

	ptab->principal = new_panel(newwin(FILAS - AT, COLUMNAS, INI - 1 + AT, FIN - 1));
	crea_borde_principal(ptab, color);
}

void crea_tab(pTab *nueva, char *nombre)
{
	int ini = 0, fin = 0;
	
	nueva->nombre = nombre;
	posiciones(&ini, &fin, nueva->nombre);
	nueva->tini = ini;
	nueva->tfin = fin;
	crea_paneles(nueva, CNOACT);
}

void actualiza_panel()
{
	update_panels();
	doupdate();
}

void desactiva_paneles_excepto(pTab *tab)
{
	pTab *auxiliar = primera;

	do
	{
		if(auxiliar->numero != tab->numero)
		{
			crea_borde_titulo(tab, CNOACT);
			crea_borde_principal(tab, CNOACT);
		}
		auxiliar = auxiliar->siguiente;
	}while(auxiliar != ultima);
}

void activa_panel(pTab *tab)
{
	top_panel(tab->titulo);
	top_panel(tab->principal);
	actual = tab;
//
	pTab *auxiliar = primera;
	do
	{
		if(auxiliar == actual)
		{
			crea_borde_titulo(auxiliar, CSIACT);
			crea_borde_principal(auxiliar, CSIACT);
		}
		else
			crea_borde_titulo(auxiliar, CNOACT);
		auxiliar = auxiliar->siguiente;
	}while(auxiliar != primera);
//
	actualiza_panel();
}

void recorre_tab(int num)
{
	pTab *auxiliar = primera;

	for(int contador = 0; contador < num - 1; contador++)
		auxiliar = auxiliar->siguiente;

	activa_panel(auxiliar);
}

void activa_tab(int num)
{
	pTab *auxiliar = primera;

	while(auxiliar != ultima)
		if(auxiliar->numero == num)
			break;
		else
			auxiliar = auxiliar->siguiente;

	activa_panel(auxiliar);
}

void activa_primera()
{
	pTab *auxiliar = primera;
	activa_panel(auxiliar);
}

void activa_ultima()
{
	pTab *auxiliar = ultima;
	activa_panel(auxiliar);
}

void activa_siguiente()
{
	actual = actual->siguiente;
	activa_panel(actual);
}

void activa_anterior()
{
	actual = actual->anterior;
	activa_panel(actual);
}

void agrega_tab(char *nombre)
{
	pTab *nueva = malloc(sizeof(pTab));

	if(actual == NULL)
	{
		nueva->siguiente = nueva;
		nueva->anterior = nueva;
		primera = nueva;
		ultima = nueva;
		actual = nueva;
		nueva->numero = 1;
	}
	else
	{
		nueva->numero = ultima->numero + 1;
		nueva->siguiente = primera;
		nueva->anterior = actual;
		actual->siguiente = nueva;
		actual = nueva;
		ultima = nueva;
		primera->anterior = ultima;
	}

	int ln = strlen(nombre);
	int t = ln + 3;
	char *nomaux = malloc(sizeof(char) * t);
	nomaux[0] = ' ';
	for(int c = 0; c < ln; c++)
		nomaux[c + 1] = nombre[c];
	nomaux[ln + 1] = ' ';
	nomaux[ln + 2] = '\0';

	crea_tab(nueva, nomaux);
}

#endif
