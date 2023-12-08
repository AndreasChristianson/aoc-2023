def lines = new File("input.txt").text.readLines()

def directions = lines[0]

String[] mapLines = lines[2..-1]
def map = [:]
for (String line : mapLines) {
    def matcher = line =~ /(...) = \((...), (...)\)/
    def matches = matcher[0][1..-1]
    map.put(matches[0], matches[1..-1])
}
def dirPos = 0
def pos = 'AAA'
println "start: " + pos
def count = 0
do {
    count++
    def dir = directions[dirPos]
    dirPos++
    if (dirPos == directions.length()) {
        dirPos = 0
    }
    if (dir == 'L') {
        pos = map[pos][0]
    } else {
        pos = map[pos][1]
    }
} while (pos != 'ZZZ')
println "single path: " + count
def positions = map.keySet().findAll { it[2] == 'A' }.collect()

println "starts: " + positions
def cycles=[]

for (int i = 0; i < positions.size(); i++) {
    count=0
    do {
        count++
        def dir = directions[dirPos]
        dirPos++
        if (dirPos == directions.length()) {
            dirPos = 0
        }
        if (dir == 'L') {
            positions[i] = map[positions[i]][0]
        } else {
            positions[i] = map[positions[i]][1]
        }
    } while (positions[i][2] != 'Z')
    cycles[i]=count
}
println "take this to wolfram alpha: LCM" + cycles