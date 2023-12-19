package com.pessimistic;

public enum Attribute {
    x, m, a, s;

    public int get(Part p) {
        return switch (this) {
            case x -> p.x();
            case m -> p.m();
            case a -> p.a();
            case s -> p.s();
        };
    }

    public Range get(PartRange p) {
        return switch (this) {
            case x -> p.x();
            case m -> p.m();
            case a -> p.a();
            case s -> p.s();
        };
    }
}
