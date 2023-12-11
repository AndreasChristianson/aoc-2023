run: output
	./output

output: aoc.nim types.nim helpers.nim combinatorics.nim
	nim compile --out:output aoc.nim

clean:
	rm -rf output
