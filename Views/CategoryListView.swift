//
//  CategoryListView.swift
//  Restaurante
//
//  Created by ALUMNO on 20/04/26.
//

import SwiftUI

struct CategoryListView: View {
    @EnvironmentObject var menuController: MenuController
    @State var categories = [String]()
    @State var errorMessage: String?
    @State var showError = false
    @State private var navigationPath = NavigationPath()

    var restoredCategory: String?
    var restoredMenuItem: MenuItem?

    var body: some View {
        NavigationStack(path: $navigationPath) {  // ← pasa el path
            List(categories, id: \.self) { category in
                NavigationLink(value: category) {  // ← usa value-based navigation
                    Text(category.capitalized)
                        .font(.headline)
                        .padding(.vertical, 8)
                }
            }
            .navigationTitle("Restaurante")
            .navigationDestination(for: String.self) { category in
                MenuListView(
                    category: category,
                    restoredMenuItem: restoredCategory == category ? restoredMenuItem : nil
                )
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: OrderView()) {
                        Image(systemName: "cart")
                            .overlay(alignment: .topTrailing) {
                                if !menuController.order.menuItems.isEmpty {
                                    Text("\(menuController.order.menuItems.count)")
                                        .font(.caption2).bold()
                                        .foregroundColor(.white)
                                        .padding(4)
                                        .background(Color.red)
                                        .clipShape(Circle())
                                        .offset(x: 8, y: -8)
                                }
                            }
                    }
                }
            }
            .task {
                if categories.isEmpty {
                    do {
                        categories = try await menuController.fetchCategories()
                    } catch {
                        displayError(error, title: "Failed to Fetch Categories")
                    }
                }
            }
            .onAppear {
                MenuController.shared.updateUserActivity(with: .categories)
            }
            .alert(errorMessage ?? "Error", isPresented: $showError) {
                Button("Dismiss", role: .cancel) {}
            }
            // ← NUEVO: cuando orderJustPlaced cambia a true, vacía el stack
            .onChange(of: menuController.orderJustPlaced) { placed in
                if placed {
                    navigationPath.removeLast(navigationPath.count)
                    menuController.orderJustPlaced = false
                }
            }
        }
    }

    func displayError(_ error: Error, title: String) {
        errorMessage = "\(title): \(error.localizedDescription)"
        showError = true
    }
}
