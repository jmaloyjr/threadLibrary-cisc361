# Makefile for UD CISC user-level thread library

CC = gcc
CFLAGS = -g

LIBOBJS = t_lib.o 

TSTOBJS = test00.o T1.o T1X.o

# specify the executable 

EXECS = test00 T1 T1X

# specify the source files

LIBSRCS = t_lib.c

TSTSRCS = test00.c

# ar creates the static thread library

t_lib.a: ${LIBOBJS} Makefile
	ar rcs t_lib.a ${LIBOBJS}

# here, we specify how each file should be compiled, what
# files they depend on, etc.

t_lib.o: t_lib.c t_lib.h Makefile
	${CC} ${CFLAGS} -c t_lib.c

test00.o: test00.c ud_thread.h Makefile
	${CC} ${CFLAGS} -c test00.c

test00: test00.o t_lib.a Makefile
	${CC} ${CFLAGS} test00.o t_lib.a -o test00

# Testing commands

# T1

T1.o: T1.c ud_thread.h Makefile
	${CC} ${CFLAGS} -c T1.c

T1: T1.o t_lib.a Makefile
	${CC} ${CFLAGS} T1.o t_lib.a -o T1

# T1X

T1X.o: T1X.c ud_thread.h Makefile
	${CC} ${CFLAGS} -c T1X.c

T1X: T1X.o t_lib.a Makefile
	${CC} ${CFLAGS} T1X.o t_lib.a -o T1X



clean:
	rm -f t_lib.a ${EXECS} ${LIBOBJS} ${TSTOBJS} 
