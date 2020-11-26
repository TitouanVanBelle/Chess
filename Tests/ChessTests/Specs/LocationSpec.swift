//
//  LocationSpec.swift
//  
//
//  Created by Titouan Van Belle on 26.11.20.
//

import Nimble
import Quick
import XCTest

@testable import Chess

class LocationSpec: QuickSpec {
    override func spec() {
        describe("init(file:rank:)") {
            it("initializes the location and sets the index") {
                Rank.all
                    .flatMap { rank in
                        File.all.map { file in (file, rank) }
                    }
                    .enumerated()
                    .forEach { index, locationTuple in
                        let location = Location(file: locationTuple.0, rank: locationTuple.1)
                        expect(location.file) == locationTuple.0
                        expect(location.rank) == locationTuple.1
                        expect(location.index) == index
                    }
            }
        }

        describe("init(index:)") {
            context("index is inside the range [0-63]") {
                it("initializes the location and sets the file and rank") {
                    Array(0..<64).forEach { index in
                        let location = Location(index: index)
                        expect(location?.file) == File.all[index % 8]
                        expect(location?.rank) == Rank.all[index / 8]
                        expect(location?.index) == index
                    }
                }
            }

            context("index is outside of the range [0-63]") {
                it("returns nil") {
                    [-1,64].forEach { index in
                        let location = Location(index: index)
                        expect(location).to(beNil())
                    }
                }
            }

        }

        describe("init(notation:)") {
            context("notation is valid and represents a location") {
                it("initializes the location") {
                    Rank.all
                        .flatMap { rank in
                            File.all.map { file in "\(file.notation)\(rank.notation)" }
                        }
                        .enumerated()
                        .forEach { index, notation in
                            let location = Location(notation: notation)
                            expect(location?.file) == File.all[index % 8]
                            expect(location?.rank) == Rank.all[index / 8]
                            expect(location?.index) == index
                        }
                }
            }

            context("notation is invalid and does not represent a location") {
                it("returns nil") {
                    ["ee", "c9", "2f", "11"].forEach { notation in
                        let location = Location(notation: notation)
                        expect(location).to(beNil())
                    }
                }
            }
        }
    }
}

fileprivate extension Rank {
    static let all: [Rank] = [.one, .two, .three, .four, .five, .six, .seven, .eight]
}

fileprivate extension File {
    static let all: [File] = [.a, .b, .c, .d, .e, .f, .g, .h]
}
