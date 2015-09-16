//
// Project Euler Solutions
// Problem 56: Powerful digit sum
// Jerry Yu
//

import Foundation

func p56() {
	var ans = 1

	for a in 2..<100 {
		var big = BigInt(n: a)
		for _ in 2..<100 {
			big *= a
			ans = max(ans, big.digitalSum)
		}
	}

	print(ans)	// Ans 972
				// 2013 Air 1.02s
}
