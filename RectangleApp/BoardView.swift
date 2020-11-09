import SwiftUI

struct BoardView: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        GeometryReader { (geometry: GeometryProxy) in
            return self.createBoard(boundingRect: geometry.size)
        }
    }
    
    //create a numCols by numRows board
    func createBoard(boundingRect: CGSize) -> some View {
        let nCols = viewModel.numCols
        let nRows = viewModel.numRows
        let blockSize = min(boundingRect.width / CGFloat(nCols), boundingRect.height / CGFloat(nRows))
        let xoffset = (boundingRect.width - blockSize * CGFloat(nCols)) / 2
        let yoffset = (boundingRect.height - blockSize * CGFloat(nRows)) / 2
        return ForEach(0...nCols-1, id: \.self) { column in
            ForEach(0...nRows-1, id: \.self) { row in
                Path { path in
                    let x = CGFloat(column) * blockSize + xoffset
                    let y = boundingRect.height - (CGFloat(row+1) * blockSize + yoffset)
                    path.addRect(CGRect(x: x, y: y, width: blockSize, height: blockSize))
                }
                .fill(self.viewModel.board[column][row].color)
            }
        }
    }
}
