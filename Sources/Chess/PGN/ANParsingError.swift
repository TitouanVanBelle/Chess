//
//  File.swift
//  
//
//  Created by Titouan Van Belle on 11.11.20.
//

import Foundation

enum ANParsingError: Error {
    case invalidAlgebraicNotation(AlgebraicNotation)
}

extension ANParsingError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidAlgebraicNotation(let notation):
            return "Impossible to parse following algebraic notation: \(notation)"
        }
    }
}
