package com.pessimistic

class Tile(val tileType: TileType, val location: Pair<Int, Int>) {
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
