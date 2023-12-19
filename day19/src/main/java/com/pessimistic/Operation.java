package com.pessimistic;

import java.util.Arrays;

public enum Operation {
    GT(">"),
    LT("<");

    private final String asString;

    Operation(String asString) {
        this.asString = asString;
    }

    public static Operation parse(String asString) {
        return Arrays.stream(Operation.values())
                .filter(op -> op.asString.equals(asString))
                .findFirst()
                .orElseThrow();
    }

    boolean compare(int l, int r) {
        return switch (this) {
            case GT -> l > r;
            case LT -> l < r;
        };
    }
}
