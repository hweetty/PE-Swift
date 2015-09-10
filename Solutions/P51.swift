//
// Project Euler Solutions
// Problem 51: Prime digit replacements
// Jerry Yu
//

import Foundation

// For each range of primes with `m` digits, inspect those that contain
// repeating digits and test if has family of size 8.
func p51(familySize: Int = 8) {
    let n =  10000000
    let (primes, lookup) = primesLessThan(n)
	var power = 10
	var m = 1 // Number of digits
	var i = 0 // Used enumerate primes

	while power < n {
		var dict = Dictionary< String, Set<Int> >()

		while (i < primes.count && primes[i] <= power) {
			var p = primes[i]
			var set = Set<Int>()
			// Assume the correct prime will have at least two digits replaced (>= 2 digits the same)
			var commonDigit = -1
			for j in 0...m {
				let d = p%10
				if set.contains(d) { commonDigit = d }
				set.insert(d)
				p /= 10
			}
			if set.count < m {
				let d = primes[i]%10

				set.remove(commonDigit)
				let str = String(primes[i]).stringByReplacingOccurrencesOfString("\(commonDigit)", withString: "x")
				if dict[str] == nil { dict[str] = Set<Int>() }
				dict[str]!.insert(primes[i])

				// Check the other digits
				for digit in set {
					let numStr = str.stringByReplacingOccurrencesOfString("x", withString: "\(digit)")
					let num = Int(numStr)!
					if lookup[num] { dict[str]!.insert(num) }
				}
			}
			i++
		}
		m++

		let min = power / 10
		let potentials = dict.filter{ return $1.count >= familySize && Array($1).filter{ $0 >= min }.count >= familySize }

		var ans = Int.max
		for v in potentials {
			ans = Array(v.1).reduce(ans, combine: { return Swift.min($0, $1) })
		}
		if ans != Int.max {
			print(ans)		// Ans: 121313
			return			// 2013 Air 19s
		}

		power *= 10
	}
}
