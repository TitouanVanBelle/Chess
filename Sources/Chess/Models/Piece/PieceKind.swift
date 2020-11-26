//
//  PieceKind.swift
//  Chess
//
//  Created by Titouan Van Belle on 15.10.19.
//  Copyright © 2019 Titouan Van Belle. All rights reserved.
//

import Foundation

public enum PieceKind: Int, Codable, ANNotable {
    case pawn = 5
    case rook = 1
    case king = 4
    case queen = 2
    case knight = 3
    case bishop = 0

    public var value: Int {
        switch self {
        case .pawn: return 1
        case .rook: return 5
        case .king: return 0
        case .queen: return 9
        case .knight: return 3
        case .bishop: return 3
        }
    }

    public var name: String {
        switch self {
        case .pawn: return "Pawn"
        case .rook: return "Rook"
        case .king: return "King"
        case .queen: return "Queen"
        case .knight: return "Knight"
        case .bishop: return "Bishop"
        }
    }

    public var notation: AlgebraicNotation {
        switch self {
        case .pawn: return ""
        case .rook: return "R"
        case .king: return "K"
        case .queen: return "Q"
        case .knight: return "N"
        case .bishop: return "B"
        }
    }

    init?(notation: AlgebraicNotation) {
        switch notation {
        case "Q": self = .queen
        case "K": self = .king
        case "N": self = .knight
        case "B": self = .bishop
        case "R": self = .rook
        default: return nil
        }
    }
}

extension PieceKind {
    var movement: Movement {
        switch self {
        case .pawn: return PawnMovement()
        case .rook: return RookMovement()
        case .king: return KingMovement()
        case .queen: return QueenMovement()
        case .knight: return KnightMovement()
        case .bishop: return BishopMovement()
        }
    }
}
