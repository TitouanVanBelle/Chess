//
//  PieceProtocol.swift
//  Chess
//
//  Created by Titouan Van Belle on 09/11/2019.
//  Copyright © 2019 Titouan Van Belle. All rights reserved.
//

import Foundation

public struct Piece {
    let kind: PieceKind
    let color: PieceColor
    let initialLocation: Location
    var location: Location

    init(kind: PieceKind, color: PieceColor, initialLocation: Location) {
        self.kind = kind
        self.color = color
        self.initialLocation = initialLocation
        self.location = initialLocation
    }
}

extension Piece: Hashable {}

extension Piece : ANNotable {
    public var notation: AlgebraicNotation {
        kind.notation
    }
}

extension Piece {
    var hasMoved: Bool {
        initialLocation != location
    }

    var isCapturable: Bool {
        kind != .king
    }

    var movement: Movement {
        kind.movement
    }

    var hasInfiniteAttackingRange: Bool {
        kind != .pawn
            && kind != .knight
            && kind != .king
    }

    var unicode: String {
        let string: String
        switch kind {
        case .pawn:
            string = color == .black ? "U+2659" : "U+265F"
        case .rook:
            string = color == .black ? "U+2656" : "U+265C"
        case .bishop:
            string = color == .black ? "U+2657" : "U+265D"
        case .knight:
            string = color == .black ? "U+2658" : "U+265E"
        case .king:
            string = color == .black ? "U+2654" : "U+265A"
        case .queen:
            string = color == .black ? "U+2655" : "U+265B"

        }

        return string.applyingTransform(StringTransform("Hex/Unicode"), reverse: true)!
    }

    func promoted(to newKind: PieceKind) -> Piece {
        guard kind == .pawn else { return self }
        guard newKind != .king else { return self }

        var promotedPiece = Piece(kind: newKind, color: color, initialLocation: initialLocation)
        promotedPiece.location = location
        return promotedPiece
    }
}

