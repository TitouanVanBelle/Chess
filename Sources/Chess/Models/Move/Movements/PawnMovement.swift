//
//  PawnMovement.swift
//  
//
//  Created by Titouan Van Belle on 10.11.20.
//

import Foundation

struct PawnMovement: Movement {
    var allowsCollisions = false
    var allowedMoveDirectionTypes: [DirectionType] = [.straight]
    var allowedTakeDirectionTypes: [DirectionType] = [.diagonally]

    func isMoveAllowed(for move: Move) -> Bool {
        guard genericIsMoveAllowed(for: move) else {
            return false
        }

        if move.piece.color == .white && move.deltaRank < 1 {
            return false
        }

        if move.piece.color == .black && move.deltaRank > -1 {
            return false
        }

        if move.piece.hasMoved && abs(move.deltaRank) > 1 {
            return false
        }

        if !move.piece.hasMoved && abs(move.deltaRank) > 2 {
            return false
        }

        return true
    }

    func isTakeAllowed(for move: Move) -> Bool {
        guard genericIsTakeAllowed(for: move) else {
            return false
        }

        guard abs(move.deltaFile) == 1 else {
            return false
        }

        guard (move.deltaRank == 1 && move.piece.color == .white) ||
              (move.deltaRank == -1 && move.piece.color == .black) else {
            return false
        }

        return true
    }
}
