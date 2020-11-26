//
//  ANRegex.swift
//  
//
//  Created by Titouan Van Belle on 09.11.20.
//

import Foundation

enum ANRegex {
    static let queenCastle: Regex = "^O-O-O(\\+|\\#)?$"
    static let kingCastle: Regex = "^O-O(\\+|\\#)?$"
    // e4
    static let pawnMove: Regex = "^[a-h][1-8](=[QRNB])?(\\+|\\#)?$"
    // exf5
    static let pawnCapture: Regex = "^[a-h]x[a-h][1-8](=[QRNB])?(\\+|\\#)?$"
    // Nf6, Nef6, N5f6
    static let pieceMove: Regex = "^[KQRNB]([a-h1-8])?[a-h][1-8](\\+|\\#)?$"
    // Nxf6, Nexf6, N5xf6
    static let pieceCapture: Regex = "^[KQRNB]([a-h1-8])?x[a-h][1-8](\\+|\\#)?$"
    static let check: Regex = "\\+$"
    static let checkMate: Regex = "\\#$"
    static let promotion: Regex = "=[QRNB]$"
}
