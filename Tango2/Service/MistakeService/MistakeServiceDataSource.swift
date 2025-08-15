//
//  MistakeServiceDataSource.swift
//  Tango2
//
//  Created by Sergei Vasilenko on 13.08.2025.
//

protocol MistakeServiceDataSource: AnyObject {
    func level() -> Level
    func conditions() -> [Condition]
    func row(_ rowIndex: Int) -> [GameCell]
    func column(_ columnIndex: Int) -> [GameCell]
}
