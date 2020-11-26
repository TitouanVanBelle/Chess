//
//  File.swift
//  Chess
//
//  Created by Titouan Van Belle on 09/11/2019.
//  Copyright © 2019 Titouan Van Belle. All rights reserved.
//

import Foundation

public enum File: Int, ANNotable {
    case a = 0
    case b = 1
    case c = 2
    case d = 3
    case e = 4
    case f = 5
    case g = 6
    case h = 7

    init?(notation: AlgebraicNotation) {
        switch notation {
        case "a": self = .a
        case "b": self = .b
        case "c": self = .c
        case "d": self = .d
        case "e": self = .e
        case "f": self = .f
        case "g": self = .g
        case "h": self = .h
        default: return nil
        }
    }

    public var notation: AlgebraicNotation {
        switch self {
        case .a: return "a"
        case .b: return "b"
        case .c: return "c"
        case .d: return "d"
        case .e: return "e"
        case .f: return "f"
        case .g: return "g"
        case .h: return "h"
        }
    }
}
