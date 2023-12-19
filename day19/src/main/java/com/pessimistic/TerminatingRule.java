package com.pessimistic;

import java.util.Optional;

public class TerminatingRule implements CanProcess {
    private final String destination;

    public TerminatingRule(String destination) {
        this.destination = destination;
    }

    @Override
    public Optional<String> process(Part p) {
        return Optional.of(destination);
    }

    @Override
    public PartRangeSplit processRange(PartRange partRange) {
        return new PartRangeSplit(partRange,destination);
    }

    @Override
    public String toString() {
        return "TerminatingRule{" +
                "destination='" + destination + '\'' +
                '}';
    }
}
