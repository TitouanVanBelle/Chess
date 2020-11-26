//
//  RookMovement.swift
//  
//
//  Created by Titouan Van Belle on 10.11.20.
//

import Foundation

struct RookMovement: Movement {
    var allowsCollisions = false
    var allowedMoveDirectionTypes: [DirectionType] = [.straight]
    var allowedTakeDirectionTypes: [DirectionType] = [.straight]
}
