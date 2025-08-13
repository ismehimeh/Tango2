//
//  MistakeServiceProtocol.swift
//  Tango2
//
//  Created by Sergei Vasilenko on 13.08.2025.
//

protocol MistakeServiceProtocol {
    func getMistakes() -> [Mistake]
    func getMistakes(forRowWithIndex rowIndex: Int) -> [Mistake]
    func getMistakes(forColumnWithIndex columnIndex: Int) -> [Mistake]
}
