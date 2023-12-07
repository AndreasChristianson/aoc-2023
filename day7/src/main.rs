use std::fs::read_to_string;
use std::collections::HashMap;

fn main() {
    let lines = read_lines("input.txt");
    let mut hands = vec![];
    for line in lines {
        let parts: Vec<&str> = line.split(' ').collect();
        let cards_in_hand=parts[0]
            .replace("T", "a")
            .replace("J", "0")
            // .replace("J", "b") // part1
            .replace("Q", "c")
            .replace("K", "d")
            .replace("A", "e");
        let hand = Hand {
            rank: find_rank(cards_in_hand.clone()),
            cards: cards_in_hand,
            bid: parts[1].parse::<u32>().unwrap(),
        };
        hands.push(hand);
    }
    hands.sort();
    let mut sum = 0;
    let mut pos = 0;
    for hand in hands {
        pos = pos + 1;
        sum = pos * hand.bid + sum;
    }
    println!("{}", sum);
}

#[derive(Debug, PartialEq, Eq, PartialOrd, Ord)]
enum Rank {
    HighCard,
    OnePair,
    TowPair,
    Three,
    Full,
    Four,
    Five,
}

#[derive(Debug, PartialEq, Eq, PartialOrd, Ord)]
struct Hand {
    rank: Rank,
    cards: String,
    bid: u32,
}


fn read_lines(filename: &str) -> Vec<String> {
    let mut result = Vec::new();

    for line in read_to_string(filename).unwrap().lines() {
        result.push(line.to_string())
    }

    result
}

fn find_rank(hand: String) -> Rank {
    let char_count_map = find_dup_chars(hand.clone());
    let mut largest = 0;
    let mut second_largest = 0;
    let mut jokers = 0;
    for (c, count) in char_count_map {
        if c == '0' {
            jokers = count;
            continue;
        }
        match count {
            count if count > largest => {
                second_largest = largest;
                largest = count;
            }
            count if count > second_largest => {
                second_largest = count
            }
            _ => ()
        }
    }
    largest=largest+jokers;

    if largest == 5 {
        return Rank::Five;
    }
    if largest == 4 {
        return Rank::Four;
    }
    if largest == 3 && second_largest == 2 {
        return Rank::Full;
    }
    if largest == 3 {
        return Rank::Three;
    }
    if largest == 2 && second_largest == 2 {
        return Rank::TowPair;
    }
    if largest == 2 {
        return Rank::OnePair;
    }
    return Rank::HighCard;
}

fn find_dup_chars(string: String) -> HashMap<char, isize> {
    let mut chars: HashMap<char, isize> = HashMap::new();

    for c in string.chars() {
        let count = chars.entry(c).or_insert(0);
        *count += 1;
    }
    chars
}