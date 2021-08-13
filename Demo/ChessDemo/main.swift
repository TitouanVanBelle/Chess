//
//  main.swift
//  ChessDemo
//
//  Created by Titouan Van Belle on 09.11.20.
//

import Chess

let board = ChessBoard()

let pgn = "1. e3 Nf6 2. Ba6 Nh5 3. Nf3 Nf4 4. Bxb7 Nh3 5. Bxa8 Nf4 6. Bb7 Nh5 7. Bxc8 Ng3"
try! board.load(pgn: pgn)
board.loadAllMoves()

print(board.gui)

let e1 = board.square(withNotation: "e1")!
print(board.legalSquares(forPieceAt: e1))
