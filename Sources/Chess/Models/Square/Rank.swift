//
//  Rank.swift
//  Chess
//
//  Created by Titouan Van Belle on 09/11/2019.
//  Copyright © 2019 Titouan Van Belle. All rights reserved.
//

import Foundation

public enum Rank: Int, ANNotable {
    case one = 0
    case two = 1
    case three = 2
    case four = 3
    case five = 4
    case six = 5
    case seven = 6
    case eight = 7

    init?(notation: AlgebraicNotation) {
        switch notation {
        case "1": self = .one
        case "2": self = .two
        case "3": self = .three
        case "4": self = .four
        case "5": self = .five
        case "6": self = .six
        case "7": self = .seven
        case "8": self = .eight
        default: return nil
        }
    }

    public var notation: AlgebraicNotation {
        switch self {
        case .one: return "1"
        case .two: return "2"
        case .three: return "3"
        case .four: return "4"
        case .five: return "5"
        case .six: return "6"
        case .seven: return "7"
        case .eight: return "8"
        }
    }

    var previousRankForWhite: Rank? {
        switch self {
        case .one: return nil
        case .two: return .one
        case .three: return .two
        case .four: return .three
        case .five: return .four
        case .six: return .five
        case .seven: return .six
        case .eight: return .seven
        }
    }

    var previousRankForBlack: Rank? {
        switch self {
        case .one: return .two
        case .two: return .three
        case .three: return .four
        case .four: return .five
        case .five: return .six
        case .six: return .seven
        case .seven: return .eight
        case .eight: return nil
        }
    }

    func previous(for color: PieceColor) -> Rank? {
        switch color {
        case .white: return previousRankForWhite
        case .black: return previousRankForBlack
        }
    }

    func next(for color: PieceColor) -> Rank? {
        switch color {
        case .white: return previousRankForBlack
        case .black: return previousRankForWhite
        }
    }

    func isLastRank(for color: PieceColor) -> Bool {
        (self == .eight && color == .white)
            || (self == .one && color == .black)
    }

    func isEnPassantStartingRank(for color: PieceColor) -> Bool {
        (self == .five && color == .white)
            || (self == .four && color == .black)
    }
}
