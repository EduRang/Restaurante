//
//  OrderConfirmationView.swift
//  Restaurante
//
//  Created by ALUMNO on 20/04/26.
//

import SwiftUI

struct OrderConfirmationView: View {
    let minutesToPrepare: Int
    let onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.green)

            Text("¡Orden enviada!")
                .font(.title)
                .bold()

            Text("Gracias por tu orden. Tu tiempo de espera es de aproximadamente \(minutesToPrepare) minutos.")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)

            Button(action: {
                MenuController.shared.order.menuItems.removeAll()
                onDismiss()
            }) {
                Text("Dismiss")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }

            Spacer()
        }
        .presentationDetents([.medium])
    }
}
