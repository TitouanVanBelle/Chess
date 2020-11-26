//
//  Location.swift
//  Chess
//
//  Created by Titouan Van Belle on 01.10.19.
//  Copyright © 2019 Titouan Van Belle. All rights reserved.
//

import Foundation

public struct Location {
    public let index: Int
    public let rank: Rank
    public let file: File

    init(file: File, rank: Rank) {
        self.rank = rank
        self.file = file
        self.index = (rank.rawValue * 8) + file.rawValue
    }

    init?(index: Int) {
        guard index >= 0, index < 64 else {
            return nil
        }

        guard let rank = Rank(rawValue: index / 8) else {
            return nil
        }

        guard let file = File(rawValue: index % 8) else {
            return nil
        }

        self.index = index
        self.rank = rank
        self.file = file
    }
}

extension Location: Hashable {}

extension Location {
    init?(notation: AlgebraicNotation) {
        guard let fileChar = notation.first,
            let rankChar = notation.last else {
                return nil
        }

        let fileValue = String(fileChar)
        let rankValue = String(rankChar)

        guard let rank = Rank(notation: rankValue) else {
            return nil
        }

        guard let file = File(notation: fileValue) else {
            return nil
        }

        self.init(file: file, rank: rank)
    }

    func afterApplying(vector: Vector) -> Location? {
        let fileValue = file.rawValue + vector.deltaFile
        let rankValue = rank.rawValue + vector.deltaRank

        guard let file = File(rawValue: fileValue) else {
            return nil
        }

        guard let rank = Rank(rawValue: rankValue) else {
            return nil
        }

        return Location(file: file, rank: rank)
    }
}

extension Location: ANNotable {
    public var notation: AlgebraicNotation {
        "\(file.notation)\(rank.notation)"
    }
}

extension Location: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.index == rhs.index
    }
}
