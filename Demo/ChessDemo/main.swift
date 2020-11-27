//
//  main.swift
//  ChessDemo
//
//  Created by Titouan Van Belle on 09.11.20.
//

import Chess

let board = ChessBoard()

// Load PGN: C42: Petrov's Defense: Classical, Stafford Gambit
let pgn = "1. e4 e5 2. Nf3 Nf6 3. Nxe5 Nc6 4. Nxc6 dxc6 5. Nc3 Bc5 6. d3 Ng4"
try! board.load(pgn: pgn)
board.loadAllMoves()

print(board.gui)
// ♖   ♗ ♕ ♔     ♖
// ♙ ♙ ♙     ♙ ♙ ♙
//     ♙
//     ♗
//        ♟   ♘
//     ♞ ♟
// ♟ ♟ ♟     ♟ ♟ ♟
// ♜   ♝ ♛ ♚ ♝   ♜

// Play Move: White blunders
try! board.play(move: "Be2")

// Play Move: Black attacks
try! board.play(move: "Bxf2+")

print(board.isKingInCheck(for: .white))
// true

let e1 = board.square(withNotation: "e1")!
let d2 = board.square(withNotation: "d2")!
try! board.playMove(from: e1, to: d2)

let d8 = board.square(withNotation: "d8")!
let g5 = board.square(withNotation: "g5")!
try! board.playMove(from: d8, to: g5)

print(board.isKingCheckMate(for: .white))
// true

print(board.pgn)
// 1. e4 e5 2. Nf3 Nf6 3. Nxe5 Nc6 4. Nxc6 dxc6 5. Nc3 Bc5 6. d3 Ng4 7. Be2 Bxf2+ 8. Kd2 Qg5#
