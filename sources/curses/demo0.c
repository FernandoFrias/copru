#include "tabs.h"

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

int main()
{
	inicio();

	agrega_tab("rojo");
	agrega_tab("verde");
	agrega_tab("amarillo");
	agrega_tab("cyan");
	agrega_tab("magenta");
	agrega_tab("blanco");

//	recorre_tab(9);
	activa_tab(1);
//	activa_primera();
//	activa_ultima();
//	activa_siguiente();
//	activa_anterior();

	int ch;
	while((ch = getch()) != KEY_F(2))
		switch(ch)
		{
			case 9: //tab
				if(activo == titulo)
					activa_siguiente();
				break;
			case 353: //shift + tab
				if(activo == titulo)
					activa_anterior();
				break;
			case 274: //F10
				if(activo == principal)
					activo = titulo;
				else
					activo = principal;
				break;
		}

	endwin();

	return 0;
}

