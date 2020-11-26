//
//  PGNParser.swift
//  
//
//  Created by Titouan Van Belle on 09.11.20.
//

import Foundation

protocol PGNParserProtocol {
    func moves(for pgn: PGN) throws -> [Move]
}

final class PGNParser: PGNParserProtocol {

    // MARK: Private Properties

    private let checkDetector: CheckDetectorProtocol
    private let collisionDetector: CollisionDetectorProtocol
    private let anParser: ANParserProtocol

    // MARK: Init

    init(
        checkDetector: CheckDetectorProtocol = CheckDetector(),
        collisionDetector: CollisionDetectorProtocol = CollisionDetector(),
        anParser: ANParserProtocol = ANParser()
    ) {
        self.checkDetector = checkDetector
        self.collisionDetector = collisionDetector
        self.anParser = anParser
    }

    // MARK: PGNParserProtocol

    func moves(for pgn: PGN) throws -> [Move] {
        try pgn
            .components(separatedBy: .whitespaces)
            .enumerated()
            .reduce(([Move](), ChessBoard() as ChessBoardProtocol)) { acc, enumeratedNotation in
                let moves = acc.0
                let board = acc.1

                guard enumeratedNotation.offset % 3 != 0 else {
                    return (moves, board)
                }

                let notation = enumeratedNotation.element
                let move = try anParser.move(for: notation, in: board)

                guard move.isAllowed else {
                    throw ChessBoardError.invalidPgn(pgn, notation)
                }

                guard !collisionDetector.collisions(for: move, in: board) else {
                    throw ChessBoardError.invalidMove(.collisionDetected)
                }

                let boardAfterMove = board.after(move: move)
                guard !boardAfterMove.isKingInCheck(for: boardAfterMove.currentPlayer.next) else {
                    throw ChessBoardError.invalidMove(.kingInCheck)
                }

                return (moves + [move], boardAfterMove)
            }.0
    }
}
