PROG=mop

DEPS=tabs
FLAGS=-lncurses -lpanel -lform -lmenu -Wall

$(PROG) : $(PROG).o
	gcc $< -o $@ $(FLAGS)

$(PROG).o : $(PROG).c $(DEPS).h
	gcc -c $<
