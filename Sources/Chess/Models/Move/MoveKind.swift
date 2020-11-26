//
//  MoveType.swift
//  Chess
//
//  Created by Titouan Van Belle on 14.10.19.
//  Copyright © 2019 Titouan Van Belle. All rights reserved.
//

import Foundation

public enum MoveKind {
    case move
    case enPassant
    case capture
    case castle(CastleSide)
}

extension MoveKind: Equatable {}
