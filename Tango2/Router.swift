//
//  Router.swift
//  Tango2
//
//  Created by Sergei Vasilenko on 3.07.2025.
//

import SwiftUI

@Observable
class Router {
    var path: NavigationPath
    
    init(path: NavigationPath) {
        self.path = path
    }
}
