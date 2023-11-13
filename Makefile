CC=gcc
CFLAGS=-I.

main: main.o
	$(CC) -o program main.o

clean: 
	rm *.o program

