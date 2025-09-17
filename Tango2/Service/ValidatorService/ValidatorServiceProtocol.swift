//
//  ValidatorServiceProtocol.swift
//  Tango2
//
//  Created by Sergei Vasilenko on 11.08.2025.
//

protocol ValidatorServiceProtocol: AnyObject {

    var dataSource: ValidatorServiceDataSource? { get set }

    func isFieldValid() -> Bool
}
