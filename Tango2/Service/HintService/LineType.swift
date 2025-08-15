/// Represents the type of line being processed (row or column)
enum LineType {
    case row(index: Int)
    case column(index: Int)
    
    var index: Int {
        switch self {
        case .row(let index), .column(let index):
            return index
        }
    }
    
    var name: String {
        switch self {
        case .row: return "row"
        case .column: return "column"
        }
    }
}
