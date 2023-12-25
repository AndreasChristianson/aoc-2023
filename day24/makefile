run: output
	./output input.txt 200000000000000 400000000000000

example: output
	./output example.txt 7 27

output: aoc.go hail2d/hail2d.go hail3d/hail3d.go
	go build -o output

clean:
	rm -f output