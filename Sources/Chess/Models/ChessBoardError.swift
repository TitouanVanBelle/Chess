//
//  ChessBoardError.swift
//  
//
//  Created by Titouan Van Belle on 09.11.20.
//

import Foundation

public enum InvalidMoveReason: String {
    case unknown = "Unknown reason"
    case moveNotAllowed = "Move is not allowed for this piece"
    case kingInCheck = "King is in check"
    case collisionDetected = "Collision detected"
}

public enum ChessBoardError: Error {
    case invalidPgn(PGN, AlgebraicNotation)
    case invalidMove(InvalidMoveReason)
    case wrongPlayer(PieceColor)
    case boardInUse
    case noVariationAllowed
}

extension ChessBoardError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidPgn(let pgn, let move):
            return "Loaded PGN is invalid. PGN: \(pgn). Invalid move: \(move)"

        case .invalidMove(let reason):
            return "Move is invalid. Reason: \(reason.rawValue)"

        case .wrongPlayer(let actualPlayer):
            return "Wrong player. \(actualPlayer.rawValue) should be playing"

        case .boardInUse:
            return "Board is already loaded with a PGN. Use load(pgn:overwite:) with overwrite set to true to load a new PGN"

        case .noVariationAllowed:
            return "Variation are currently not supported. Load all the moves to move a new piece"
        }
    }
}
