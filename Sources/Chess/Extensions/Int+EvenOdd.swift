//
//  Int+EvenOdd.swift
//  
//
//  Created by Titouan Van Belle on 09.11.20.
//

import Foundation

extension Int {
    var isEven: Bool {
        self % 2 == 0
    }

    var isOdd: Bool {
        !isEven
    }
}
