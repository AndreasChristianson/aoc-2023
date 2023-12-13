package com.pessimistic;

public enum Tile {
    Sand('.'),
    Rocks('#');

    private final char c;

    Tile(char c) {
        this.c = c;
    }

    public static Tile from(char c) {
        switch (c) {
            case '.':
                return Sand;
            case '#':
                return Rocks;
            default:
                throw new RuntimeException();
        }
    }

    @Override
    public String toString() {
        return Character.toString(c);
    }
}
