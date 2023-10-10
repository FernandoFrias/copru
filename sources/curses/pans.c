#include <ncurses.h>
#include <string.h>
#include <malloc.h>

typedef enum{negro = 0, rojo, verde, amarillo, azul, magenta, cyan, blanco} Color;

typedef struct ventana{
	WINDOW *id;
	char *nombre;
	int color;
}Ventana;

void cambia_borde(Ventana v, int color)
{
	wattron(v.id, COLOR_PAIR(color));
	wborder(v.id,ACS_VLINE,ACS_VLINE,ACS_HLINE,ACS_HLINE,ACS_ULCORNER,ACS_URCORNER,ACS_LLCORNER,ACS_LRCORNER);
	wattroff(v.id, COLOR_PAIR(color));
}

Ventana crea_ventana(char *nombre, int fil, int col, int alto, int ancho, Color color)
//Ventana crea_ventana(int fil, int col, int alto, int ancho, Color color)
{
	Ventana nueva;

	nueva.nombre = (char *)malloc(strlen(nombre)) + 1;
	strcpy(nueva.nombre, nombre);
//	nueva.nombre[strlen(nombre)] = '\0';

	nueva.id = newwin(alto, ancho, fil, col);
	nueva.color = (int)color;

//	werase(nueva.id);
	cambia_borde(nueva, color);

	return nueva;
}

void elimina_ventana(Ventana v)
{
	free(v.nombre);
	werase(v.id);
	delwin(v.id);
}

void inicio()
{
	initscr();
	cbreak();
	noecho();
	keypad(stdscr, TRUE);
	start_color();

	init_pair(1, COLOR_RED, COLOR_BLACK);
	init_pair(2, COLOR_GREEN, COLOR_BLACK);
	init_pair(3, COLOR_YELLOW, COLOR_BLACK);
	init_pair(4, COLOR_BLUE, COLOR_BLACK);
	init_pair(5, COLOR_MAGENTA, COLOR_BLACK);
	init_pair(6, COLOR_CYAN, COLOR_BLACK);
	init_pair(7, COLOR_WHITE, COLOR_BLACK);
}

int main(int argc, char *argv[])
{
	inicio();

	Ventana inicial = crea_ventana("inicial", 5, 5, 10, 30, rojo);
	Ventana final = crea_ventana("final", 7, 7, 10, 30, azul);

	mvwprintw(inicial.id,1,1,"Estoy en %s", inicial.nombre);
	wrefresh(inicial.id);

	mvwprintw(final.id,1,1,"Estoy en %s", final.nombre);
	wrefresh(final.id);

	elimina_ventana(inicial);
	elimina_ventana(final);

	endwin();

	return 0;
}

