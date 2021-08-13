//
//  File.swift
//  
//
//  Created by Titouan Van Belle on 13.08.21.
//

import Foundation

protocol EnPassantDetectorProtocol {
    func isEnPassantPossible(
        from fromSquare: Square,
        to toSquare: Square,
        in board: ChessBoardProtocol
    ) -> Bool
}

final class EnPassantDetector: EnPassantDetectorProtocol {
    func isEnPassantPossible(
        from fromSquare: Square,
        to toSquare: Square,
        in board: ChessBoardProtocol
    ) -> Bool {
        guard let fromPiece = fromSquare.piece,
              fromPiece.kind == .pawn,
              !toSquare.hasPiece else {
            return false
        }

        guard let previousMove = board.moves.last else {
            return false
        }

        let file = toSquare.file
        guard let fromRank = toSquare.rank.previous(for: fromPiece.color.next),
              let toRank = toSquare.rank.next(for: fromPiece.color.next) else {
            return false
        }

        let fromLocation = Location(file: file, rank: fromRank)
        let toLocation = Location(file: file, rank: toRank)

        guard previousMove.fromSquare.location == fromLocation,
              previousMove.toSquare.location == toLocation else {
            return false
        }

        return true
    }
}
