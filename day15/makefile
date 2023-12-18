CC = g++
CFLAGS = -Wall -std=c++11

run: build/output
	./build/output input.txt

build/output: build/aoc.o build/split.o build/hash.o
	$(CC) $(CFLAGS) build/aoc.o build/split.o build/hash.o -o build/output

build/aoc.o: aoc.cpp
	$(CC) $(CFLAGS) -c aoc.cpp -o build/aoc.o

build/split.o: lib/split.cpp
	$(CC) $(CFLAGS) -c lib/split.cpp -o build/split.o

build/hash.o: lib/hash.cpp
	$(CC) $(CFLAGS) -c lib/hash.cpp -o build/hash.o

build/lens.o: class/lens.cpp
	$(CC) $(CFLAGS) -c class/lens.cpp -o build/lens.o

all: build/output

clean:
	rm -f output
	rm -f *.o
	rm -rf build/*