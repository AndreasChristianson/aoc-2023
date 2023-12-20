example: ./bin/Release/net8.0/day20
	./bin/Release/net8.0/day20 example.txt
	
example2: ./bin/Release/net8.0/day20
	./bin/Release/net8.0/day20 example2.txt

run: ./bin/Release/net8.0/day20
	./bin/Release/net8.0/day20 input.txt

./bin/Release/net8.0/day20: Aoc.cs Message.cs Node.cs Dummy.cs Conjunction.cs Broadcast.cs FlipFlop.cs Helpers.cs
	dotnet build -c Release

clean:
	rm -rf obj bin
