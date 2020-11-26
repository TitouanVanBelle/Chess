//
//  PieceSpec.swift
//  
//
//  Created by Titouan Van Belle on 26.11.20.
//

import Foundation

import Nimble
import Quick
import XCTest

@testable import Chess

class PieceSpec: QuickSpec {
    override func spec() {
        describe("init(kind:color:initialLocation)") {
            it("initializes the piece") {
                let initialLocation = Location(file: .a, rank: .one)
                let piece = Piece(kind: .rook, color: .white, initialLocation: initialLocation)

                expect(piece.kind) == .rook
                expect(piece.color) == .white
                expect(piece.initialLocation) == initialLocation
                expect(piece.location) == initialLocation
            }
        }

        describe("notation") {
            let location = Location(file: .a, rank: .one)

            PieceKind.all
                .map { ($0, Piece(kind: $0, color: .white, initialLocation: location)) }
                .forEach { kind, piece in
                    expect(piece.notation) == kind.notation
                }
        }

        describe("hasMoves") {
            context("piece's location is the same its initial location") {
                it("returns false") {
                    let initialLocation = Location(file: .a, rank: .one)
                    let piece = Piece(kind: .rook, color: .white, initialLocation: initialLocation)

                    expect(piece.hasMoved) == false
                }
            }

            context("piece's location is different from its initial location") {
                it("returns false") {
                    let initialLocation = Location(file: .a, rank: .one)
                    var piece = Piece(kind: .rook, color: .white, initialLocation: initialLocation)
                    piece.location = Location(file: .a, rank: .two)

                    expect(piece.hasMoved) == true
                }
            }
        }

        describe("isCapturable") {
            it("returns true if piece kind is .king, false otherwise") {
                let location = Location(file: .a, rank: .one)

                PieceKind.all
                    .map { ($0, Piece(kind: $0, color: .white, initialLocation: location)) }
                    .forEach { kind, piece in
                        expect(piece.isCapturable) == (kind != .king)
                    }
            }
        }

        describe("hasInfiniteAttackingRange") {
            it("returns true if piece kind is .bishop, .queen or .rook, false otherwise") {
                let location = Location(file: .a, rank: .one)

                PieceKind.all
                    .map { ($0, Piece(kind: $0, color: .white, initialLocation: location)) }
                    .forEach { kind, piece in
                        let pieceWithInfiniteAttackingRange: [PieceKind] = [.rook, .bishop, .queen]
                        expect(piece.hasInfiniteAttackingRange) == pieceWithInfiniteAttackingRange.contains(piece.kind)
                    }
            }
        }

        describe("promoted(to:)") {
            context("piece kind is not .pawn") {
                it("returns the same piece") {
                    let kinds: [PieceKind] = [.rook, .bishop, .queen, .king, .knight]
                    let location = Location(file: .a, rank: .one)

                    kinds
                        .map { Piece(kind: $0, color: .white, initialLocation: location) }
                        .forEach { piece in
                            let newKind: PieceKind = piece.kind == .queen ? .knight : .queen
                            let promotedPiece = piece.promoted(to: newKind)

                            expect(promotedPiece.kind) == piece.kind
                        }

                }
            }

            context("piece kind is .pawn") {
                context("new kind is .king") {
                    it("returns de same piece") {
                        let location = Location(file: .a, rank: .one)
                        let piece = Piece(kind: .pawn, color: .white, initialLocation: location)
                        let promotedPiece = piece.promoted(to: .king)

                        expect(promotedPiece.kind) == .pawn
                    }
                }

                context("new kind is not .king") {
                    it("changes the kind of the piece to the new kind") {
                        let promotionKinds: [PieceKind] = [.rook, .bishop, .queen, .knight]
                        let location = Location(file: .a, rank: .one)
                        let piece = Piece(kind: .pawn, color: .white, initialLocation: location)


                        promotionKinds
                            .forEach { newKind in
                                let promotedPiece = piece.promoted(to: newKind)
                                expect(promotedPiece.kind) == newKind
                            }
                    }
                }
            }
        }

    }
}

fileprivate extension PieceKind {
    static let all: [PieceKind] = [.rook, .knight, .bishop, .queen, .king, .pawn]
}
