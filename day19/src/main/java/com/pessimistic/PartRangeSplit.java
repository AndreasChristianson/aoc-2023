package com.pessimistic;

public class PartRangeSplit {
    private final PartRange passSplit;
    private final String passDest;
    private final PartRange failSplit;

    public PartRange getPassSplit() {
        return passSplit;
    }

    public String getPassDest() {
        return passDest;
    }

    public PartRange getFailSplit() {
        return failSplit;
    }


    public PartRangeSplit(PartRange passSplit, String passDest, PartRange failSplit) {
        this.passSplit = passSplit;
        this.passDest = passDest;
        this.failSplit = failSplit;
    }

    public PartRangeSplit(PartRange split, String dest) {
        this(split, dest, null);
    }

    public PartRangeSplit(PartRange split) {
        this(null,null, split);
    }


    public boolean hasPass() {
        return passSplit!=null;
    }

    public boolean hasFail() {
        return failSplit!=null;
    }
}
