//
//  LegalSquaresCalculator.swift
//  
//
//  Created by Titouan Van Belle on 16.11.20.
//

import Foundation

protocol LegalSquaresCalculatorProtocol {
    func legalSquares(forPieceAt fromSquare: Square, in board: ChessBoardProtocol) -> Set<Square>
    func capturableSquares(forPieceAt fromSquare: Square, in board: ChessBoardProtocol) -> Set<Square>
}

final class LegalSquaresCalculator: LegalSquaresCalculatorProtocol {

    private let enPassantDetector: EnPassantDetectorProtocol

    init(enPassantDetector: EnPassantDetectorProtocol = EnPassantDetector()) {
        self.enPassantDetector = enPassantDetector
    }

    func legalSquares(forPieceAt fromSquare: Square, in board: ChessBoardProtocol) -> Set<Square> {
        capturableSquares(forPieceAt: fromSquare, in: board)
            .union(legalMoveSquares(forPieceAt: fromSquare, in: board))
    }

    func capturableSquares(forPieceAt fromSquare: Square, in board: ChessBoardProtocol) -> Set<Square> {
        guard let piece = fromSquare.piece else {
            return []
        }

        var squares = Set<Square>()
        let vectors = piece.movement.allowedTakeDirectionTypes.flatMap(\.vectors)

        for vector in vectors {
            var location = fromSquare.location.afterApplying(vector: vector)
            while let currentLocation = location {
                let attackedSquare = board.squares[currentLocation.index]

                if let attackedPiece = attackedSquare.piece {
                    if attackedPiece.color != piece.color {
                        squares.insert(attackedSquare)
                    }

                    location = currentLocation.afterApplying(vector: vector)
                    break
                } else if piece.hasInfiniteAttackingRange {
                    location = currentLocation.afterApplying(vector: vector)
                } else if enPassantDetector.isEnPassantPossible(from: fromSquare, to: attackedSquare, in: board) {
                    squares.insert(attackedSquare)
                    break
                } else {
                    break
                }
            }
        }

        return squares
    }
}

fileprivate extension LegalSquaresCalculator {
    func legalMoveSquares(forPieceAt fromSquare: Square, in board: ChessBoardProtocol) -> Set<Square> {
        guard let piece = fromSquare.piece else {
            return []
        }

        var toSquares = Set<Square>()
        let vectors = piece.movement.allowedMoveDirectionTypes.flatMap(\.vectors)

        for vector in vectors {
            var location = fromSquare.location.afterApplying(vector: vector)
            while let currentLocation = location {
                let toSquare = board.squares[currentLocation.index]

                if toSquare.piece != nil {
                    break
                }

                if fromSquare.location.notation == "e1" && toSquare.location.notation == "c1" {
                    _ = 1
                }

                if let move = board.move(from: fromSquare, to: toSquare), move.isAllowed {
                    if case .castle(let side) = move.kind, side == .queen {
                        if move.player == .white, board.square(at: Location(file: .b, rank: .one)).hasPiece {
                            break
                        }

                        if move.player == .black, board.square(at: Location(file: .b, rank: .eight)).hasPiece {
                            break
                        }
                    }

                    toSquares.insert(toSquare)
                    location = currentLocation.afterApplying(vector: vector)
                } else {
                    break
                }
            }
        }

        return toSquares
    }
}
