//
//  ViewController.swift
//  ios
//
//  Created by tho on 11/20/22.
//

import UIKit
import Collections

class ViewController: UIViewController {
    let nouns = {
        if let path = Bundle.main.path(forResource: "nouns", ofType: "txt") {
            do {
                return try String(contentsOfFile: path, encoding: .utf8)
            } catch {
                print(error)
            }
        }
        return ""
    }
    
    let adjectives = {
        if let path = Bundle.main.path(forResource: "adjectives", ofType: "txt") {
            do {
                return try String(contentsOfFile: path, encoding: .utf8)
            } catch {
                print(error)
            }
        }
        return ""
    }
    
    var nounsCount = 0, adjectivesCount = 0
    var nounsDict: OrderedDictionary<Character, Int> = [:], adjectivesDict: OrderedDictionary<Character, Int> = [:]
    let alphabet = "abcdefghijklmnopqrstuvwxyz"
    var randoml: Character = "a"
    var randomNoun = "", randomAdjective = ""
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nounsCount = countWords(nouns)
        adjectivesCount = countWords(adjectives)
        nounsDict = makeADict(nouns)
        adjectivesDict = makeADict(adjectives)
        randoml = randomLetter()
        randomNoun = randomWord(at: randoml, dict: nounsDict, words: nouns)
        randomAdjective = randomWord(at: randoml, dict: adjectivesDict, words: adjectives)
    }
    
    @IBOutlet var randomPhraseButton: UIButton!
    
    @IBAction func buttonPressed(_ sender: Any) {
        updateUI()
    }
    
    func updateUI() {
        randoml = randomLetter()
        randomNoun = randomWord(at: randoml, dict: nounsDict, words: nouns)
        randomAdjective = randomWord(at: randoml, dict: adjectivesDict, words: adjectives)
        randomPhraseButton.setTitle("\(randomAdjective) \(randomNoun)", for: .normal)
        randomPhraseButton.backgroundColor = UIColor(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: 1)
        randomPhraseButton.titleLabel?.font = UIFont.systemFont(ofSize: 50)
        randomPhraseButton.setTitleColor(UIColor(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: 1), for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateUI()
    }
    
    func countWords(_ words: () -> String) -> Int {
        return words().components(separatedBy: .newlines).count
    }
    
    func makeADict(_ words: () -> String) -> OrderedDictionary<Character, Int> {
        let nounsData = words().components(separatedBy: .newlines)
        var wordsDict: OrderedDictionary<Character, Int> = [:]
        for noun in nounsData {
            if noun.isEmpty {
                continue
            }
            let startChar = noun.index(noun.startIndex, offsetBy: 0)
            let char = noun[startChar]
            if let _ = wordsDict[char] {
                wordsDict[char]! += 1
            } else {
                wordsDict[char] = 1
            }
        }
        return wordsDict
    }
    
    func randomLetter() -> Character {
        return alphabet.randomElement()!
    }
    
    func randomWord(at char: Character, dict: OrderedDictionary<Character, Int>, words: () -> String) -> String {
        var numberWithinLetter = 0
        var total = 0
        var randomInt = 0
        for (letter, count) in dict {
            total += count
            if letter == char {
                randomInt = Int.random(in: numberWithinLetter..<total)
                break
            } else {
                numberWithinLetter += count
            }
        }
        print(words().components(separatedBy: .newlines).count)
        return words().components(separatedBy: .newlines)[randomInt]
    }
}

