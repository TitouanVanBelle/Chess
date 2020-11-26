//
//  File.swift
//  
//
//  Created by Titouan Van Belle on 10.11.20.
//

import Foundation

struct QueenMovement: Movement {
    var allowsCollisions = false
    var allowedMoveDirectionTypes: [DirectionType] = [.straight, .diagonally]
    var allowedTakeDirectionTypes: [DirectionType] = [.straight, .diagonally]
}
