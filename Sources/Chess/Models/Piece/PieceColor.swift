//
//  PieceColor.swift
//  
//
//  Created by Titouan Van Belle on 10.11.20.
//

import Foundation

public enum PieceColor: String {
    case black = "Black"
    case white = "White"
}

extension PieceColor {
    var next: Self {
        self == .white ? .black : .white
    }
}
