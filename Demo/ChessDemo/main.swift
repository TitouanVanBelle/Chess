//
//  main.swift
//  ChessDemo
//
//  Created by Titouan Van Belle on 09.11.20.
//

import Chess

let board = ChessBoard()

let pgn = "1. e4 h6 2. e5 d5"
try! board.load(pgn: pgn)
board.loadAllMoves()

print(board.gui)

let e5 = board.square(withNotation: "e5")!
print(board.capturableSquares(forPieceAt: e5))
print(board.legalSquares(forPieceAt: e5))

try! board.play(move: "exd6")

print(board.gui)
