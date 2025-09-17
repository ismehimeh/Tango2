//
//  DefaultFieldValidator.swift
//  Tango2
//
//  Created by Sergei Vasilenko on 11.08.2025.
//

class ValidatorService {

    weak var dataSource: ValidatorServiceDataSource?

    init() { }
}

extension ValidatorService: ValidatorServiceProtocol {

    private var lineLength: Int {
        guard let dataSource else {
            assertionFailure("dataSource not set!")
            return 0
        }
        return dataSource.level().lineLength
    }

    func isFieldValid() -> Bool {
        let isRowsValid = (0..<lineLength).map { isRowValid($0) }.allSatisfy { $0 }
        let isColumnsValid = (0..<lineLength).map { isColumnValid($0) }.allSatisfy { $0 }
        return isRowsValid && isColumnsValid
    }

    func isRowValid(_ index: Int) -> Bool {
        guard let dataSource else {
            assertionFailure("dataSource not set!")
            return false
        }

        let rowArray = dataSource.row(index)
        let conditions = dataSource.conditions().filter { $0.cellA.row == index && $0.cellB.row == index}
        return isCellsArrayValid(rowArray, conditions, lineLength: lineLength)
    }

    func isColumnValid(_ column: Int) -> Bool {
        guard let dataSource else {
            assertionFailure("dataSource not set!")
            return false
        }

        let columnArray = dataSource.column(column)
        let conditions = dataSource.conditions()
            .filter { $0.cellA.column == column && $0.cellB.column == column}
            .map { Condition(condition: $0.condition, cellA: CellPosition(row: $0.cellA.column, column: $0.cellA.row), cellB: CellPosition(row: $0.cellB.column, column: $0.cellB.row)) }
        return isCellsArrayValid(columnArray, conditions, lineLength: lineLength)
    }

    func isCellsArrayValid(_ cells: [GameCell], _ conditions: [Condition], lineLength: Int) -> Bool {
        let zeroes = cells.count { $0.value == .zero }
        let ones = cells.count { $0.value == .one }

        // count of 0 and 1
        guard
            zeroes <= lineLength / 2,
            ones <= lineLength / 2
        else {
            return false
        }

        // no more than 2 after each other
        var zeroesCount = 0
        var onesCount = 0
        for cell in cells {
            if cell.value == .zero {
                zeroesCount += 1
                onesCount = 0
            }
            if cell.value == .one {
                zeroesCount = 0
                onesCount += 1
            }
            if cell.value == nil {
                zeroesCount = 0
                onesCount = 0
            }
            guard zeroesCount <= 2 && onesCount <= 2 else { return false }
        }

        // check conditions
        for condition in conditions {
            // For row conditions, we use column as the index
            let cellA = cells[condition.cellA.column]
            let cellB = cells[condition.cellB.column]
            guard cellA.value != nil && cellB.value != nil else { continue }

            if condition.condition == .equal && cellA.value != cellB.value {
                return false
            }

            if condition.condition == .opposite && cellA.value == cellB.value {
                return false
            }
        }

        return true
    }
}
