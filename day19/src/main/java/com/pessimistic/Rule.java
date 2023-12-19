package com.pessimistic;

import reactor.util.function.Tuple2;

import java.util.Optional;

public class Rule implements CanProcess {
    private final Operation op;
    private final Attribute att;
    private final int threshold;
    private final String destination;

    public Rule(Operation op, Attribute att, int threshold, String destination) {
        this.op = op;
        this.att = att;
        this.threshold = threshold;
        this.destination = destination;
    }

    @Override
    public Optional<String> process(Part p) {
        if (op.compare(att.get(p), threshold)) {
            return Optional.of(destination);
        }
        return Optional.empty();
    }

    @Override
    public PartRangeSplit processRange(PartRange partRange) {
        Range range = att.get(partRange);
        var splitRange = range.split(op, threshold);
        if (splitRange.hasPass() && splitRange.hasFail()) {
            return new PartRangeSplit(
                    partRange.split(att, splitRange.getPass()),
                    destination,
                    partRange.split(att, splitRange.getFail())
            );
        }
        if (splitRange.hasPass()) {
            return new PartRangeSplit(
                    partRange.split(att, splitRange.getPass()),
                    destination
            );
        }
        if (splitRange.hasFail()) {
            return new PartRangeSplit(
                    partRange.split(att, splitRange.getFail())
            );
        }
        throw new AssertionError();
    }

    @Override
    public String toString() {
        return "Rule{" +
                "op=" + op +
                ", att=" + att +
                ", threshold=" + threshold +
                ", destination='" + destination + '\'' +
                '}';
    }
}
