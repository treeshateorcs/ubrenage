use rand::Rng;
use std::env;

const NOUNS: &str = include_str!("nouns");
const ADJECTIVES: &str = include_str!("adjectives");

fn main() {
    let mut rng = rand::thread_rng();
    let mut nouns = calculate_words(NOUNS);
    let mut adjectives = calculate_words(ADJECTIVES);
    adjust(&mut nouns);
    adjust(&mut adjectives);
    for each_arg in env::args().skip(1) {
        for each_letter in each_arg.chars() {
            if (each_letter as i32) < 97 || (each_letter as i32) > 122 {
                usage();
                std::process::exit(1);
            }
            let letter = each_letter as i32 - 97i32;
            let random_noun_number = random_number(&mut rng, &nouns, letter);
            let random_adj_number = random_number(&mut rng, &adjectives, letter);
            let adjective = random_word(random_adj_number, ADJECTIVES);
            let noun = random_word(random_noun_number, NOUNS);
            println!("{} {}", adjective, noun);
        }
        return;
    }
    let letter = random_letter(&mut rng);
    let random_noun_number = random_number(&mut rng, &nouns, letter);
    let random_adj_number = random_number(&mut rng, &adjectives, letter);
    let adjective = random_word(random_adj_number, ADJECTIVES);
    let noun = random_word(random_noun_number, NOUNS);
    println!("{} {}", adjective, noun);
}

fn adjust(num_words: &mut [i32; 27]) {
    let mut i = 1;
    while i < num_words.len() - 1 {
        num_words[i] += num_words[i - 1];
        i += 1;
    }
}

fn calculate_words(words: &str) -> [i32; 27] {
    let mut letters: [i32; 27] = [0; 27];
    let mut words_number = 0; // number of words total;
    let mut beg_word = true; // begining of word;
    for ch in words.chars() {
        if ch == '\n' {
            words_number += 1;
            beg_word = true;
        } else if beg_word {
            letters[(ch as i32 - 96i32) as usize] += 1;
            beg_word = false;
        }
    }
    letters[26] = words_number;
    letters
}

fn random_letter(rng: &mut rand::rngs::ThreadRng) -> i32 {
    rng.gen_range(0, 26)
}

fn random_word(number: i32, words: &str) -> String {
    let mut words_number = 0;
    let mut result = Vec::new();
    for noun in words.chars() {
        if noun == '\n' {
            words_number += 1;
        } else if words_number == number {
            result.push(noun);
        }
    }
    result.into_iter().collect()
}

fn random_number(rng: &mut rand::rngs::ThreadRng, map: &[i32; 27], letter: i32) -> i32 {
    let start = map[letter as usize];
    let end = map[1 + letter as usize];
    let random: i32 = rng.gen_range(start, end + 1);
    random
}

fn usage() {
    println!("usage: ubrenage [abcdefghijklmnopqrstuvwxyz...]");
}
