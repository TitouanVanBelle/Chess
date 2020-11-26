//
//  MoveProtocol.swift
//  Chess
//
//  Created by Titouan Van Belle on 09/11/2019.
//  Copyright © 2019 Titouan Van Belle. All rights reserved.
//

import Foundation

public struct Move {
    let player: PieceColor
    let fromSquare: Square
    let toSquare: Square
    let directionType: DirectionType
    let kind: MoveKind
    let capturedPiece: Piece?
    let promotion: Promotion?

    init(
        fromSquare: Square,
        toSquare: Square,
        kind: MoveKind,
        directionType: DirectionType,
        capturedPiece: Piece? = nil,
        promotion: Promotion? = nil
    ) {
        self.player = fromSquare.piece!.color
        self.fromSquare = fromSquare
        self.toSquare = toSquare
        self.kind = kind
        self.directionType = directionType
        self.capturedPiece = capturedPiece
        self.promotion = promotion
    }
}

extension Move {
    var requiresPromotion: Bool {
        piece.kind == .pawn && toSquare.isPromotionSquare(for: piece.color)
    }

    var piece: Piece {
        guard let piece = fromSquare.piece else {
            fatalError("A move should always have a piece on its fromSquare")
        }

        return piece
    }

    var vector: Vector {
        Vector(fromSquare: fromSquare, toSquare: toSquare)
    }

    var deltaFile: Int {
        vector.deltaFile
    }

    var deltaRank: Int {
        vector.deltaRank
    }

    var isAllowed: Bool {
        switch kind {
        case .move:
            return piece.movement.isMoveAllowed(for: self)

        case .capture:
            return toSquare.piece!.isCapturable && piece.movement.isTakeAllowed(for: self)

        case .castle:
            return piece.movement.isMoveAllowed(for: self)

        case .enPassant:
            return piece.movement.isTakeAllowed(for: self)
        }
    }
}
