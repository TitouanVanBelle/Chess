//
//  MoveProtocol.swift
//  Chess
//
//  Created by Titouan Van Belle on 09/11/2019.
//  Copyright © 2019 Titouan Van Belle. All rights reserved.
//

import Foundation

public struct Move {
    public let player: PieceColor
    public let fromSquare: Square
    public let toSquare: Square
    public let kind: MoveKind
    public let capturedSquare: Square?
    public let promotion: Promotion?

    let directionType: DirectionType

    init(
        fromSquare: Square,
        toSquare: Square,
        kind: MoveKind,
        directionType: DirectionType,
        capturedSquare: Square? = nil,
        promotion: Promotion? = nil
    ) {
        self.player = fromSquare.piece!.color
        self.fromSquare = fromSquare
        self.toSquare = toSquare
        self.kind = kind
        self.directionType = directionType
        self.capturedSquare = capturedSquare
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
