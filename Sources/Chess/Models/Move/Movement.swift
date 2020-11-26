//
//  Movement.swift
//  Chess
//
//  Created by Titouan Van Belle on 01.10.19.
//  Copyright © 2019 Titouan Van Belle. All rights reserved.
//

import Foundation

protocol Movement {
    var allowedMoveDirectionTypes: [DirectionType] { get set }
    var allowedTakeDirectionTypes: [DirectionType] { get set }
    var allowsCollisions: Bool { get set }

    func isMoveAllowed(for move: Move) -> Bool
    func isTakeAllowed(for move: Move) -> Bool
}

extension Movement {
    func isMoveAllowed(for move: Move) -> Bool {
        genericIsMoveAllowed(for: move)
    }

    func isTakeAllowed(for move: Move) -> Bool {
        genericIsTakeAllowed(for: move)
    }

    func genericIsMoveAllowed(for move: Move) -> Bool {
        guard allowedMoveDirectionTypes.contains(move.directionType) else {
            return false
        }

        return true
    }

    func genericIsTakeAllowed(for move: Move) -> Bool {
        guard allowedTakeDirectionTypes.contains(move.directionType) else {
            return false
        }

        return true
    }
}

