//
//  FieldValidatorProtocol.swift
//  Tango2
//
//  Created by Sergei Vasilenko on 11.08.2025.
//

protocol FieldValidatorProtocol {
    func isCellsArrayValid(_ cells: [GameCell], _ conditions: [Condition], lineLength: Int) -> Bool
}
