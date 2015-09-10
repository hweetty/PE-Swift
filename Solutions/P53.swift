//
// Project Euler Solutions
// Problem 53: Combinatoric selections
// Jerry Yu
//

import Foundation

// Construct Pascal's triangle
func p53(cutoff: Int = 1000000) {
	var tri = Array<Int>(count: 102, repeatedValue: 0)
	tri[0] = 1
	var count = 0

	for row in 1...100 {
		var prev = tri[0] // Store the previous value since it will be overwritten
		for col in 1...row {
			let temp = prev + tri[col]
			prev = tri[col]

			if temp < cutoff {
				tri[col] = temp
			} else {
				tri[col] = cutoff; // Store the cutoff value to prevent overflow (we don't need the exact value)
				count++
			}
		}
	}

	print(count)	// Ans: 4075
					// 2013 Air 0.0050s
}
