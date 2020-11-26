//
//  Vector.swift
//  Chess
//
//  Created by Titouan Van Belle on 14.10.19.
//  Copyright © 2019 Titouan Van Belle. All rights reserved.
//

import Foundation

struct Vector {
    let deltaFile: Int
    let deltaRank: Int

    init(deltaFile: Int, deltaRank: Int) {
        self.deltaFile = deltaFile
        self.deltaRank = deltaRank
    }

    init(fromSquare: Square, toSquare: Square) {
        self.init(
            deltaFile: toSquare.file.rawValue - fromSquare.file.rawValue,
            deltaRank: toSquare.rank.rawValue - fromSquare.rank.rawValue
        )
    }
}

extension Vector: Hashable {
    static func == (lhs: Vector, rhs: Vector) -> Bool {
        lhs.deltaFile == rhs.deltaFile
            && lhs.deltaRank == rhs.deltaRank
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(deltaRank)
        hasher.combine(deltaFile)
    }
}
