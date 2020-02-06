CFILES = toml.c

# Markus: added override and += to be abled to pass CFLAGS to the make file and removed flag -fpic
override CFLAGS += -std=c99 -Wall -Wextra

# to compile for debug: make DEBUG=1
# to compile for no debug: make
ifdef DEBUG
    CFLAGS += -O0 -g
else
    CFLAGS += -O2 -DNDEBUG
endif

EXEC = toml_json toml_cat

LIB = libtoml.a
LIB_SHARED = libtoml.so

all: $(LIB) $(LIB_SHARED) $(EXEC)


libtoml.a: toml.o
	$(AR) -rcs $@ $^

libtoml.so: toml.o
	# Markus: commented this out
	#$(CC) -shared -o $@ $^

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
