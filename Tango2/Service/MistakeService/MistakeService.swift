//
//  MistakeService.swift
//  Tango2
//
//  Created by Sergei Vasilenko on 13.08.2025.
//

final class MistakeService {
    weak var dataSource: MistakeServiceDataSource?

    init() { }
}

// MARK: - MistakeServiceProtocol
extension MistakeService: MistakeServiceProtocol {

    func getMistakes() -> [Mistake] {
        guard let level = dataSource?.level() else {
            assertionFailure("Level is not provided for MistakeService!")
            return []
        }
        var allMistakes = [Mistake]()

        // Check all rows
        for rowIndex in 0..<level.levelCells.count {
            allMistakes.append(contentsOf: getMistakes(forRowWithIndex: rowIndex))
        }

        // Check all columns
        for columnIndex in 0..<level.levelCells[0].count {
            allMistakes.append(contentsOf: getMistakes(forColumnWithIndex: columnIndex))
        }

        return allMistakes
    }

    func getMistakes(forRowWithIndex rowIndex: Int) -> [Mistake] {
        guard let dataSource else {
            assertionFailure("DataSource is not provided for MistakeService!")
            return []
        }

        var mistakes = [Mistake]()
        mistakes.append(contentsOf: checkSignViolation(cells: dataSource.row(rowIndex), isRow: true, index: rowIndex))
        mistakes.append(contentsOf: checkSameNumberValues(cells: dataSource.row(rowIndex), isRow: true, index: rowIndex))
        mistakes.append(contentsOf: checkNoMoreThan2(cells: dataSource.row(rowIndex), isRow: true, index: rowIndex))
        return mistakes
    }

    func getMistakes(forColumnWithIndex columnIndex: Int) -> [Mistake] {
        guard let dataSource else {
            assertionFailure("DataSource is not provided for MistakeService!")
            return []
        }

        var mistakes = [Mistake]()
        mistakes.append(contentsOf: checkSignViolation(cells: dataSource.column(columnIndex), isRow: false, index: columnIndex))
        mistakes.append(contentsOf: checkSameNumberValues(cells: dataSource.column(columnIndex), isRow: false, index: columnIndex))
        mistakes.append(contentsOf: checkNoMoreThan2(cells: dataSource.column(columnIndex), isRow: false, index: columnIndex))
        return mistakes
    }
}

// MARK: - Private

extension MistakeService {
    /**
     Checks for sign violations between cells based on game conditions.
     
     - Parameters:
       - cells: Array of cells to check (either a row or column)
       - isRow: True if checking a row, false if checking a column
       - index: The index of the row or column being checked
     - Returns: Array of mistake types found
     */
    private func checkSignViolation(cells: [GameCell], isRow: Bool, index: Int) -> [Mistake] {
        guard let conditions = dataSource?.conditions() else {
            assertionFailure("Conditions are not provided for MistakeService!")
            return []
        }

        var mistakes = [Mistake]()

        // Filter conditions that apply to this row/column
        let relatedConditions = conditions.filter {
            if isRow {
                return $0.cellA.row == index && $0.cellB.row == index
            } else {
                return $0.cellA.column == index && $0.cellB.column == index
            }
        }

        relatedConditions.forEach { condition in
            let positionA = isRow ? condition.cellA.column : condition.cellA.row
            let positionB = isRow ? condition.cellB.column : condition.cellB.row

            let cellAValue = cells[positionA].value
            let cellBValue = cells[positionB].value

            guard cellAValue != nil && cellBValue != nil else { return }

            switch condition.condition {
            case .equal:
                if cellAValue != cellBValue {
                    mistakes.append(.init(cells: [condition.cellA, condition.cellB],
                                          type: .signViolation(.equal)))
                }
            case .opposite:
                if cellAValue == cellBValue {
                    mistakes.append(.init(cells: [condition.cellA, condition.cellB],
                                          type: .signViolation(.opposite)))
                }
            }
        }

        return mistakes
    }

    /**
     Checks for more than 2 consecutive identical values in a line of cells.
     
     - Parameter cells: Array of cells to check
     - Returns: Array of mistake types found
     */
    func checkNoMoreThan2(cells: [GameCell], isRow: Bool, index: Int) -> [Mistake] {
        var mistakes = [Mistake]()
        if let zerosMistakePosition = MistakeService.checkNoMoreThan2(of: .zero, in: cells.map { $0.value }) {
            let positions = (zerosMistakePosition.0...zerosMistakePosition.1).map {
                CellPosition(row: isRow ? index : $0, column: isRow ? $0 : index)
            }
            mistakes.append(.init(cells: positions, type: .noMoreThan2))
        }

        if let onesMistakePosition = MistakeService.checkNoMoreThan2(of: .one, in: cells.map { $0.value }) {
            let positions = (onesMistakePosition.0...onesMistakePosition.1).map {
                CellPosition(row: isRow ? index : $0, column: isRow ? $0 : index)
            }
            mistakes.append(.init(cells: positions, type: .noMoreThan2))
        }
        return mistakes
    }

    // we have line of length 6
    // so there could be only 2 mistaked sequence of different symbols (000111 where 000 and 111 are mistakes) per line
    // or just one sequence per line (010111, 001111, 111111)
    // that is why we return single optional tuple instead of array
    static func checkNoMoreThan2(of target: CellValue, in array: [CellValue?]) -> (Int, Int)? {
        var startIndex = -1
        var sequenceLength = 0
        for index in 0..<array.count {
            // not nil
            if let value = array[index] {
                if startIndex >= 0 {
                    if value == target {
                        sequenceLength += 1
                    }
                    else {
                        if sequenceLength > 2 {
                            return (startIndex, startIndex + sequenceLength - 1)
                        }
                        else {
                            startIndex = -1
                            sequenceLength = 0
                        }
                    }
                }
                else {
                    if value == target {
                        sequenceLength += 1
                        startIndex = index
                    }
                    else {
                        if sequenceLength > 2 {
                            return (startIndex, startIndex + sequenceLength - 1)
                        }
                    }
                }
            }
            // nil
            else {
                // if we started to track sequence
                if startIndex >= 0 {
                    if sequenceLength > 2 {
                        return (startIndex, startIndex + sequenceLength - 1)
                    }
                    else {
                        startIndex = -1
                        sequenceLength = 0
                    }
                }
            }
        }

        if startIndex >= 0 {
            if sequenceLength > 2 {
                return (startIndex, startIndex + sequenceLength - 1)
            }
        }

        return nil
    }

    /**
     Checks if a completely filled line has an equal number of zeros and ones.
     
     - Parameter cells: Array of cells to check
     - Returns: Array of mistake types found
     */
    private func checkSameNumberValues(cells: [GameCell], isRow: Bool, index: Int) -> [Mistake] {
        var mistakes = [Mistake]()

        // Count zeroes, ones, and nil values
        let zeroCount = cells.filter { $0.value == .zero }.count
        let oneCount = cells.filter { $0.value == .one }.count
        let nilCount = cells.filter { $0.value == nil }.count

        // Only check for balance in completely filled lines (no nil values)
        if nilCount == 0 {
            // Check if number of zeros equals number of ones
            if zeroCount != oneCount {
                let cells = (0..<cells.count).map {
                    CellPosition(row: isRow ? index : $0, column: isRow ? $0 : index)
                }
                mistakes.append(.init(cells: cells, type: .sameNumberValues))
            }
        }

        return mistakes
    }
}
