//
//  ANParser.swift
//  
//
//  Created by Titouan Van Belle on 09.11.20.
//

import Foundation

protocol ANParserProtocol {
    func move(for notation: AlgebraicNotation, in board: ChessBoardProtocol) throws -> Move
}

final class ANParser: ANParserProtocol {

    // MARK: Private Properties

    private let legalSquareCalculator: LegalSquaresCalculatorProtocol

    init(legalSquareCalculator: LegalSquaresCalculatorProtocol = LegalSquaresCalculator()) {
        self.legalSquareCalculator = legalSquareCalculator
    }

    func move(for notation: AlgebraicNotation, in board: ChessBoardProtocol) throws -> Move {

        let strippedNotation = notation
            .replacingOccurrences(of: "+", with: "")
            .replacingOccurrences(of: "#", with: "")

        switch strippedNotation {

        case ANRegex.kingCastle:
            return try castleMove(for: strippedNotation, in: board, side: .king)
        case ANRegex.queenCastle:
            return try castleMove(for: strippedNotation, in: board, side: .queen)
        case ANRegex.pawnMove:
            return try pawnMove(for: strippedNotation, in: board)
        case ANRegex.pawnCapture:
            return try pawnCapture(for: strippedNotation, in: board)
        case ANRegex.pieceMove:
            return try pieceMove(for: strippedNotation, in: board)
        case ANRegex.pieceCapture:
            return try pieceCapture(for: strippedNotation, in: board)

        default:
            throw ANParsingError.invalidAlgebraicNotation(notation)
        }
    }
}

fileprivate extension ANParser {
    func pieceMove(for notation: AlgebraicNotation, in board: ChessBoardProtocol) throws -> Move {
        let toLocationNotation = String(notation.suffix(2))
        var fromRank: Rank?
        var fromFile: File?

        if notation.count == 4 {
            fromRank = Rank(notation: String(notation[1]))
            fromFile = File(notation: String(notation[1]))
        }

        guard let toLocation = Location(notation: toLocationNotation) else {
            throw ANParsingError.invalidAlgebraicNotation(notation)
        }

        let pieceKind = PieceKind(notation: notation[0])

        let fromLocations = board.squares(for: pieceKind, color: board.currentPlayer)
            .filter { square in
                if let fromRank = fromRank {
                    return square.rank == fromRank
                }

                if let fromFile = fromFile {
                    return square.file == fromFile
                }

                return legalSquareCalculator.legalSquares(forPieceAt: square, in: board)
                    .contains { $0.location == toLocation }
            }
            .filter { fromSquare in
                let toSquare = board.square(at: toLocation)
                guard let potentialMove = board.move(from: fromSquare, to: toSquare) else {
                    return false
                }

                let boardAfterMove = board.after(move: potentialMove)

                return !boardAfterMove.isKingInCheck(for: board.currentPlayer)
            }
            .map(\.location)

        guard let fromLocation = fromLocations.first else {
            throw ANParsingError.invalidAlgebraicNotation(notation)
        }

        return move(from: fromLocation, to: toLocation, in: board)
    }

    func pieceCapture(for notation: AlgebraicNotation, in board: ChessBoardProtocol) throws -> Move {
        let toLocationNotation = String(notation.suffix(2))
        var fromRank: Rank?
        var fromFile: File?

        if notation.count == 5 {
            fromRank = Rank(notation: String(notation[1]))
            fromFile = File(notation: String(notation[1]))
        }

        guard let toLocation = Location(notation: toLocationNotation) else {
            throw ANParsingError.invalidAlgebraicNotation(notation)
        }

        let pieceKind = PieceKind(notation: notation[0])

        let fromLocations = board.squares(for: pieceKind, color: board.currentPlayer)
            .filter { square in
                if let fromRank = fromRank {
                    return square.rank == fromRank
                }

                if let fromFile = fromFile {
                    return square.file == fromFile
                }

                return legalSquareCalculator.legalSquares(forPieceAt: square, in: board)
                    .contains { $0.location == toLocation }
            }
            .filter { fromSquare in
                let toSquare = board.square(at: toLocation)
                guard let potentialMove = board.move(from: fromSquare, to: toSquare) else {
                    return false
                }

                let boardAfterMove = board.after(move: potentialMove)

                return !boardAfterMove.isKingInCheck(for: board.currentPlayer)
            }
            .map(\.location)

        guard let fromLocation = fromLocations.first else {
            throw ANParsingError.invalidAlgebraicNotation(notation)
        }

        return move(from: fromLocation, to: toLocation, in: board)
    }

    func pawnMove(for notation: AlgebraicNotation, in board: ChessBoardProtocol) throws -> Move {
        let pgnComponents = notation
            .split(separator: "=")

        let toSquareNotation = String(pgnComponents[0])
        guard let toLocation = Location(notation: toSquareNotation) else {
            throw ANParsingError.invalidAlgebraicNotation(notation)
        }

        let fromLocation = board.squares(for: .pawn, color: board.currentPlayer)
            .filter { $0.file == toLocation.file }
            .map(\.location)
            .sorted(by: { lhs, rhs in
                board.currentPlayer == .white ?
                    lhs.rank.rawValue > rhs.rank.rawValue :
                    lhs.rank.rawValue < rhs.rank.rawValue
            })
            .first

        let promotion: Promotion?

        if pgnComponents.count == 2 {
            let pieceNotation = String(pgnComponents.last!)
            promotion = PieceKind(notation: pieceNotation)
        } else {
            promotion = nil
        }

        guard let unwrappedFromLocation = fromLocation else {
            throw ANParsingError.invalidAlgebraicNotation(notation)
        }

        return move(from: unwrappedFromLocation, to: toLocation, promotion: promotion, in: board)
    }

    func pawnCapture(for notation: AlgebraicNotation, in board: ChessBoardProtocol) throws -> Move {
        let pgnComponents = notation
            .split(separator: "x")
            .flatMap { $0.split(separator: "=") }

        let toSquareNotation = String(pgnComponents[1])
        guard let toLocation = Location(notation: toSquareNotation) else {
            throw ANParsingError.invalidAlgebraicNotation(notation)
        }

        let fileValue = String(pgnComponents[0])
        guard let file = File(notation: fileValue) else {
            throw ANParsingError.invalidAlgebraicNotation(notation)
        }

        let color = board.currentPlayer
        let rank = toLocation.rank.previous(for: color)
        let fromLocation = Location(file: file, rank: rank)
        let promotion: Promotion?

        if pgnComponents.count == 3 {
            let pieceNotation = String(pgnComponents.last!)
            promotion = PieceKind(notation: pieceNotation)
        } else {
            promotion = nil
        }

        return move(from: fromLocation, to: toLocation, promotion: promotion, in: board)
    }

    func castleMove(for notation: AlgebraicNotation, in board: ChessBoardProtocol, side: CastleSide) throws -> Move {
        let color = board.currentPlayer
        let kingIndex = color == .white ? 4 : 60
        guard let kingLocation = Location(index: kingIndex) else {
            throw ANParsingError.invalidAlgebraicNotation(notation)
        }

        let rookIndex = color == .white ?
            (side == .king ? 7 : 0) :
            (side == .king ? 63 : 56)
        guard let rookLocation = Location(index: rookIndex) else {
            throw ANParsingError.invalidAlgebraicNotation(notation)
        }

        return move(from: kingLocation, to: rookLocation, in: board)
    }

    func move(from fromLocation: Location, to toLocation: Location, promotion: Promotion? = nil, in board: ChessBoardProtocol) -> Move {
        /// - TODO: remove bang
        board.move(
            from: board.square(at: fromLocation),
            to: board.square(at: toLocation),
            promotion: promotion
        )!
    }
}
