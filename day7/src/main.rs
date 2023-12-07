use std::fs::read_to_string;
use std::collections::HashMap;

fn main() {
    let lines = read_lines("input.txt");
    let mut hands = vec![];
    for line in lines {
        let parts: Vec<&str> = line.split(' ').collect();
        let cards_in_hand = parts[0]
            .replace("T", "a")
            .replace("J", "0")
            // .replace("J", "b") // part1
            .replace("Q", "c")
            .replace("K", "d")
            .replace("A", "e");
        let hand = Hand {
            rank: find_rank(cards_in_hand.clone()),
            cards: cards_in_hand,
            bid: parts[1].parse::<usize>().unwrap(),
        };
        hands.push(hand);
    }
    hands.sort();
    let sum = hands.iter().enumerate().fold(
        0,
        |sum, (index, hand)| sum + (index + 1) * hand.bid
    );
    println!("{}", sum);
}

#[derive(Debug, PartialEq, Eq, PartialOrd, Ord)]
struct Hand {
    rank: usize,
    cards: String,
    bid: usize,
}


fn read_lines(filename: &str) -> Vec<String> {
    let mut result = Vec::new();

    for line in read_to_string(filename).unwrap().lines() {
        result.push(line.to_string())
    }

    result
}

fn find_rank(hand: String) -> usize {
    let mut char_count_map = find_char_count_map(hand.clone());
    let jokers = char_count_map.remove(&'0');

    let mut counts: Vec<usize> = char_count_map.into_iter()
        .map(|(_, count)| count)
        .collect();
    counts.sort();

    let largest = counts.pop().unwrap_or(0) + jokers.unwrap_or(0);
    let second_largest = counts.pop().unwrap_or(0);

    if largest == 3 && second_largest == 2 {
        return 35;
    }
    if largest == 2 && second_largest == 2 {
        return 25;
    }
    return largest * 10;
}

fn find_char_count_map(string: String) -> HashMap<char, usize> {
    let mut chars: HashMap<char, usize> = HashMap::new();

    for c in string.chars() {
        let count = chars.entry(c).or_insert(0);
        *count += 1;
    }
    chars
}