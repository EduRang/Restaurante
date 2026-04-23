import SwiftUI

struct MenuItemDetailView: View {
    let menuItem: MenuItem
    @EnvironmentObject var menuController: MenuController
    @State private var buttonScale: CGFloat = 1.0
    @State private var showOrderSuccess = false  // ← NUEVO

    var body: some View {
        VStack(spacing: 20) {
            AsyncImage(url: menuItem.imageURL) { phase in
                switch phase {
                case .empty:
                    Image(systemName: "photo.on.rectangle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.secondary)
                case .success(let image):
                    image.resizable().aspectRatio(contentMode: .fit)
                case .failure:
                    Image(systemName: "photo.on.rectangle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.secondary)
                @unknown default:
                    EmptyView()
                }
            }
            .frame(height: 250)

            HStack {
                Text(menuItem.name).font(.title).bold()
                Spacer()
                Text(menuItem.price.formatted(.currency(code: "usd")))
                    .font(.title2)
                    .foregroundColor(.secondary)
            }

            Text(menuItem.detailText)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)

            Button(action: addToOrder) {
                Text("Agregar a la Orden")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .scaleEffect(buttonScale)

            Spacer()
        }
        .padding()
        .navigationTitle(menuItem.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            MenuController.shared.updateUserActivity(with: .menuItemDetail(menuItem))
        }
        .sheet(isPresented: $showOrderSuccess) {
            OrderSuccessModal {
                menuController.orderJustPlaced = true
                showOrderSuccess = false
            }
        }
    }

    func addToOrder() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.4)) {
            buttonScale = 1.3
        }
        withAnimation(.spring(response: 0.3, dampingFraction: 0.4).delay(0.15)) {
            buttonScale = 1.0
        }
        MenuController.shared.order.menuItems.append(menuItem)
        showOrderSuccess = true  // ← NUEVO
    }
}
