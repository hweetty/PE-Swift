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

	var primes = [Int]()
    var isPrime = [Bool](count: n, repeatedValue: true)
    isPrime[0] = false; isPrime[1] = false

    let s = Int( sqrt(Float(n)) ) // Seriously swift?
    for i in 2..<s {
        if isPrime[i] {
			primes.append(i)
            for var j = i*2; j < n; j += i {
                isPrime[j] = false
            }
        }
    }

	// Count the primes between [sqrt(n) < n]
	for i in s..<n {
		if isPrime[i] { primes.append(i) }
	}

    return (primes, isPrime)
}


// MARK: Extensions

// Foreach for arrays: http://nicemohawk.com/blog/2014/09/adding-foreach-to-swift-arrays/
extension Array {
	func forEach(doThis: (element: Element) -> Void) {
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
		return Dictionary<OutKey, OutValue>(self.map(transform))
	}

	func filter(includeElement: Element -> Bool) -> [Key: Value] {
		return Dictionary(self.filter(includeElement))
	}
}

// Subscript access String: http://oleb.net/blog/2014/07/swift-strings/
extension String
{
	subscript(integerIndex: Int) -> Character
		{
			let index = startIndex.advancedBy(integerIndex)
			return self[index]

	}
	subscript(integerRange: Range<Int>) -> String
		{
			let start = startIndex.advancedBy(integerRange.startIndex)
			let end = startIndex.advancedBy(integerRange.endIndex)
			let range = start..<end
			return self[range]
	}
}
