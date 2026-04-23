//
//  MenuListView.swift
//  Restaurante
//
//  Created by ALUMNO on 20/04/26.
//

import SwiftUI

struct MenuListView: View {
    let category: String
    var restoredMenuItem: MenuItem? = nil
    @State var menuItems = [MenuItem]()
    @State var errorMessage: String?
    @State var showError = false

    var body: some View {
        List(menuItems) { item in
            NavigationLink(destination: MenuItemDetailView(menuItem: item)) {
                MenuItemRow(menuItem: item)
            }
        }
        .navigationTitle(category.capitalized)
        .task {
            do {
                menuItems = try await MenuController.shared.fetchMenuItems(forCategory: category)
            } catch {
                displayError(error, title: "Failed to Fetch Menu Items")
            }
        }
        .onAppear {
            MenuController.shared.updateUserActivity(with: .menu(category: category))
        }
        .alert(errorMessage ?? "Error", isPresented: $showError) {
            Button("Dismiss", role: .cancel) {}
        }
        .background {
            if let item = restoredMenuItem {
                NavigationLink(destination: MenuItemDetailView(menuItem: item), isActive: .constant(true)) {
                    EmptyView()
                }
                .hidden()
            }
        }
    }

    func displayError(_ error: Error, title: String) {
        errorMessage = "\(title): \(error.localizedDescription)"
        showError = true
    }
}
