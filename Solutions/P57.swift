//
// Project Euler Solutions
// Problem 56: Powerful digit sum
// Jerry Yu
//

import Foundation

func p57() {
	var num = BigInt(n: 3, precision:390), den = BigInt(n: 2, precision:390), count = 0
	for _ in 2...1000 {
		let newNum = num + den*2
		den += num
		num = newNum

		if num.numDigits > den.numDigits { count++ }
	}
	print(count)	// Ans: 153
					// 2013 Air 0.88s

}
