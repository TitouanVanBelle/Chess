//
//  ChessBoardError.swift
//  
//
//  Created by Titouan Van Belle on 09.11.20.
//

import Foundation

public enum InvalidMoveReason {
    case unknown
    case moveNotAllowed
    case kingInCheck(Square)
    case collisionDetected

    var localizedReason: String {
        switch self {
        case .unknown:
            return "Unknown reason"

        case .moveNotAllowed:
            return "Move is not allowed for this piece"

        case .kingInCheck(let square):
            return "King is in check in \(square.location.notation)"

        case .collisionDetected:
            return "Collision detected"
        }
    }
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
            return "Move is invalid. Reason: \(reason.localizedReason)"

        case .wrongPlayer(let actualPlayer):
            return "Wrong player. \(actualPlayer.rawValue) should be playing"

        case .boardInUse:
            return "Board is already loaded with a PGN. Use load(pgn:overwite:) with overwrite set to true to load a new PGN"

        case .noVariationAllowed:
            return "Variation are currently not supported. Load all the moves to move a new piece"
        }
    }
}
