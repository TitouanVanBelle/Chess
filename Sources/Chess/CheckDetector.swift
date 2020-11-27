//
//  CheckDetector.swift
//  
//
//  Created by Titouan Van Belle on 09.11.20.
//

import Foundation

protocol CheckDetectorProtocol {
    func willKingBeInCheck(after move: Move, in board: ChessBoardProtocol, color: PieceColor) -> Bool
    func willKingBeInCheckMate(after move: Move, in board: ChessBoardProtocol, color: PieceColor) -> Bool
    func isKingInCheck(in board: ChessBoardProtocol, for color: PieceColor) -> Bool
    func isKingInCheckMate(in board: ChessBoardProtocol, for color: PieceColor) -> Bool
}

extension CheckDetectorProtocol {
    func willKingBeInCheck(after move: Move, in board: ChessBoardProtocol, color: PieceColor) -> Bool {
        isKingInCheck(
            in: board.after(move: move),
            for: color
        )
    }

    func willKingBeInCheckMate(after move: Move, in board: ChessBoardProtocol, color: PieceColor) -> Bool {
        isKingInCheckMate(
            in: board.after(move: move),
            for: color
        )
    }
}

struct CheckDetector: CheckDetectorProtocol {

    // MARK: Private Properties

    private let legalSquareCalculator: LegalSquaresCalculatorProtocol

    // MARK: Init

    init(legalSquareCalculator: LegalSquaresCalculatorProtocol = LegalSquaresCalculator()) {
        self.legalSquareCalculator = legalSquareCalculator
    }

    // MARK: CheckDetectorProtocol

    func isKingInCheck(in board: ChessBoardProtocol, for color: PieceColor) -> Bool {
        let opponentSquares = board.squares(color: color.next)
        let kingSquare = board.squares(for: .king, color: color)

        for opponentSquare in opponentSquares {
            let capturableSquares = legalSquareCalculator.capturableSquares(forPieceAt: opponentSquare, in: board)

            if !capturableSquares.intersection(kingSquare).isEmpty {
                return true
            }
        }

        return false
    }

    func isKingInCheckMate(in board: ChessBoardProtocol, for color: PieceColor) -> Bool {
        guard isKingInCheck(in: board, for: color) else {
            return false
        }

        let allLegalMoves = board.squares(color: color)
            .flatMap { fromSquare in
                board.legalSquares(forPieceAt: fromSquare).map { toSquare in
                    (fromSquare, toSquare)
                }
            }
            .compactMap { board.move(from: $0.0, to: $0.1) }

        for move in allLegalMoves {
            if !willKingBeInCheck(after: move, in: board, color: color) {
                return false
            }
        }

        return true
    }
}
