run: target/classes/com/pessimistic/AocKt.class
	mvn exec:java -Dexec.mainClass="com.pessimistic.AocKt" -Dexec.args="input.txt"

example: target/classes/com/pessimistic/AocKt.class
	mvn exec:java -Dexec.mainClass="com.pessimistic.AocKt" -Dexec.args="example.txt"

target/classes/com/pessimistic/AocKt.class: src/main/kotlin/com/pessimistic/Aoc.kt
	mvn compile

clean:
	mvn clean