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

	var digitalSum: Int {
		return self.digits.reduce(0){ $0 + Int($1) }
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

func *= (inout lhs: BigInt, n: Int) {
	lhs = lhs * n
}
