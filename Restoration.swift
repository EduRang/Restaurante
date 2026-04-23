//
//  Restoration.swift
//  Restaurante
//
//  Created by ALUMNO on 20/04/26.
//

import Foundation

// Equivalente a la extensión NSUserActivity del libro
// En SwiftUI usamos SceneStorage y AppStorage en lugar de NSUserActivity
// pero mantenemos la lógica del libro adaptada para SwiftUI

enum StateRestorationController {

    enum Identifier: String, Codable {
        case categories, menu, menuItemDetail, order
    }

    case categories
    case menu(category: String)
    case menuItemDetail(MenuItem)
    case order

    var identifier: Identifier {
        switch self {
        case .categories:    return .categories
        case .menu:          return .menu
        case .menuItemDetail: return .menuItemDetail
        case .order:         return .order
        }
    }
}

// Estructura que encapsula todo el estado restaurable
// Equivalente al userInfo dictionary de NSUserActivity del libro
struct AppRestorationState: Codable {
    var order: Order = Order()
    var controllerIdentifier: StateRestorationController.Identifier = .categories
    var menuCategory: String?
    var menuItem: MenuItem?
}
