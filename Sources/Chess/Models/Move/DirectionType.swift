//
//  DirectionType.swift
//  Chess
//
//  Created by Titouan Van Belle on 14.10.19.
//  Copyright © 2019 Titouan Van Belle. All rights reserved.
//

import Foundation

public enum DirectionType {
    case straight
    case diagonally
    case knight

    init?(vector: Vector) {
        guard vector.deltaFile != 0 || vector.deltaRank != 0 else {
            return nil
        }

        if vector.deltaFile == 0 || vector.deltaRank == 0 {
            self = .straight
        } else if abs(vector.deltaFile) == abs(vector.deltaRank) {
            self = .diagonally
        } else if abs(vector.deltaFile) + abs(vector.deltaRank) == 3 {
            self = .knight
        } else {
            return nil
        }
    }

    var vectors: [Vector] {
        var vectorValues: [(Int, Int)]
        switch self {
        case .knight:
            vectorValues = [
                (1, 2),
                (1, -2),
                (-1, 2),
                (-1, -2),
                (2, 1),
                (2, -1),
                (-2, 1),
                (-2, -1)
            ]
        case .straight:
            vectorValues = [
                (0, 1),
                (0, -1),
                (1, 0),
                (-1, 0)
            ]
        case .diagonally:
            vectorValues = [
                (1, 1),
                (1, -1),
                (-1, 1),
                (-1, -1)
            ]
        }

        return vectorValues
            .map(Vector.init)
    }
}
