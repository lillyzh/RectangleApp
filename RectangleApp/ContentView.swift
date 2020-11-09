import SwiftUI
import RectangleKit

struct ContentView: View {
    @ObservedObject var viewModel = ViewModel(numRows: 50, numColumns: 50)
    var defaultNumVerticalBars = 0
    var defaultMaxVertHeight = 0
    var defaultMaxVertWidth = 5 //max width of a vertical rectangle
    var rectangleKit = RectangleKit()
    @State var validMaxHeight = true
    @State var validNumBars = true
    @State var numVerticalBars: String = ""
    @State var maxVertHeight: String = ""
    @State var verticalBars = [VerticalRectangle]()
    
    var body: some View {
        Text("Rectangle Kit App")
            .font(.title)
            .padding()
        configurationView()
        BoardView(viewModel: viewModel)
        buttonsView()
    }
    
    //create a view that contains the two text fields for number of vertical bars and maximum vertical height
    func configurationView() -> AnyView {
        return AnyView(
            VStack(alignment: .leading, spacing: 10) {
                //since the number of columns is fixed at 50 and each column can be as wide as 5, this program can accommodate at most 10 vertical bars
                Text("Enter number of vertical bars between 0 and 10")
                    .bold()
                TextField("Try 10", text: $numVerticalBars)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
                    .onChange(of: numVerticalBars) { newValue in
                        validNumBars = ((Int(newValue) ?? -1) >= 0 && (Int(newValue) ?? -1 ) <= (viewModel.numCols / defaultMaxVertWidth))
                    }
                //since the number of rows is fixed at 50, the height of a vertical bar can be at most 50
                Text("Enter maximum vertical height between 0 and 50")
                    .bold()
                TextField("Try 50", text: $maxVertHeight)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
                    .onChange(of: maxVertHeight) { newValue in
                        validMaxHeight = (Int(newValue) ?? -1) >= 0 && (Int(newValue) ?? -1 ) <= (viewModel.numRows)
                    }
            }
        )
    }
    
    //create a view for buttons Generate Input and Compute Output
    func buttonsView() -> AnyView {
        return AnyView(
            VStack {
                Button(action: {
                    viewModel.clear()
                    verticalBars = generateRandomVerticalBars()
                    drawInputGraph(verticalRects: verticalBars)
                }) {
                    Text("Generate Input")
                        .foregroundColor(.white)
                        .padding(.all)
                        .background((validNumBars && validMaxHeight) ? Color.blue : Color.gray.opacity(0.4))
                        .cornerRadius(16)
                        .font(.body)
                }
                .disabled(!(validNumBars && validMaxHeight))
                Button(action: {
                    let horizontalBars = rectangleKit.findHorizontalBars(input: verticalBars)
                    drawOutputGraph(horizontalRects: horizontalBars)
                }) {
                    Text("Compute Output")
                        .foregroundColor(.white)
                        .padding(.all)
                        .background((validNumBars && validMaxHeight) ? Color.green : Color.gray.opacity(0.4))
                        .cornerRadius(16)
                        .font(.body)
                }
                .disabled(!(validNumBars && validMaxHeight))
            }
        )
    }
    
    //generate a list of vertical rectangles with random heights and widths
    //the width is any value between 1 and 5
    func generateRandomVerticalBars() -> [VerticalRectangle] {
        var verticalBars = [VerticalRectangle]()
        let numBars = (Int(numVerticalBars) ?? defaultNumVerticalBars)
        let maxHeight = (Int(maxVertHeight) ?? defaultMaxVertHeight)
        if numBars != 0 && maxHeight != 0 {
            for _ in 0..<numBars {
                var verticalBar = VerticalRectangle()
                verticalBar.height = Int.random(in: 1...maxHeight)
                verticalBar.width = Int.random(in: 1...defaultMaxVertWidth)
                verticalBars.append(verticalBar)
            }
        }
        return verticalBars
    }
    
    //param: a list of vertical rectangles
    //draw each vertical rectangle with a random color on the board
    func drawInputGraph(verticalRects: [VerticalRectangle]) {
        var col = 0
        for x in 0..<verticalRects.count {
            let color = Color(red: Double.random(), green: Double.random(), blue: Double.random())
            for _ in 0..<verticalRects[x].width {
                for row in 0..<verticalRects[x].height {
                    viewModel.drawBlock(col: col, row: row, color: color)
                }
                col += 1
            }
        }
    }
    
    //param: a list of horizontal rectangles
    //draw each horizontal rectangle with a random color on the board
    func drawOutputGraph(horizontalRects: [HorizontalRectangle]) {
        for rec in horizontalRects {
            let color = Color(red: Double.random(), green: Double.random(), blue: Double.random())
            for coor in rec.coordinates {
                for i in 0..<rec.height {
                    viewModel.drawBlock(col: coor.x, row: coor.y + i, color: color)
                }
            }
        }
    }
}

extension Double {
    private static let arc4randomMax = Double(UInt32.max)
    
    //keep generating a random double between 0 and 1 until first non-zero
    //want non-zero value so the color of the bar isn't black as the background
    static func random() -> Double {
        while(true){
            let randDoub = Double(arc4random()) / arc4randomMax
            if randDoub != 0 {
                return randDoub
            }
        }
    }
}
