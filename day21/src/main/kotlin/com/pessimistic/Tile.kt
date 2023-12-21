package com.pessimistic

class Tile(tileType: TileType, location: Pair<Int, Int>) {
    val tileType = tileType
    val location = location
    val links: MutableList<Tile> = mutableListOf()

    val walkable
        get() = tileType == TileType.Bed

    override fun toString(): String {
        return when (tileType) {
            TileType.Bed -> "."
            TileType.Rock -> "#"
        }
    }

}
