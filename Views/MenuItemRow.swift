//
//  MenuItemRow.swift
//  Restaurante
//
//  Created by ALUMNO on 20/04/26.
//

import SwiftUI

struct MenuItemRow: View {
    let menuItem: MenuItem

    var body: some View {
        HStack {
            AsyncImage(url: menuItem.imageURL) { phase in
                switch phase {
                case .empty:
                    Image(systemName: "photo.on.rectangle")
                        .foregroundColor(.secondary)
                        .frame(width: 50, height: 50)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                case .failure:
                    Image(systemName: "photo.on.rectangle")
                        .foregroundColor(.secondary)
                        .frame(width: 50, height: 50)
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 50, height: 50)

            VStack(alignment: .leading, spacing: 4) {
                Text(menuItem.name)
                    .font(.headline)
                Text(menuItem.price.formatted(.currency(code: "usd")))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}
