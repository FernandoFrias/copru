#include <ncurses.h>
#include <panel.h>
#include <string.h>
#include <malloc.h>

typedef enum{negro = 0, rojo, verde, amarillo, azul, magenta, cyan, blanco} Color;
typedef enum{uno = 1, dos, tres, cuatro, cinco, seis, siete, ocho, nueve} Orden;

typedef struct ventana{
	PANEL *pid;
	char *nombre;
	int color;
}Ventana;

void establece_borde(WINDOW *w, int color, char *nombre)
{
	wattron(w, COLOR_PAIR(color));
	wborder(w,ACS_VLINE,ACS_VLINE,ACS_HLINE,ACS_HLINE,ACS_ULCORNER,ACS_URCORNER,ACS_LLCORNER,ACS_LRCORNER);
	wattroff(w, COLOR_PAIR(color));
}

void asigna_nombre(Ventana v, char *nombre)
{
	v.nombre = (char *)malloc(strlen(nombre)) + 1;
	strcpy(v.nombre, nombre);
	v.nombre[strlen(nombre)] = '\0';
}

Ventana crea_ventana(Orden orden, char *nombre, int fil, int col, int alto, int ancho, Color color)
{
	Ventana principal;

	principal.pid = new_panel(newwin(alto, ancho, fil, col));
	principal.color = (int)color;
	asigna_nombre(principal, nombre);
	establece_borde(panel_window(principal.pid), color, nombre);

	return principal;
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

	Ventana a = crea_ventana(uno, "amarillo", 2, 0, 22, 80, amarillo);
	Ventana b = crea_ventana(dos, "cyan", 2, 0, 22, 79, cyan);
	Ventana c = crea_ventana(tres, "verde", 2, 0, 22, 78, verde);

//	move_panel(final.pid, 13, 3);

	update_panels();
	doupdate();

	getch();
	endwin();

	return 0;
}

