//
//  String+Subscript.swift
//  
//
//  Created by Titouan Van Belle on 09.11.20.
//

import Foundation

extension String {
    subscript (i: Int) -> String {
        self[i ..< i + 1]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(count, r.lowerBound)),
                                            upper: min(count, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        
        return String(self[start ..< end])
    }
}
