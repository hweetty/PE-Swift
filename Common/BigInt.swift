//
//  BigInt.swift
//  PE-Swift
//
//  Created by Jerry Yu on 2015-09-16.
//  Copyright © 2015 Jerry Yu. All rights reserved.
//

import Foundation


struct BigInt: CustomStringConvertible {
	var digits: [UInt8] // Digits are flipped
	init(var n: Int = 0, precision: Int = 200) {
		precondition(n>=0, "Currently only positive numbers are supported")
		self.digits = [UInt8](count: precision, repeatedValue: 0)

		var i = 0
		while n > 0 {
			digits[i++] = UInt8(n % 10)
			n /= 10
		}
	}
	init(digits: [UInt8]) {
		self.digits = digits
	}

	var description: String {
		var str = ""
		var shouldAppend = false
		for v in digits.reverse() {
			if v > 0 { shouldAppend = true }
			if shouldAppend { str = "\(str)\(v)" }
		}
		return str
	}

	// Returns the sum of each individual digit
	var digitalSum: Int {
		return self.digits.reduce(0){ $0 + Int($1) }
	}

	// Returns the number of digits
	var numDigits: Int {
		var count = 0
		var started = false
		for v in digits.reverse() {
			if v > 0 { started = true }
			if started { count++ }
		}
		return count
	}
}

func * (lhs: BigInt, n: Int) -> BigInt {
	var carry = 0
	var digits = lhs.digits
	for i in 0..<digits.count {
		carry += Int(digits[i]) * n
		digits[i] = UInt8(carry % 10)
		carry /= 10
	}
	return BigInt(digits: digits)
}
func * (n: Int, lhs: BigInt) -> BigInt { return lhs * n }
func *= (inout lhs: BigInt, n: Int) { lhs = lhs * n }

func + (lhs: BigInt, rhs: BigInt) -> BigInt {
	var carry: UInt8 = 0
	var d1 = lhs.digits, d2 = rhs.digits
	for i in 0..<d1.count {
		carry += d1[i] + d2[i]
		d1[i] = carry % 10
		carry /= 10
	}
	return BigInt(digits: d1)
}
func += (inout lhs: BigInt, rhs: BigInt) { lhs = lhs + rhs }
