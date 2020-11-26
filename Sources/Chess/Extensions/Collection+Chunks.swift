//
//  Array+Chunks.swift
//  
//
//  Created by Titouan Van Belle on 09.11.20.
//

import Foundation

extension Collection where Index == Int {
    func chunks(of size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
