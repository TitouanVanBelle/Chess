# Chess

A chess board to use in command-line or GUI apps

*This project is meant to be used for production apps.*

<br/>
<p align="center">
  <img src="https://i.postimg.cc/50yTKWnh/carbon.png" height="400">
</p>
<br/>

## Features



## How to use

### Play moves

Moves are played by passing algebraic notations to the chess board

```swift
let board = ChessBoard()
board.play(move: "e4")
```

### Print the board

Print the content of the chess board using the following code

```swift
print(board.gui)
// ===============
//   ♖       ♔ ♖   
// ♙ ♗ ♙ ♝ ♝ ♙   ♙ 
//   ♗       ♟     
//                 
//                 
//     ♟     ♕     
// ♟         ♟ ♟ ♟ 
//       ♜     ♚   
// 
// ===============
```

### Print the PGN

Print the PGN of the chess board using the following code

```swift
print(board.pgn)
// 1. e4 e5 2. Nf3 Nc6
```

## To Do

- Write Tests
- Complete descriptions for ChessBoardError
- Prevent castle if in, going through or ending in
- Complex PGNs (Event, Site, Date, Round, White, Black, Result, Comments, Variation)

