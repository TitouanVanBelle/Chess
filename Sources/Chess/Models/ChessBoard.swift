//
//  ChessBoard.swift
//  
//
//  Created by Titouan Van Belle on 09.11.20.
//

import Foundation

public typealias AlgebraicNotation = String
public typealias PGN = String
public typealias Promotion = PieceKind

public final class ChessBoard {

    // MARK: Static

    private static let initialSquares: [Square] = makeInitialSquares()

    private static func makeInitialSquares() -> [Square] {
        func square(for location: Location) -> Square {
            let pieces: [PieceKind] = [
                .rook,
                .knight,
                .bishop,
                .queen,
                .king,
                .bishop,
                .knight,
                .rook
            ]

            let whiteRanks: [Rank] = [.two, .one]
            let color: PieceColor = whiteRanks.contains(location.rank) ? .white : .black
            let kind: PieceKind
            switch location.rank {
            case .one, .eight:
                kind = pieces[location.index % 8]
            case .two, .seven:
                kind = .pawn
            default:
                return Square(location: location)
            }

            let piece = Piece(kind: kind, color: color, initialLocation: location)
            return Square(location: location, piece: piece)
        }

        return Array(0...63)
            .compactMap(Location.init)
            .map(square)
    }

    // MARK: Public Properties

    public internal(set) var squares: [Square]
    public internal(set) var moves: [Move]
    public internal(set) var currentPlayer: PieceColor
    public internal(set) var currentMoveIndex: Int

    // MARK: Private Properties

    private let checkDetector: CheckDetectorProtocol
    private let collisionDetector: CollisionDetectorProtocol
    private let legalSquareCalculator: LegalSquaresCalculatorProtocol
    private let pgnBuilder: PGNBuilderProtocol
    private let pgnParser: PGNParserProtocol
    private let anParser: ANParserProtocol

    // MARK: Init

    public convenience init() {
        self.init(squares: Self.initialSquares)
    }

    private init(
        squares: [Square],
        moves: [Move] = [],
        currentPlayer: PieceColor = .white,
        currentMoveIndex: Int = 0,
        checkDetector: CheckDetectorProtocol = CheckDetector(),
        collisionDetector: CollisionDetectorProtocol = CollisionDetector(),
        legalSquareCalculator: LegalSquaresCalculatorProtocol = LegalSquaresCalculator(),
        pgnBuilder: PGNBuilderProtocol = PGNBuilder(),
        pgnParser: PGNParserProtocol = PGNParser(),
        anParser: ANParserProtocol = ANParser()
    ) {
        self.currentPlayer = currentPlayer
        self.squares = squares
        self.moves = moves
        self.currentMoveIndex = currentMoveIndex

        self.checkDetector = checkDetector
        self.collisionDetector = collisionDetector
        self.legalSquareCalculator = legalSquareCalculator
        self.pgnBuilder = pgnBuilder
        self.anParser = anParser
        self.pgnParser = pgnParser
    }
}

// MARK: Public API

public extension ChessBoard {

    // MARK: Board's Current State

    var pgn: String {
        pgnBuilder.pgn(for: moves)
    }

    var gui: String {
        squares
            .chunks(of: 8)
            .reversed()
            .flatMap { $0.map { "\($0.unicode) " } + ["\n"] }
            .joined()
    }

    // MARK: Load PGN

    func load(pgn: PGN, overwrite: Bool = false) throws {
        guard moves.isEmpty || overwrite else {
            throw ChessBoardError.boardInUse
        }

        moves = try pgnParser.moves(for: pgn.trimmingCharacters(in: .whitespacesAndNewlines))
    }

    // MARK: Access to Squares

    func square(withNotation notation: AlgebraicNotation) -> Square? {
        guard let location = Location(notation: notation) else {
            return nil
        }

        return square(at: location)
    }

    func legalSquares(forPieceAt fromSquare: Square) -> Set<Square> {
        legalSquareCalculator.legalSquares(forPieceAt: fromSquare, in: self)
    }

    func capturableSquares(forPieceAt fromSquare: Square) -> Set<Square> {
        legalSquareCalculator.capturableSquares(forPieceAt: fromSquare, in: self)
    }

    // MARK: Check + Check Mate

    func isKingInCheck(for color: PieceColor) -> Bool {
        checkDetector.isKingInCheck(in: self, for: color)
    }

    func isKingCheckMate(for color: PieceColor) -> Bool {
        checkDetector.isKingInCheckMate(in: self, for: color)
    }

    // MARK: Play

    @discardableResult
    func play(move notation: AlgebraicNotation) throws -> Move {
        guard currentMoveIndex == moves.count else {
            throw ChessBoardError.noVariationAllowed
        }

        let move = try anParser.move(for: notation, in: self)

        try play(move)

        return move
    }

    @discardableResult
    func playMove(from fromSquare: Square, to toSquare: Square) throws -> Move {
        guard currentMoveIndex == moves.count else {
            throw ChessBoardError.noVariationAllowed
        }

        guard let move = move(from: fromSquare, to: toSquare) else {
            throw ChessBoardError.invalidMove(.unknown)
        }

        try play(move)

        return move
    }

    // MARK: Navigation

    @discardableResult
    func loadNextMove() -> Move? {
        guard moves.indices.contains(currentMoveIndex) else {
            return nil
        }

        let move = moves[currentMoveIndex]

        load(move: move)

        return move
    }

    func loadAllMoves() {
        moves[currentMoveIndex..<moves.count]
            .forEach(load(move:))
    }

    @discardableResult
    func unloadPreviousMove() -> Move? {
        guard currentMoveIndex > 0 else {
            return nil
        }

        let move = moves[currentMoveIndex - 1]

        unload(move: move)

        return move
    }

    func unloadAllMoves() {
        moves[0..<currentMoveIndex]
            .reversed()
            .forEach(unload(move:))
    }
}

// MARK: Chess Board Protocol

extension ChessBoard: ChessBoardProtocol {
    func squares(for pieceType: PieceKind?, color: PieceColor) -> Set<Square> {
        Set(squares).filter { square in
            guard let piece = square.piece else {
                return false
            }

            guard let pieceType = pieceType else {
                return piece.color == color
            }

            return piece.kind == pieceType && piece.color == color
        }
    }

    func after(move: Move) -> ChessBoardProtocol {
        let board = ChessBoard(
            squares: squares,
            moves: moves + [move],
            currentPlayer: currentPlayer,
            currentMoveIndex: currentMoveIndex
        )

        board.loadNextMove()

        return board
    }

    func move(from fromSquare: Square, to toSquare: Square, promotion: Promotion? = nil) -> Move? {
        guard let kind = moveKind(from: fromSquare, to: toSquare) else {
            return nil
        }

        let vector = Vector(fromSquare: fromSquare, toSquare: toSquare)
        guard let directionType = DirectionType(vector: vector) else {
            return nil
        }

        var capturedSquare: Square? = nil

        if kind == .capture {
            capturedSquare = toSquare
        } else if kind == .enPassant {
            capturedSquare = square(at: Location(file: toSquare.file, rank: fromSquare.rank))
        }

        return Move(
            fromSquare: fromSquare,
            toSquare: toSquare,
            kind: kind,
            directionType: directionType,
            capturedSquare: capturedSquare,
            promotion: promotion 
        )
    }
}

// MARK: Helpers

fileprivate extension ChessBoard {
    func play(_ move: Move) throws {
        guard move.player == currentPlayer else {
            throw ChessBoardError.wrongPlayer(currentPlayer)
        }

        guard move.isAllowed else {
            throw ChessBoardError.invalidMove(.moveNotAllowed)
        }

        guard !collisionDetector.collisions(for: move, in: self) else {
            throw ChessBoardError.invalidMove(.collisionDetected)
        }

        guard !willKingBeInCheck(after: move) else {
            let square = squares(for: PieceKind.king, color: move.player).first!
            throw ChessBoardError.invalidMove(.kingInCheck(square))
        }

        load(move: move)
    }

    func load(move: Move) {
        switch move.kind {
        case .move:
            movePiece(from: move.fromSquare.location.index, to: move.toSquare.location.index)

        case .capture:
            removePiece(at: move.toSquare.location.index)
            movePiece(from: move.fromSquare.location.index, to: move.toSquare.location.index)

        case .castle(let castleSide):
            castle(move.piece.color, castleSide: castleSide)

        case .enPassant:
            movePiece(from: move.fromSquare.location.index, to: move.toSquare.location.index)
            let location = Location(file: move.toSquare.file, rank: move.fromSquare.rank)
            removePiece(at: location.index)
        }

        if let promotion = move.promotion {
            promotePiece(at: move.toSquare.location.index, to: promotion)
        }

        if currentMoveIndex == moves.count {
            moves.append(move)
        }

        currentMoveIndex += 1
        currentPlayer = currentPlayer.next
    }

    func unload(move: Move) {
        let fromIndex = move.toSquare.location.index
        let toIndex = move.fromSquare.location.index

        switch move.kind {
        case .move:
            movePieceBack(from: fromIndex, to: toIndex)

        case .capture:
            movePieceBack(from: fromIndex, to: toIndex)
            addPiece(move.capturedSquare!.piece!, at: fromIndex)

        case .castle(let castleSide):
            uncastle(move.piece.color, castleSide: castleSide)

        case .enPassant:
            movePieceBack(from: fromIndex, to: toIndex)
            let location = Location(file: move.toSquare.file, rank: move.fromSquare.rank)
            addPiece(move.capturedSquare!.piece!, at: location.index)
            return
        }

        currentMoveIndex -= 1
        currentPlayer = currentPlayer.next
    }

    func moveKind(from fromSquare: Square, to toSquare: Square) -> MoveKind? {
        guard let fromPiece = fromSquare.piece else {
            fatalError("From square should have a piece on it")
        }

        if let toPiece = toSquare.piece {
            guard toPiece.color == fromPiece.color else {
                return .capture
            }

            if fromPiece.kind == .king,
                !fromPiece.hasMoved,
                toPiece.kind == .rook,
                !toPiece.hasMoved {
                return .castle(toSquare.file == .h ? .king : .queen)
            } else {
                return nil
            }

        } else {
            if fromPiece.kind == .pawn,
               fromSquare.isEnPassantStartingSquare(for: fromPiece.color),
               abs(Vector(fromSquare: fromSquare, toSquare: toSquare).deltaFile) == 1,
               let piece = square(at: Location(file: toSquare.file, rank: fromSquare.rank)).piece,
               piece.kind == .pawn,
               piece.color == fromPiece.color.next,
               let lastMove = moves.last,
               lastMove.toSquare.location == Location(file: toSquare.file, rank: fromSquare.rank) {
                return .enPassant
            } else if fromPiece.kind == .king,
                      !fromPiece.hasMoved,
                      (toSquare == squares[kingCastledIndex(for: fromPiece.color, castleSide: .queen)]
                        || toSquare == squares[kingCastledIndex(for: fromPiece.color, castleSide: .king)]) {
                return .castle(toSquare.file == .g ? .king : .queen)
            } else {
                return .move
            }
        }
    }

    /// - TODO: Work with Location instead of Int

    func movePiece(from fromIndex: Int, to toIndex: Int) {
        guard let piece = squares[fromIndex].piece else {
            return
        }

        squares[fromIndex].piece = nil
        squares[toIndex].piece = piece
        squares[toIndex].piece?.location = Location(index: toIndex)!
    }

    func movePieceBack(from fromIndex: Int, to toIndex: Int) {
        let piece = squares[fromIndex].piece
        squares[fromIndex].piece = nil
        squares[toIndex].piece = piece
        squares[toIndex].piece?.location = Location(index: toIndex)!
    }

    func addPiece(_ piece: Piece, at index: Int) {
        squares[index].piece = piece
    }

    func removePiece(at index: Int) {
        squares[index].piece = nil
    }

    func promotePiece(at index: Int, to promotion: Promotion) {
        let piece = squares[index].piece
        squares[index].piece = piece?.promoted(to: promotion)
    }

    // MARK: Helpers

    func willKingBeInCheck(after move: Move) -> Bool {
        checkDetector.willKingBeInCheck(after: move, in: self, color: currentPlayer)
    }

    func kingCastledIndex(for color: PieceColor, castleSide: CastleSide) -> Int {
        let kindStartIndex = kingInitialIndex(for: color)
        return castleSide == .king ?
            kindStartIndex + 2 :
            kindStartIndex - 2
    }

    func kingInitialIndex(for color: PieceColor) -> Int {
        color == .white ? 4 : 60
    }

    func rookInitialIndex(for color: PieceColor, castleSide: CastleSide) -> Int {
        return color == .white ?
            (castleSide == .king ? 7 : 0) :
            (castleSide == .king ? 63 : 56)
    }

    func rookCastledIndex(for color: PieceColor, castleSide: CastleSide) -> Int {
        let kingEndIndex = kingCastledIndex(for: color, castleSide: castleSide)
        return castleSide == .king ?
            kingEndIndex - 1 :
            kingEndIndex + 1
    }

    func castle(_ color: PieceColor, castleSide: CastleSide) {
        movePiece(from: kingInitialIndex(for: color),
                  to: kingCastledIndex(for: color, castleSide: castleSide))

        movePiece(from: rookInitialIndex(for: color, castleSide: castleSide),
                  to: rookCastledIndex(for: color, castleSide: castleSide))
    }

    func uncastle(_ color: PieceColor, castleSide: CastleSide) {
        movePiece(from: kingCastledIndex(for: color, castleSide: castleSide),
                  to: kingInitialIndex(for: color))

        movePiece(from: rookCastledIndex(for: color, castleSide: castleSide),
                  to: rookInitialIndex(for: color, castleSide: castleSide))
    }
}
