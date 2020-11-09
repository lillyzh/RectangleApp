import  SwiftUI

class ViewModel: ObservableObject {
    @Published var board: [[Block]]
    var numRows: Int
    var numCols: Int
    
    init(numRows: Int, numColumns: Int) {
        self.numRows = numRows
        self.numCols = numColumns
        board = Array(repeating: Array(repeating: Block(color: Color.black), count: numRows), count: numColumns)
    }
    
    //color the block with the given color
    func drawBlock(col: Int, row: Int, color: Color) {
        board[col][row].color = color
    }
    
    //clear all colors from the default black board
    func clear() {
        for col in 0..<numCols {
            for row in 0..<numRows {
                board[col][row].color = Color.black
            }
        }
    }
}

struct Block {
    var color: Color
}


