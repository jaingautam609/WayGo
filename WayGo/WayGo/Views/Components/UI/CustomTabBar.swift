import SwiftUI
import UIKit

enum RootTab: CaseIterable {
    case home, booking, cart, community, more


    var icon: String {
        switch self {
        case .home:      return "house"
        case .booking:   return "calendar"
        case .cart:      return "cart"
        case .community: return "bubble.left.and.bubble.right"
        case .more:      return "ellipsis"
        }
    }
}

struct CustomTabBar: View {
    @Binding var selection: RootTab
    @EnvironmentObject var cart: CartStore

    var body: some View {
        HStack(spacing: 22) {
            ForEach(RootTab.allCases, id: \.self) { tab in
                Button { selection = tab } label: {
                    ZStack(alignment: .topTrailing) {
                        ZStack {
                            if selection == tab {
                                Circle().fill(Color.white).frame(width: 42, height: 42)
                            }
                            Image(systemName: tab.icon)
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(selection == tab ? .black : .white)
                        }
                        // cart badge
                        if tab == .cart, cart.count > 0 {
                            Text("\(cart.count)")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(.white)
                                .padding(5)
                                .background(Color.red, in: Circle())
                                .offset(x: 12, y: -10)
                        }
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Capsule().fill(Color.black))
        .padding(.horizontal, 24)
        .padding(.bottom, 18)
    }
}
