aoc.beam: aoc.erl
	erlc aoc.erl

run: aoc.beam
	erl -noshell -s aoc day1 -s init stop

.PHONY: clean
clean:
	rm -f *.beam
