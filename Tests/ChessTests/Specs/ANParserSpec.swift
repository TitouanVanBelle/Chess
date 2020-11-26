////
////  ANParserSpecs.swift
////  
////
////  Created by Titouan Van Belle on 09.11.20.
////
//
//import Nimble
//import Quick
//import XCTest
//
//@testable import Chess
//
//class ANParserSpecs: QuickSpec {
//    override func spec() {
//        var sut: ANParserProtocol!
//
//        beforeEach {
//            sut = ANParser()
//        }
//
//        afterEach {
//            sut = nil
//        }
//
//        describe("move(for:)") {
//            context("e5") {
//                it("returns a pawn move") {
//                    let move = try? sut.move(for: "e4", in: ChessBoard())
//                    expect(move).notTo(beNil())
//                    expect(move!.kind) == .move
//                    expect(move!.piece.kind) == .pawn
//                    expect(move!.fromSquare.file) == .e
//                    expect(move!.fromSquare.rank) == .two
//                    expect(move!.toSquare.file) == .e
//                    expect(move!.toSquare.rank) == .four
//                    expect(move!.piece.color) == .white
//                }
//            }
//        }
//    }
//}
