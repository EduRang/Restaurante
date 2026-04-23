//
//  RestauranteApp.swift
//  Restaurante
//
//  Created by ALUMNO on 20/04/26.
//

import SwiftUI

@main
struct RestauranteApp: App {
    @StateObject var menuController = MenuController.shared

    @State private var restoredCategory: String?
    @State private var restoredMenuItem: MenuItem?
    @State private var restoredTab: StateRestorationController.Identifier = .categories

    init() {
        let temporaryDirectory = NSTemporaryDirectory()
        let urlCache = URLCache(
            memoryCapacity: 25_000_000,
            diskCapacity: 50_000_000,
            diskPath: temporaryDirectory
        )
        URLCache.shared = urlCache
    }

    var body: some Scene {
        WindowGroup {
            CategoryListView(
                restoredCategory: restoredCategory,
                restoredMenuItem: restoredMenuItem
            )
            .environmentObject(menuController)
            .onAppear {
                restoreState()
            }
        }
    }

    func restoreState() {
        guard let state = menuController.loadRestorationState() else { return }

        if !state.order.menuItems.isEmpty {
            menuController.order = state.order
        }

        switch state.controllerIdentifier {
        case .menu:
            restoredCategory = state.menuCategory
        case .menuItemDetail:
            restoredCategory = state.menuItem?.category
            restoredMenuItem = state.menuItem
        case .categories, .order:
            break
        }
    }
}
