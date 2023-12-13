package com.pessimistic;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.function.Predicate;
import java.util.stream.Collectors;

public class Aoc {

    private final List<String> lines;
    private final List<Landscape> landscapes;

    public Aoc(String file) {
        List<String> readLines = readFile(file);
        this.lines = readLines;
        this.landscapes = parse(readLines);
    }

    public static void main(String[] args) throws IOException {
        String file = "input.txt";
        Aoc part1 = new Aoc(file);
        List<Integer> heights0 = part1.getReflectionHeights(0);
        List<Integer> widths0 = part1.getReflectionWidths(0);
        int height0 = heights0.stream().mapToInt(i -> i).sum();
        int width0 = widths0.stream().mapToInt(i -> i).sum();
        System.out.format("zero smudges - heights: %s\n", heights0);
        System.out.format("zero smudges - widths: %s\n", widths0);
        System.out.println(width0 + height0 * 100);

        List<Integer> heights1 = part1.getReflectionHeights(1);
        List<Integer> widths1 = part1.getReflectionWidths(1);
        int height1 = heights1.stream().mapToInt(i -> i).sum();
        int width1 = widths1.stream().mapToInt(i -> i).sum();
        System.out.format("one smudge - heights: %s\n", heights1);
        System.out.format("one smudge - widths: %s\n", widths1);
        System.out.println(width1 + height1 * 100);
    }

    private List<Integer> getReflectionHeights(int smudges) {
        return landscapes.stream().map(landscape -> landscape.getReflectionHeight(smudges)).collect(Collectors.toList());
    }

    private List<Integer> getReflectionWidths(int smudges) {
        return landscapes.stream().map(landscape -> landscape.getReflectionWidth(smudges)).collect(Collectors.toList());
    }

    private static List<Landscape> parse(List<String> lines) {
        List<List<String>> partitions = partition(lines, String::isEmpty);
        return partitions.stream().map(Landscape::new).collect(Collectors.toList());
    }

    private static List<List<String>> partition(List<String> lines, Predicate<String> predicate) {
        List<List<String>> accum = new ArrayList<>();
        List<String> curr = new ArrayList<>();
        for (String line : lines) {
            if (predicate.test(line)) {
                accum.add(curr);
                curr = new ArrayList<>();
            } else {
                curr.add(line);
            }
        }
        accum.add(curr);
        return accum;
    }

    private static List<String> readFile(String file) {
        List<String> lines = new ArrayList<>();
        try (BufferedReader br = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = br.readLine()) != null) {
                lines.add(line);
            }
            return lines;
        } catch (IOException ioe) {
            throw new RuntimeException(ioe);
        }
    }
}
