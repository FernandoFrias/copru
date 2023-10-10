#include <ncurses.h>

int main()
{
	int ch, f, c;

	initscr();
	raw();
	keypad(stdscr, TRUE);
	noecho();

	printw("Teclea un caracter...");
	ch = getch();

	if(ch == KEY_F(2))
		printw("Tecleaste F2");
	else
	{
		printw("\nTecleaste el caracter ");
		attron(A_BOLD);
		printw("%c(%d), (%s)", ch, ch, keyname(ch));
		addch(ch|A_UNDERLINE);
		attroff(A_BOLD);
	}

	mvaddch(5, 5, 'H');

	getmaxyx(stdscr, f, c);
	printw("Fila = %d, Columnas = %d\n", f, c);

	refresh();
	getch();
	endwin();

	return 0;
}

