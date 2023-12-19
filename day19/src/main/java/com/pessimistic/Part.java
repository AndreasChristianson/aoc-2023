package com.pessimistic;

public record Part(int x, int m, int a, int s) {
    public int sum() {
        return x + a + m + s;
    }
}
