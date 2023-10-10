#include <curses.h>
#include <menu.h>
#include <malloc.h>
#define ARRAY_SIZE(a) (sizeof(a) / sizeof(a[0]))
#define CTRLD 4

char *choices[] = {"1", "2", "3", "4", "X"};
char *choices1[] = {"Choice 1", "Choice 2", "Choice 3", "Choice 4", "Exit"};

int main()
{
	ITEM **my_items, *cur_item;
	MENU *my_menu;
	int c, n_choices, i;

	initscr();
	cbreak();
	noecho();
	keypad(stdscr, TRUE);

	n_choices = ARRAY_SIZE(choices);
//	my_items = (ITEM **)calloc(n_choices + 1, sizeof(ITEM *));
	my_items = (ITEM **)malloc((n_choices + 1) * sizeof(ITEM *));

	for(i = 0; i < n_choices; ++i)
		my_items[i] = new_item(choices[i], choices1[i]);

	my_items[n_choices] = (ITEM *)NULL;
	my_menu = new_menu((ITEM **)my_items);
	mvprintw(LINES - 2, 0, "F2 to Exit");
	post_menu(my_menu);
	refresh();

	while((c = getch()) != KEY_F(2))
	{
		switch(c)
		{
			case KEY_DOWN:
				menu_driver(my_menu, REQ_DOWN_ITEM);
				break;
			case KEY_UP:
				menu_driver(my_menu, REQ_UP_ITEM);
				break;
		}
	}

	free_item(my_items[0]);
	free_item(my_items[1]);
	free_menu(my_menu);
	endwin();
}

