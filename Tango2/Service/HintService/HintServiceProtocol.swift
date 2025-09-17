//
//  HintServiceProtocol.swift
//  Tango2
//
//  Created by Sergei Vasilenko on 15.08.2025.
//

protocol HintServiceProtocol: AnyObject {

    var dataSource: HintServiceDataSource? { get set }

    func getHint() -> Hint?
}
