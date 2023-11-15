CC=gcc
CFLAGS=-I.

main: main.o load_fields.o
	$(CC) -o program main.o load_fields.o

clean: 
	rm *.o program

