#include <form.h>
#include <string.h>
#include <malloc.h>
#include <stdlib.h>

#define NegroNegro COLOR_PAIR(00)
#define NegroRojo COLOR_PAIR(01)
#define NegroVerde COLOR_PAIR(02)
#define NegroAmarillo COLOR_PAIR(03)
#define NegroAzul COLOR_PAIR(04)
#define NegroMagenta COLOR_PAIR(05)
#define NegroCyan COLOR_PAIR(06)
#define NegroBlanco COLOR_PAIR(07)

#define RojoNegro COLOR_PAIR(10)
#define RojoRojo COLOR_PAIR(11)
#define RojoVerde COLOR_PAIR(12)
#define RojoAmarillo COLOR_PAIR(13)
#define RojoAzul COLOR_PAIR(14)
#define RojoMagenta COLOR_PAIR(15)
#define RojoCyan COLOR_PAIR(16)
#define RojoBlanco COLOR_PAIR(17)

#define VerdeNegro COLOR_PAIR(20)
#define VerdeRojo COLOR_PAIR(21)
#define VerdeVerde COLOR_PAIR(22)
#define VerdeAmarillo COLOR_PAIR(23)
#define VerdeAzul COLOR_PAIR(24)
#define VerdeMagenta COLOR_PAIR(25)
#define VerdeCyan COLOR_PAIR(26)
#define VerdeBlanco COLOR_PAIR(27)

#define AmarilloNegro COLOR_PAIR(30)
#define AmarilloRojo COLOR_PAIR(31)
#define AmarilloVerde COLOR_PAIR(32)
#define AmarilloAmarillo COLOR_PAIR(33)
#define AmarilloAzul COLOR_PAIR(34)
#define AmarilloMagenta COLOR_PAIR(35)
#define AmarilloCyan COLOR_PAIR(36)
#define AmarilloBlanco COLOR_PAIR(37)

#define AzulNegro COLOR_PAIR(40)
#define AzulRojo COLOR_PAIR(41)
#define AzulVerde COLOR_PAIR(42)
#define AzulAmarillo COLOR_PAIR(43)
#define AzulAzul COLOR_PAIR(44)
#define AzulMagenta COLOR_PAIR(45)
#define AzulCyan COLOR_PAIR(46)
#define AzulBlanco COLOR_PAIR(47)

#define MagentaNegro COLOR_PAIR(50)
#define MagentaRojo COLOR_PAIR(51)
#define MagentaVerde COLOR_PAIR(52)
#define MagentaAmarillo COLOR_PAIR(53)
#define MagentaAzul COLOR_PAIR(54)
#define MagentaMagenta COLOR_PAIR(55)
#define MagentaCyan COLOR_PAIR(56)
#define MagentaBlanco COLOR_PAIR(57)

#define CyanNegro COLOR_PAIR(60)
#define CyanRojo COLOR_PAIR(61)
#define CyanVerde COLOR_PAIR(62)
#define CyanAmarillo COLOR_PAIR(63)
#define CyanAzul COLOR_PAIR(64)
#define CyanMagenta COLOR_PAIR(65)
#define CyanCyan COLOR_PAIR(66)
#define CyanBlanco COLOR_PAIR(67)

#define BlancoNegro COLOR_PAIR(70)
#define BlancoRojo COLOR_PAIR(71)
#define BlancoVerde COLOR_PAIR(72)
#define BlancoAmarillo COLOR_PAIR(73)
#define BlancoAzul COLOR_PAIR(74)
#define BlancoMagenta COLOR_PAIR(75)
#define BlancoCyan COLOR_PAIR(76)
#define BlancoBlanco COLOR_PAIR(77)

#define COLOR_BLUE_BOLD 80


typedef enum{si = 0, no} Logico;

char *cadena(char *campo)
{
	int contador = 0, li = 0, ld = strlen(campo) - 1, largo;
	char *linea = NULL;

	while(campo[li])
		if(campo[li] != ' ')
			break;
		else
			++li;

	if(li <= ld)
		while(campo[ld])
			if(campo[ld] != ' ')
				break;
			else
				--ld;

	largo = (ld - li) + 1;

	linea = malloc(sizeof(char) * (largo + 1));
	for(contador = 0; contador < largo; contador++)
		linea[contador] = campo[contador + li];
	linea[largo] = '\0';

	return linea;
}

char *entero(Logico con_signo)
{
	char *exp = NULL;
	int lim;
	if(con_signo == si)
	{
		lim = 22;
		exp = malloc(sizeof(char) * (lim + 1));
		sprintf(exp, "^ *[+--]{0,1}[0-9]+ *$");
	}
	else
	{
		lim = 12;
		exp = malloc(sizeof(char) * (lim + 1));
		sprintf(exp, "^ *[0-9]+ *$");
	}
	exp[lim] = '\0';
	return exp;
}

char *entero_signado()
{
	return entero(si);
}

char *entero_no_signado()
{
	return entero(no);
}

char *real(Logico con_signo, int numdec)
{
//	"^ *[+--]{0,1}[0-9]+(\\.[0-9]{1,D}){0,1} *$"
//                                  D = numero de decimales

	int decs, limite_cs = 42,  limite_ss = 32, lim;
	char signo[] = "[+--]{0,1}";
	char exp_a[] = " *[0-9]+(\\.[0-9]{1,";
	char exp_b[] = "}){0,1} *$";

	char *expresion = NULL;

	if(numdec < 1 || numdec > 4)
		decs = 2;
	else
		decs = numdec;

	if(con_signo == si)
	{
		lim = limite_cs;

		expresion = malloc(sizeof(char) * (lim + 1));
		sprintf(expresion, "^%s%s%d%s", signo, exp_a, decs, exp_b);
	}
	else
	{
		lim = limite_ss;

		expresion = malloc(sizeof(char) * (lim + 1));
		sprintf(expresion, "^%s%d%s", exp_a, decs, exp_b);
	}
	expresion[lim] = '\0';

	return expresion;
}

char *numerico(Logico con_signo, int numdec)
{
	return real(con_signo, numdec);
}

char *numerico_signado(int numdec)
{
	return numerico(si, numdec);
}

char *numerico_no_signado(int numdec)
{
	return numerico(no, numdec);
}

Logico valor_correcto(FIELD *campo)
{
	Logico vc = si;
	float numero, li, ls;
	
	if(strlen(cadena(field_buffer(campo, 0))) != 0)
	{
		li = ((float *)field_userptr(campo))[0];
		ls = ((float *)field_userptr(campo))[1];
		numero = atof(cadena(field_buffer(campo, 0)));
		if(numero < li || numero > ls)
			vc = no;
	}

	return vc;
}

int main()
{
	float limites[] = {-100.99, 100.99};
	FIELD *field[6];
	FIELD *field_aux;
	FORM *my_form;
	int ch, nerr = 0;
	char *cmp0 = NULL;
	char *cmp1 = NULL;
	char *cmp2 = NULL;
	char *cmp3 = NULL;
	char *cmp4 = NULL;
	float num, a = 3, b = 5;

//	typedef enum{negro = 0, rojo, verde, amarillo, azul, magenta, cyan, blanco} Color;
	/* Initialize curses */
	initscr();
	start_color();
	cbreak();
	noecho();
	keypad(stdscr, TRUE);

init_pair(00, COLOR_BLACK, COLOR_BLACK);
init_pair(01, COLOR_BLACK, COLOR_RED);
init_pair(02, COLOR_BLACK, COLOR_GREEN);
init_pair(03, COLOR_BLACK, COLOR_YELLOW);
init_pair(04, COLOR_BLACK, COLOR_BLUE);
init_pair(05, COLOR_BLACK, COLOR_MAGENTA);
init_pair(06, COLOR_BLACK, COLOR_CYAN);
init_pair(07, COLOR_BLACK, COLOR_WHITE);
init_pair(10, COLOR_RED, COLOR_BLACK);
init_pair(11, COLOR_RED, COLOR_RED);
init_pair(12, COLOR_RED, COLOR_GREEN);
init_pair(13, COLOR_RED, COLOR_YELLOW);
init_pair(14, COLOR_RED, COLOR_BLUE);
init_pair(15, COLOR_RED, COLOR_MAGENTA);
init_pair(16, COLOR_RED, COLOR_CYAN);
init_pair(17, COLOR_RED, COLOR_WHITE);
init_pair(20, COLOR_GREEN, COLOR_BLACK);
init_pair(21, COLOR_GREEN, COLOR_RED);
init_pair(22, COLOR_GREEN, COLOR_GREEN);
init_pair(23, COLOR_GREEN, COLOR_YELLOW);
init_pair(24, COLOR_GREEN, COLOR_BLUE);
init_pair(25, COLOR_GREEN, COLOR_MAGENTA);
init_pair(26, COLOR_GREEN, COLOR_CYAN);
init_pair(27, COLOR_GREEN, COLOR_WHITE);
init_pair(30, COLOR_YELLOW, COLOR_BLACK);
init_pair(31, COLOR_YELLOW, COLOR_RED);
init_pair(32, COLOR_YELLOW, COLOR_GREEN);
init_pair(33, COLOR_YELLOW, COLOR_YELLOW);
init_pair(34, COLOR_YELLOW, COLOR_BLUE);
init_pair(35, COLOR_YELLOW, COLOR_MAGENTA);
init_pair(36, COLOR_YELLOW, COLOR_CYAN);
init_pair(37, COLOR_YELLOW, COLOR_WHITE);
init_pair(40, COLOR_BLUE, COLOR_BLACK);
init_pair(41, COLOR_BLUE, COLOR_RED);
init_pair(42, COLOR_BLUE, COLOR_GREEN);
init_pair(43, COLOR_BLUE, COLOR_YELLOW);
init_pair(44, COLOR_BLUE, COLOR_BLUE);
init_pair(45, COLOR_BLUE, COLOR_MAGENTA);
init_pair(46, COLOR_BLUE, COLOR_CYAN);
init_pair(47, COLOR_BLUE, COLOR_WHITE);
init_pair(50, COLOR_MAGENTA, COLOR_BLACK);
init_pair(51, COLOR_MAGENTA, COLOR_RED);
init_pair(52, COLOR_MAGENTA, COLOR_GREEN);
init_pair(53, COLOR_MAGENTA, COLOR_YELLOW);
init_pair(54, COLOR_MAGENTA, COLOR_BLUE);
init_pair(55, COLOR_MAGENTA, COLOR_MAGENTA);
init_pair(56, COLOR_MAGENTA, COLOR_CYAN);
init_pair(57, COLOR_MAGENTA, COLOR_WHITE);
init_pair(60, COLOR_CYAN, COLOR_BLACK);
init_pair(61, COLOR_CYAN, COLOR_RED);
init_pair(62, COLOR_CYAN, COLOR_GREEN);
init_pair(63, COLOR_CYAN, COLOR_YELLOW);
init_pair(64, COLOR_CYAN, COLOR_BLUE);
init_pair(65, COLOR_CYAN, COLOR_MAGENTA);
init_pair(66, COLOR_CYAN, COLOR_CYAN);
init_pair(67, COLOR_CYAN, COLOR_WHITE);
init_pair(70, COLOR_WHITE, COLOR_BLACK);
init_pair(71, COLOR_WHITE, COLOR_RED);
init_pair(72, COLOR_WHITE, COLOR_GREEN);
init_pair(73, COLOR_WHITE, COLOR_YELLOW);
init_pair(74, COLOR_WHITE, COLOR_BLUE);
init_pair(75, COLOR_WHITE, COLOR_MAGENTA);
init_pair(76, COLOR_WHITE, COLOR_CYAN);
init_pair(77, COLOR_WHITE, COLOR_WHITE);

	/* Initialize the fields */
	field[0] = new_field(1, 10, 4, 18, 0, 0);
	field[1] = new_field(1, 10, 6, 18, 0, 0);
	field[2] = new_field(1, 10, 8, 18, 0, 0);
	field[3] = new_field(1, 10, 10, 18, 0, 0);
	field[4] = new_field(2, 10, 12, 18, 0, 0);
	field[5] = NULL;
	set_field_userptr(field[3], limites);

	/* Set field options */
//	set_field_back(field[0], A_UNDERLINE); /* Print a line for the option */
//	field_opts_off(field[0], O_AUTOSKIP); /* Don't go to next field when this */

	/* Field is filled up */
//	set_field_back(field[1], A_UNDERLINE);
//	field_opts_off(field[1], O_AUTOSKIP);

//	set_field_buffer(field[3], 0, "0.00");
	char *opciones[] = {"Primero", "Segundo", "Tercero"};
	for(int i = 0; i < 5; i++)
	{
		field_opts_off(field[i], O_AUTOSKIP);
		set_field_back(field[i], A_UNDERLINE);
/*		if(i == 2)
			field_opts_off(field[i], O_AUTOSKIP);
		else
			field_opts_off(field[i], O_AUTOSKIP|O_BLANK);*/
	}
//	field_opts_off(field[2], O_NULLOK);
	set_field_just(field[0], JUSTIFY_RIGHT);
	set_field_just(field[1], JUSTIFY_RIGHT);
	set_field_just(field[2], JUSTIFY_LEFT);
	set_field_just(field[3], JUSTIFY_RIGHT);
	set_field_just(field[4], JUSTIFY_LEFT);

	set_field_type(field[0], TYPE_REGEXP, entero_signado());
	set_field_type(field[1], TYPE_REGEXP, entero_no_signado());
	set_field_type(field[2], TYPE_ENUM, opciones);
	set_field_type(field[3], TYPE_REGEXP, numerico_signado(2));
	set_field_type(field[4], TYPE_REGEXP, entero_signado());

	set_field_fore(field[0], RojoAmarillo);/* Put the field with a color background */
	set_field_back(field[0], RojoAmarillo);/* and white foreground (characters */

	/* Create the form and post it */
	my_form = new_form(field);
	post_form(my_form);
	refresh();
	mvprintw(4, 10, "Value 1:");
	mvprintw(6, 10, "Value 2:");
	mvprintw(8, 10, "Value 3:");
	mvprintw(10, 10, "Value 4:");
	refresh();

	short int v = 1000;
	int retorno = init_color(COLOR_RED, v, 0, 0);

	form_driver(my_form, REQ_FIRST_FIELD);
	/* Loop through to get user requests */
	while((ch = getch()) != KEY_F(2))
	{
		switch(ch)
		{
			case 127:		//backspace
				if(form_driver(my_form, REQ_LEFT_CHAR) != E_REQUEST_DENIED)
					form_driver(my_form, REQ_DEL_CHAR);
				break;
			case KEY_SDC:	//shift+delete
				form_driver(my_form, REQ_CLR_EOF);
				break;
			case KEY_DC:	//delete
				form_driver(my_form, REQ_DEL_CHAR);
				break;
			case KEY_RIGHT:	//derecha
				form_driver(my_form, REQ_RIGHT_CHAR);
				break;
			case KEY_LEFT:	//izquierda
				form_driver(my_form, REQ_LEFT_CHAR);
				break;
			case KEY_END:	//fin
				form_driver(my_form, REQ_END_FIELD);
				break;
			case KEY_HOME:	//inicio
				form_driver(my_form, REQ_BEG_FIELD);
				break;
			case KEY_DOWN:	//down
			case 10:		//tab
			case '\t':		//tab
				if (valor_correcto(field[3]) == si)
				{
					form_driver(my_form, REQ_NEXT_FIELD);
					form_driver(my_form, REQ_END_FIELD);
//
					field_aux = current_field(my_form);
					if (field_aux == field[2])
						form_driver(my_form, REQ_BEG_FIELD);
//
				}
				else
					++nerr;
				break;
			case KEY_UP:	//up
			case KEY_BTAB:	//back-tab
				if (valor_correcto(field[3]) == si)
				{
					form_driver(my_form, REQ_PREV_FIELD);
					form_driver(my_form, REQ_END_FIELD);
//
					field_aux = current_field(my_form);
					if (field_aux == field[2])
						form_driver(my_form, REQ_BEG_FIELD);
//
				}
				break;
			default:
				form_driver(my_form, ch);
				break;
		}
		form_driver(my_form, REQ_VALIDATION);
	}

	cmp0 = cadena(field_buffer(field[0], 0));
	cmp1 = cadena(field_buffer(field[1], 0));
	cmp2 = cadena(field_buffer(field[2], 0));
	cmp3 = cadena(field_buffer(field[3], 0));
	cmp4 = cadena(field_buffer(field[4], 0));
	num = atof(field_buffer(field[3], 0));

	short int red = 0, green = 0, blue = 0;
	color_content(COLOR_BLUE, &red, &green, &blue);
	
	/* Un post form and free the memory */
	unpost_form(my_form);
	free_form(my_form);
	free_field(field[0]);
	free_field(field[1]);
	free_field(field[2]);
	free_field(field[3]);
	free_field(field[4]);
	endwin();

	printf("campo 0 = %s, %d\n", cmp0, strlen(cmp0));
	printf("campo 1 = %s, %d\n", cmp1, strlen(cmp1));
	printf("campo 2 = %s, %d\n", cmp2, strlen(cmp2));
	printf("campo 3 = %s, %d\n", cmp3, strlen(cmp3));
	printf("campo 4 = %s, %d\n", cmp4, strlen(cmp4));
/*	printf("valor 3 = %f\n", num);
	printf("nerr c 3 = %d\n", nerr);
	printf("Rojo = %d\n", red);
	printf("Verde = %d\n", green);
	printf("Azul = %d\n", blue);
	printf("v = %d, ret = %d\n", v, retorno);*/
	getchar();
	free(cmp0);
	free(cmp1);
	free(cmp2);
	free(cmp3);
	free(cmp4);

	return 0;
}

