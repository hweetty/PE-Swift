//
// Project Euler Solutions
// Problem 50: Consecutive prime sum
// Jerry Yu
//


// Sum consecutive primes by adding the next prime and subtracting the
// leftmost (so we are always summing `m` consecutive primes).
// Trick is to always check the make sure sum is below n.
func p50(n: Int = 1000000) {
    let (primes, lookup) = primesLessThan(n)
    let q = primes.count

    // Sum consecutive primes, try longest length first
    var m = 0, firstSum = 0
    for ; m <= q && firstSum < n; m++ {
        firstSum += primes[m]
    }

    for m = m-1; m >= 2; m-- {
        firstSum -= primes[m]
        var sum = firstSum
        if sum >= n { continue }

        for i in m..<q {
            // Sum, check, then subtract
            sum += primes[i]

            if sum >= n { break }
            else if lookup[sum] {
                print(sum)		// Ans: 997651
                return			// 2013 Air 1.2s
            }
            sum -= primes[i-m]
        }
    }
}
