CFILES = toml.c

# Only set CFLAGS if undefined
CFLAGS ?= -std=c99 -Wall -Wextra -fpic

# to compile for debug: make DEBUG=1
ifdef DEBUG
    CFLAGS += -O0 -g
endif

EXEC = toml_json toml_cat

LIB = libtoml.a
LIB_SHARED = libtoml.so

all: $(LIB) $(LIB_SHARED) $(EXEC)

all_noshared: $(LIB) $(EXEC)

libtoml.a: toml.o
	$(AR) -rcs $@ $^

libtoml.so: toml.o
	$(CC) -shared -o $@ $^

toml_json: toml_json.c $(LIB)

toml_cat: toml_cat.c $(LIB)

prefix ?= /usr/local

install: all
	install -d ${prefix}/include ${prefix}/lib
	install toml.h ${prefix}/include
	install $(LIB) ${prefix}/lib
	install $(LIB_SHARED) ${prefix}/lib

clean:
	rm -f *.o $(EXEC) $(LIB) $(LIB_SHARED)
