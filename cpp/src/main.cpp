#include <array>
#include <fmt/core.h>
#include <random>
#include <string>

extern std::string NOUNS;
extern std::string ADJECTIVES;

std::array<int, 27> calculate_words(std::string);
void adjust(std::array<int, 27> &);
void usage();
std::string random_word(int, std::string &);
int random_number(std::mt19937, std::array<int, 27>, int);
int random_letter(std::mt19937);

int main(int argc, char *argv[]) {
  std::random_device rd;
  std::mt19937 gen(rd());
  std::array<int, 27> nouns{calculate_words(NOUNS)};
  std::array<int, 27> adjectives{calculate_words(ADJECTIVES)};
  adjust(nouns);
  adjust(adjectives);
  for (int i = 1; i < argc; ++i) {
    std::string arg{argv[i]};
    for (auto ch : arg) {
      if (ch < 97 || ch > 122) {
        usage();
        std::exit(1);
      }
      int letter = ch - 97;
      int random_noun_number = random_number(gen, nouns, letter);
      int random_adj_number = random_number(gen, adjectives, letter);
      std::string adjective = random_word(random_adj_number, ADJECTIVES);
      std::string noun = random_word(random_noun_number, NOUNS);
      fmt::print("{} {}\n", adjective, noun);
    }
    return 0;
  }
  int letter = random_letter(gen);
  int random_noun_number = random_number(gen, nouns, letter);
  int random_adj_number = random_number(gen, adjectives, letter);
  std::string adjective = random_word(random_adj_number, ADJECTIVES);
  std::string noun = random_word(random_noun_number, NOUNS);
  fmt::print("{} {}\n", adjective, noun);
  return 0;
}

void adjust(std::array<int, 27> &num_words) {
  int i{1};
  while (i < num_words.size() - 1) {
    num_words[i] += num_words[i - 1];
    i += 1;
  }
}

std::array<int, 27> calculate_words(std::string words) {
  std::array<int, 27> letters{0, 27};
  int words_number{0};
  bool beg_word = true;
  for (auto ch : words) {
    if (ch == '\n') {
      words_number++;
      beg_word = true;
    } else if (beg_word) {
      letters[ch - 96]++;
      beg_word = false;
    }
  }
  letters[26] = words_number;
  return letters;
}

int random_letter(std::mt19937 gen) {
  std::uniform_int_distribution<> distr(0, 26);
  return distr(gen);
}

std::string random_word(int number, std::string &words) {
  int words_number{0};
  std::string result{};
  for (auto ch : words) {
    if (ch == '\n') {
      words_number += 1;
    } else if (words_number == number) {
      result.push_back(ch);
    }
  }
  return result;
}

int random_number(std::mt19937 gen, std::array<int, 27> map, int letter) {
  int start{map[letter]};
  int end{map[1 + letter]};
  std::uniform_int_distribution<> distr(start, end);
  int random = distr(gen);
  return random;
}

void usage() { fmt::print("usage: ubrenage [abcdefghijklmnopqrstuvwxyz...]"); }
