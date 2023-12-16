run: build/output
	./build/output input.txt

build/output: build/aoc.o
	cc build/aoc.o -o build/output

build/aoc.o: aoc.c
	cc -c aoc.c -o build/aoc.o

clean:
	rm -rf build/*

all: build/output
