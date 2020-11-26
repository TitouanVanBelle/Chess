//
//  PGNBuilder.swift
//  
//
//  Created by Titouan Van Belle on 09.11.20.
//

import Foundation

protocol PGNBuilderProtocol {
    func pgn(for moves: [Move], until untilIndex: Int?) -> String
}

extension PGNBuilderProtocol {
    func pgn(for moves: [Move]) -> String {
        pgn(for: moves, until: nil)
    }
}

final class PGNBuilder: PGNBuilderProtocol {

    // MARK: Inner Types

    enum ConstantNotations {
        static let check = "+"
        static let checkMate = "#"
    }

    // MARK: Private Properties

    private let checkDetector: CheckDetectorProtocol

    // MARK: Init

    init(checkDetector: CheckDetectorProtocol = CheckDetector()) {
        self.checkDetector = checkDetector
    }

    // MARK: PGNBuilderProtocol

    func pgn(for moves: [Move], until optionalUntilIndex: Int? = nil) -> String {
        moves[0..<(optionalUntilIndex ?? moves.count)]
            .reduce(([AlgebraicNotation](), ChessBoard() as ChessBoardProtocol)) { acc, move in
                let nextNotations: [AlgebraicNotation] = acc.0 + [notation(for: move, in: acc.1)]
                let nextBoard = acc.1.after(move: move)
                return (nextNotations, nextBoard)
            }
            .0
            .enumerated()
            .map { index, notation in
                var pgn = ""

                if index.isEven {
                    let currentMoveIndex = index / 2 + 1
                    pgn = "\(currentMoveIndex). "
                }

                pgn += notation

                return pgn
            }
            .joined(separator: " ")
    }
}

fileprivate extension PGNBuilder {
    func notation(for move: Move, in board: ChessBoardProtocol) -> String {
        var notation: String

        switch move.kind {

        case .castle(let castleSide):
            notation = castleNotation(for: castleSide)

        case .move:
            notation = moveNotation(for: move.piece, from: move.fromSquare, to: move.toSquare, in: board)

        case .capture:
            notation = captureNotation(for: move.piece, from: move.fromSquare, to: move.toSquare, in: board)

        case .enPassant:
            /// - TODO: Fix notation
            notation = "EN PASSANT"
        }

        if let promotion = move.promotion {
            notation += promotionNotation(for: promotion)
        }

        if checkDetector.willKingBeInCheckMate(after: move, in: board, color: move.piece.color.next) {
            notation += ConstantNotations.checkMate
        } else if checkDetector.willKingBeInCheck(after: move, in: board, color: move.piece.color.next) {
            notation += ConstantNotations.check
        }

        return notation
    }

    func moveNotation(for piece: Piece, from fromSquare: Square, to toSquare: Square, in board: ChessBoardProtocol) -> String {
        switch piece.kind {
        case .pawn:
            return toSquare.location.notation

        case .knight, .rook:
            let squares = board.squares(for: piece.kind, color: piece.color)

            guard let squareForOtherPiece = squares.filter({ $0.location != fromSquare.location }).first else {
                return "\(piece.notation)\(toSquare.location.notation)"
            }

            let legalSquares = board.legalSquares(forPieceAt: squareForOtherPiece)

            if legalSquares.filter({ $0.location.index == toSquare.location.index }).isEmpty {
                return "\(piece.notation)\(toSquare.location.notation)"
            }

            if fromSquare.file == squareForOtherPiece.file {
                return "\(piece.notation)\(fromSquare.rank.notation)\(toSquare.notation)"
            } else {
                return "\(piece.notation)\(fromSquare.file.notation)\(toSquare.notation)"
            }

        default:
            return "\(piece.notation)\(toSquare.location.notation)"
        }
    }

    func captureNotation(for piece: Piece, from fromSquare: Square, to toSquare: Square, in board: ChessBoardProtocol) -> String {
        switch piece.kind {
        case .pawn:
            return "\(fromSquare.file.notation)x\(toSquare.location.notation)"

        case .knight, .rook:
            let squares = board.squares(for: piece.kind, color: piece.color)

            guard let squareForOtherPiece = squares.filter({ $0.location != fromSquare.location }).first else {
                return "\(piece.notation)x\(toSquare.location.notation)"
            }

            let legalSquares = board.legalSquares(forPieceAt: squareForOtherPiece)

            if legalSquares.filter({ $0.location == toSquare.location }).isEmpty {
                return "\(piece.notation)x\(toSquare.location.notation)"
            }

            if fromSquare.file == squareForOtherPiece.file {
                return "\(piece.notation)\(fromSquare.rank.notation)x\(toSquare.notation)"
            } else {
                return "\(piece.notation)\(fromSquare.file.notation)x\(toSquare.notation)"
            }

        default:
            return "\(piece.notation)x\(toSquare.location.notation)"
        }
    }

    func castleNotation(for side: CastleSide) -> String {
        switch side {
        case .queen: return "O-O-O"
        case .king: return "O-O"
        }
    }

    func promotionNotation(for promotion: Promotion) -> AlgebraicNotation {
        "=" + promotion.notation
    }
}
