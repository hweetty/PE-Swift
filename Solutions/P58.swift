//
// Project Euler Solutions
// Problem 56: Powerful digit sum
// Jerry Yu
//

import Foundation

struct P58: GeneratorType {
	var step = 2
	var ne = 1, nw = 1, sw = 1, se = 1

	mutating func next() -> (Int, Int, Int, Int)? {
		ne += step
		nw += step + 2
		sw += step + 4
		se += step + 6

		step += 8
		return (ne, nw, sw, se)
	}
}

func p58() {
	var corners = P58()
	var count = 0, total = 1
	for i in 1...30000 {
		let a = corners.next()!
		if isPrime(a.0) { count++ }
		if isPrime(a.1) { count++ }
		if isPrime(a.2) { count++ }
		if isPrime(a.3) { count++ }

		total += 4
		if Double(count) / Double(total) < 0.1 {
			print(i*2 + 1)	// Ans: 26241
			return			// 2013 Air 0.72s
		}
	}
}
