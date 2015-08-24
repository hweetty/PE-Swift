//
// Project Euler Solutions
// Problem 52: Permuted multiples
// Jerry Yu
//

import Foundation

func p52() {
	var i = 125874
	while true {
		if check(i) {
			println(i)	// Ans: 142857
			return		// 2013 Air 0.35s
		}
		i++
	}
}

func check(num: Int) -> Bool {
	// First store the digits of the base number
	var digits = Set<Int>()
	var n = num
	while (n > 0) {
		let d = n%10
		if digits.contains(d) { return false } // Assume unique digits
		digits.insert(d)
		n /= 10
	}

	for x in 2...6 {
		var n = num*x
		var remaingDigits = digits
		while (n > 0) {
			let d = n%10
			if remaingDigits.contains(d) == false { return false } // Return if digit not available
			remaingDigits.remove(d)
			n /= 10
		}
	}

	return true
}
