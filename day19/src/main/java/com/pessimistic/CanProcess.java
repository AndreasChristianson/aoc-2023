package com.pessimistic;

import java.util.Optional;

public interface CanProcess {
    Optional<String> process(Part p);

    PartRangeSplit processRange(PartRange partRange);
}
