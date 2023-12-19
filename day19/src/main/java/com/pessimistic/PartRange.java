package com.pessimistic;

public record PartRange(Range x, Range m, Range a, Range s) {

    public PartRange split(Attribute att, Range replacement) {
        return switch (att) {
            case x -> new PartRange(replacement, m, a, s);
            case m -> new PartRange(x, replacement, a, s);
            case a -> new PartRange(x, m, replacement, s);
            case s -> new PartRange(x, m, a, replacement);
        };
    }

    public long product() {
        return x.width() * m.width() * a.width() * s.width();
    }
}
