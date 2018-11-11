# Makefile for UD CISC user-level thread library

CC = gcc
CFLAGS = -g

LIBOBJS = t_lib.o 

# specify the executable 

EXECS = test00 test01 test01x test01a test02 test04 test07

# specify the source files

LIBSRCS = t_lib.c

TSTSRCS = test00.c test01.c test01x.c

# ar creates the static thread library
all: test00 test01 test01x test01a test02 test04 test07
	echo Type 'make phase1' to make and run phase 1 tests
	echo Type 'make phase2' to make and run phase 2 tests

phase1: test00 test01 test01x
	./test00
	./test01
	./test01x

phase2: test01a test02 test04 test07
	./test01a
	./test02
	./test04
	./test07

t_lib.a: ${LIBOBJS} Makefile
	ar rcs t_lib.a ${LIBOBJS}

# here, we specify how each file should be compiled, what
# files they depend on, etc.

t_lib.o: t_lib.c t_lib.h Makefile
	${CC} ${CFLAGS} -c t_lib.c

# phase 1
test00.o: test00.c ud_thread.h Makefile
	${CC} ${CFLAGS} -c test00.c

test00: test00.o t_lib.a Makefile
	${CC} ${CFLAGS} test00.o t_lib.a -o test00

test01.o: test01.c ud_thread.h Makefile
	${CC} ${CFLAGS} -c test01.c

test01: test01.o t_lib.a Makefile
	${CC} ${CFLAGS} test01.o t_lib.a -o test01

test01x.o: test01x.c ud_thread.h Makefile
	${CC} ${CFLAGS} -c test01x.c

test01x: test01x.o t_lib.a Makefile
	${CC} ${CFLAGS} test01x.o t_lib.a -o test01x

# phase 2
test01a: test01a.o t_lib.a Makefile
	${CC} ${CFLAGS} test01a.o t_lib.a -o test01a

test01a.o:
	${CC} ${CFLAGS} -c test01a.c

test02: test02.o t_lib.a Makefile
	${CC} ${CFLAGS} test02.o t_lib.a -o test02

test02.o:
	${CC} ${CFLAGS} -c test02.c

test04: test04.o t_lib.a Makefile
	${CC} ${CFLAGS} test04.o t_lib.a -o test04

test04.o:
	${CC} ${CFLAGS} -c test04.c

test07: test07.o t_lib.a Makefile
	${CC} ${CFLAGS} test07.o t_lib.a -o test07

test07.o:
	${CC} ${CFLAGS} -c test07.c

clean:
	rm -f t_lib.a ${EXECS} ${LIBOBJS} *.o *~
