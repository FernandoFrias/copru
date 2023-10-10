#include <ncurses.h>
#include <string.h>

int main()
{
	char *nombre = "Hola";
	int limites[2];
	initscr();
	mvprintw(1, 0, "l = %d", strlen(nombre));
	refresh();
	getch();
	endwin();

	return 0;
}

