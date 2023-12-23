run: output
	./output input.txt

example: output
	./output example.txt

output: bin/day23.dart lib/day23.dart
	dart compile exe bin/day23.dart -o output

clean:
	rm -f output