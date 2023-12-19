package com.pessimistic;

import reactor.util.function.Tuple2;
import reactor.util.function.Tuples;

public class Range {
    private final int upperBound;
    private final int lowerBound;

    @Override
    public String toString() {
        return "Range{" +
                "upperBound=" + upperBound +
                ", lowerBound=" + lowerBound +
                '}';
    }

    public Range(int lowerBound, int upperBound) {
        this.lowerBound = lowerBound;
        this.upperBound = upperBound;
    }

    public SplitRange split(Operation op, int threshold) {
        switch (op) {
            case GT -> {
                if (threshold >= upperBound) {
                    return SplitRange.failOnly(this);
                }
                if (threshold < lowerBound) {
                    return SplitRange.passOnly(this);
                }
                return new SplitRange(
                        new Range(threshold + 1, upperBound),
                        new Range(lowerBound, threshold));
            }
            case LT -> {
                if (threshold > upperBound) {
                    return SplitRange.passOnly(this);
                }
                if (threshold <= lowerBound) {
                    return SplitRange.failOnly(this);
                }
                return new SplitRange(
                        new Range(lowerBound, threshold - 1),
                        new Range(threshold, upperBound)
                );
            }
        }
        throw new AssertionError();
    }

    public long width() {
        return upperBound-lowerBound+1;
    }
}
