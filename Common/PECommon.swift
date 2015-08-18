//
// Common Code for Project Euler solutions
// Version: 2015-08-10
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
