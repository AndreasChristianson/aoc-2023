package com.pessimistic;

public class SplitRange {
    private final Range pass;
    private final Range fail;

    public SplitRange(Range pass, Range fail) {
        this.pass = pass;
        this.fail = fail;
    }

    public static SplitRange failOnly(Range range) {
        return new SplitRange(null, range);
    }

    public static SplitRange passOnly(Range range) {
        return new SplitRange(range, null);
    }

    public boolean hasPass() {

        return pass !=null;
    }

    public boolean hasFail() {
        return fail!=null;
    }

    public Range getPass() {
        return pass;
    }

    public Range getFail() {
        return fail;
    }
}
