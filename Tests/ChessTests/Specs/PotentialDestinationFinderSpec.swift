////
////  PotentialDestinationFinderSpec.swift
////  
////
////  Created by Titouan Van Belle on 16.11.20.
////
//
//import Foundation
//
//import Nimble
//import Quick
//import XCTest
//
//@testable import Chess
//
//class PotentialDestinationFinderSpec: QuickSpec {
//    override func spec() {
//        var sut: LegalSquaresCalculatorProtocol!
//        var board: ChessBoardProtocol!
//
//        beforeEach {
//            sut = LegalSquaresCalculator()
//            board = ChessBoard()
//        }
//
//        afterEach {
//            sut = nil
//            board = nil
//        }
//
//        describe("potentialCaptureSquares(forPieceAt:)") {
//            it("") {
//                let e2 = board.squares[12]
//                let e2Captures = sut.potentialCaptureSquares(forPieceAt: e2, in: board)
//
//                expect(e2Captures).to(beEmpty())
//
//                // Playing King's Gambit
//                try! board.play(move: "e4")
//                try! board.play(move: "e5")
//                try! board.play(move: "f4")
//
//                let e5 = board.squares[36]
//                let e5Captures = sut.potentialCaptureSquares(forPieceAt: e5, in: board)
//
//                expect(e5Captures.count) == 1
//                expect(e5Captures[0].location.notation) == "f4"
//
//                let f4 = board.squares[29]
//                let f4Captures = sut.potentialCaptureSquares(forPieceAt: f4, in: board)
//
//                expect(f4Captures.count) == 1
//                expect(f4Captures[0].location.notation) == "e5"
//
//                // Playing King's Gambit Accepted
//                try! board.play(move: "exf4")
//                try! board.play(move: "d4")
//
//                let Bc1 = board.squares[2]
//                let Bc1Captures = sut.potentialCaptureSquares(forPieceAt: Bc1, in: board)
//
//                expect(Bc1Captures.count) == 1
//                expect(Bc1Captures[0].location.notation) == "f4"
//            }
//        }
//
//        describe("potentialMoveSquares(forPieceAt:)") {
//            it("") {
//                let e2 = board.squares[12]
//                let e2ToSquares = sut.potentialMoveSquares(forPieceAt: e2, in: board)
//                var locationsInAlgebraic = e2ToSquares.map(\.location.notation)
//
//                print(locationsInAlgebraic)
//
//                expect(locationsInAlgebraic).to(contain("e3"))
//                expect(locationsInAlgebraic).to(contain("e4"))
//
//                // Playing King's Gambit
//                try! board.play(move: "e4")
//                try! board.play(move: "e5")
//                try! board.play(move: "f4")
//                try! board.play(move: "exf4")
//                try! board.play(move: "d4")
//
//                let whiteQueen = board.squares[3]
//                let whiteQueenToSquares = sut.potentialMoveSquares(forPieceAt: whiteQueen, in: board)
//                locationsInAlgebraic = whiteQueenToSquares.map(\.location.notation)
//
//                expect(locationsInAlgebraic).to(contain("d2"))
//                expect(locationsInAlgebraic).to(contain("d3"))
//                expect(locationsInAlgebraic).to(contain("e2"))
//                expect(locationsInAlgebraic).to(contain("f3"))
//                expect(locationsInAlgebraic).to(contain("g4"))
//                expect(locationsInAlgebraic).to(contain("h5"))
//
//                let whiteKnight = board.squares[1]
//                let whiteKnightToSquares = sut.potentialMoveSquares(forPieceAt: whiteKnight, in: board)
//                locationsInAlgebraic = whiteKnightToSquares.map(\.location.notation)
//
//                expect(locationsInAlgebraic).to(contain("a3"))
//                expect(locationsInAlgebraic).to(contain("c3"))
//                expect(locationsInAlgebraic).to(contain("d2"))
//
//                let whiteBishop = board.squares[2]
//                let whiteBishopToSquares = sut.potentialMoveSquares(forPieceAt: whiteBishop, in: board)
//                locationsInAlgebraic = whiteBishopToSquares.map(\.location.notation)
//
//                expect(locationsInAlgebraic).to(contain("d2"))
//                expect(locationsInAlgebraic).to(contain("e3"))
//            }
//        }
//    }
//}
