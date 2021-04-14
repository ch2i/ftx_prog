uname_S := $(shell uname -s)

# Mac osx (brew install libftdi)
ifeq ($(uname_S), Darwin)
CFLAGS = -Wall -O2 -s -Werror -pedantic -I/opt/homebrew/Cellar/libftdi/1.5_2/include/libftdi1/
LDFLAGS = -lusb-1.0 -lftdi1 -s -L/opt/homebrew/Cellar/libftdi/1.5_2/lib
endif

# Linux
ifeq ($(uname_S), Linux)
CFLAGS = -Wall -O2 -s -Werror -pedantic
LDFLAGS = -lusb -lftdi -s
endif

PROG = ftx_prog

all:	$(PROG)

$(PROG):	$(PROG).c
	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)

clean:
	rm -f $(PROG)


