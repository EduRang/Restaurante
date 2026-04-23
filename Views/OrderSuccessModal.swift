//
//  OrderSuccessModal.swift
//  Restaurante
//
//  Created by ALUMNO on 22/04/26.
//

import SwiftUI

struct OrderSuccessModal: View {
    let onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.green)

            Text("¡Platillo agregado!")
                .font(.title)
                .bold()

            Text("Tu platillo fue añadido a la orden correctamente.")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)

            Button(action: onDismiss) {
                Text("Ver Menú Principal")
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
