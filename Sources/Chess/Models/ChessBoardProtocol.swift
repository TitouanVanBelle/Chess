//
//  BoardProtocol.swift
//  Chess
//
//  Created by Titouan Van Belle on 09/11/2019.
//  Copyright © 2019 Titouan Van Belle. All rights reserved.
//

import Foundation

protocol ChessBoardProtocol {
    var squares: [Square] { get set }

    var currentPlayer: PieceColor { get set }

    func legalSquares(forPieceAt fromSquare: Square) -> Set<Square>
    func squares(for pieceType: PieceKind?, color: PieceColor) -> Set<Square>

    func after(move: Move) -> ChessBoardProtocol
    func isKingInCheck(for color: PieceColor) -> Bool

    func move(from fromSquare: Square, to toSquare: Square, promotion: Promotion?) -> Move?
}

extension ChessBoardProtocol {
    func square(at location: Location) -> Square {
        squares[location.index]
    }

    func squares(color: PieceColor) -> Set<Square> {
        squares(for: nil, color: color)
    }

    func move(from fromSquare: Square, to toSquare: Square) -> Move? {
        move(from: fromSquare, to: toSquare, promotion: nil)
    }
}
