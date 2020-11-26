//
//  BishopMovement.swift
//  
//
//  Created by Titouan Van Belle on 10.11.20.
//

import Foundation

struct BishopMovement: Movement {
    var allowsCollisions = false
    var allowedMoveDirectionTypes: [DirectionType] = [.diagonally]
    var allowedTakeDirectionTypes: [DirectionType] = [.diagonally]
}
