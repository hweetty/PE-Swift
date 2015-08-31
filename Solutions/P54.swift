//
// Project Euler Solutions
// Problem 54: Poker hands
// Jerry Yu
//

import Foundation

enum Rank: Int {
	case HighCard = 1,
	OnePair,
	TwoPair,
	ThreeOfAKind,
	Straight,
	Flush,
	FullHouse,
	FourOfAKind,
	StraightFlush // Royal Flush is just a special case of Straight Flush
}

enum Suit: Int {
	case Diamond = 0, Club,	Heart, Spade
}

func p54(filename: String = "p054_poker.txt") {
	// Set working directory in XCode scheme settings: http://stackoverflow.com/a/15537436
	let path = NSFileManager.defaultManager().currentDirectoryPath.stringByAppendingPathComponent(filename)
	let poker = String(contentsOfFile: path, encoding: NSUTF8StringEncoding, error: nil)!
	let hands = poker.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())

	var wins = 0 // # of Player 1 wins
	var gen = hands.generate()
	for i in 0..<hands.count / 10 {
		let p1 = Hand(gen: &gen), p2 = Hand(gen: &gen)
		if p1 > p2 { wins++ }
	}

	println(wins)
}

// If comparison is required multiple times, it may be better to convert the rank
// of each hand to a value, which can then trivially be compared in constant time
// This thing kicks: https://github.com/eljefeo/DeadHorseEval
func > (left: Hand, right: Hand) -> Bool {
	if left.highestRank.rawValue > right.highestRank.rawValue { return true }
	if left.highestRank == right.highestRank {
		if left.highCardInRank > right.highCardInRank { return true }
		if left.highCardInRank == right.highCardInRank {
			// This should happen only if Rank is <= ThreeOfAKind
			precondition(left.highestRank.rawValue <= Rank.ThreeOfAKind.rawValue, "Rank is actually \(left.highestRank.rawValue)")
			let c1 = left.cards.filter{ return $0 != left.highCardInRank }
			let c2 = right.cards.filter{ return $0 != right.highCardInRank }
			precondition(c1.count == c2.count, "# of other cards not the same: \(c1.count) vs. \(c2.count)")
			for (i, v) in enumerate(c1) {
				if v > c2[i] { return true }
				if v < c2[i] { return false }
			}
		}
	}

	return false
}

struct Hand {
	var cards = Array<Int>() // Sorted array of cards
	var values = Array<Int>(count: 15, repeatedValue: 0) // Index starts at one
	var suits = Array<Int>(count: 4, repeatedValue: 0)
	var highestRank = Rank.HighCard
	var highCardInRank = 0
	var highCard = 0

	init(inout gen: IndexingGenerator<Array<String>>) {
		for i in 0..<5 {
			let c = Card(str: gen.next()!)
			values[c.value]++
			suits[c.suit.rawValue]++
			cards.append(c.value)
		}
		cards.sort(>)

		let hasFlush = suits.reduce(false) { return $0 || $1 == 5 }

		// Check straight
		var highestStraight = 15+4, straightCounter = 0
		for i in reverse(2...14) {
			if values[i] > 0 { straightCounter++ }
			else { straightCounter = 0 }

			highestStraight--
			if straightCounter == 5 { break }
		}
		// Check straight with Ace to 5
		if straightCounter == 4 && values[14] >= 1 { straightCounter = 5; highestStraight = 5 }
		let hasStraight = straightCounter==5

		if hasStraight && hasFlush {
			self.highestRank = .StraightFlush
			self.highCardInRank = highestStraight
			return
		}

		let fourOfAKind = Array(enumerate(values)).reduce(0) { return $1.1==4 ?  $1.0:$0 } // Get the card value
		if fourOfAKind > 0 {
			self.highestRank = .FourOfAKind
			self.highCardInRank = fourOfAKind
			// Find the leftover high card
			self.highCard = Array(enumerate(values)).reduce(0) { return $1.1 == 1 ?  $1.0:$0 }
			return
		}

		// Prepare to check full house, triples, pairs...
		var pairs = Array<Int>(), triples = Array<Int>()
		for (i, v) in enumerate(values) {
			if v == 2 { pairs.append(i) }
			else if v == 3 { triples.append(i) }
		}
		precondition(pairs.count <= 2 && triples.count <= 1, "Pairs: \(pairs), triples: \(triples)")

		// Full house
		if pairs.count == 1 && triples.count == 1 {
			self.highestRank = .FullHouse
			self.highCardInRank = triples[0]
			self.highCard = pairs[0]
			return
		}

		// Flush/straight
		if hasFlush { self.highestRank = .Flush }
		else if hasStraight { self.highestRank = .Straight }
		if hasFlush || hasStraight {
			self.highCardInRank = Array(enumerate(values)).reduce(0) { return $1.1==1 ?  $1.0:$0 } // Get highest card
			return
		}

		// Rest
		if triples.count == 1 {
			self.highestRank = .ThreeOfAKind
			self.highCardInRank = triples[0]
			self.highCard = Array(enumerate(values)).reduce(0) { return ($1.1>=1 && $1.1 != 3) ?  $1.0:$0 } // Get highest card
		} else if pairs.count == 2 {
			self.highestRank = .TwoPair
			self.highCardInRank = max(pairs[0], pairs[1])
			self.highCard = Array(enumerate(values)).reduce(0) { return $1.1==1 ?  $1.0:$0 } // Get highest card
		} else if pairs.count == 1 {
			self.highestRank = .OnePair
			self.highCardInRank = pairs[0]
			// Get highest card not used in rank
			self.highCard = Array(enumerate(values)).reduce(0) { return ($1.1>=1 && $1.0 != pairs[0]) ?  $1.0:$0 }
		} else {
			self.highestRank = .HighCard
			self.highCardInRank = Array(enumerate(values)).reduce(0) { return $1.1==1 ?  $1.0:$0 } // Get highest card
		}
	}
}

struct Card {
	var value: Int
	var suit: Suit
	init(str: String) {
		let lookupA: [Character: Int] = ["2":2, "3":3, "4":4, "5":5, "6":6, "7":7, "8":8, "9":9, "T":10, "J":11, "Q":12, "K":13, "A":14]
		let lookupB: [Character: Suit] = ["D": .Diamond, "C": .Club, "H": .Heart, "S": .Spade]

		self.value = lookupA[str[0]]!
		self.suit = lookupB[str[1]]!
	}
}
