//
//  OrderView.swift
//  Restaurante
//
//  Created by ALUMNO on 20/04/26.
//

import SwiftUI

struct OrderView: View {
    @EnvironmentObject var menuController: MenuController
    @State private var minutesToPrepare: Int?
    @State private var isSubmitting = false
    @State private var showConfirmation = false
    @State private var showSubmitAlert = false
    @State private var errorMessage: String?
    @State private var showError = false

    var orderTotal: Double {
        menuController.order.menuItems.reduce(0.0) { $0 + $1.price }
    }

    var body: some View {
        List {
            Section {
                if menuController.order.menuItems.isEmpty {
                    Text("No hay platillos en tu orden.")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(menuController.order.menuItems) { item in
                        MenuItemRow(menuItem: item)
                    }
                    .onDelete { indexSet in
                        MenuController.shared.order.menuItems.remove(atOffsets: indexSet)
                    }
                }
            }

            if !menuController.order.menuItems.isEmpty {
                Section {
                    HStack {
                        Text("Total").bold()
                        Spacer()
                        Text(orderTotal.formatted(.currency(code: "usd"))).bold()
                    }
                }
                Section {
                    Button(action: { showSubmitAlert = true }) {
                        if isSubmitting {
                            ProgressView().frame(maxWidth: .infinity)
                        } else {
                            Text("Enviar Orden")
                                .frame(maxWidth: .infinity)
                                .bold()
                        }
                    }
                    .disabled(isSubmitting)
                }
            }
        }
        .navigationTitle("Mi Orden")
        .toolbar {
            if !menuController.order.menuItems.isEmpty {
                EditButton()
            }
        }
        .onAppear {
            MenuController.shared.updateUserActivity(with: .order)
        }
        .confirmationDialog(
            "Tu orden tiene un total de \(orderTotal.formatted(.currency(code: "usd")))",
            isPresented: $showSubmitAlert,
            titleVisibility: .visible
        ) {
            Button("Enviar") { uploadOrder() }
            Button("Cancelar", role: .cancel) {}
        }
        .sheet(isPresented: $showConfirmation) {
            OrderConfirmationView(minutesToPrepare: minutesToPrepare ?? 0) {
                showConfirmation = false
            }
        }
        .alert(errorMessage ?? "Error", isPresented: $showError) {
            Button("Dismiss", role: .cancel) {}
        }
    }

    func uploadOrder() {
        isSubmitting = true
        let menuIDs = menuController.order.menuItems.map { $0.id }
        Task {
            do {
                minutesToPrepare = try await MenuController.shared.submitOrder(forMenuIDs: menuIDs)
                showConfirmation = true
            } catch {
                errorMessage = "Order Request Failed: \(error.localizedDescription)"
                showError = true
            }
            isSubmitting = false
        }
    }
}
