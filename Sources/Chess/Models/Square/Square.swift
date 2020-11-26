//
//  Square.swift
//  Chess
//
//  Created by Titouan Van Belle on 01.10.19.
//  Copyright © 2019 Titouan Van Belle. All rights reserved.
//

import Foundation

public struct Square {
    public let location: Location
    public var piece: Piece?
}

extension Square: Hashable {}

extension Square {
    var file: File {
        location.file
    }

    var rank: Rank {
        location.rank
    }

    var hasPiece: Bool {
        piece != nil
    }

    var unicode: String {
        piece?.unicode ?? " "
    }

    func isPromotionSquare(for color: PieceColor) -> Bool {
        rank.isLastRank(for: color)
    }

    func isEnPassantStartingSquare(for color: PieceColor) -> Bool {
        rank.isEnPassantStartingRank(for: color)
    }
}

extension Square: ANNotable {
    public var notation: AlgebraicNotation {
        location.notation
    }
}
