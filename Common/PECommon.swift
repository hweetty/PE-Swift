//
// Common Code for Project Euler solutions
// Version: 2015-08-21
// Jerry Yu
//

import Foundation

// Returns a pair of arrays (A, B)
// A is an array of primes <n
// B is a lookup array of primality
public func primesLessThan(n: Int) -> (primes: [Int], lookup: [Bool]) {
    if n <= 1 { return ([], []) }

    var isPrime = [Bool](count: n, repeatedValue: true)
    isPrime[0] = false; isPrime[1] = false

    let s = Int( sqrt(Float(n)) ) // Seriously swift?
    for i in 2..<s {
        if isPrime[i] {
            for var j = i*2; j < n; j += i {
                isPrime[j] = false
            }
        }
    }

    var primes = [Int]()
    for (i, v) in enumerate(isPrime) {
        if v {
            primes.append(i)
        }
    }

    return (primes, isPrime)
}


// MARK: Extensions

// Foreach for arrays: http://nicemohawk.com/blog/2014/09/adding-foreach-to-swift-arrays/
extension Array {
	func forEach(doThis: (element: T) -> Void) {
		for e in self {
			doThis(element: e)
		}
	}
}

// Adding map and filter to Dictionary: http://stackoverflow.com/a/24219069
extension Dictionary {
	init(_ pairs: [Element]) {
		self.init()
		for (k, v) in pairs {
			self[k] = v
		}
	}

	func map<OutKey: Hashable, OutValue>(transform: Element -> (OutKey, OutValue)) -> [OutKey: OutValue] {
		return Dictionary<OutKey, OutValue>(Swift.map(self, transform))
	}

	func filter(includeElement: Element -> Bool) -> [Key: Value] {
		return Dictionary(Swift.filter(self, includeElement))
	}
}
