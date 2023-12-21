package com.pessimistic

class Garden(lines: Array<String>) {

    val grid: Map<Pair<Int, Int>, Tile> = parse(lines)
    val startLocation: Pair<Int, Int> = findStart(lines)
    val start: Tile
        get() = grid[startLocation]!!
    val width: Int = lines[0].length
    val height: Int = lines.size


    companion object {

        private fun parse(lines: Array<String>): Map<Pair<Int, Int>, Tile> {
            val ret: MutableMap<Pair<Int, Int>, Tile> = HashMap()
            for ((row, line) in lines.withIndex()) {
                for ((col, char) in line.chars().toArray().withIndex()) {
                    val location = Pair(row, col)
                    when (char) {
                        '.'.code, 'S'.code -> ret[location] = Tile(TileType.Bed, location)
                        '#'.code -> ret[location] = Tile(TileType.Rock, location)
                    }
                }
            }
            for (entry in ret.entries) {
                val (row, col) = entry.key
                ret[Pair(row, col + 1)]?.takeIf { it.walkable }?.let { entry.value.links.add(it) }
                ret[Pair(row, col - 1)]?.takeIf { it.walkable }?.let { entry.value.links.add(it) }
                ret[Pair(row + 1, col)]?.takeIf { it.walkable }?.let { entry.value.links.add(it) }
                ret[Pair(row - 1, col)]?.takeIf { it.walkable }?.let { entry.value.links.add(it) }
            }
            return ret
        }

        private fun findStart(lines: Array<String>): Pair<Int, Int> {
            for ((row, line) in lines.withIndex()) {
                val col = line.indexOf('S')
                if (col != -1) {
                    return Pair(row, col)
                }
            }
            throw Exception()
        }
    }

    override fun toString(): String {
        var ret = ""
        for (row in 0..<height) {
            for (col in 0..<width) {
                val location = Pair(row, col)
                when {
                    location == start.location -> ret += 's'
                    (grid[location])!!.tileType == TileType.Rock -> ret += '#'
                    else -> ret += '.'
                }
            }
            ret += System.lineSeparator()
        }
        return ret
    }

    fun walk(targetDistance: Int, startingLocation: Tile): Collection<Tile> {
        var processing = mutableSetOf(startingLocation)
        var nextCycle: MutableSet<Tile> = mutableSetOf()
        for (distance in 1..targetDistance) {
            while (processing.isNotEmpty()) {
                val current = processing.first()
                processing.remove(current)
                nextCycle.addAll(current.links)
            }
            processing = nextCycle
            nextCycle = mutableSetOf()
        }
        return processing
    }

    fun planWalk(startingLocation: Pair<Int, Int>) = iterator {
        val adjust = height*width*100
        val (startingRow, startingCol) = startingLocation
        val startLoc = Pair(startingRow + adjust, startingCol + adjust)
        var processing = mutableSetOf(startLoc)
        var nextCycle: MutableSet<Pair<Int, Int>> = mutableSetOf()
        yield(0)
        while (true) {
            while (processing.isNotEmpty()) {
                val current = processing.first()
                processing.remove(current)
                val (row, col) = current

                if ( infiniteGet(row, col + 1)) {
                    nextCycle.add(Pair(row, col + 1))
                }
                if ( infiniteGet(row, col - 1)) {
                    nextCycle.add(Pair(row, col - 1))
                }
                if (infiniteGet(row + 1, col)) {
                    nextCycle.add(Pair(row + 1, col))
                }
                if (infiniteGet(row - 1, col)) {
                    nextCycle.add(Pair(row - 1, col))
                }
            }
            processing = nextCycle
            nextCycle = mutableSetOf()

            yield(processing.size)
        }
    }

    private fun infiniteGet(row: Int, col: Int): Boolean {
        val ret = grid[Pair(row % height, col % width)]
        if(ret == null){
            println(Pair(row % height, col % width))
            println(Pair(row , col ))
        }
        return ret?.walkable!!
    }
}
