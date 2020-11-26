//
//  KingMovement.swift
//  
//
//  Created by Titouan Van Belle on 10.11.20.
//

import Foundation

struct KingMovement: Movement {
    var allowsCollisions = false
    var allowedMoveDirectionTypes: [DirectionType] = [.straight, .diagonally]
    var allowedTakeDirectionTypes: [DirectionType] = [.straight, .diagonally]

    func isMoveAllowed(for move: Move) -> Bool {
        guard genericIsMoveAllowed(for: move) else {
            return false
        }

        if case .castle(_) = move.kind {
            return true
        }

        guard abs(move.deltaFile) <= 1 && abs(move.deltaRank) <= 1 else {
            return false
        }

        return true
    }

    func isTakeAllowed(for move: Move) -> Bool {
        guard genericIsTakeAllowed(for: move) else {
            return false
        }

        guard abs(move.deltaFile) <= 1 && abs(move.deltaRank) <= 1 else {
            return false
        }

        return true
    }
}
