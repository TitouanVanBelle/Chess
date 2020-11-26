//
//  Regex.swift
//  
//
//  Created by Titouan Van Belle on 09.11.20.
//

import Foundation

struct Regex: ExpressibleByStringLiteral, Equatable {

    fileprivate let expression: NSRegularExpression

    init(stringLiteral: String) {
        do {
            expression = try NSRegularExpression(pattern: stringLiteral, options: [])
        } catch {
            expression = try! NSRegularExpression(pattern: ".*", options: [])
        }
    }

    fileprivate func match(_ input: String) -> Bool {
        let result = expression.rangeOfFirstMatch(in: input, options: [],
                                                  range: NSRange(input.startIndex..., in: input))
        return !NSEqualRanges(result, NSMakeRange(NSNotFound, 0))
    }
}

extension Regex {
    static func ~=(pattern: Regex, value: String) -> Bool {
        pattern.match(value)
    }
}

extension String {
    static func ~=(value: String, pattern: Regex) -> Bool {
        pattern.match(value)
    }
}
