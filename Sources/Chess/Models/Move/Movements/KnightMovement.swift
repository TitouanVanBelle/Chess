//
//  KnightMovement.swift
//  
//
//  Created by Titouan Van Belle on 10.11.20.
//

import Foundation

struct KnightMovement: Movement {
    var allowsCollisions = true
    var allowedMoveDirectionTypes: [DirectionType] = [.knight]
    var allowedTakeDirectionTypes: [DirectionType] = [.knight]
}
