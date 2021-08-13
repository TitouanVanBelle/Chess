//
//  CollisionDetector.swift
//  
//
//  Created by Titouan Van Belle on 12.11.20.
//

import Foundation

protocol CollisionDetectorProtocol {
    func collisions(for move: Move, in board: ChessBoardProtocol) -> Bool
}

final class CollisionDetector: CollisionDetectorProtocol {
    func collisions(for move: Move, in board: ChessBoardProtocol) -> Bool {
        guard let squaresInBetween = squaresBetween(move.fromSquare, and: move.toSquare, directionType: move.directionType, in: board) else {
            return false
        }

        return !squaresInBetween
            .filter { $0.hasPiece }
            .isEmpty
    }
}

fileprivate extension CollisionDetector {
    func squaresBetween(_ fromSquare: Square, and toSquare: Square, directionType: DirectionType, in board: ChessBoardProtocol) -> [Square]? {
        var locations: [Location]?
        let vector = Vector(fromSquare: fromSquare, toSquare: toSquare)

        switch directionType {

        case .diagonally:
            guard abs(vector.deltaFile) > 1 else {
                break
            }

            let inbetweenRanks = ranks(between: fromSquare, and: toSquare)
            let inbetweenFiles = files(between: fromSquare, and: toSquare)

            locations = zip(inbetweenFiles, inbetweenRanks)
                .map { Location(file: $0, rank: $1) }

        case .straight:
            if vector.deltaFile == 0 {
                guard abs(vector.deltaRank) > 1 else {
                    break
                }

                locations = ranks(between: fromSquare, and: toSquare)
                    .map { Location(file: fromSquare.file, rank: $0) }
            } else {
                guard abs(vector.deltaFile) > 1 else {
                    break
                }

                locations = files(between: fromSquare, and: toSquare)
                    .map { Location(file: $0, rank: fromSquare.rank) }

            }
        default:
            locations = nil
        }

        return locations?
            .map(\.index)
            .map { board.squares[$0] }
    }

    func ranks(between fromSquare: Square, and toSquare: Square) -> [Rank] {
        let lowerBound = min(fromSquare.rank.rawValue, toSquare.rank.rawValue)
        let higherBound = max(fromSquare.rank.rawValue, toSquare.rank.rawValue)
        let range = (lowerBound + 1)...(higherBound - 1)
        var ranks = Array(range)

        if toSquare.rank.rawValue < fromSquare.rank.rawValue {
            ranks.reverse()
        }

        return ranks.compactMap { Rank(rawValue: $0) }
    }

    func files(between fromSquare: Square, and toSquare: Square) -> [File] {
        let lowerBound = min(fromSquare.file.rawValue, toSquare.file.rawValue)
        let higherBound = max(fromSquare.file.rawValue, toSquare.file.rawValue)
        let range = (lowerBound + 1)...(higherBound - 1)
        var files = Array(range)

        if toSquare.file.rawValue < fromSquare.file.rawValue {
            files.reverse()
        }

        return files.compactMap { File(rawValue: $0) }
    }
}
