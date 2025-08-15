//
//  HintServiceDataSource.swift
//  Tango2
//
//  Created by Sergei Vasilenko on 15.08.2025.
//

protocol HintServiceDataSource: AnyObject {
    
    func level() -> Level
    func conditions() -> [Condition]
    func row(_ rowIndex: Int) -> [GameCell]
    func column(_ columnIndex: Int) -> [GameCell]
    func solvedRow(_ rowIndex: Int) -> [CellValue]
    func solvedColumn(_ columnIndex: Int) -> [CellValue]
}
