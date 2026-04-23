//
//  MenuController.swift
//  Restaurante
//
//  Created by ALUMNO on 20/04/26.
//

import Foundation
import Combine

extension Notification.Name {
    static let orderUpdated = Notification.Name("orderUpdated")
}

enum MenuControllerError: Error, LocalizedError {
    case categoriesNotFound
    case menuItemsNotFound
    case orderRequestFailed
    case imageDataMissing

    var errorDescription: String? {
        switch self {
        case .categoriesNotFound:    return "No se pudieron encontrar las categorías."
        case .menuItemsNotFound:     return "No se encontraron elementos para esta categoría."
        case .orderRequestFailed:    return "El envío de la orden falló. Inténtalo de nuevo."
        case .imageDataMissing:      return "No se pudo cargar la imagen."
        }
    }
}

class MenuController: ObservableObject {
    @Published var orderJustPlaced = false
    static let shared = MenuController()

    let baseURL = URL(string: "http://localhost:8080/")!
    typealias MinutesToPrepare = Int

    @Published var restorationState = AppRestorationState()

    @Published var order = Order() {
        didSet {
            NotificationCenter.default.post(name: .orderUpdated, object: nil)
            restorationState.order = order
            saveRestorationState()
        }
    }

    func updateUserActivity(with controller: StateRestorationController) {
        switch controller {
        case .menu(let category):
            restorationState.menuCategory = category
        case .menuItemDetail(let menuItem):
            restorationState.menuItem = menuItem
        case .order, .categories:
            break
        }
        restorationState.controllerIdentifier = controller.identifier
        saveRestorationState()
    }

    private func saveRestorationState() {
        if let data = try? JSONEncoder().encode(restorationState) {
            UserDefaults.standard.set(data, forKey: "restorationState")
        }
    }

    func loadRestorationState() -> AppRestorationState? {
        guard let data = UserDefaults.standard.data(forKey: "restorationState"),
              let state = try? JSONDecoder().decode(AppRestorationState.self, from: data)
        else { return nil }
        return state
    }

    func fetchCategories() async throws -> [String] {
        let categoriesURL = baseURL.appendingPathComponent("categories")
        let (data, response) = try await URLSession.shared.data(from: categoriesURL)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw MenuControllerError.categoriesNotFound
        }
        return try JSONDecoder().decode(Categories.self, from: data).categories
    }

    func fetchMenuItems(forCategory categoryName: String) async throws -> [MenuItem] {
        let initialMenuURL = baseURL.appendingPathComponent("menu")
        var components = URLComponents(url: initialMenuURL, resolvingAgainstBaseURL: true)!
        components.queryItems = [URLQueryItem(name: "category", value: categoryName)]
        let (data, response) = try await URLSession.shared.data(from: components.url!)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw MenuControllerError.menuItemsNotFound
        }
        return try JSONDecoder().decode(MenuResponse.self, from: data).items
    }

    func submitOrder(forMenuIDs menuIDs: [Int]) async throws -> MinutesToPrepare {
        let orderURL = baseURL.appendingPathComponent("order")
        var request = URLRequest(url: orderURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(["menuIds": menuIDs])
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw MenuControllerError.orderRequestFailed
        }
        return try JSONDecoder().decode(OrderResponse.self, from: data).prepTime
    }
}
