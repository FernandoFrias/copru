#include <ncurses.h>

WINDOW *create_newwin(int height, int width, int starty, int startx);
void destroy_win(WINDOW *local_win);

int main(int argc, char *argv[])
{
	WINDOW *my_win;
	int startx, starty, width, height;
	int ch;

	initscr(); /* Start curses mode */
	cbreak(); /* Line buffering disabled, Pass on * everty thing to me */
	noecho(); /* Line buffering disabled, Pass on * everty thing to me */
	keypad(stdscr, TRUE); /* I need that nifty F2 */

	height = 24;
	width = 80;
	starty = (LINES - height) / 2; /* Calculating for a center placement */
	startx = (COLS - width) / 2; /* of the window */

	printw("Press F2 to exit, lineas = %d, columnas = %d", LINES, COLS);
	refresh();
	my_win = create_newwin(height, width, starty, startx);

	while((ch = getch()) != KEY_F(2))
	{
		switch(ch)
		{
			case KEY_LEFT:
				destroy_win(my_win);
				my_win = create_newwin(height, width, starty,--startx);
				break;
			case KEY_RIGHT:
				destroy_win(my_win);
				my_win = create_newwin(height, width, starty,++startx);
				break;
			case KEY_UP:
				destroy_win(my_win);
				my_win = create_newwin(height, width, --starty,startx);
				break;
			case KEY_DOWN:
				destroy_win(my_win);
				my_win = create_newwin(height, width, ++starty,startx);
				break;
		}
	}

	werase(my_win);
	destroy_win(my_win);
	erase();
	endwin(); /* End curses mode */
	printf("\e[1;1H\e[2J");
	return 0;

}

WINDOW *create_newwin(int height, int width, int starty, int startx)
{
	WINDOW *local_win;
	local_win = newwin(height, width, starty, startx);
	box(local_win, 0 , 0);  /*0, 0 gives default characters
	* for the vertical and horizontal
	* * lines */
/*	wborder(local_win,ACS_VLINE,ACS_VLINE,ACS_HLINE,ACS_HLINE,ACS_ULCORNER,ACS_URCORNER,ACS_LLCORNER,ACS_LRCORNER);*/
	mvwprintw(local_win, 1, 1, "Estoy en: %d, %d", starty, startx);
	wrefresh(local_win); /* Show that box */
	return local_win;
}

void destroy_win(WINDOW *local_win)
{
	/* box(local_win, ' ', ' '); : This won't produce the desired
	 * * result of erasing the window. It will leave it's four corners
	 * * and so an ugly remnant of window.
	 * */
/*	wborder(local_win, ' ', ' ', ' ',' ',' ',' ',' ',' ');*/
	werase(local_win);
	/* The parameters taken are
	 * * 1. win: the window on which to operate
	 * * 2. ls: character to be used for the left side of the window
	 * * 3. rs: character to be used for the right side of the window
	 * * 4. ts: character to be used for the top side of the window
	 * * 5. bs: character to be used for the bottom side of the window
	 * * 6. tl: character to be used for the top left corner of the window
	 * * 7. tr: character to be used for the top right corner of the window
	 * * 8. bl: character to be used for the bottom left corner of the window
	 * * 9. br: character to be used for the bottom right corner of the window
	 * */
	wrefresh(local_win);
	delwin(local_win);
}

