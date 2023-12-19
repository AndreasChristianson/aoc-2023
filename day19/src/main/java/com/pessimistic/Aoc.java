package com.pessimistic;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

public class Aoc {

    private void send(Part p, String destination) {
        switch (destination) {
            case "R":
                rejected.add(p);
                break;
            case "A":
                accepted.add(p);
                break;
            default:
                pile.get(destination).process(p);
        }
    }
    private void sendRange(PartRange p, String destination) {
        switch (destination) {
            case "R":
                rejectedRange.add(p);
                break;
            case "A":
                acceptedRange.add(p);
                break;
            default:
                pile.get(destination).processRange(p);
        }
    }

    private final Map<String, Workflow> pile;
    private final List<Part> toProcess;
    private final List<Part> rejected = new ArrayList<>();
    private final List<Part> accepted = new ArrayList<>();
    private final List<PartRange> rejectedRange = new ArrayList<>();
    private final List<PartRange> acceptedRange = new ArrayList<>();


    public Aoc(String file) {
        List<String> lines = readFile(file);
        this.pile = parseWorkflows(lines);
        this.toProcess = parseParts(lines);
    }

    private List<Part> parseParts(List<String> lines) {
        Pattern pattern = Pattern.compile("\\{x=(\\d+),m=(\\d+),a=(\\d+),s=(\\d+)}");

        return lines.stream()
                .map(pattern::matcher)
                .filter(Matcher::find)
                .map(match -> new Part(
                        Integer.parseInt(match.group(1)),
                        Integer.parseInt(match.group(2)),
                        Integer.parseInt(match.group(3)),
                        Integer.parseInt(match.group(4))))
                .collect(Collectors.toList());

    }

    private Map<String, Workflow> parseWorkflows(List<String> lines) {
        var ret = new HashMap<String, Workflow>();
        for (var line : lines) {
            if (line.isBlank()) {
                break;
            }
            Pattern pattern = Pattern.compile("(\\w+)\\{(.+)}");
            Matcher matcher = pattern.matcher(line);
            if (!matcher.find()) throw new AssertionError();
            ret.put(matcher.group(1), parseWorkFlowRules(matcher.group(2)));
        }
        return ret;
    }

    private Workflow parseWorkFlowRules(String rules) {
        var rulesList = new ArrayList<CanProcess>();
        for (var rule : rules.split(",")) {
            Pattern pattern = Pattern.compile("([xmas])([<>])(\\d+):(\\w+)|(\\w+)");
            Matcher matcher = pattern.matcher(rule);
            if (!matcher.find()) throw new AssertionError();
            if (matcher.group(5) != null) {
                rulesList.add(new TerminatingRule(matcher.group(5)));
            } else {

                rulesList.add(new Rule(
                        Operation.parse(matcher.group(2)),
                        Attribute.valueOf(matcher.group(1)),
                        Integer.parseInt(matcher.group(3)),
                        matcher.group(4)
                ));
            }
        }
        return new Workflow(rulesList);
    }

    public static void main(String[] args) throws IOException {
        String file = args[0];
        Aoc aoc = new Aoc(file);
        aoc.process();
        System.out.format("total accepted attributes: %d\n", aoc.acceptedSum());
        aoc.processRange();
        System.out.format("total accepted permutations: %d\n", aoc.acceptedRangePermutationsSum());
    }

    private long acceptedRangePermutationsSum() {
        return acceptedRange.stream().mapToLong(range -> range.product()).sum();
    }

    private void processRange() {
        pile.get("in").processRange(new PartRange(
                new Range(1, 4000),
                new Range(1, 4000),
                new Range(1, 4000),
                new Range(1, 4000)
        ));
    }

    private void process() {
        for (var part : toProcess) {
            pile.get("in").process(part);
        }
    }

    private int acceptedSum() {
        return accepted.stream().mapToInt(Part::sum).sum();
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

    private class Workflow {
        private final List<CanProcess> rules;

        private Workflow(List<CanProcess> rules) {
            this.rules = rules;
        }

        public void process(Part p) {
            rules.stream()
                    .flatMap(r -> r.process(p).stream())
                    .findFirst()
                    .ifPresentOrElse(
                            dest -> Aoc.this.send(p, dest),
                            () -> {
                                throw new RuntimeException("no terminator in rule");
                            }
                    );
        }

        public void processRange(PartRange partRange) {
            var current = partRange;
            for (var rule:rules){
                PartRangeSplit result = rule.processRange(current);
                if(result.hasPass()){
                    Aoc.this.sendRange(result.getPassSplit(), result.getPassDest());
                }
                if(result.hasFail()){
                    current = result.getFailSplit();
                }
            }
        }
    }
}
