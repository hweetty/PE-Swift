//
// Project Euler Solutions
// Problem 55: Lychrel numbers
// Jerry Yu
//

import Foundation

func p55(n: Int = 10000) {
	var count = 0
	for i in 1..<n {
		if recurse(Double(i), 1) { count++ }
	}

	println(count)	// AnsL 249
					// 2013 Air 0.017s
}

// Returns true if n is Lychrel number
func recurse(n: Double, iteration: Int) -> Bool {
	if iteration > 50 { return true } // Assume will not take more than 50 iterations to find palindromic

	let rev = reverse(n)
	let pal = rev + n
	if pal == reverse(pal) { return false }
	return recurse(pal, iteration+1)
}

func reverse(var n: Double) -> Double {
	var rev: Double = 0
	while (n > 0) {
		rev = rev*10 + n%10
		n = floor(n/10)
	}
	return rev
}
